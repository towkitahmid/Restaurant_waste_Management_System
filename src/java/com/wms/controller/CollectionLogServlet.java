package com.wms.controller;

import com.wms.model.CollectionLog;
import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CollectionLogServlet")
public class CollectionLogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";

        try {
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
            String collectionDateStr = request.getParameter("collectionDate");
            String wasteType = request.getParameter("wasteType");
            double wasteWeight = Double.parseDouble(request.getParameter("wasteWeight"));
            int truckId = Integer.parseInt(request.getParameter("truckId"));
            // NEW: Get Zone ID
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));

            Date collectionDate = Date.valueOf(collectionDateStr);
            
            // Create object with new zoneId
            CollectionLog log = new CollectionLog(restaurantId, collectionDate, wasteType, wasteWeight, truckId, zoneId);

            conn = DBUtil.getConnection();
            // Updated SQL Query
            String sql = "INSERT INTO Collection_Log (Restaurant_ID, Collection_Date, Waste_Type, Waste_Weight, Truck_ID, Zone_ID) VALUES (?, ?, ?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);

            ps.setInt(1, log.getRestaurantId());
            ps.setDate(2, log.getCollectionDate());
            ps.setString(3, log.getWasteType());
            ps.setDouble(4, log.getWasteWeight());
            ps.setInt(5, log.getTruckId());
            ps.setInt(6, log.getZoneId()); // Set Zone ID

            ps.executeUpdate();
            message = "Collection Log successful! Dumped at Zone ID " + zoneId;

        } catch (NumberFormatException e) {
            message = "Error: Please ensure all selections (Restaurant, Truck, Zone) are valid.";
        } catch (SQLException e) {
            message = "Database Error: " + e.getMessage();
        } catch (Exception e) {
            message = "Unexpected Error: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }

        request.setAttribute("message", message);
        request.getRequestDispatcher("collection_log.jsp").forward(request, response);
    }
}