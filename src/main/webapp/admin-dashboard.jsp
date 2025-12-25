<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%@ page import="com.multihub.models.Listing" %>
<%@ page import="com.multihub.dao.UserDAO" %>
<%@ page import="com.multihub.dao.ListingDAO" %>
<%@ page import="java.util.List" %>

<% 
    // 1. Security Check
    User user = (User) session.getAttribute("user"); 
    if (user == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    } 

    if (!"admin".equals(user.getRole())) { 
        response.sendRedirect("dashboard.jsp?error=Access denied. Admin only."); 
        return; 
    } 

    // 2. Fetch Data
    String adminName = user.getFullName();
    String adminEmail = user.getEmail(); 
    
    UserDAO dao = new UserDAO(); 
    int totalUsers = dao.getTotalUserCount(); 
    List<User> recentUsers = dao.getRecentUsers(5); 

    ListingDAO listingDao = new ListingDAO(); 
    List<Listing> pending = listingDao.getPendingListings();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .admin-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .admin-table th, .admin-table td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
        .admin-table th { background: #f8f9fa; font-weight: bold; }
        .thumb-mini { width: 40px; height: 40px; border-radius: 4px; object-fit: cover; }
        .btn-success { background: #2ecc71; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
        .btn-error { background: #e74c3c; color: white; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo"><i class="fas fa-user-shield"></i> Multi-Hub Admin</div>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 30px;">
        <div class="admin-header">
            <h1>Admin Control Panel</h1>
            <p>Welcome back, <strong><%= adminName %></strong></p>
        </div>

        <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0;">
            <div class="stat-card">
                <i class="fas fa-users"></i>
                <h3><%= totalUsers %></h3>
                <p>Registered Users</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-hourglass-start"></i>
                <h3><%= pending.size() %></h3>
                <p>Pending Approvals</p>
            </div>
        </div>

        <div class="dashboard-section">
            <h2><i class="fas fa-clipboard-list"></i> Listings Awaiting Approval</h2>
            <% if(pending.isEmpty()) { %>
                <p>No listings currently waiting for review.</p>
            <% } else { %>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Image</th>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Listing l : pending) { %>
                        <tr>
                            <td>
                                <% if(l.getImageUrl() != null) { %>
                                    <img src="<%= l.getImageUrl() %>" class="thumb-mini">
                                <% } else { %>
                                    <i class="fas fa-image" style="color:#ccc"></i>
                                <% } %>
                            </td>
                            <td><%= l.getTitle() %></td>
                            <td><%= l.getCategory() %></td>
                            <td><%= l.getPrice() %></td>
                            <td>
                                <a href="admin-action?id=<%= l.getId() %>&action=approved" class="btn-success">Approve</a>
                                <a href="admin-action?id=<%= l.getId() %>&action=rejected" class="btn-error">Reject</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <div class="dashboard-section" style="margin-top: 40px;">
            <h2><i class="fas fa-user-clock"></i> Recent Users</h2>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                    </tr>
                </thead>
                <tbody>
                    <% for(User u : recentUsers) { %>
                    <tr>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="badge"><%= u.getRole() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>