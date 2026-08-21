package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SegregationServlet")
public class SegregationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        String message = "";
        
        try {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            int vendorId = Integer.parseInt(request.getParameter("vendorId"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            String material = request.getParameter("material"); 

            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 1. Log the Segregation (Vendor pick up)
            // Using Store_ID column to store Zone_ID
            String sqlLog = "INSERT INTO Segregation_Log (Store_ID, Vendor_ID, Quantity, Material_Segregated, Segregation_Date) VALUES (?, ?, ?, ?, CURDATE())";
            PreparedStatement psLog = conn.prepareStatement(sqlLog);
            psLog.setInt(1, zoneId); 
            psLog.setInt(2, vendorId);
            psLog.setDouble(3, amount);
            psLog.setString(4, material);
            psLog.executeUpdate();

            // 2. Reduce Load from Dumping Zone (Deduct waste)
            String sqlUpdate = "UPDATE Dumping_Zone SET Current_Load = GREATEST(Current_Load - ?, 0) WHERE Zone_ID = ?";
            PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setDouble(1, amount);
            psUpdate.setInt(2, zoneId);
            psUpdate.executeUpdate();

            conn.commit();
            message = "Success: " + amount + "kg assigned to Vendor successfully.";
            
        } catch (NumberFormatException e) {
            message = "Error: Invalid number format.";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            try { if(conn != null) conn.rollback(); } catch(Exception ex) {}
        } finally {
            DBUtil.closeConnection(conn);
        }
        
        request.setAttribute("message", message);
        // Redirect back to the merged Zone Panel
        request.getRequestDispatcher("dumping_zone_registration.jsp").forward(request, response);
    }
}