package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/FactoryShipmentServlet")
public class FactoryShipmentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String factoryName = request.getParameter("factoryName"); // We need ID, but usually get Name from dropdown
        int vendorId = Integer.parseInt(request.getParameter("vendorId"));
        String productName = request.getParameter("productName");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            
            // 1. Get Factory ID from Name
            int factoryId = 0;
            PreparedStatement psF = conn.prepareStatement("SELECT Factory_ID FROM Factory WHERE Name = ?");
            psF.setString(1, factoryName);
            ResultSet rsF = psF.executeQuery();
            if(rsF.next()) factoryId = rsF.getInt(1);
            
            // 2. Log the Shipment (Factory -> Vendor)
            String sqlShip = "INSERT INTO Factory_Shipment (Factory_ID, Vendor_ID, Product_Name, Quantity, Shipment_Date) VALUES (?, ?, ?, ?, CURDATE())";
            PreparedStatement ps = conn.prepareStatement(sqlShip);
            ps.setInt(1, factoryId);
            ps.setInt(2, vendorId);
            ps.setString(3, productName);
            ps.setInt(4, quantity);
            ps.executeUpdate();

            // 3. Update Vendor Inventory (Add Stock)
            // Check if vendor already has this product
            String sqlCheck = "SELECT Inventory_ID FROM Vendor_Product_Inventory WHERE Vendor_ID = ? AND Product_Name = ?";
            PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
            psCheck.setInt(1, vendorId);
            psCheck.setString(2, productName);
            ResultSet rsCheck = psCheck.executeQuery();

            if (rsCheck.next()) {
                // Update existing record
                String sqlUpdate = "UPDATE Vendor_Product_Inventory SET Quantity = Quantity + ? WHERE Vendor_ID = ? AND Product_Name = ?";
                PreparedStatement psUp = conn.prepareStatement(sqlUpdate);
                psUp.setInt(1, quantity);
                psUp.setInt(2, vendorId);
                psUp.setString(3, productName);
                psUp.executeUpdate();
            } else {
                // Insert new record
                String sqlIns = "INSERT INTO Vendor_Product_Inventory (Vendor_ID, Product_Name, Quantity) VALUES (?, ?, ?)";
                PreparedStatement psIn = conn.prepareStatement(sqlIns);
                psIn.setInt(1, vendorId);
                psIn.setString(2, productName);
                psIn.setInt(3, quantity);
                psIn.executeUpdate();
            }

            request.setAttribute("msg", "Successfully shipped " + quantity + " " + productName + " to Vendor.");
            request.setAttribute("msgType", "success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("msg", "Error: " + e.getMessage());
        } finally {
            DBUtil.closeConnection(conn);
        }
        
        request.getRequestDispatcher("factory_dashboard.jsp").forward(request, response);
    }
}