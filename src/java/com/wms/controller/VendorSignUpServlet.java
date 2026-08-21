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

@WebServlet("/VendorSignUpServlet")
public class VendorSignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        // Get form data
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String licenseNo = request.getParameter("licenseNo");
        String password = request.getParameter("password");

        try {
            conn = DBUtil.getConnection(); 
            
            // --- FIX: Removed 'Current_Stock' from the query ---
            String sql = "INSERT INTO Vendor (Name, Category, License_No, Password) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, name);
            ps.setString(2, category);
            ps.setString(3, licenseNo);
            ps.setString(4, password);
            
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // Success: Redirect to Login
                request.setAttribute("message", "Registration successful! Please log in.");
                request.getRequestDispatcher("vendor_login.jsp").forward(request, response);
                return;
            } else {
                message = "Registration failed. Please try again.";
            }

        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
        } catch (Exception e) {
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        // Failure: Send back to Sign Up page
        request.setAttribute("message", message);
        request.getRequestDispatcher("vendor_signup.jsp").forward(request, response);
    }
}