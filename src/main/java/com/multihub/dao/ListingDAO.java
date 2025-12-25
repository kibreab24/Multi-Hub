package com.multihub.dao;

import com.multihub.models.Listing;
import com.multihub.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class ListingDAO {

    public List<Listing> getPendingListings() {
        List<Listing> list = new ArrayList<>();
        // Look for anything not yet approved or rejected
        String sql = "SELECT * FROM listings WHERE status = 'pending' OR status IS NULL ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- 1. Get all approved listings (Using is_approved = TRUE) ---
    public List<Listing> getAllApprovedListings() {
        return fetchListings("SELECT * FROM listings WHERE status = 'approved' ORDER BY created_at DESC",
                new String[0]);
    }

    // --- 2. Search listings (Using is_approved = TRUE) ---
    public List<Listing> searchListings(String query, String category, Double minPrice, Double maxPrice) {
        List<Listing> results = new ArrayList<>();
        // Start with the base query (only approved items)
        StringBuilder sql = new StringBuilder("SELECT * FROM listings WHERE status = 'approved' ");

        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (title ILIKE ? OR description ILIKE ?)");
        }
        if (category != null && !category.equals("All")) {
            sql.append(" AND category = ?");
        }
        if (minPrice != null) {
            sql.append(" AND price >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
        }

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIdx = 1;
            if (query != null && !query.trim().isEmpty()) {
                pstmt.setString(paramIdx++, "%" + query + "%");
                pstmt.setString(paramIdx++, "%" + query + "%");
            }
            if (category != null && !category.equals("All")) {
                pstmt.setString(paramIdx++, category);
            }
            if (minPrice != null) {
                pstmt.setDouble(paramIdx++, minPrice);
            }
            if (maxPrice != null) {
                pstmt.setDouble(paramIdx++, maxPrice);
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                results.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return results;
    }

    // Fix for the browse.jsp error: Method with 1 argument
    public List<Listing> searchListings(String query) {
        // We call the existing 4-argument method and pass null for filters we don't
        // have
        return searchListings(query, "All", null, null);
    }

    // --- 3. Filter by Type (Mapping to your listing_type column) ---
    public List<Listing> getListingsByCategory(String type) {
        String sql = "SELECT * FROM listings WHERE status = 'approved' AND category = ? ORDER BY created_at DESC";
        return fetchListings(sql, type);
    }

    // --- 4. Get listings for a specific user ---
    public List<Listing> getListingsByUserId(UUID userId) {
        List<Listing> list = new ArrayList<>();
        String sql = "SELECT * FROM listings WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- HELPER: Map SQL Columns to Java Model ---
    private Listing mapRow(ResultSet rs) throws SQLException {
        Listing l = new Listing();
        l.setId((UUID) rs.getObject("id"));
        l.setUserId((UUID) rs.getObject("user_id"));
        l.setTitle(rs.getString("title"));
        l.setDescription(rs.getString("description"));

        // Use 'category' column if it exists, otherwise fallback to 'listing_type'
        String cat = rs.getString("category");
        if (cat == null)
            cat = rs.getString("listing_type");
        l.setCategory(cat);

        l.setPrice(rs.getDouble("price"));
        l.setImageUrl(rs.getString("image_url"));

        // Handle Status: Check 'status' column first, then 'is_approved'
        String status = rs.getString("status");
        if (status == null) {
            boolean approved = rs.getBoolean("is_approved");
            status = approved ? "approved" : "pending";
        }
        l.setStatus(status);

        return l;
    }

    // --- HELPER: Fetch logic ---
    private List<Listing> fetchListings(String sql, String... params) {
        List<Listing> list = new ArrayList<>();
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setString(i + 1, params[i]);
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Listing getListingById(UUID id) {
        String sql = "SELECT * FROM listings WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Listing l = new Listing();
                l.setId((UUID) rs.getObject("id"));
                l.setUserId((UUID) rs.getObject("user_id"));
                l.setTitle(rs.getString("title"));
                l.setDescription(rs.getString("description"));
                l.setPrice(rs.getDouble("price"));
                l.setCategory(rs.getString("category"));
                l.setImageUrl(rs.getString("image_url"));
                l.setStatus(rs.getString("status"));
                return l;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // --- ADMIN: Update Status ---
    public boolean updateListingStatus(String id, boolean approve) {
        // Determine the status string based on the boolean
        String status = approve ? "approved" : "rejected";

        String sql = "UPDATE listings SET status = ? WHERE id = ?::uuid";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, id); // PostgreSQL handles the ::uuid cast

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteListing(String id, java.util.UUID userId) {
        String sql = "DELETE FROM listings WHERE id = ?::uuid AND user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.setObject(2, userId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateListingDetails(String id, String title, double price, String description) {
        String sql = "UPDATE listings SET title = ?, price = ?, description = ?, status = 'pending' WHERE id = ?::uuid";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setDouble(2, price);
            pstmt.setString(3, description);
            pstmt.setString(4, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createListing(Listing listing) {
        String sql = "INSERT INTO listings (id, title, description, price, category, image_url, user_id, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setObject(1, listing.getId()); // UUID
            stmt.setString(2, listing.getTitle());
            stmt.setString(3, listing.getDescription());
            stmt.setDouble(4, listing.getPrice());
            stmt.setString(5, listing.getCategory());
            stmt.setString(6, listing.getImageUrl());
            stmt.setObject(7, listing.getUserId()); // UUID
            stmt.setString(8, listing.getStatus()); // Usually "pending"

            stmt.executeUpdate();
            System.out.println("Listing created successfully in DB!");
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}