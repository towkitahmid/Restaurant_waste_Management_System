package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/LogisticsServlet")
public class LogisticsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            if ("assignPickup".equals(action)) {
                // ============================================================
                // SCENARIO 1: Restaurant -> Zone (ADD WASTE TO ZONE)
                // ============================================================
                int logId = Integer.parseInt(request.getParameter("logId"));
                int truckId = Integer.parseInt(request.getParameter("truckId"));
                int zoneId = Integer.parseInt(request.getParameter("zoneId"));

                // 1. Get the weight of this specific request
                double wasteWeight = 0.0;
                PreparedStatement psGetWeight = conn.prepareStatement("SELECT Waste_Weight FROM Collection_Log WHERE Log_ID = ?");
                psGetWeight.setInt(1, logId);
                ResultSet rs = psGetWeight.executeQuery();
                if (rs.next()) {
                    wasteWeight = rs.getDouble("Waste_Weight");
                }
                rs.close();
                psGetWeight.close();

                // 2. Update Collection_Log (Assign Truck/Zone)
                String sqlUpdateLog = "UPDATE Collection_Log SET Truck_ID = ?, Zone_ID = ?, Status = 'Collected' WHERE Log_ID = ?";
                PreparedStatement psLog = conn.prepareStatement(sqlUpdateLog);
                psLog.setInt(1, truckId);
                psLog.setInt(2, zoneId);
                psLog.setInt(3, logId);
                psLog.executeUpdate();
                psLog.close();

                // 3. Update Dumping_Zone (ADD the waste to inventory)
                String sqlUpdateZone = "UPDATE Dumping_Zone SET Current_Waste = Current_Waste + ? WHERE Zone_ID = ?";
                PreparedStatement psZone = conn.prepareStatement(sqlUpdateZone);
                psZone.setDouble(1, wasteWeight);
                psZone.setInt(2, zoneId);
                psZone.executeUpdate();
                psZone.close();

                conn.commit(); 
                response.sendRedirect("dashboard.jsp"); 

            } else if ("transferToFactory".equals(action)) {
                // ============================================================
                // SCENARIO 2: Zone -> Factory (SUBTRACT WASTE FROM ZONE)
                // ============================================================
                int zoneId = Integer.parseInt(request.getParameter("sourceZoneId"));
                int factoryId = Integer.parseInt(request.getParameter("factoryId"));
                double amount = Double.parseDouble(request.getParameter("amount"));
                int truckId = 1; // Default truck for internal transfer

                // 1. Check if Zone has enough waste
                double currentZoneWaste = 0.0;
                PreparedStatement psCheck = conn.prepareStatement("SELECT Current_Waste FROM Dumping_Zone WHERE Zone_ID = ?");
                psCheck.setInt(1, zoneId);
                ResultSet rsCheck = psCheck.executeQuery();
                if (rsCheck.next()) currentZoneWaste = rsCheck.getDouble(1);
                rsCheck.close();
                psCheck.close();

                if (currentZoneWaste < amount) {
                    // Not enough waste!
                    conn.rollback();
                    response.getWriter().println("Error: Not enough waste in this zone. Available: " + currentZoneWaste + "kg");
                    return;
                }

                // 2. Insert into Supply_Log (Create Shipment)
                // Note: Vendor_ID is NULL because it comes from a Zone
                String sqlSupply = "INSERT INTO Supply_Log (Vendor_ID, Factory_ID, Material_Name, Supply_Date, Quantity, Current_Quantity, Source_Zone_ID, Truck_ID) " +
                                   "VALUES (NULL, ?, 'Mixed Waste', CURDATE(), ?, ?, ?, ?)";
                PreparedStatement psSupply = conn.prepareStatement(sqlSupply);
                psSupply.setInt(1, factoryId);
                psSupply.setDouble(2, amount); 
                psSupply.setDouble(3, amount); 
                psSupply.setInt(4, zoneId);
                psSupply.setInt(5, truckId);
                psSupply.executeUpdate();
                psSupply.close();

                // 3. Update Dumping_Zone (SUBTRACT the waste)
                String sqlDeductZone = "UPDATE Dumping_Zone SET Current_Waste = Current_Waste - ? WHERE Zone_ID = ?";
                PreparedStatement psDeduct = conn.prepareStatement(sqlDeductZone);
                psDeduct.setDouble(1, amount);
                psDeduct.setInt(2, zoneId);
                psDeduct.executeUpdate();
                psDeduct.close();

                conn.commit();
                response.sendRedirect("dashboard.jsp");
            }

        } catch (Exception e) {
            try { if(conn != null) conn.rollback(); } catch(SQLException ex) {}
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        } finally {
            try { if(conn != null) conn.setAutoCommit(true); } catch(SQLException ex) {}
            DBUtil.closeConnection(conn);
        }
    }
}