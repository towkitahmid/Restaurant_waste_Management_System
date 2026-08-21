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

@WebServlet("/ReportWasteServlet")
public class ReportWasteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            double wasteWeight = Double.parseDouble(request.getParameter("wasteWeight"));

            conn = DBUtil.getConnection();
            
            // LOGIC: ADD to the current stock (Daily_Waste_Quantity)
            // This represents the owner "Putting" waste out for collection
            String sql = "UPDATE Restaurant SET Daily_Waste_Quantity = Daily_Waste_Quantity + ? WHERE Restaurant_ID = ?";
            ps = conn.prepareStatement(sql);
            ps.setDouble(1, wasteWeight);
            ps.setInt(2, restaurantId);
            
            int rows = ps.executeUpdate();
            
            if (rows > 0) {
                message = "Success: Added " + wasteWeight + " kg to your waste stock.";
            } else {
                message = "Error: Could not update record.";
            }

        } catch (NumberFormatException e) {
            message = "Error: Invalid weight format.";
        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        request.setAttribute("message", message);
        request.getRequestDispatcher("restaurant_dashboard.jsp").forward(request, response);
    }
}