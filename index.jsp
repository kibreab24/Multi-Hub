<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-Hub | Skills • Tools • Jobs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/fonts/css/all.min.css">
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
                <a href="${pageContext.request.contextPath}/browse.jsp"><i class="fas fa-search"></i> Browse</a>
                
                <%-- Check if user is logged in --%>
                <%
                    HttpSession sessionObj = request.getSession(false);
                    if (sessionObj != null && sessionObj.getAttribute("user") != null) {
                        // User is logged in
                        String userRole = (String) sessionObj.getAttribute("userRole");
                %>
                        <a href="${pageContext.request.contextPath}/dashboard.jsp"><i class="fas fa-user"></i> Dashboard</a>
                        <% if ("admin".equals(userRole)) { %>
                            <a href="${pageContext.request.contextPath}/admin.jsp"><i class="fas fa-user-shield"></i> Admin</a>
                        <% } %>
                        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                <% } else { %>
                        <a href="${pageContext.request.contextPath}/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
                        <a href="${pageContext.request.contextPath}/signup.jsp"><i class="fas fa-user-plus"></i> Sign Up</a>
                <% } %>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <h2>Find Skills, Rent Tools, Get Jobs</h2>
        <p>Connect with your community. Share resources. Grow together.</p>

        <div class="search-box">
            <input type="text" placeholder="Search for skills, tools, or jobs...">
            <button><i class="fas fa-search"></i> Search</button>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="categories">
        <div class="category-card" onclick="window.location='${pageContext.request.contextPath}/browse.jsp?type=skill'">
            <div class="category-icon">
                <i class="fas fa-laptop-code"></i>
            </div>
            <h3>Skills Hub</h3>
            <p>Offer or hire professional skills and services</p>
            <button class="btn">Browse Skills</button>
        </div>

        <div class="category-card" onclick="window.location='${pageContext.request.contextPath}/browse.jsp?type=tool'">
            <div class="category-icon">
                <i class="fas fa-tools"></i>
            </div>
            <h3>Tools Hub</h3>
            <p>Rent or lend tools and equipment</p>
            <button class="btn">Browse Tools</button>
        </div>

        <div class="category-card" onclick="window.location='${pageContext.request.contextPath}/browse.jsp?type=job'">
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
                <div class="listing-card" onclick="window.location='${pageContext.request.contextPath}/browse.jsp?id=1'">
                    <div class="listing-image">
                        <i class="fas fa-code"></i>
                    </div>
                    <div class="listing-content">
                        <h3 class="listing-title">Web Development Tutoring</h3>
                        <p class="listing-price">$25/hour</p>
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
                            <span><i class="fas fa-map-marker-alt"></i> Addis Ababa</span>
                        </div>
                    </div>
                </div>

                <!-- Listing 2 -->
                <div class="listing-card" onclick="window.location='${pageContext.request.contextPath}/browse.jsp?id=2'">
                    <div class="listing-image">
                        <i class="fas fa-tools"></i>
                    </div>
                    <div class="listing-content">
                        <h3 class="listing-title">Power Drill Set</h3>
                        <p class="listing-price">$15/day</p>
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
                            <span><i class="fas fa-map-marker-alt"></i> Mekelle </span>
                        </div>
                    </div>
                </div>

                <!-- Listing 3 -->
                <div class="listing-card" onclick="window.location='${pageContext.request.contextPath}/browse.jsp?id=3'">
                    <div class="listing-image">
                        <i class="fas fa-briefcase"></i>
                    </div>
                    <div class="listing-content">
                        <h3 class="listing-title">Data Entry Specialist</h3>
                        <p class="listing-price">$500/month</p>
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
                <a href="${pageContext.request.contextPath}/browse.jsp" class="btn">
                    <i class="fas fa-list"></i> View All Listings
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2025 Multi-Hub. All rights reserved.</p>
            <p>Mekelle University</p>
            <div class="footer-links">
                <a href="#">About</a> |
                <a href="#">Contact</a> |
                <a href="#">Privacy</a>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
