package com.wms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/wms_db"; 
    private static final String JDBC_USER = "stephen"; // YOUR ACTUAL USERNAME
    private static final String JDBC_PASSWORD = "1234"; // YOUR ACTUAL PASSWORD
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() throws SQLException {
        Connection conn = null;
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
            return conn;
            
        } catch (ClassNotFoundException e) {
            System.err.println("FATAL ERROR: JDBC Driver not found. Check Libraries.");
            throw new SQLException("JDBC Driver not available or classpath incorrect.", e);
        } catch (SQLException e) {
            System.err.println("FATAL ERROR: Could not connect to database. Check URL/credentials.");
            throw e;
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}