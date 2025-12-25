<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%
    // 1. Session and Security
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo">
                <i class="fas fa-hubspot"></i> Multi-Hub
            </div>
            <div class="nav-links" id="navLinks">
                <a href="index.jsp"><i class="fas fa-home"></i> Home</a>
                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="browse.jsp"><i class="fas fa-search"></i> Browse</a>
                <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <main class="container">
        <div class="form-container">
            <h1><i class="fas fa-user-edit"></i> Edit Profile</h1>
            
            <div class="profile-header">
                <div class="profile-avatar" style="background: #4A90E2; color: white; width: 80px; height: 80px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 15px;">
                    <%= user.getFullName().substring(0,1).toUpperCase() %>
                </div>
            </div>
            
            <form action="update-profile" method="POST">
                <div class="form-group">
                    <label for="profileName"><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" name="full_name" id="profileName" class="form-control" 
                           value="<%= user.getFullName() %>" required>
                </div>
                
                <div class="form-group">
                    <label for="profileEmail"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" id="profileEmail" class="form-control" 
                           value="<%= user.getEmail() %>" readonly style="background: #f4f4f4;">
                    <small>Email cannot be changed.</small>
                </div>
                
                <div class="form-group">
                    <label for="profilePhone"><i class="fas fa-phone"></i> Phone Number</label>
                    <input type="tel" name="phone" id="profilePhone" class="form-control" 
                           placeholder="+251 XXX XXX XXX" 
                           value="<%= (user.getPhone() != null) ? user.getPhone() : "" %>">
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user-tag"></i> Role</label>
                    <input type="text" class="form-control" value="<%= user.getRole() %>" readonly style="background: #f4f4f4;">
                </div>
                
                <button type="submit" class="btn btn-primary btn-block">
                    <i class="fas fa-save"></i> Save Changes
                </button>
                
                <div class="text-center" style="margin-top: 1.5rem;">
                    <a href="dashboard.jsp" class="btn">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            </form>
        </div>
    </main>

    <footer class="footer" style="margin-top: 50px; text-align: center; padding: 20px;">
        <p>&copy; 2025 Multi-Hub. All rights reserved.</p>
    </footer>
</body>
</html>