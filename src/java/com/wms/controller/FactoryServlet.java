package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FactoryServlet")
public class FactoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement psFactory = null;
        String message = "";
        
        try {
            // 1. Get Factory Data (Removed Product & Capacity inputs)
            String factoryName = request.getParameter("factoryName");
            String factoryType = request.getParameter("factoryType");
            
            // Default capacity to 0 since we removed it from the UI
            double capacity = 0.0; 

            conn = DBUtil.getConnection(); 
            
            // 2. Insert Factory
            String sqlFactory = "INSERT INTO Factory (Name, Type, Production_Capacity) VALUES (?, ?, ?)";
            psFactory = conn.prepareStatement(sqlFactory);
            psFactory.setString(1, factoryName);
            psFactory.setString(2, factoryType);
            psFactory.setDouble(3, capacity);
            
            int rows = psFactory.executeUpdate();
            
            if(rows > 0) {
                message = "Registration successful! Factory '" + factoryName + "' has been added.";
            } else {
                message = "Error: Could not register factory.";
            }

        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
        } catch (Exception e) {
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            try { if (psFactory != null) psFactory.close(); } catch (SQLException e) { /* ignore */ }
            DBUtil.closeConnection(conn);
        }
        
        request.setAttribute("message", message);
        request.getRequestDispatcher("factory_registration.jsp").forward(request, response);
    }
}