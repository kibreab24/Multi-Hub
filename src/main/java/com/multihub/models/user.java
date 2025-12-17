package com.multihub.models;

import java.util.Date;

public class User {
    private String id;
    private String email;
    private String passwordHash;
    private String fullName;
    private String role; // "provider", "tool_owner", "job_seeker", "employer", "admin"
    private boolean isVerified;
    private boolean isApproved;
    private double rating;
    private Date createdAt;
    
    // Constructors
    public User() {}
    
    public User(String email, String fullName, String role) {
        this.email = email;
        this.fullName = fullName;
        this.role = role;
        this.createdAt = new Date();
        this.rating = 0.0;
        this.isVerified = false;
        this.isApproved = false;
    }
    
    // Getters and Setters (generate these)
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    // ... Add all other getters/setters
}
