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

@WebServlet("/RestaurantSignUpServlet")
public class RestaurantSignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        // Get all form parameters
        String name = request.getParameter("name");
        String location = request.getParameter("location");
        String contactNo = request.getParameter("contactNo");
        double wasteQuantity = Double.parseDouble(request.getParameter("wasteQuantity"));
        String password = request.getParameter("password"); // The new password

        try {
            conn = DBUtil.getConnection(); 
            String sql = "INSERT INTO Restaurant (Name, Location, Contact_No, Daily_Waste_Quantity, Password) VALUES (?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, name);
            ps.setString(2, location);
            ps.setString(3, contactNo);
            ps.setDouble(4, wasteQuantity);
            ps.setString(5, password); // Save the password
            
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                // On success, send them to the login page with a success message
                request.setAttribute("message", "Sign up successful! Please log in with your new account.");
                request.getRequestDispatcher("restaurant_login.jsp").forward(request, response);
                return; // Stop execution
            } else {
                message = "Sign up failed. Please try again.";
            }

        } catch (NumberFormatException e) {
            message = "Error: Daily Waste Quantity must be a valid number.";
        } catch (SQLException e) {
            // Handle unique constraint violation (e.g., restaurant name already exists)
            if (e.getErrorCode() == 1062) { // 1062 is MySQL's error code for "Duplicate entry"
                message = "Error: A restaurant with this name already exists.";
            } else {
                message = "Database Error: " + e.getMessage();
            }
        } catch (Exception e) {
            message = "An unexpected Java error occurred: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        // If we are here, an error occurred. Send back to the sign-up page.
        request.setAttribute("message", message);
        request.getRequestDispatcher("restaurant_signup.jsp").forward(request, response);
    }
}