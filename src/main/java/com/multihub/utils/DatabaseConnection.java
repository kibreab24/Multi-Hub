package com.multihub.utils;

import java.sql.*;
import java.util.Properties;
import java.io.InputStream;

public class DatabaseConnection {
    private static Connection connection = null;
    
    public static Connection getConnection() {
        if (connection == null) {
            try {
                // Load database properties
                Properties props = new Properties();
                InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("database.properties");
                
                if (input == null) {
                    System.out.println("⚠️ database.properties not found!");
                    return null;
                }
                
                props.load(input);
                
                // For testing without Supabase yet
                String url = "jdbc:h2:mem:test;DB_CLOSE_DELAY=-1";
                connection = DriverManager.getConnection(url);
                
                System.out.println("✅ Database connected successfully");
                
            } catch (Exception e) {
                System.out.println("❌ Database connection failed: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return connection;
    }
}
