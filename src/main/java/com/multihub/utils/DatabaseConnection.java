package com.multihub.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;

public class DatabaseConnection {
    // DON'T store connection as singleton - create new each time

    public static Connection getConnection() {
        Connection connection = null; // Create new connection each time
        try {
            // Load database configuration
            Properties props = new Properties();
            InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("database.properties");

            if (input == null) {
                throw new RuntimeException("❌ database.properties file not found!");
            }

            props.load(input);
            String url = props.getProperty("db.url");
            String user = props.getProperty("db.user");
            String password = props.getProperty("db.password");

            // For Supabase connection pooler, we need special handling
            if (url.contains("pooler.supabase.com")) {
                // Add connection parameters for pooler
                url += "?sslmode=require&prepareThreshold=0";
            }

            // Load PostgreSQL driver
            Class.forName("org.postgresql.Driver");

            // Create NEW connection
            connection = DriverManager.getConnection(url, user, password);

            // Set auto-commit to true (default)
            connection.setAutoCommit(true);

            return connection;

        } catch (Exception e) {
            System.out.println("❌ Database connection failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    // Always close connections after use
    public static void closeConnection(Connection conn) {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            System.out.println("❌ Error closing connection: " + e.getMessage());
        }
    }

    // Test connection
    public static void main(String[] args) {
        System.out.println("🚀 Testing database connection...");
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Connected to Supabase!");

                // Test query
                var stmt = conn.createStatement();
                var rs = stmt.executeQuery("SELECT version()");
                if (rs.next()) {
                    System.out.println("📊 Database: " + rs.getString(1));
                }
            }
        } catch (Exception e) {
            System.out.println("❌ Connection test failed: " + e.getMessage());
        }
    }
}