<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Multi-Hub</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="fonts/css/all.min.css">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="logo">Multi-Hub</div>
        <button class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </button>
        <div class="nav-links" id="navLinks">
            <a href="../index.html"><i class="fas fa-home"></i> Home</a>
            <a href="signup.html"><i class="fas fa-user-plus"></i> Sign Up</a>
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
        
        <!-- Login Form -->
        <form action="login" method="post">
            <!-- Email -->
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: #333;">
                    <i class="fas fa-envelope" style="color: #4a6cf7; margin-right: 8px;"></i> 
                    Email Address
                </label>
                <input type="email" name="email" required 
                       placeholder="Enter your email address"
                       style="width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; transition: border 0.3s;"
                       onfocus="this.style.borderColor='#4a6cf7'; this.style.outline='none';"
                       onblur="this.style.borderColor='#ddd';">
            </div>
            
            <!-- Password -->
            <div style="margin-bottom: 25px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: #333;">
                    <i class="fas fa-lock" style="color: #4a6cf7; margin-right: 8px;"></i> 
                    Password
                </label>
                <input type="password" name="password" required 
                       placeholder="Enter your password"
                       style="width: 100%; padding: 12px 15px; border: 1px solid #ddd; border-radius: 5px; font-size: 16px; transition: border 0.3s;"
                       onfocus="this.style.borderColor='#4a6cf7'; this.style.outline='none';"
                       onblur="this.style.borderColor='#ddd';">
                
                <!-- Forgot Password -->
                <div style="text-align: right; margin-top: 8px;">
                    <a href="#" onclick="forgotPassword()" 
                       style="color: #4a6cf7; font-size: 14px; text-decoration: none; transition: color 0.3s;"
                       onmouseover="this.style.textDecoration='underline';"
                       onmouseout="this.style.textDecoration='none';">
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
                    style="width: 100%; padding: 14px; background: linear-gradient(135deg, #4a6cf7 0%, #3a5ce5 100%); color: white; border: none; border-radius: 5px; font-size: 16px; font-weight: 600; cursor: pointer; transition: all 0.3s; box-shadow: 0 4px 15px rgba(74, 108, 247, 0.3);"
                    onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 20px rgba(74, 108, 247, 0.4)';"
                    onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 15px rgba(74, 108, 247, 0.3)';">
                <i class="fas fa-sign-in-alt" style="margin-right: 8px;"></i> 
                Login to Your Account
            </button>
        </form>
        
        <!-- Alternative Login Options -->
        <div style="margin: 30px 0; text-align: center; position: relative;">
            <div style="height: 1px; background: #eee; position: absolute; top: 50%; left: 0; right: 0;"></div>
            <span style="background: white; padding: 0 15px; color: #888; font-size: 14px; position: relative;">
                Or continue with
            </span>
        </div>
        
        <!-- Social Login Buttons -->
        <div style="display: flex; gap: 15px; margin-bottom: 30px;">
            <button type="button" onclick="socialLogin('google')"
                    style="flex: 1; padding: 12px; background: white; border: 1px solid #ddd; border-radius: 5px; color: #db4437; font-weight: 500; cursor: pointer; transition: all 0.3s;"
                    onmouseover="this.style.borderColor='#db4437'; this.style.background='#fce8e6';"
                    onmouseout="this.style.borderColor='#ddd'; this.style.background='white';">
                <i class="fab fa-google" style="margin-right: 8px;"></i> Google
            </button>
            
            <button type="button" onclick="socialLogin('facebook')"
                    style="flex: 1; padding: 12px; background: white; border: 1px solid #ddd; border-radius: 5px; color: #4267B2; font-weight: 500; cursor: pointer; transition: all 0.3s;"
                    onmouseover="this.style.borderColor='#4267B2'; this.style.background='#e7f3ff';"
                    onmouseout="this.style.borderColor='#ddd'; this.style.background='white';">
                <i class="fab fa-facebook" style="margin-right: 8px;"></i> Facebook
            </button>
        </div>
        
        <!-- Signup Link -->
        <div style="text-align: center; margin-top: 30px; padding-top: 25px; border-top: 1px solid #eee;">
            <p style="color: #666; margin-bottom: 5px;">Don't have an account?</p>
            <a href="signup.html" 
               style="color: #4a6cf7; font-weight: 600; text-decoration: none; font-size: 16px; transition: color 0.3s;"
               onmouseover="this.style.textDecoration='underline'; color='#3a5ce5';"
               onmouseout="this.style.textDecoration='none'; color='#4a6cf7';">
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

    <script src="js/main.js"></script>
    
    <script>
        // Forgot password function
        function forgotPassword() {
            const email = document.querySelector('input[name="email"]').value;
            
            if (email && email.includes('@')) {
                if (confirm('Send password reset instructions to:\n' + email + '?')) {
                    alert('Password reset email sent! Please check your inbox.\n\n(Note: This is a demo. In production, this would send a real email.)');
                }
            } else {
                alert('Please enter a valid email address first.');
                document.querySelector('input[name="email"]').focus();
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
            
            // Load saved email if exists
            if (localStorage.getItem('rememberEmail')) {
                emailInput.value = localStorage.getItem('rememberEmail');
                rememberCheckbox.checked = true;
            }
            
            // Save email on form submit if "Remember me" is checked
            document.querySelector('form').addEventListener('submit', function() {
                if (rememberCheckbox.checked && emailInput.value) {
                    localStorage.setItem('rememberEmail', emailInput.value);
                } else {
                    localStorage.removeItem('rememberEmail');
                }
            });
        });
        
        // Add some interactivity to form
        const inputs = document.querySelectorAll('input[type="email"], input[type="password"]');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                if (this.value.trim() !== '') {
                    this.style.background = '#f8f9ff';
                } else {
                    this.style.background = 'white';
                }
            });
        });
    </script>
</body>
</html>

