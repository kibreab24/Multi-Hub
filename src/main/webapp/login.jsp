<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%
    // Check if user is already logged in
    User loggedInUser = (User) session.getAttribute("user");
    if (loggedInUser != null) {
        // Redirect based on role
        if ("admin".equals(loggedInUser.getRole())) {
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            response.sendRedirect("dashboard.jsp");
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="logo">
            <i class="fas fa-hubspot"></i> Multi-Hub
        </div>
        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
        <div class="nav-links" id="navLinks">
            <a href="index.jsp"><i class="fas fa-home"></i> Home</a>
            <a href="login.jsp" class="active"><i class="fas fa-sign-in-alt"></i> Login</a>
            <a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a>
            <a href="admin-dashboard.jsp"><i class="fas fa-user-shield"></i> Admin</a>
        </div>
    </nav>

    <!-- Login Form -->
    <div class="container">
        <div class="form-container">
            <h1 class="section-title"><i class="fas fa-sign-in-alt"></i> Login</h1>
            <p style="text-align: center; margin-bottom: 2rem; color: #666;">
                Access your Multi-Hub account
            </p>

            <!-- Error/Success Messages -->
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message" style="background: #f8d7da; color: #721c24; padding: 1rem; border-radius: 6px; margin-bottom: 1.5rem; border: 1px solid #f5c6cb;">
                    <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getParameter("message") != null) { %>
                <div class="success-message" style="background: #d4edda; color: #155724; padding: 1rem; border-radius: 6px; margin-bottom: 1.5rem; border: 1px solid #c3e6cb;">
                    <i class="fas fa-check-circle"></i> <%= request.getParameter("message") %>
                </div>
            <% } %>
            
            <% if (request.getParameter("logout") != null) { %>
                <div class="info-message" style="background: #d1ecf1; color: #0c5460; padding: 1rem; border-radius: 6px; margin-bottom: 1.5rem; border: 1px solid #bee5eb;">
                    <i class="fas fa-info-circle"></i> You have been logged out successfully.
                </div>
            <% } %>

            <!-- Real Form - Posts to Java Servlet -->
            <form action="login" method="post">
                <div class="form-group">
                    <label for="email"><i class="fas fa-envelope"></i> Email Address</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="your@email.com" required>
                </div>

                <div class="form-group">
                    <label for="password"><i class="fas fa-lock"></i> Password</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Enter your password" required>
                    <div style="text-align: right; margin-top: 0.5rem;">
                        <a href="#" onclick="showForgotPassword()" style="font-size: 0.9rem; color: #3498db;">
                            <i class="fas fa-question-circle"></i> Forgot password?
                        </a>
                    </div>
                </div>

                <div class="form-group">
                    <label style="font-weight: normal; display: flex; align-items: center; gap: 0.5rem;">
                        <input type="checkbox" id="rememberMe" name="rememberMe">
                        Remember me
                    </label>
                </div>

                <button type="submit" class="btn btn-block">
                    <i class="fas fa-sign-in-alt"></i> Login
                </button>

                <p style="text-align: center; margin-top: 1.5rem;">
                    Don't have an account?
                    <a href="register.jsp" style="font-weight: 600; color: #3498db;">
                        <i class="fas fa-user-plus"></i> Register Now
                    </a>
                </p>
            </form>

        
            <!-- Alternative Login Methods -->
            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid #eee;">
                <p style="text-align: center; color: #666; margin-bottom: 1rem;">Or login with</p>
                <div style="display: flex; gap: 1rem; justify-content: center;">
                    <button type="button" class="btn" style="background: #db4437;" onclick="alert('Social login coming in future version')">
                        <i class="fab fa-google"></i> Google
                    </button>
                    <button type="button" class="btn" style="background: #4267B2;" onclick="alert('Social login coming in future version')">
                        <i class="fab fa-facebook"></i> Facebook
                    </button>
                </div>
                <p style="text-align: center; font-size: 0.9rem; color: #999; margin-top: 1rem;">
                    Social login coming soon
                </p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Multi-Hub. All rights reserved.</p>
          
        </div>
    </footer>

    <!-- JavaScript -->
    <script>
        function showForgotPassword() {
            const email = prompt('Enter your email to reset password:');
            if (email) {
                alert(`Password reset feature would send email to ${email}\n\n(Feature not implemented in MVP)`);
            }
        }
        
        // Mobile menu toggle
        document.getElementById('menuToggle')?.addEventListener('click', function() {
            const navLinks = document.getElementById('navLinks');
            navLinks.style.display = navLinks.style.display === 'flex' ? 'none' : 'flex';
        });
        
       
        document.addEventListener('DOMContentLoaded', function() {
            const savedEmail = localStorage.getItem('multihub_email');
            const rememberCheckbox = document.getElementById('rememberMe');
            
            if (savedEmail && document.getElementById('email')) {
                document.getElementById('email').value = savedEmail;
                rememberCheckbox.checked = true;
            }
            
            // Save email on form submit if remember me is checked
            document.querySelector('form')?.addEventListener('submit', function() {
                const email = document.getElementById('email')?.value;
                if (rememberCheckbox.checked && email) {
                    localStorage.setItem('multihub_email', email);
                } else {
                    localStorage.removeItem('multihub_email');
                }
            });
        });
    </script>
    
    <script src="js/main.js"></script>
</body>
</html>