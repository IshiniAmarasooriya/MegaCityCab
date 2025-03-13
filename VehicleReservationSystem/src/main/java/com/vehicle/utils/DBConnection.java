package com.vehicle.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static DBConnection instance;
    private static final String URL = "jdbc:mysql://localhost:3306/vehicle_reservation_db";
    private static final String USER = "root";       
    private static final String PASSWORD = "1234"; 

    // Private constructor prevents instantiation from other classes
    private DBConnection() throws Exception {
        // Load the JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
    }

    // Double-checked locking for thread safety
    public static DBConnection getInstance() throws Exception {
        if (instance == null) {
            synchronized (DBConnection.class) {
                if (instance == null) {
                    instance = new DBConnection();
                }
            }
        }
        return instance;
    }

    // Returns a new connection; consider a connection pool for production apps
    public Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
