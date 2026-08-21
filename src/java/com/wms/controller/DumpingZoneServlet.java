package com.wms.controller;

import com.wms.model.DumpingZone;
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

@WebServlet("/DumpingZoneServlet")
public class DumpingZoneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        try {
            // 1. Get parameters
            String type = request.getParameter("type");
            double capacity = Double.parseDouble(request.getParameter("capacity"));
            String area = request.getParameter("area");

            DumpingZone zone = new DumpingZone(type, capacity, area);
            
            // 2. Database Operation
            conn = DBUtil.getConnection(); 
            String sql = "INSERT INTO Dumping_Zone (Type, Capacity, Area) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, zone.getType());
            ps.setDouble(2, zone.getCapacity());
            ps.setString(3, zone.getArea());
            
            ps.executeUpdate();
            message = "Registration successful! Dumping Zone '" + area + "' has been added.";

        } catch (NumberFormatException e) {
            message = "Error: Capacity must be a valid number.";
        } catch (SQLException e) {
            message = "Database Error: Failed to register zone. Details: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        // 3. Forward to the new JSP page
        request.setAttribute("message", message);
        request.getRequestDispatcher("dumping_zone_registration.jsp").forward(request, response);
    }
}