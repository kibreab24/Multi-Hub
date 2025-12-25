package com.multihub.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import com.multihub.models.User;
import com.multihub.utils.DatabaseConnection;

public class UserDAO {

    public boolean emailExists(String email) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            rs.close();
            pstmt.close();
        } catch (SQLException e) {
            System.out.println("❌ Error checking email: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return false;
    }

    // Register new user - with proper connection handling
    public boolean registerUser(User user) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "INSERT INTO users (id, email, password_hash, full_name, role) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            // FIX: Create the UUID here and use setObject
            UUID newId = UUID.randomUUID();
            String hashedPassword = hashPassword(user.getPasswordHash());

            pstmt.setObject(1, newId); // This fixes the 'character varying' error
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, hashedPassword);
            pstmt.setString(4, user.getFullName());
            pstmt.setString(5, user.getRole());

            int rows = pstmt.executeUpdate();
            pstmt.close();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("❌ Error registering user: " + e.getMessage());
            return false;
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
    }

    // Login user - with proper connection handling
    public User loginUser(String email, String password) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getConnection();
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password_hash");

                // Verify password with PBKDF2
                if (verifyPassword(password, storedHash)) {
                    User user = new User();
                    user.setId(UUID.fromString(rs.getString("id")));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setRole(rs.getString("role"));
                    user.setVerified(rs.getBoolean("is_verified"));
                    user.setApproved(rs.getBoolean("is_approved"));
                    user.setRating(rs.getDouble("rating"));

                    rs.close();
                    pstmt.close();
                    return user;
                }
            }
            rs.close();
            pstmt.close();
        } catch (SQLException e) {
            System.out.println("❌ Error logging in: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DatabaseConnection.closeConnection(conn);
        }
        return null;
    }

    private static String hashPassword(String password) {
        try {
            int iterations = 65536;
            int keyLength = 256;
            byte[] salt = new byte[16];
            SecureRandom sr = new SecureRandom();
            sr.nextBytes(salt);
            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keyLength);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] hash = skf.generateSecret(spec).getEncoded();
            return iterations + ":" + Base64.getEncoder().encodeToString(salt) + ":"
                    + Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new RuntimeException(e);
        }
    }

    private static boolean verifyPassword(String password, String stored) {
        try {
            String[] parts = stored.split(":");
            int iterations = Integer.parseInt(parts[0]);
            byte[] salt = Base64.getDecoder().decode(parts[1]);
            byte[] hash = Base64.getDecoder().decode(parts[2]);

            PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, hash.length * 8);
            SecretKeyFactory skf = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
            byte[] testHash = skf.generateSecret(spec).getEncoded();

            int diff = hash.length ^ testHash.length;
            for (int i = 0; i < Math.min(hash.length, testHash.length); i++) {
                diff |= hash[i] ^ testHash[i];
            }
            return diff == 0;
        } catch (NoSuchAlgorithmException | InvalidKeySpecException | NumberFormatException
                | ArrayIndexOutOfBoundsException e) {
            return false;
        }
    }

    public int getTotalUserCount() {
        int count = 0;
        String query = "SELECT COUNT(*) FROM users";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(query);
                ResultSet rs = pstmt.executeQuery()) {
            if (rs.next())
                count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<User> getRecentUsers(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, full_name, email, role FROM users ORDER BY created_at DESC LIMIT ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                User u = new User();
                u.setId((java.util.UUID) rs.getObject("id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                users.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }

    public User getUserById(UUID id) {
        String sql = "SELECT id, full_name, email, role, phone, rating FROM users WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setObject(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId((UUID) rs.getObject("id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setRating(rs.getDouble("rating"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update User Profile
    public boolean updateUserProfile(UUID id, String fullName, String phone) {
        String sql = "UPDATE users SET full_name = ?, phone = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, fullName);
            pstmt.setString(2, phone);
            pstmt.setObject(3, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Simple Notification Logic: Fetching recent status changes
    public List<String> getUserNotifications(UUID userId) {
        List<String> notes = new ArrayList<>();
        // Example: Getting notes for listings that were approved/rejected recently
        String sql = "SELECT title, status FROM listings WHERE user_id = ? AND status != 'pending'";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, userId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                notes.add("Your listing '" + rs.getString("title") + "' is now " + rs.getString("status") + ".");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notes;
    }

    // Test method - FIXED
    public static void createTestUser() {
        User testUser = new User();
        testUser.setEmail("test@multihub.com");
        testUser.setPasswordHash("test123");
        testUser.setFullName("Test User");
        testUser.setRole("provider");

        UserDAO userDAO = new UserDAO();
        if (userDAO.registerUser(testUser)) {
            System.out.println("✅ Test user created successfully!");
        } else {
            System.out.println("❌ Failed to create test user");
        }
    }

    public static void main(String[] args) throws InterruptedException {
        System.out.println("🚀 Testing UserDAO...");

        // Test registration
        createTestUser();

        // Wait a moment for connection to close
        Thread.sleep(1000);

        // Test login
        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser("test@multihub.com", "test123");
        if (user != null) {
            System.out.println("✅ Login successful! Welcome " + user.getFullName());
        } else {
            System.out.println("❌ Login failed");
        }
    }

}