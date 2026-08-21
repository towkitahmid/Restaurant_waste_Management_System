package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/VendorDistributionServlet")
public class VendorDistributionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer vendorId = (Integer) session.getAttribute("vendorId");
        
        if(vendorId == null) { response.sendRedirect("vendor_login.jsp"); return; }

        String mallName = request.getParameter("mallName");
        String productName = request.getParameter("productName");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Check Stock
            int currentStock = 0;
            PreparedStatement psCheck = conn.prepareStatement("SELECT Quantity FROM Vendor_Product_Inventory WHERE Vendor_ID = ? AND Product_Name = ?");
            psCheck.setInt(1, vendorId);
            psCheck.setString(2, productName);
            ResultSet rs = psCheck.executeQuery();
            if(rs.next()) currentStock = rs.getInt(1);

            if(currentStock >= quantity) {
                // 2. Deduct Stock
                PreparedStatement psDed = conn.prepareStatement("UPDATE Vendor_Product_Inventory SET Quantity = Quantity - ? WHERE Vendor_ID = ? AND Product_Name = ?");
                psDed.setInt(1, quantity);
                psDed.setInt(2, vendorId);
                psDed.setString(3, productName);
                psDed.executeUpdate();

                // 3. Log Distribution to Mall
                PreparedStatement psLog = conn.prepareStatement("INSERT INTO Mall_Distribution (Vendor_ID, Mall_Name, Product_Name, Quantity, Dist_Date) VALUES (?, ?, ?, ?, CURDATE())");
                psLog.setInt(1, vendorId);
                psLog.setString(2, mallName);
                psLog.setString(3, productName);
                psLog.setInt(4, quantity);
                psLog.executeUpdate();

                conn.commit();
                request.setAttribute("msg", "Success! Delivered " + quantity + " units to " + mallName);
                request.setAttribute("msgType", "success");
            } else {
                request.setAttribute("msg", "Error: Insufficient stock. Available: " + currentStock);
                request.setAttribute("msgType", "error");
            }

        } catch (Exception e) {
            try { if(conn!=null) conn.rollback(); } catch(SQLException ex){}
            e.printStackTrace();
            request.setAttribute("msg", "Error: " + e.getMessage());
        } finally {
            try { if(conn!=null) conn.setAutoCommit(true); } catch(SQLException ex){}
            DBUtil.closeConnection(conn);
        }
        
        request.getRequestDispatcher("vendor_dashboard.jsp").forward(request, response);
    }
}