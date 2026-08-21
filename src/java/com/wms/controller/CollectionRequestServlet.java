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

@WebServlet("/CollectionRequestServlet")
public class CollectionRequestServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Restaurant r = (Restaurant) session.getAttribute("restaurant");
        
        if (r != null) {
            String dateStr = request.getParameter("date");
            String type = request.getParameter("type");
            double weight = Double.parseDouble(request.getParameter("weight"));
            
            try (Connection conn = DBUtil.getConnection()) {
                // Truck_ID is omitted (NULL) to indicate a pending request
                String sql = "INSERT INTO Collection_Log (Restaurant_ID, Collection_Date, Waste_Type, Waste_Weight, Truck_ID) VALUES (?, ?, ?, ?, NULL)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, r.getRestaurantId());
                ps.setDate(2, Date.valueOf(dateStr));
                ps.setString(3, type);
                ps.setDouble(4, weight);
                ps.executeUpdate();
                
                request.setAttribute("reqMessage", "Collection request sent successfully!");
            } catch (Exception e) {
                request.setAttribute("reqMessage", "Error: " + e.getMessage());
            }
        }
        request.getRequestDispatcher("restaurant_dashboard.jsp").forward(request, response);
    }
}