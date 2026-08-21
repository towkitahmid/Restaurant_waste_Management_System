package com.wms.controller;

import com.wms.model.Vendor;
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

@WebServlet("/VendorServlet")
public class VendorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        try {
            String name = request.getParameter("name");
            String category = request.getParameter("category");
            String licenseNo = request.getParameter("licenseNo");

            Vendor vendor = new Vendor(name, category, licenseNo);
            
            conn = DBUtil.getConnection(); 
            String sql = "INSERT INTO Vendor (Name, Category, License_No) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, vendor.getName());
            ps.setString(2, vendor.getCategory());
            ps.setString(3, vendor.getLicenseNo());
            
            ps.executeUpdate();
            message = "Registration successful! Vendor '" + name + "' has been added.";

        } catch (SQLException e) {
            message = "Database Error: Failed to register vendor. Details: " + e.getMessage();
        } catch (Exception e) {
            message = "An unexpected Java error occurred: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        // Note: You need to create a vendor_registration.jsp page to display the result
        request.setAttribute("message", message);
        request.getRequestDispatcher("vendor_registration.jsp").forward(request, response);
    }
}