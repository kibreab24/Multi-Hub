package com.multihub.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

public class DatabaseConnection {
    private static Connection connection = null;
    
    public static Connection getConnection() {
        if (connection == null) {
            try {
                // Load database configuration
                Properties props = new Properties();
                InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("database.properties");
                
                if (input == null) {
                    // For development - use H2 in-memory database
                    String url = "jdbc:h2:mem:multihub;DB_CLOSE_DELAY=-1;INIT=CREATE SCHEMA IF NOT EXISTS multihub";
                    String user = "sa";
                    String password = "";
                    
                    connection = DriverManager.getConnection(url, user, password);
                    createTables(connection); // Create initial tables
                    
                    System.out.println("✅ Connected to H2 in-memory database (development)");
                } else {
                    // Production - load from properties file
                    props.load(input);
                    String url = props.getProperty("db.url");
                    String user = props.getProperty("db.user");
                    String password = props.getProperty("db.password");
                    
                    connection = DriverManager.getConnection(url, user, password);
                    System.out.println("✅ Connected to production database");
                }
                
            } catch (Exception e) {
                System.out.println("❌ Database connection failed: " + e.getMessage());
                e.printStackTrace();
            }
        }
        return connection;
    }
    
    private static void createTables(Connection conn) throws SQLException {
        String createUsersTable = """
            CREATE TABLE IF NOT EXISTS users (
                id VARCHAR(50) PRIMARY KEY,
                email VARCHAR(255) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                full_name VARCHAR(100),
                role VARCHAR(20),
                is_verified BOOLEAN DEFAULT FALSE,
                is_approved BOOLEAN DEFAULT FALSE,
                rating DECIMAL(3,2) DEFAULT 0.00,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """;
        
        conn.createStatement().execute(createUsersTable);
        System.out.println("✅ Created users table");
    }
    
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                connection = null;
                System.out.println("✅ Database connection closed");
            }
        } catch (SQLException e) {
            System.out.println("❌ Error closing connection: " + e.getMessage());
        }
    }
}
