<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.Listing" %>
<%@ page import="com.multihub.models.User" %>
<%@ page import="com.multihub.dao.ListingDAO" %>
<%@ page import="com.multihub.dao.UserDAO" %>
<%@ page import="java.util.UUID" %>

<%
    // 1. Get the ID from the URL
    String idStr = request.getParameter("id");
    Listing listing = null;
    User seller = null;
    
    if (idStr != null) {
        ListingDAO dao = new ListingDAO();
        UserDAO userDAO = new UserDAO();
        
        listing = dao.getListingById(UUID.fromString(idStr));
        
        if (listing != null) {
            // Fetch the seller details using the user_id linked to the listing
            seller = userDAO.getUserById(listing.getUserId());
        }
    }

    // 2. Redirect if listing not found
    if (listing == null || seller == null) {
        response.sendRedirect("browse.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= listing.getTitle() %> - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .details-container {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 40px;
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            margin-top: 30px;
        }
        .listing-main-image {
            width: 100%;
            border-radius: 10px;
            object-fit: cover;
            max-height: 500px;
            border: 1px solid #eee;
        }
        .price-tag {
            font-size: 2.2rem;
            color: #2ecc71;
            font-weight: bold;
            margin: 15px 0;
        }
        .contact-card {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            border-top: 4px solid #4A90E2;
            margin-top: 20px;
        }
        .seller-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .seller-avatar {
            width: 50px;
            height: 50px;
            background: #4A90E2;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 1.2rem;
        }
        @media (max-width: 768px) {
            .details-container { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo"><i class="fas fa-hubspot"></i> Multi-Hub</div>
            <div class="nav-links">
                <a href="browse.jsp"><i class="fas fa-arrow-left"></i> Back to Browse</a>
            </div>
        </div>
    </nav>

    <main class="container">
        <div class="details-container">
            <div class="image-section">
                <% if(listing.getImageUrl() != null && !listing.getImageUrl().isEmpty()) { %>
                    <img src="<%= listing.getImageUrl() %>" class="listing-main-image" alt="Listing Image">
                <% } else { %>
                    <div style="background:#f4f4f4; height:400px; display:flex; align-items:center; justify-content:center; border-radius:10px;">
                        <i class="fas fa-image fa-5x" style="color:#ccc;"></i>
                    </div>
                <% } %>
            </div>

            <div class="info-section">
                <span class="category-badge" style="background:#4A90E2; color:white; padding:6px 16px; border-radius:20px; text-transform:uppercase; font-size:11px; font-weight:bold;">
                    <%= listing.getCategory() %>
                </span>
                
                <h1 style="margin: 15px 0 5px 0; font-size: 2rem;"><%= listing.getTitle() %></h1>
                <div class="price-tag"><%= listing.getPrice() %> Birr</div>

                <h4 style="color: #888; margin-bottom: 10px;">Description</h4>
                <p style="font-size: 1.05rem; line-height: 1.6; color: #444; margin-bottom: 30px;">
                    <%= listing.getDescription() %>
                </p>

                <div class="contact-card">
                    <div class="seller-info">
                        <div class="seller-avatar">
                            <%= seller.getFullName().substring(0,1).toUpperCase() %>
                        </div>
                        <div>
                            <h4 style="margin:0;"><%= seller.getFullName() %></h4>
                            <small style="color:#777;">Verified Provider</small>
                        </div>
                    </div>

                    <div style="margin-bottom: 20px;">
                        <p style="margin: 8px 0;"><i class="fas fa-phone-alt" style="color:#2ecc71; width:20px;"></i> <%= (seller.getPhone() != null) ? seller.getPhone() : "Contact via Email" %></p>
                        <p style="margin: 8px 0;"><i class="fas fa-envelope" style="color:#4A90E2; width:20px;"></i> <%= seller.getEmail() %></p>
                    </div>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <% if(seller.getPhone() != null) { %>
                            <a href="tel:0<%= seller.getPhone() %>" class="btn btn-primary" style="background:#2ecc71; border:none; text-align:center; text-decoration:none;">
                                <i class="fas fa-phone"></i> Call
                            </a>
                        <% } %>
                        <a href="mailto:<%= seller.getEmail() %>?subject=Inquiry regarding <%= listing.getTitle() %>" class="btn btn-primary" style="text-align:center; text-decoration:none;">
                            <i class="fas fa-envelope"></i> Email
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>