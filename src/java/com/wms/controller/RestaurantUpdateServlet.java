package com.wms.controller;

import com.wms.model.Restaurant;
import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/RestaurantUpdateServlet")
public class RestaurantUpdateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Restaurant r = (Restaurant) session.getAttribute("restaurant");
        
        if (r != null) {
            double newQty = Double.parseDouble(request.getParameter("dailyWaste"));
            
            try (Connection conn = DBUtil.getConnection()) {
                String sql = "UPDATE Restaurant SET Daily_Waste_Quantity = ? WHERE Restaurant_ID = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setDouble(1, newQty);
                ps.setInt(2, r.getRestaurantId());
                ps.executeUpdate();
                
                // Update session object so dashboard reflects change immediately
                r.setDailyWasteQuantity(newQty);
                request.setAttribute("updateMessage", "Profile updated successfully!");
            } catch (Exception e) {
                request.setAttribute("updateMessage", "Error: " + e.getMessage());
            }
        }
        request.getRequestDispatcher("restaurant_dashboard.jsp").forward(request, response);
    }
}