<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Multi-Hub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fonts/css/all.min.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="logo">Multi-Hub</div>
        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
        <div class="nav-links" id="navLinks">
            <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i> Home</a>
            <a href="${pageContext.request.contextPath}/signup.jsp"><i class="fas fa-user-plus"></i> Sign Up</a>
        </div>
    </nav>

    <!-- Login Form -->
    <div class="container" style="max-width: 400px; margin: 50px auto;">
        <h2 style="text-align: center; margin-bottom: 30px;">Login to Multi-Hub</h2>
        
        <!-- Success message after registration -->
        <% if (request.getParameter("registered") != null) { %>
            <div style="background: #d4edda; color: #155724; padding: 12px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                <i class="fas fa-check-circle"></i> Registration successful! Please login.
            </div>
        <% } %>
        
        <!-- Error message from backend -->
        <% if (request.getAttribute("error") != null) { %>
            <div style="background: #f8d7da; color: #721c24; padding: 12px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <!-- Logout message -->
        <% if (request.getParameter("logout") != null) { %>
            <div style="background: #d1ecf1; color: #0c5460; padding: 12px; border-radius: 5px; margin-bottom: 20px; text-align: center;">
                <i class="fas fa-info-circle"></i> You have been logged out successfully.
            </div>
        <% } %>
        
        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/login" method="post">
            <!-- Email -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: #333;">
                    <i class="fas fa-envelope" style="color: #4a6cf7; margin-right: 8px;"></i> 
                    Email Address
                </label>
                <input type="email" name="email" required 
                       placeholder="Enter your email address"
                       value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                       style="width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px;">
            </div>
            
            <!-- Password -->
            <div style="margin-bottom: 25px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: #333;">
                    <i class="fas fa-lock" style="color: #4a6cf7; margin-right: 8px;"></i> 
                    Password
                </label>
                <input type="password" name="password" required 
                       placeholder="Enter your password"
                       style="width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px;">
                
                <!-- Forgot Password -->
                <div style="text-align: right; margin-top: 8px;">
                    <a href="#" onclick="forgotPassword()" 
                       style="color: #4a6cf7; font-size: 14px; text-decoration: none;">
                        Forgot your password?
                    </a>
                </div>
            </div>
            
            <!-- Remember Me -->
            <div style="margin-bottom: 25px; display: flex; align-items: center;">
                <input type="checkbox" id="remember" name="remember" 
                       style="margin-right: 10px; width: 18px; height: 18px;">
                <label for="remember" style="font-size: 14px; color: #555; cursor: pointer;">
                    Remember me on this device
                </label>
            </div>
            
            <!-- Submit Button -->
            <button type="submit" 
                    style="width: 100%; padding: 14px; background: #4a6cf7; color: white; border: none; border-radius: 5px; font-size: 16px; font-weight: 600; cursor: pointer;">
                <i class="fas fa-sign-in-alt" style="margin-right: 8px;"></i> 
                Login to Your Account
            </button>
        </form>
        
        <!-- Signup Link -->
        <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
            <p style="color: #666; margin-bottom: 5px;">Don't have an account?</p>
            <a href="${pageContext.request.contextPath}/signup.jsp" 
               style="color: #4a6cf7; font-weight: 600; text-decoration: none; font-size: 16px;">
                <i class="fas fa-user-plus" style="margin-right: 5px;"></i> 
                Create New Account
            </a>
        </div>
        
        <!-- Admin Note -->
        <div style="margin-top: 25px; padding: 15px; background: #f8f9ff; border-radius: 5px; text-align: center;">
            <p style="color: #666; font-size: 14px; margin: 0;">
                <i class="fas fa-user-shield" style="color: #4a6cf7; margin-right: 5px;"></i>
                <strong>Admin Access:</strong> Use admin credentials for moderation panel
            </p>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
    
    <script>
        // Forgot password function
        function forgotPassword() {
            const emailInput = document.querySelector('input[name="email"]');
            const email = emailInput.value;
            
            if (email && email.includes('@')) {
                if (confirm('Send password reset instructions to:\n' + email + '?')) {
                    alert('Password reset email sent! Please check your inbox.');
                }
            } else {
                alert('Please enter a valid email address first.');
                emailInput.focus();
            }
        }
        
        // Social login function
        function socialLogin(provider) {
            alert(provider.charAt(0).toUpperCase() + provider.slice(1) + 
                  ' login would open here.\n\nIn a real application, this would redirect to ' + 
                  provider + ' authentication.');
        }
        
        // Remember me functionality
        document.addEventListener('DOMContentLoaded', function() {
            const rememberCheckbox = document.getElementById('remember');
            const emailInput = document.querySelector('input[name="email"]');
            
            // Load saved email from localStorage
            if (localStorage.getItem('rememberEmail')) {
                emailInput.value = localStorage.getItem('rememberEmail');
                rememberCheckbox.checked = true;
            }
            
            // Save to localStorage on form submit
            document.querySelector('form').addEventListener('submit', function() {
                if (rememberCheckbox.checked && emailInput.value) {
                    localStorage.setItem('rememberEmail', emailInput.value);
                } else {
                    localStorage.removeItem('rememberEmail');
                }
            });
        });
    </script>
</body>
</html>
