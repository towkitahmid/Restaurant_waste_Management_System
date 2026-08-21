package com.wms.controller;

import com.wms.model.Employee;
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

@WebServlet("/EmployeeServlet")
public class EmployeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        String message = "";
        
        try {
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String role = request.getParameter("role");
            String gender = request.getParameter("gender");
            double salary = Double.parseDouble(request.getParameter("salary"));
            int managerId = Integer.parseInt(request.getParameter("managerId"));

            Employee employee = new Employee(firstName, lastName, role, gender, salary, managerId);
            
            conn = DBUtil.getConnection(); 
            String sql = "INSERT INTO Employee (First_Name, Last_Name, Role, Gender, Salary, Manager_ID) VALUES (?, ?, ?, ?, ?, ?)";
            
            ps = conn.prepareStatement(sql);
            
            ps.setString(1, employee.getFirstName());
            ps.setString(2, employee.getLastName());
            ps.setString(3, employee.getRole());
            ps.setString(4, employee.getGender());
            ps.setDouble(5, employee.getSalary());
            ps.setInt(6, employee.getManagerId());
            
            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                message = "Registration successful! Employee '" + firstName + " " + lastName + "' has been added.";
            } else {
                message = "Registration failed. Database updated 0 rows.";
            }

        } catch (NumberFormatException e) {
            message = "Error: Salary and Manager ID must be valid numbers.";
        } catch (SQLException e) {
            message = "Database Error: Failed to register employee. Details: " + e.getMessage();
        } catch (Exception e) {
            message = "An unexpected Java error occurred: " + e.getMessage();
        } finally {
            if (ps != null) { try { ps.close(); } catch (SQLException e) {}}
            DBUtil.closeConnection(conn);
        }
        
        request.setAttribute("message", message);
        request.getRequestDispatcher("employee_registration.jsp").forward(request, response);
    }
}