<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%@ page import="com.multihub.models.Listing" %>
<%@ page import="com.multihub.dao.ListingDAO" %>
<%@ page import="java.util.List" %>

<%
    // 1. Session and Auth
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
    
    // 2. Parameters
    String searchQuery = request.getParameter("search") != null ? request.getParameter("search") : "";
    String typeFilter = request.getParameter("type") != null ? request.getParameter("type") : "";
    String myOnly = request.getParameter("my");

    // 3. Fetch Real Data
    ListingDAO listingDao = new ListingDAO();
    List<Listing> listings;

    if ("true".equals(myOnly) && isLoggedIn) {
        listings = listingDao.getListingsByUserId(user.getId());
    } else if (typeFilter != null && !typeFilter.isEmpty()) {
        listings = listingDao.getListingsByCategory(typeFilter);
    } else if (searchQuery != null && !searchQuery.isEmpty()) {
        listings = listingDao.searchListings(searchQuery);
    } else {
        listings = listingDao.getAllApprovedListings(); 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse - Multi-Hub</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <style>
        .listing-card { 
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            height: 100%;
        }
        .listing-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .card-image-container {
            width: 100%;
            height: 200px;
            background: #f4f4f4;
            position: relative;
            overflow: hidden;
        }
        .card-image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .category-badge { 
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(255,255,255,0.9); 
            padding: 4px 12px; 
            border-radius: 20px; 
            font-size: 11px; 
            font-weight: bold;
            text-transform: uppercase;
            color: #4A90E2;
        }

        .tab {
            padding: 8px 20px;
            border-radius: 20px;
            text-decoration: none;
            color: #666;
            background: #eee;
            font-weight: 500;
            transition: 0.3s;
        }
        .tab.active {
            background: #4A90E2;
            color: white;
        }

        .btn-block {
            width: 100%;
            display: block;
            text-align: center;
            padding: 10px;
            border-radius: 6px;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="container">
            <div class="logo"><i class="fas fa-hubspot"></i> Multi-Hub</div>
            <div class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="browse.jsp" class="active">Browse</a>
                <% if (isLoggedIn) { %>
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="logout">Logout</a>
                <% } else { %>
                    <a href="login.jsp">Login</a>
                <% } %>
            </div>
        </div>
    </nav>

    <main class="container">
        <div class="browse-header" style="margin-top: 30px;">
            <h1><i class="fas fa-search"></i> <%= ("true".equals(myOnly)) ? "My Listings" : "Browse Marketplace" %></h1>
        </div>

        <form action="browse.jsp" method="get" class="search-form" style="margin: 20px 0;">
            <div style="display: flex; gap: 10px;">
                <input type="text" name="search" placeholder="Search skills, tools, or jobs..." 
                       value="<%= searchQuery %>" style="flex: 1; padding: 12px; border-radius: 8px; border: 1px solid #ddd;">
                <button type="submit" class="btn btn-primary">Search</button>
            </div>
        </form>

        <div class="category-tabs" style="margin-bottom: 25px; display: flex; gap: 10px;">
            <a href="browse.jsp" class="tab <%= typeFilter.isEmpty() ? "active" : "" %>">All</a>
            <a href="browse.jsp?type=skill" class="tab <%= "skill".equalsIgnoreCase(typeFilter) ? "active" : "" %>">Skills</a>
            <a href="browse.jsp?type=tool" class="tab <%= "tool".equalsIgnoreCase(typeFilter) ? "active" : "" %>">Tools</a>
            <a href="browse.jsp?type=job" class="tab <%= "job".equalsIgnoreCase(typeFilter) ? "active" : "" %>">Jobs</a>
        </div>

        <div class="featured-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px;">
            <% if (listings == null || listings.isEmpty()) { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 50px;">
                    <i class="fas fa-box-open" style="font-size: 3rem; color: #ccc;"></i>
                    <p>No listings found.</p>
                </div>
            <% } else { 
                for (Listing l : listings) { %>
                <div class="listing-card">
                    <div class="card-image-container">
                        <% if(l.getImageUrl() != null && !l.getImageUrl().isEmpty()) { %>
                            <img src="<%= l.getImageUrl() %>" alt="Listing">
                        <% } else { %>
                            <div style="display:flex; justify-content:center; align-items:center; height:100%; color:#ccc;">
                                <i class="fas fa-image fa-3x"></i>
                            </div>
                        <% } %>
                        <span class="category-badge"><%= l.getCategory() %></span>
                    </div>

                    <div style="padding: 15px; flex-grow: 1;">
                        <h3 style="margin:0;"><%= l.getTitle() %></h3>
                        <p style="color: #2ecc71; font-weight: bold;"><%= l.getPrice() %> Birr</p>
                        <p style="font-size: 0.9rem; color: #666; height: 60px; overflow: hidden;"><%= l.getDescription() %></p>
                        
                        <div style="margin-top: 15px;">
                            <a href="view-listing.jsp?id=<%= l.getId() %>" class="btn btn-primary btn-block">
                                <i class="fas fa-eye"></i> View Details
                            </a>
                        </div>
                    </div>
                </div>
            <% } } %>
        </div>
    </main>
</body>
</html>