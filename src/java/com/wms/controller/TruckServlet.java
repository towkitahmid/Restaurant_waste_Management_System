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

@WebServlet("/TruckServlet")
public class TruckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        try {
            String type = request.getParameter("type");
            double capacity = Double.parseDouble(request.getParameter("capacity"));
            String regArea = request.getParameter("regArea");
            int driverId = Integer.parseInt(request.getParameter("driverId"));

            conn = DBUtil.getConnection(); 
            
            String sql = "INSERT INTO Waste_Collection_Truck (Type, Capacity, Reg_Area, Driver_Emp_ID) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, type);
            ps.setDouble(2, capacity);
            ps.setString(3, regArea);
            ps.setInt(4, driverId);
            
            int rows = ps.executeUpdate();
            
            if(rows > 0) {
                message = "Success! Truck registered and assigned to driver.";
            } else {
                message = "Error: Could not register truck.";
            }

        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
        } catch (Exception e) {
            message = "An unexpected error occurred: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { /* ignore */ }
            DBUtil.closeConnection(conn);
        }
        
        request.setAttribute("message", message);
        request.getRequestDispatcher("truck_registration.jsp").forward(request, response);
    }
}