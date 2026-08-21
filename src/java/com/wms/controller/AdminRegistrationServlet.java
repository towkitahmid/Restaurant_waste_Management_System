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

@WebServlet("/AdminRegistrationServlet")
public class AdminRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        // Get all form parameters
        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String role = request.getParameter("role");
        String password = request.getParameter("password");

        try {
            conn = DBUtil.getConnection(); 
            // Insert into the Management table
            String sql = "INSERT INTO Management (Name, Contact, Role, Password) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, name);
            ps.setString(2, contact);
            ps.setString(3, role);
            ps.setString(4, password); // Save the password
            
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                message = "Success! New admin account '" + name + "' has been created.";
            } else {
                message = "Creation failed. Please try again.";
            }

        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) { 
                message = "Error: An admin with this name already exists.";
            } else {
                message = "Database Error: " + e.getMessage();
            }
        } catch (Exception e) {
            message = "An unexpected Java error occurred: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        // Send back to the same registration page with a message
        request.setAttribute("message", message);
        request.getRequestDispatcher("admin_registration.jsp").forward(request, response);
    }
}