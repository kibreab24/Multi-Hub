<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%@ page import="com.multihub.dao.ListingDAO" %>
<%@ page import="com.multihub.models.Listing" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<% 
    // 1. Session & Security 
    User user = (User) session.getAttribute("user"); 
    if (user == null) {
        response.sendRedirect("login.jsp"); 
        return; 
    } 

    // 2. Data Preparation
    String userName = user.getFullName(); 
    String userRole = user.getRole(); 
    String userEmail = user.getEmail();
    double userRating = user.getRating(); 
    
    ListingDAO listingDao = new ListingDAO(); 
    List<Listing> myListings = listingDao.getListingsByUserId(user.getId());
    if (myListings == null) {
        myListings = new ArrayList<>();
    }

    int activeCount = 0;
    for(Listing l : myListings) {
        if("approved".equals(l.getStatus())) activeCount++;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .status-tag { padding: 4px 8px; border-radius: 4px; font-size: 0.75rem; font-weight: bold; text-transform: uppercase; display: inline-block; }
        .status-approved { color: #2ecc71; background: rgba(46, 204, 113, 0.1); }
        .status-pending { color: #f39c12; background: rgba(243, 156, 18, 0.1); }
        .status-rejected { color: #e74c3c; background: rgba(231, 76, 60, 0.1); }
        
        .listing-thumb { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
        .no-image { width: 60px; height: 60px; display: flex; align-items: center; justify-content: center; background: #f8f9fa; color: #ccc; border-radius: 8px; }
        
        .btn-delete { color: #e74c3c; background: none; border: none; cursor: pointer; padding: 8px; transition: color 0.2s; }
        .btn-delete:hover { color: #c0392b; }
        
        .alert-box { 
            padding: 15px; 
            margin-bottom: 12px; 
            border-radius: 8px; 
            border-left-width: 5px; 
            border-left-style: solid; 
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
        }

        table tr:hover { background-color: #fafafa; }
    </style>
</head>

<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo"><i class="fas fa-hubspot"></i> Multi-Hub</div>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="browse.jsp">Browse</a>
                <a href="create-listing.jsp">Create Listing</a>
                <a href="profile.jsp">Profile</a>
                <a href="logout">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container" style="margin-top: 20px;">
        <div class="hero">
            <h1>Welcome, <%= userName %>!</h1>
            <p><%= userEmail %> | <strong><%= userRole.replace("_", " ") %></strong></p>
        </div>

        <div class="notifications-container">
            <%
                for(Listing l : myListings) {
                    if(!"pending".equals(l.getStatus())) { 
                        boolean isApproved = "approved".equals(l.getStatus());
                        String bg = isApproved ? "#d4edda" : "#f8d7da";
                        String text = isApproved ? "#155724" : "#721c24";
                        String border = isApproved ? "#28a745" : "#dc3545";
                        String alertId = "alert_" + l.getId().toString().replace("-", "");
            %>
                <div class="alert-box" id="<%= alertId %>"
                     style="--bg: <%= bg %>; --text: <%= text %>; --border: <%= border %>; 
                            background-color: var(--bg); color: var(--text); border-left-color: var(--border);">
                    
                    <span>
                        <i class="fas fa-bell"></i> 
                        Your listing "<strong><%= l.getTitle() %></strong>" has been <strong><%= l.getStatus() %></strong>.
                    </span>

                    <button onclick="dismissAlert('<%= alertId %>')" 
                            style="background:none; border:none; color:inherit; cursor:pointer; font-size: 1.5rem; line-height: 1;">
                        &times;
                    </button>
                </div>
            <% 
                    }
                }
            %>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-check-circle"></i>
                <h3><%= activeCount %></h3>
                <p>Approved Listings</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-star"></i>
                <h3><%= String.format("%.1f", userRating) %></h3>
                <p>Rating</p>
            </div>
        </div>

        <div class="dashboard-section" style="margin-top: 30px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h2>My Submissions</h2>
                <a href="create-listing.jsp" class="btn btn-primary">Add New Listing</a>
            </div>

            <% if (myListings.isEmpty()) { %>
                <div class="info-box">You haven't submitted any listings yet.</div>
            <% } else { %>
                <table style="width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
                    <thead>
                        <tr style="text-align: left; background: #f8f9fa; border-bottom: 2px solid #eee;">
                            <th style="padding: 15px;">Item</th>
                            <th style="padding: 15px;">Price</th>
                            <th style="padding: 15px;">Category</th>
                            <th style="padding: 15px;">Status</th>
                            <th style="padding: 15px; text-align: center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for(Listing l : myListings) { 
                            String statusClass = "status-pending";
                            if("approved".equals(l.getStatus())) statusClass = "status-approved";
                            if("rejected".equals(l.getStatus())) statusClass = "status-rejected"; 
                        %>
                        <tr style="border-bottom: 1px solid #eee;">
                            <td style="padding: 12px; display: flex; align-items: center; gap: 15px;">
                                <% if(l.getImageUrl() != null && !l.getImageUrl().isEmpty()) { %>
                                    <img src="<%= l.getImageUrl() %>" class="listing-thumb" alt="Thumbnail">
                                <% } else { %>
                                    <div class="no-image"><i class="fas fa-image"></i></div>
                                <% } %>
                                <strong><%= l.getTitle() %></strong>
                            </td>
                            <td style="padding: 12px;"><%= l.getPrice() %> Birr</td>
                            <td style="padding: 12px; text-transform: capitalize;"><%= l.getCategory() %></td>
                            <td style="padding: 12px;">
                                <span class="status-tag <%= statusClass %>"><%= l.getStatus() %></span>
                            </td>
                            <td style="padding: 12px; text-align: center;">
                                <a href="edit-listing.jsp?id=<%= l.getId() %>" style="color: #4A90E2; margin-right: 10px;">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="delete-listing?id=<%= l.getId() %>" class="btn-delete" onclick="return confirm('Are you sure?')">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </div>

<script>
    // Check session storage on page load
    document.addEventListener("DOMContentLoaded", function() {
        const alerts = document.querySelectorAll('.alert-box');
        alerts.forEach(alert => {
            if (sessionStorage.getItem('dismissed-' + alert.id)) {
                alert.style.display = 'none';
            }
        });
    });

    // Function to hide alert and save preference
    function dismissAlert(alertId) {
        const element = document.getElementById(alertId);
        if (element) {
            element.style.display = 'none';
            sessionStorage.setItem('dismissed-' + alertId, 'true');
        }
    }
</script>
</body>
</html>