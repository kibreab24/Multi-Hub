<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%
    // Check if user is already logged in
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
    String userName = isLoggedIn ? user.getFullName() : "";
    String userRole = isLoggedIn ? user.getRole() : "";
    
    // Redirect logged-in users to dashboard if they came directly
    if (isLoggedIn && request.getParameter("redirect") == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-Hub | Skills • Tools • Jobs</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="fonts/css/all.min.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar">
        <div class="container"> 
            <div class="logo">
                <i class="fas fa-hubspot"></i> Multi-Hub
            </div>
            <button class="menu-toggle" id="menuToggle" aria-label="Toggle menu">
                <i class="fas fa-bars"></i>
            </button>
            <div class="nav-links" id="navLinks">
                <a href="browse.jsp"><i class="fas fa-search"></i> Browse</a>
                <% if (isLoggedIn) { %>
                    <a href="dashboard.jsp"><i class="fas fa-user"></i> Dashboard</a>
                    <% if ("admin".equals(userRole)) { %>
                        <a href="admin-dashboard.jsp"><i class="fas fa-user-shield"></i> Admin</a>
                    <% } %>
                    <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                <% } else { %>
                    <a href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
                    <a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <% if (isLoggedIn) { %>
            <h1>Welcome back, <%= userName %>!</h1>
            <p>Ready to explore skills, tools, and jobs in your community?</p>
        <% } else { %>
            <h2>Find Skills, Rent Tools, Get Jobs</h2>
            <p>Connect with your community. Share resources. Grow together.</p>
        <% } %>

        <div class="search-box">
            <input type="text" id="searchInput" placeholder="Search for skills, tools, or jobs...">
            <button onclick="performSearch()"><i class="fas fa-search"></i> Search</button>
        </div>
        
        <% if (!isLoggedIn) { %>
            <div class="hero-actions">
                <a href="register.jsp" class="btn btn-primary">
                    <i class="fas fa-user-plus"></i> Join Now - It's Free
                </a>
                <a href="login.jsp" class="btn btn-secondary">
                    <i class="fas fa-sign-in-alt"></i> Already a Member? Login
                </a>
            </div>
        <% } %>
    </section>

    <!-- Categories Section -->
    <section class="categories">
        <div class="category-card" onclick="window.location='browse.jsp?type=skill'">
            <div class="category-icon">
                <i class="fas fa-laptop-code"></i>
            </div>
            <h3>Skills Hub</h3>
            <p>Offer or hire professional skills and services</p>
            <button class="btn">Browse Skills</button>
        </div>

        <div class="category-card" onclick="window.location='browse.jsp?type=tool'">
            <div class="category-icon">
                <i class="fas fa-tools"></i>
            </div>
            <h3>Tools Hub</h3>
            <p>Rent or lend tools and equipment</p>
            <button class="btn">Browse Tools</button>
        </div>

        <div class="category-card" onclick="window.location='browse.jsp?type=job'">
            <div class="category-icon">
                <i class="fas fa-briefcase"></i>
            </div>
            <h3>Jobs Hub</h3>
            <p>Find employment or hire talent</p>
            <button class="btn">Browse Jobs</button>
        </div>
    </section>

    <!-- Featured Listings -->
    <section class="featured">
        <div class="container">
            <h2 class="section-title">Featured Listings</h2>

            <div class="featured-grid">
                <!-- Listing 1 -->
                <div class="listing-card" onclick="window.location='browse.jsp?type=skill'">
                    <div class="listing-image" style="background: #4a6fa5;">
                        <i class="fas fa-code"></i>
                    </div>
                    <div class="listing-content">
                        <h3 class="listing-title">Web Development Tutoring</h3>
                        <p class="listing-price">250birr/hour</p>
                        <div class="listing-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                            <span>(4.2)</span>
                        </div>
                        <p class="listing-description">
                            Learn HTML, CSS, JavaScript from experienced developer.
                            Suitable for beginners and intermediate learners.
                        </p>
                        <div class="listing-meta">
                            <span class="listing-category">Skills</span>
                            <span><i class="fas fa-map-marker-alt"></i> mekelle</span>
                        </div>
                    </div>
                </div>

                <!-- Listing 2 -->
                <div class="listing-card" onclick="window.location='browse.jsp?type=tool'">
                    <div class="listing-image" style="background: #2ecc71;">
                        <i class="fas fa-tools"></i>
                    </div>
                    <div class="listing-content">
                        <h3 class="listing-title">Power Drill Set</h3>
                        <p class="listing-price">500birr/day</p>
                        <div class="listing-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                            <span>(4.7)</span>
                        </div>
                        <p class="listing-description">
                            Professional power drill with accessories.
                            Perfect for home improvement projects.
                        </p>
                        <div class="listing-meta">
                            <span class="listing-category">Tools</span>
                            <span><i class="fas fa-map-marker-alt"></i> mekelle</span>
                        </div>
                    </div>
                </div>

                <!-- Listing 3 -->
                <div class="listing-card" onclick="window.location='browse.jsp?type=job'">
                    <div class="listing-image" style="background: #e74c3c;">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="listing-content">
                        <h3 class="listing-title">Data Entry Specialist</h3>
                        <p class="listing-price">50000birr/month</p>
                        <div class="listing-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="far fa-star"></i>
                            <span>(4.0)</span>
                        </div>
                        <p class="listing-description">
                            Part-time remote position. Requires attention to detail
                            and basic computer skills.
                        </p>
                        <div class="listing-meta">
                            <span class="listing-category">Jobs</span>
                            <span><i class="fas fa-clock"></i> Part-time</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="view-all">
                <a href="browse.jsp" class="btn">
                    <i class="fas fa-list"></i> View All Listings
                </a>
            </div>
        </div>
    </section>

    <!-- How It Works -->
    <section class="how-it-works">
        <div class="container">
            <h2 class="section-title">How Multi-Hub Works</h2>
            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-number">1</div>
                    <h3>Sign Up</h3>
                    <p>Create a free account as a service provider, tool owner, job seeker, or employer.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">2</div>
                    <h3>Create or Browse</h3>
                    <p>Post your skills, tools, or job listings. Or browse what others are offering.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">3</div>
                    <h3>Connect</h3>
                    <p>Contact other users directly through the platform to arrange services.</p>
                </div>
                <div class="step-card">
                    <div class="step-number">4</div>
                    <h3>Rate & Review</h3>
                    <p>Build your reputation with ratings and reviews from the community.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Multi-Hub. All rights reserved.</p>
        </div>
    </footer>

    <script src="js/main.js"></script>
</body>
</html>