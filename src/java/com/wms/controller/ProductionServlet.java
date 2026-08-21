package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ProductionServlet")
public class ProductionServlet extends HttpServlet {
    
    // CONFIG: How much waste (kg) is needed to make 1 Unit of product?
    // You can make this dynamic later, but for now, let's say 1 Unit = 0.5 KG of waste.
    private static final double WASTE_PER_UNIT = 0.5; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String factoryName = request.getParameter("factoryName");
        String productName = request.getParameter("productName");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        double price = Double.parseDouble(request.getParameter("price"));
        
        double totalValue = quantity * price;
        double totalWasteNeeded = quantity * WASTE_PER_UNIT; // Calculate required raw material

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            // 1. Get Factory ID
            int factoryId = 0;
            ps = conn.prepareStatement("SELECT Factory_ID FROM Factory WHERE Name = ?");
            ps.setString(1, factoryName);
            rs = ps.executeQuery();
            if (rs.next()) factoryId = rs.getInt(1);
            rs.close();
            ps.close();

            // 2. CHECK STOCK: Get available waste batches (FIFO order)
            // We only look at records where Current_Quantity > 0
            String fetchStockSql = "SELECT Supply_ID, Current_Quantity FROM Supply_Log WHERE Factory_ID = ? AND Current_Quantity > 0 ORDER BY Supply_Date ASC";
            ps = conn.prepareStatement(fetchStockSql);
            ps.setInt(1, factoryId);
            rs = ps.executeQuery();

            double remainingToDeduct = totalWasteNeeded;

            while (rs.next() && remainingToDeduct > 0) {
                int supplyId = rs.getInt("Supply_ID");
                double currentQty = rs.getDouble("Current_Quantity");

                double deductAmount = 0;

                if (currentQty >= remainingToDeduct) {
                    // This batch has enough to cover the rest
                    deductAmount = remainingToDeduct;
                    remainingToDeduct = 0;
                } else {
                    // Use up this whole batch and move to the next
                    deductAmount = currentQty;
                    remainingToDeduct -= currentQty;
                }

                // Update the Supply_Log table (Deducting the waste)
                PreparedStatement psUpdate = conn.prepareStatement("UPDATE Supply_Log SET Current_Quantity = Current_Quantity - ? WHERE Supply_ID = ?");
                psUpdate.setDouble(1, deductAmount);
                psUpdate.setInt(2, supplyId);
                psUpdate.executeUpdate();
                psUpdate.close();
            }

            // 3. Validation: Did we have enough waste?
            if (remainingToDeduct > 0) {
                // Rollback! Not enough raw material.
                conn.rollback();
                request.setAttribute("msg", "Error: Not enough raw waste! Need " + totalWasteNeeded + "kg, but stock is low.");
                request.setAttribute("msgType", "error");
            } else {
                // 4. Success: Log Production
                String sqlProd = "INSERT INTO Production_Log (Factory_Name, Product_Name, Quantity, Market_Value, Production_Date) VALUES (?, ?, ?, ?, CURDATE())";
                ps = conn.prepareStatement(sqlProd);
                ps.setString(1, factoryName);
                ps.setString(2, productName);
                ps.setInt(3, quantity);
                ps.setDouble(4, totalValue);
                ps.executeUpdate();
                
                conn.commit(); // Commit Transaction
                request.setAttribute("msg", "Success! Consumed " + totalWasteNeeded + "kg of waste to produce " + quantity + " units.");
                request.setAttribute("msgType", "success");
            }

        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
            request.setAttribute("msg", "System Error: " + e.getMessage());
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            DBUtil.closeConnection(conn);
        }
        
        request.getRequestDispatcher("factory_dashboard.jsp").forward(request, response);
    }
}