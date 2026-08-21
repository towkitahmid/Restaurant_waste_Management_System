package com.wms.controller;

import com.wms.util.DBUtil;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/VendorLoginServlet")
public class VendorLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String pass = request.getParameter("password");
        
        try (Connection conn = DBUtil.getConnection()) {
            // Check credentials
            String sql = "SELECT * FROM Vendor WHERE Name = ? AND Password = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, pass);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Store Vendor details in Session
                HttpSession session = request.getSession();
                session.setAttribute("vendorId", rs.getInt("Vendor_ID"));
                session.setAttribute("vendorName", rs.getString("Name"));
                session.setAttribute("vendorCategory", rs.getString("Category"));
                
                response.sendRedirect("vendor_dashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid Vendor Name or Password");
                request.getRequestDispatcher("vendor_login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}