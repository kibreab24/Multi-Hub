<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <nav class="navbar">
        <div class="logo">
            <i class="fas fa-hubspot"></i> Multi-Hub
        </div>
        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
        <div class="nav-links" id="navLinks">
            <a href="index.jsp"><i class="fas fa-home"></i> Home</a>
            <a href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
            <a href="register.jsp" class="active"><i class="fas fa-user-plus"></i> Register</a>
            <a href="admin-dashboard.jsp"><i class="fas fa-user-shield"></i> Admin</a>
        </div>
    </nav>

    <div class="container">
        <div class="form-container">
            <h1 class="section-title"><i class="fas fa-user-plus"></i> Create Account</h1>
            <p class="form-subtitle">Join Multi-Hub to offer skills, rent tools, or find jobs</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>

            <form action="register" method="post" id="registerForm">
                <div class="form-group">
                    <label for="fullName"><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Enter your full name" required>
                </div>

                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="your@email.com" required>
                </div>

                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Minimum 8 characters" minlength="8" required>
                    <small class="form-help">
                        <i class="fas fa-info-circle"></i> Must be at least 8 characters
                    </small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword"><i class="fas fa-lock"></i> Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="Re-enter your password" required>
                </div>

                <div class="form-group">
                    <label for="role"><i class="fas fa-user-tag"></i> Account Type</label>
                    <select id="role" name="role" class="form-control" required>
                        <option value="">Select your role</option>
                        <option value="provider">Service Provider (Offer skills/services)</option>
                        <option value="tool_owner">Tool Owner (Rent out equipment)</option>
                        <option value="job_seeker">Job Seeker (Find employment)</option>
                        <option value="employer">Employer (Post job openings)</option>
                    </select>
                    <small class="form-help">
                        <i class="fas fa-info-circle"></i> Choose how you want to use the platform
                    </small>
                </div>

                <div class="form-group checkbox-group">
                    <label>
                        <input type="checkbox" id="terms" name="terms" required>
                        I agree to the <a href="#" class="terms-link">Terms & Conditions</a>
                    </label>
                </div>

                <button type="submit" class="btn btn-success btn-block">
                    <i class="fas fa-user-plus"></i> Create Account
                </button>
            </form>

            <p class="text-center">
                Already have an account?
                <a href="login.jsp" class="link-primary">
                    <i class="fas fa-sign-in-alt"></i> Login Here
                </a>
            </p>
        </div>
    </div>

    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Multi-Hub. All rights reserved.</p>
        </div>
    </footer>

    <script src="js/main.js"></script>
</body>
</html>