package com.wms.controller;

import com.wms.model.Restaurant;
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

@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        try {
            String name = request.getParameter("name");
            String location = request.getParameter("location");
            String contactNo = request.getParameter("contactNo");
            double wasteQuantity = Double.parseDouble(request.getParameter("wasteQuantity"));

            Restaurant restaurant = new Restaurant(name, location, contactNo, wasteQuantity);
            
            conn = DBUtil.getConnection(); 
            String sql = "INSERT INTO Restaurant (Name, Location, Contact_No, Daily_Waste_Quantity) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getLocation());
            ps.setString(3, restaurant.getContactNo());
            ps.setDouble(4, restaurant.getDailyWasteQuantity());
            
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                message = "Registration successful! Restaurant '" + name + "' has been added.";
            } else {
                message = "Registration failed. Database updated 0 rows.";
            }

        } catch (NumberFormatException e) {
            message = "Error: Daily Waste Quantity must be a valid number.";
        } catch (SQLException e) {
            message = "Database Error: Failed to register restaurant. Details: " + e.getMessage();
        } catch (Exception e) {
            message = "An unexpected Java error occurred: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        request.setAttribute("message", message);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}