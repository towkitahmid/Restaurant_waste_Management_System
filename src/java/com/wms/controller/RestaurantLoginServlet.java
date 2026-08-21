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

@WebServlet("/RestaurantLoginServlet")
public class RestaurantLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String pass = request.getParameter("password");
        
        try (Connection conn = DBUtil.getConnection()) {
            // Check credentials
            String sql = "SELECT * FROM Restaurant WHERE Name = ? AND Password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Create Restaurant object for session
                Restaurant r = new Restaurant();
                r.setRestaurantId(rs.getInt("Restaurant_ID"));
                r.setName(rs.getString("Name"));
                r.setDailyWasteQuantity(rs.getDouble("Daily_Waste_Quantity"));
                // Store in session
                HttpSession session = request.getSession();
                session.setAttribute("restaurant", r);
                response.sendRedirect("restaurant_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid Name or Password");
                request.getRequestDispatcher("restaurant_login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}