package com.wms.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

// The class definition starts here
public class ReportDAO {

    // --- Methods for Admin Dashboard Cards ---

    public static int getTotalRestaurants() throws SQLException {
        String sql = "SELECT COUNT(Restaurant_ID) FROM Restaurant";
        return fetchSingleInt(sql);
    }
    
    public static double getTotalCollectionsToday() throws SQLException {
        String sql = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log WHERE Collection_Date = CURDATE()";
        return fetchSingleDouble(sql);
    }
    
    public static int getTotalActiveTrucks() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT Truck_ID) FROM Collection_Log WHERE Collection_Date = CURDATE()";
        return fetchSingleInt(sql);
    }
    
    public static double getTotalCollectionAllTime() throws SQLException {
        String sql = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log";
        return fetchSingleDouble(sql);
    }
    
    public static double getTotalCollectionThisMonth() throws SQLException {
        String sql = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log WHERE MONTH(Collection_Date) = MONTH(CURDATE()) AND YEAR(Collection_Date) = YEAR(CURDATE())";
        return fetchSingleDouble(sql);
    }
    
    public static double getTotalCollectionThisYear() throws SQLException {
        String sql = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log WHERE YEAR(Collection_Date) = YEAR(CURDATE())";
        return fetchSingleDouble(sql);
    }
    
    public static List<List<String>> getEmployeeCountsByRole() throws SQLException {
        List<List<String>> data = new ArrayList<>();
        String sql = "SELECT Role, COUNT(Emp_ID) as Total FROM Employee GROUP BY Role ORDER BY Role";
        
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            List<String> headers = new ArrayList<>();
            headers.add("Role");
            headers.add("Total Employees");
            data.add(headers);
            
            while (rs.next()) {
                List<String> row = new ArrayList<>();
                row.add(rs.getString("Role"));
                row.add(rs.getString("Total"));
                data.add(row);
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            DBUtil.closeConnection(conn);
        }
        return data;
    }

    
    // --- Methods for Restaurant Portal ---
    
    public static double[] getRestaurantWasteTotals(int restaurantId) throws SQLException {
        double[] totals = new double[3]; // All-Time, Month, Year
        String sqlAllTime = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log WHERE Restaurant_ID = ?";
        String sqlMonth = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log WHERE Restaurant_ID = ? AND MONTH(Collection_Date) = MONTH(CURDATE()) AND YEAR(Collection_Date) = YEAR(CURDATE())";
        String sqlYear = "SELECT COALESCE(SUM(Waste_Weight), 0) FROM Collection_Log WHERE Restaurant_ID = ? AND YEAR(Collection_Date) = YEAR(CURDATE())";

        Connection conn = null;
        PreparedStatement psAll = null, psMonth = null, psYear = null;
        ResultSet rsAll = null, rsMonth = null, rsYear = null;
        
        try {
            conn = DBUtil.getConnection();
            
            psAll = conn.prepareStatement(sqlAllTime);
            psAll.setInt(1, restaurantId);
            rsAll = psAll.executeQuery();
            if (rsAll.next()) totals[0] = rsAll.getDouble(1);
            
            psMonth = conn.prepareStatement(sqlMonth);
            psMonth.setInt(1, restaurantId);
            rsMonth = psMonth.executeQuery();
            if (rsMonth.next()) totals[1] = rsMonth.getDouble(1);
            
            psYear = conn.prepareStatement(sqlYear);
            psYear.setInt(1, restaurantId);
            rsYear = psYear.executeQuery();
            if (rsYear.next()) totals[2] = rsYear.getDouble(1);
            
        } finally {
            if (rsAll != null) rsAll.close();
            if (rsMonth != null) rsMonth.close();
            if (rsYear != null) rsYear.close();
            if (psAll != null) psAll.close();
            if (psMonth != null) psMonth.close();
            if (psYear != null) psYear.close();
            DBUtil.closeConnection(conn);
        }
        return totals;
    }
    
    public static List<List<String>> getRestaurantCollectionHistory(int restaurantId) throws SQLException {
        List<List<String>> data = new ArrayList<>();
        String sql = "SELECT Collection_Date, Waste_Type, Waste_Weight, Truck_ID FROM Collection_Log WHERE Restaurant_ID = ? ORDER BY Collection_Date DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, restaurantId);
            rs = ps.executeQuery();
            
            List<String> headers = new ArrayList<>();
            headers.add("Date");
            headers.add("Waste Type");
            headers.add("Weight (kg)");
            headers.add("Truck ID");
            data.add(headers);

            while (rs.next()) {
                List<String> row = new ArrayList<>();
                row.add(rs.getString("Collection_Date"));
                row.add(rs.getString("Waste_Type"));
                row.add(rs.getString("Waste_Weight"));
                row.add(rs.getString("Truck_ID"));
                data.add(row);
            }
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            DBUtil.closeConnection(conn);
        }
        return data;
    }

    
    // --- Helper Methods to Execute Single Value Queries ---

    private static int fetchSingleInt(String sql) throws SQLException {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                return rs.getInt(1);
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            DBUtil.closeConnection(conn);
        }
        return 0;
    }

    private static double fetchSingleDouble(String sql) throws SQLException {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            DBUtil.closeConnection(conn);
        }
        return 0.0;
    }

    
    // --- Method for Data Tables (Unchanged) ---
    
    public static List<List<String>> fetchTableData(String tableName) {
        List<List<String>> data = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            
            String sql;
            if (tableName.equalsIgnoreCase("Restaurant")) {
                sql = "SELECT Restaurant_ID, Name, Location, Contact_No, Daily_Waste_Quantity FROM Restaurant";
            } else if (tableName.equalsIgnoreCase("Employee")) {
                sql = "SELECT Emp_ID, First_Name, Last_Name, Role, Salary FROM Employee";
            } else if (tableName.equalsIgnoreCase("Collection_Log")) {
                sql = "SELECT Log_ID, Restaurant_ID, Collection_Date, Waste_Type, Waste_Weight FROM Collection_Log";
            } else if (tableName.equalsIgnoreCase("Vendor")) {
                sql = "SELECT Vendor_ID, Name, Category, License_No FROM Vendor";
            } else if (tableName.equalsIgnoreCase("Factory")) {
                sql = "SELECT Factory_ID, Name, Type, Production_Capacity FROM Factory";
            } else if (tableName.equalsIgnoreCase("Product")) {
                sql = "SELECT Product_ID, Factory_ID, Name, Type, Quantity, Price FROM Product";
            } else if (tableName.equalsIgnoreCase("Dumping_Zone")) {
                sql = "SELECT Zone_ID, Type, Capacity, Area FROM Dumping_Zone";
            } else {
                return data;
            }

            rs = stmt.executeQuery(sql);
            
            ResultSetMetaData meta = rs.getMetaData();
            List<String> headers = new ArrayList<>();
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                headers.add(meta.getColumnName(i));
            }
            data.add(headers);

            while (rs.next()) {
                List<String> row = new ArrayList<>();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    row.add(rs.getString(i));
                }
                data.add(row);
            }

        } catch (SQLException e) {
            System.err.println("ReportDAO Error fetching data for " + tableName + ": " + e.getMessage());
            List<String> errorRow = new ArrayList<>();
            
            // --- THIS IS THE CORRECTED LINE ---
            errorRow.add("Database Error: Failure fetching data.");
            
            data.add(errorRow);
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
            DBUtil.closeConnection(conn);
        }
        return data;
    }

} // <-- Final closing brace