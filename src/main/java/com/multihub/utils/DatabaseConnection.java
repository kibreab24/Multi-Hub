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
                // Load database configuration from properties file
                Properties props = new Properties();
                InputStream input = DatabaseConnection.class.getClassLoader()
                    .getResourceAsStream("database.properties");
                
                if (input == null) {
                    throw new RuntimeException("❌ database.properties file not found! "
                        + "Create it in src/main/resources/");
                }
                
                props.load(input);
                String url = props.getProperty("db.url");
                String user = props.getProperty("db.user");
                String password = props.getProperty("db.password");
                
                System.out.println("🔗 Connecting to: " + url);
                System.out.println("👤 User: " + user);
                
                // Load PostgreSQL driver
                Class.forName("org.postgresql.Driver");
                
                // Create connection
                connection = DriverManager.getConnection(url, user, password);
                System.out.println("✅ Connected to Supabase PostgreSQL database!");
                
                // Test the connection with a simple query
                testConnection(connection);
                
            } catch (Exception e) {
                System.out.println("❌ Database connection failed!");
                System.out.println("Error: " + e.getMessage());
                e.printStackTrace();
                
                // Provide helpful debugging info
                System.out.println("\n🔧 DEBUGGING TIPS:");
                System.out.println("1. Check if database.properties file exists in src/main/resources/");
                System.out.println("2. Verify Supabase password is correct");
                System.out.println("3. Check if Connection Pooling is disabled in Supabase");
                System.out.println("4. Make sure pom.xml has PostgreSQL dependency");
            }
        }
        return connection;
    }
    
    private static void testConnection(Connection conn) throws SQLException {
        var stmt = conn.createStatement();
        var rs = stmt.executeQuery("SELECT version()");
        if (rs.next()) {
            System.out.println("📊 Database: " + rs.getString(1));
        }
        
        // Check if users table exists
        rs = stmt.executeQuery(
            "SELECT EXISTS (SELECT FROM information_schema.tables " +
            "WHERE table_schema = 'public' AND table_name = 'users')"
        );
        if (rs.next()) {
            System.out.println("📋 Users table exists: " + rs.getBoolean(1));
        }
    }
    
    public static void main(String[] args) {
        System.out.println("🚀 Testing database connection...");
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("\n🎉 SUCCESS! Database connection is working!");
        } else {
            System.out.println("\n❌ FAILED! Could not connect to database.");
        }
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
