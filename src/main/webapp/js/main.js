// ============================================
// MULTI-HUB - OPTIMIZED JAVASCRIPT

// ============================================

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Multi-Hub loaded successfully!');
    
    // ===== 1. INITIALIZE CORE FUNCTIONS =====
    initializeMobileMenu();
    initializeSearch();
    initializeFormValidations();
    initializeCategoryCards();
    
    // ===== 2. PAGE-SPECIFIC INITIALIZATIONS =====
    const currentPage = window.location.pathname;
    
    // Check which page we're on and initialize accordingly
    if (currentPage.includes('browse.html')) {
        initializeBrowsePage();
    } else if (currentPage.includes('dashboard.html')) {
        initializeDashboardPage();
    } else if (currentPage.includes('create-listing.html')) {
        initializeCreateListingPage();
    } else if (currentPage.includes('profile.html')) {
        initializeProfilePage();
    } else if (currentPage.includes('admin.html')) {
        initializeAdminPage();
    }
    
    // ===== 3. GLOBAL ENHANCEMENTS =====
    initializeGlobalFeatures();
});

// ============================================
// 1. CORE FUNCTIONS (Available on all pages)
// ============================================

/**
 * 1. Mobile Menu Toggle - WORKS ON ALL PAGES
 */
function initializeMobileMenu() {
    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.getElementById('navLinks');
    
    if (!menuToggle || !navLinks) return;
    
    // Function to update menu state
    function updateMenuState(isOpen) {
        if (isOpen) {
            navLinks.classList.add('active');
            const icon = menuToggle.querySelector('i');
            icon.classList.remove('fa-bars');
            icon.classList.add('fa-times');
            menuToggle.setAttribute('aria-expanded', 'true');
            menuToggle.setAttribute('aria-label', 'Close navigation menu');
        } else {
            navLinks.classList.remove('active');
            const icon = menuToggle.querySelector('i');
            icon.classList.remove('fa-times');
            icon.classList.add('fa-bars');
            menuToggle.setAttribute('aria-expanded', 'false');
            menuToggle.setAttribute('aria-label', 'Open navigation menu');
        }
    }
    
    // Toggle menu when hamburger is clicked
    menuToggle.addEventListener('click', function(e) {
        e.stopPropagation();
        const isOpen = !navLinks.classList.contains('active');
        updateMenuState(isOpen);
    });
    
    // Close menu when clicking outside
    document.addEventListener('click', function(e) {
        if (navLinks.classList.contains('active') &&
            !menuToggle.contains(e.target) &&
            !navLinks.contains(e.target)) {
            updateMenuState(false);
        }
    });
    
    // Close menu on Escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && navLinks.classList.contains('active')) {
            updateMenuState(false);
        }
    });
    
    // Close menu on window resize to desktop
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768 && navLinks.classList.contains('active')) {
            updateMenuState(false);
        }
    });
    
    // Close menu when clicking a link (for mobile)
    const navItems = navLinks.querySelectorAll('a');
    navItems.forEach(item => {
        item.addEventListener('click', function() {
            if (window.innerWidth <= 768) {
                updateMenuState(false);
            }
        });
    });
    
    // Initialize menu state
    updateMenuState(false);
}

/**
 * Search Functionality
 */
function initializeSearch() {
    const searchBox = document.querySelector('.search-box');
    if (!searchBox) return;
    
    const searchInput = searchBox.querySelector('input[type="text"]');
    const searchButton = searchBox.querySelector('button');
    
    if (!searchInput || !searchButton) return;
    
    // Search on button click
    searchButton.addEventListener('click', function() {
        performSearch(searchInput.value);
    });
    
    // Search on Enter key
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            performSearch(this.value);
        }
    });
    
    function performSearch(query) {
        if (!query.trim()) {
            showNotification('Please enter a search term', 'info');
            searchInput.focus();
            return;
        }
        
        console.log('Searching for:', query);
        
        // If on browse page, filter existing content
        if (window.location.pathname.includes('browse.html')) {
            filterListingsBySearch(query);
        } else {
            // Otherwise redirect to browse page with search query
            window.location.href = `webapp/browse.html?search=${encodeURIComponent(query)}`;
        }
    }
}

/**
 * Form Validations
 */
function initializeFormValidations() {
    // Signup Form
    const signupForm = document.getElementById('signupForm');
    if (signupForm) {
        signupForm.addEventListener('submit', validateSignupForm);
    }
    
    // Login Form
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', validateLoginForm);
    }
    
    // Create Listing Form
    const listingForm = document.getElementById('createListingForm');
    if (listingForm) {
        listingForm.addEventListener('submit', validateListingForm);
    }
    
    // Profile Form
    const profileForm = document.getElementById('profileForm');
    if (profileForm) {
        profileForm.addEventListener('submit', validateProfileForm);
    }
}

/**
 * Category Cards Interaction
 */
function initializeCategoryCards() {
    const categoryCards = document.querySelectorAll('.category-card');
    
    categoryCards.forEach(card => {
        card.addEventListener('click', function(e) {
            // Don't trigger if clicking the button inside
            if (e.target.closest('button')) return;
            
            const category = this.querySelector('h3').textContent;
            const button = this.querySelector('.btn');
            
            if (button) {
                // Animate button click
                button.classList.add('loading');
                const originalText = button.innerHTML;
                button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Redirecting...';
                
                setTimeout(() => {
                    button.classList.remove('loading');
                    button.innerHTML = originalText;
                    window.location.href = this.getAttribute('onclick').match(/'(.*?)'/)[1];
                }, 500);
            }
        });
        
        // Add keyboard support
        card.setAttribute('tabindex', '0');
        card.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                this.click();
            }
        });
    });
}

// ============================================
// 2. PAGE-SPECIFIC FUNCTIONS
// ============================================

/**
 * Browse Page Functionality
 */
function initializeBrowsePage() {
    console.log('Initializing browse page...');
    
    // Sample listings data
    const sampleListings = [
        {
            id: 1,
            title: "Web Development Tutoring",
            price: "$25/hour",
            rating: 4.2,
            category: "skill",
            location: "Addis Ababa",
            description: "Learn HTML, CSS, JavaScript from experienced developer.",
            icon: "fa-code",
            date: "2025-01-15"
        },
        {
            id: 2,
            title: "Power Drill Set",
            price: "$15/day",
            rating: 4.7,
            category: "tool",
            location: "Addis Ababa",
            description: "Professional power tools for home improvement.",
            icon: "fa-tools",
            date: "2025-01-14"
        },
        {
            id: 3,
            title: "Data Entry Specialist",
            price: "$500/month",
            rating: 4.0,
            category: "job",
            location: "Remote",
            description: "Part-time remote position requiring attention to detail.",
            icon: "fa-briefcase",
            date: "2025-01-13"
        }
    ];
    
    // Initialize pagination and filtering
    let currentPage = 1;
    const itemsPerPage = 6;
    let filteredListings = [...sampleListings];
    
    // DOM Elements
    const listingsGrid = document.getElementById('listingsGrid');
    const applyFiltersBtn = document.getElementById('applyFilters');
    const resetFiltersBtn = document.getElementById('resetFilters');
    const sortSelect = document.getElementById('sortBy');
    
    // Initialize filters
    if (applyFiltersBtn) applyFiltersBtn.addEventListener('click', applyFilters);
    if (resetFiltersBtn) resetFiltersBtn.addEventListener('click', resetFilters);
    if (sortSelect) sortSelect.addEventListener('change', applyFilters);
    
    // Check for URL parameters
    const urlParams = new URLSearchParams(window.location.search);
    const searchParam = urlParams.get('search');
    const typeParam = urlParams.get('type');
    
    if (searchParam) {
        document.querySelector('.search-box input').value = searchParam;
        filterListingsBySearch(searchParam);
    }
    
    if (typeParam) {
        const categoryCheckbox = document.querySelector(`input[name="category"][value="${typeParam}"]`);
        if (categoryCheckbox) {
            categoryCheckbox.checked = true;
            applyFilters();
        }
    }
    
    // Update initial display
    updateListingsDisplay();
    
    function applyFilters() {
        // Get filter values
        const selectedCategories = Array.from(document.querySelectorAll('input[name="category"]:checked'))
            .map(cb => cb.value);
        
        const priceFilter = document.querySelector('input[name="price"]:checked').value;
        const locationFilter = document.getElementById('locationFilter').value.toLowerCase();
        const sortBy = sortSelect.value;
        
        // Filter listings
        filteredListings = sampleListings.filter(listing => {
            // Category filter
            if (selectedCategories.length > 0 && !selectedCategories.includes(listing.category)) {
                return false;
            }
            
            // Price filter
            const priceNum = parseFloat(listing.price.replace(/[^0-9.]/g, ''));
            if (priceFilter === 'under50' && priceNum >= 50) return false;
            if (priceFilter === '50-100' && (priceNum < 50 || priceNum > 100)) return false;
            if (priceFilter === 'over100' && priceNum <= 100) return false;
            
            // Location filter
            if (locationFilter && !listing.location.toLowerCase().includes(locationFilter)) {
                return false;
            }
            
            return true;
        });
        
        // Sort listings
        sortListings(sortBy);
        
        currentPage = 1;
        updateListingsDisplay();
    }
    
    function resetFilters() {
        if (!document.querySelectorAll('input[name="category"]').length) return;
        
        document.querySelectorAll('input[name="category"]').forEach(cb => cb.checked = true);
        document.querySelector('input[name="price"][value="all"]').checked = true;
        document.getElementById('locationFilter').value = '';
        sortSelect.value = 'newest';
        
        filteredListings = [...sampleListings];
        currentPage = 1;
        updateListingsDisplay();
    }
    
    function sortListings(sortBy) {
        filteredListings.sort((a, b) => {
            switch(sortBy) {
                case 'price_low':
                    return parseFloat(a.price) - parseFloat(b.price);
                case 'price_high':
                    return parseFloat(b.price) - parseFloat(a.price);
                case 'rating':
                    return b.rating - a.rating;
                case 'newest':
                    return new Date(b.date) - new Date(a.date);
                default:
                    return 0;
            }
        });
    }
    
    function updateListingsDisplay() {
        if (!listingsGrid) return;
        
        if (filteredListings.length === 0) {
            listingsGrid.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-search fa-3x"></i>
                    <h3>No listings found</h3>
                    <p>Try adjusting your filters or search terms</p>
                    <button onclick="resetFilters()" class="btn">
                        <i class="fas fa-redo"></i> Reset Filters
                    </button>
                </div>
            `;
            return;
        }
        
        listingsGrid.innerHTML = filteredListings.map(listing => `
            <div class="listing-card" data-id="${listing.id}">
                <div class="listing-image">
                    <i class="fas ${listing.icon}"></i>
                </div>
                <div class="listing-content">
                    <h3 class="listing-title">${listing.title}</h3>
                    <p class="listing-price">${listing.price}</p>
                    <div class="listing-rating">
                        ${generateStars(listing.rating)}
                        <span>(${listing.rating})</span>
                    </div>
                    <p class="listing-description">${listing.description}</p>
                    <div class="listing-meta">
                        <span class="listing-category">${capitalizeFirstLetter(listing.category)}</span>
                        <span><i class="fas fa-map-marker-alt"></i> ${listing.location}</span>
                    </div>
                </div>
            </div>
        `).join('');
        
        // Add click events to cards
        document.querySelectorAll('.listing-card').forEach(card => {
            card.addEventListener('click', function() {
                const id = this.getAttribute('data-id');
                viewListingDetails(id);
            });
        });
    }
    
    function filterListingsBySearch(searchTerm) {
        filteredListings = sampleListings.filter(listing =>
            listing.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
            listing.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
            listing.location.toLowerCase().includes(searchTerm.toLowerCase())
        );
        updateListingsDisplay();
    }
    
    function viewListingDetails(id) {
        showNotification(`Viewing listing #${id}`, 'info');
        // In real app: window.location.href = `listing-details.html?id=${id}`;
    }
}

/**
 * Dashboard Page Functionality
 */
function initializeDashboardPage() {
    console.log('Initializing dashboard...');
    
    // Update user stats
    updateDashboardStats();
    
    // Load user listings
    loadUserListings();
    
    // Logout button
    const logoutBtn = document.getElementById('logoutBtn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (confirm('Are you sure you want to logout?')) {
                showNotification('Logging out...', 'info');
                setTimeout(() => {
                    window.location.href = '../index.html';
                }, 1000);
            }
        });
    }
    
    // Quick action buttons
    document.querySelectorAll('.quick-action-btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            const action = this.getAttribute('data-action');
            handleQuickAction(action);
        });
    });
}

/**
 * Create Listing Page Functionality
 */
function initializeCreateListingPage() {
    console.log('Initializing create listing page...');
    
    // Type selection
    const typeOptions = document.querySelectorAll('.type-option');
    const skillFields = document.getElementById('skillFields');
    const toolFields = document.getElementById('toolFields');
    const jobFields = document.getElementById('jobFields');
    
    typeOptions.forEach(option => {
        option.addEventListener('click', function() {
            // Remove active class from all
            typeOptions.forEach(opt => opt.classList.remove('active'));
            
            // Add to clicked
            this.classList.add('active');
            
            // Show/hide fields
            const type = this.getAttribute('data-type');
            if (skillFields) skillFields.style.display = type === 'skill' ? 'block' : 'none';
            if (toolFields) toolFields.style.display = type === 'tool' ? 'block' : 'none';
            if (jobFields) jobFields.style.display = type === 'job' ? 'block' : 'none';
        });
    });
    
    // Select first type by default
    if (typeOptions.length > 0) {
        typeOptions[0].click();
    }
}

/**
 * Profile Page Functionality
 */
function initializeProfilePage() {
    console.log('Initializing profile page...');
    
    // Profile tabs
    const profileTabs = document.querySelectorAll('.profile-tab');
    const profileContents = document.querySelectorAll('.profile-content');
    
    profileTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            const tabId = this.getAttribute('data-tab');
            
            // Update active tab
            profileTabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            // Show corresponding content
            profileContents.forEach(content => {
                content.classList.remove('active');
                if (content.id === `${tabId}Content`) {
                    content.classList.add('active');
                }
            });
        });
    });
    
    // Change photo button
    const changePhotoBtn = document.getElementById('changePhotoBtn');
    if (changePhotoBtn) {
        changePhotoBtn.addEventListener('click', function() {
            showNotification('Photo upload feature would open here', 'info');
        });
    }
}

/**
 * Admin Page Functionality
 */
function initializeAdminPage() {
    console.log('Initializing admin panel...');
    
    // Approve/Reject buttons
    document.querySelectorAll('.btn-approve').forEach(btn => {
        btn.addEventListener('click', function() {
            const row = this.closest('tr');
            const itemName = row.querySelector('td:nth-child(2)').textContent;
            
            if (confirm(`Approve "${itemName}"?`)) {
                row.style.backgroundColor = '#d4edda';
                row.classList.add('approved');
                showNotification(`Approved: ${itemName}`, 'success');
            }
        });
    });
    
    document.querySelectorAll('.btn-reject').forEach(btn => {
        btn.addEventListener('click', function() {
            const row = this.closest('tr');
            const itemName = row.querySelector('td:nth-child(2)').textContent;
            
            if (confirm(`Reject "${itemName}"?`)) {
                row.style.backgroundColor = '#f8d7da';
                row.classList.add('rejected');
                showNotification(`Rejected: ${itemName}`, 'error');
            }
        });
    });
}

// ============================================
// 3. GLOBAL FEATURES & UTILITIES
// ============================================

function initializeGlobalFeatures() {
    // Set current year in footer
    const yearElements = document.querySelectorAll('.current-year');
    if (yearElements.length > 0) {
        const currentYear = new Date().getFullYear();
        yearElements.forEach(el => {
            el.textContent = currentYear;
        });
    }
    
    // Add loading states to all buttons with .btn class
    document.querySelectorAll('.btn').forEach(button => {
        button.addEventListener('click', function(e) {
            if (this.classList.contains('loading')) {
                e.preventDefault();
                return;
            }
        });
    });
    
    // Initialize tooltips
    initializeTooltips();
}

/**
 * Show notification (toast message)
 */
function showNotification(message, type = 'info') {
    // Remove existing notifications
    const existing = document.querySelectorAll('.notification-toast');
    existing.forEach(notif => notif.remove());
    
    // Create notification
    const notification = document.createElement('div');
    notification.className = `notification-toast notification-${type}`;
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas ${getNotificationIcon(type)}"></i>
            <span>${message}</span>
        </div>
        <button class="notification-close" aria-label="Close notification">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    // Add styles
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${getNotificationColor(type)};
        color: white;
        padding: 15px 20px;
        border-radius: 8px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        display: flex;
        align-items: center;
        gap: 15px;
        z-index: 10000;
        animation: slideInRight 0.3s ease;
        max-width: 400px;
    `;
    
    // Add animation
    const style = document.createElement('style');
    if (!document.querySelector('#notification-animations')) {
        style.id = 'notification-animations';
        style.textContent = `
            @keyframes slideInRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutRight {
                from { transform: translateX(0); opacity: 1; }
                to { transform: translateX(100%); opacity: 0; }
            }
        `;
        document.head.appendChild(style);
    }
    
    // Add close functionality
    const closeBtn = notification.querySelector('.notification-close');
    closeBtn.addEventListener('click', function() {
        notification.style.animation = 'slideOutRight 0.3s ease forwards';
        setTimeout(() => notification.remove(), 300);
    });
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            closeBtn.click();
        }
    }, 5000);
    
    document.body.appendChild(notification);
    return notification;
}

/**
 * Form Validation Functions
 */
function validateSignupForm(e) {
    e.preventDefault();
    
    const form = e.target;
    const fullName = form.querySelector('#fullName').value.trim();
    const email = form.querySelector('#email').value.trim();
    const password = form.querySelector('#password').value;
    const confirmPassword = form.querySelector('#confirmPassword').value;
    const userRole = form.querySelector('#userRole').value;
    const terms = form.querySelector('#terms');
    
    // Validation
    const errors = [];
    
    if (fullName.length < 2) errors.push('Name must be at least 2 characters');
    if (!isValidEmail(email)) errors.push('Please enter a valid email');
    if (password.length < 6) errors.push('Password must be at least 6 characters');
    if (password !== confirmPassword) errors.push('Passwords do not match');
    if (!userRole) errors.push('Please select a role');
    if (!terms || !terms.checked) errors.push('You must agree to the terms');
    
    if (errors.length > 0) {
        showNotification(errors[0], 'error');
        return false;
    }
    
    // Show loading
    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn.innerHTML;
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
    submitBtn.disabled = true;
    
    // Simulate API call
    setTimeout(() => {
        showNotification('Account created successfully!', 'success');
        setTimeout(() => {
            window.location.href = 'login.html';
        }, 1500);
    }, 1500);
    
    return false;
}

function validateLoginForm(e) {
    e.preventDefault();
    
    const form = e.target;
    const email = form.querySelector('#loginEmail').value.trim();
    const password = form.querySelector('#loginPassword').value;
    
    if (!email || !password) {
        showNotification('Please fill in all fields', 'error');
        return false;
    }
    
    // Demo credentials
    if (email === 'admin@multihub.com' && password === 'admin123') {
        showNotification('Admin login successful!', 'success');
        setTimeout(() => window.location.href = 'admin.html', 1000);
    } else if (email === 'test@user.com' && password === 'test123') {
        showNotification('Login successful!', 'success');
        setTimeout(() => window.location.href = '../index.html', 1000);
    } else {
        // Demo mode - accept any credentials
        showNotification('Login successful! (Demo mode)', 'success');
        setTimeout(() => window.location.href = '../index.html', 1000);
    }
    
    return false;
}

function validateListingForm(e) {
    e.preventDefault();
    const form = e.target;
    
    // Basic validation
    const title = form.querySelector('#title').value.trim();
    const description = form.querySelector('#description').value.trim();
    
    if (!title || !description) {
        showNotification('Please fill in all required fields', 'error');
        return false;
    }
    
    if (description.length < 20) {
        showNotification('Description must be at least 20 characters', 'error');
        return false;
    }
    
    showNotification('Listing submitted successfully!', 'success');
    setTimeout(() => window.location.href = 'dashboard.html', 1500);
    return false;
}

function validateProfileForm(e) {
    e.preventDefault();
    
    const form = e.target;
    const name = form.querySelector('#profileName').value.trim();
    
    if (!name) {
        showNotification('Please enter your name', 'error');
        return false;
    }
    
    showNotification('Profile updated successfully!', 'success');
    return false;
}

// ============================================
// HELPER FUNCTIONS
// ============================================

/**
 * Fix tablet menu visibility
 */
function checkTabletMenu() {
    const width = window.innerWidth;
    const isTablet = width >= 769 && width <= 1024;
    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.getElementById('navLinks');
    
    if (!menuToggle || !navLinks) return;
    
    if (isTablet) {
        // On tablet, hide hamburger and show menu
        menuToggle.style.display = 'none';
        navLinks.style.display = 'flex';
        navLinks.classList.remove('active');
    } else if (width <= 768) {
        // On mobile, show hamburger
        menuToggle.style.display = 'block';
    } else {
        // On desktop, hide hamburger, show menu
        menuToggle.style.display = 'none';
        navLinks.style.display = 'flex';
    }
}

/**
 * Generate star rating HTML
 */
function generateStars(rating) {
    let stars = '';
    const fullStars = Math.floor(rating);
    const hasHalfStar = rating % 1 >= 0.3 && rating % 1 <= 0.7;
    const isEmptyHalfStar = rating % 1 > 0.7;
    
    for (let i = 1; i <= 5; i++) {
        if (i <= fullStars) {
            stars += '<i class="fas fa-star"></i>';
        } else if (i === fullStars + 1) {
            if (hasHalfStar) {
                stars += '<i class="fas fa-star-half-alt"></i>';
            } else if (isEmptyHalfStar) {
                stars += '<i class="far fa-star"></i>';
            } else {
                stars += '<i class="far fa-star"></i>';
            }
        } else {
            stars += '<i class="far fa-star"></i>';
        }
    }
    return stars;
}

/**
 * Utility functions
 */
function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}

function getNotificationIcon(type) {
    switch(type) {
        case 'success': return 'fa-check-circle';
        case 'error': return 'fa-exclamation-circle';
        case 'warning': return 'fa-exclamation-triangle';
        default: return 'fa-info-circle';
    }
}

function getNotificationColor(type) {
    switch(type) {
        case 'success': return '#27ae60';
        case 'error': return '#e74c3c';
        case 'warning': return '#f39c12';
        default: return '#3498db';
    }
}

function initializeTooltips() {
    // Add tooltips to elements with data-tooltip attribute
    document.querySelectorAll('[data-tooltip]').forEach(element => {
        element.addEventListener('mouseenter', function(e) {
            const tooltip = document.createElement('div');
            tooltip.className = 'tooltip';
            tooltip.textContent = this.getAttribute('data-tooltip');
            
            document.body.appendChild(tooltip);
            
            const rect = this.getBoundingClientRect();
            tooltip.style.cssText = `
                position: absolute;
                background: #2c3e50;
                color: white;
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                z-index: 10001;
                top: ${rect.top - 35}px;
                left: ${rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2)}px;
                white-space: nowrap;
            `;
            
            this.tooltipElement = tooltip;
        });
        
        element.addEventListener('mouseleave', function() {
            if (this.tooltipElement) {
                this.tooltipElement.remove();
                this.tooltipElement = null;
            }
        });
    });
}

// Initialize on load
checkTabletMenu();

// Export for module usage if needed
if (typeof module !== 'undefined' && module.exports) {
    module.exports = {
        initializeMobileMenu,
        showNotification,
        validateSignupForm,
        validateLoginForm
    };
}


// Make admin tables mobile-friendly
function makeTablesResponsive() {
    const tables = document.querySelectorAll('.admin-table');
    
    tables.forEach(table => {
        // Add wrapper for horizontal scroll
        if (!table.parentElement.classList.contains('table-responsive')) {
            const wrapper = document.createElement('div');
            wrapper.className = 'table-responsive';
            wrapper.style.overflowX = 'auto';
            table.parentElement.insertBefore(wrapper, table);
            wrapper.appendChild(table);
        }
        
        // Add responsive class to table
        table.classList.add('table-responsive');
    });
}

// Run on page load and window resize
document.addEventListener('DOMContentLoaded', makeTablesResponsive);
window.addEventListener('resize', makeTablesResponsive);







// ==================== REGISTRATION PAGE JS ====================
function initRegistrationPage() {
    const form = document.getElementById('registerForm');
    const roleSelect = document.getElementById('role');
    
    if (!form && !roleSelect) return; // Not on registration page
    
    // Password validation
    if (form) {
        form.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms');
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Passwords do not match!');
                return;
            }
            
            if (terms && !terms.checked) {
                e.preventDefault();
                alert('You must agree to the Terms & Conditions');
                return;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            if (submitBtn) {
                const originalHTML = submitBtn.innerHTML;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
                submitBtn.disabled = true;
                
                // Re-enable after 5 seconds (in case of error)
                setTimeout(() => {
                    submitBtn.innerHTML = originalHTML;
                    submitBtn.disabled = false;
                }, 5000);
            }
        });
    }
    
    // Role description
    if (roleSelect) {
        roleSelect.addEventListener('change', function() {
            const descriptions = {
                'provider': 'Offer your skills and services (tutoring, repairs, etc.)',
                'tool_owner': 'Rent out equipment and tools to others',
                'job_seeker': 'Browse and apply for job opportunities',
                'employer': 'Post job openings and hire talent'
            };
            
            // Remove previous description
            const oldDesc = document.getElementById('roleDescription');
            if (oldDesc) oldDesc.remove();
            
            // Add new description
            const desc = descriptions[this.value];
            if (desc) {
                const descElement = document.createElement('small');
                descElement.id = 'roleDescription';
                descElement.className = 'form-help text-success';
                descElement.innerHTML = `<i class="fas fa-check-circle"></i> ${desc}`;
                this.parentNode.appendChild(descElement);
            }
        });
    }
    
    // Terms link
    document.querySelector('.terms-link')?.addEventListener('click', function(e) {
        e.preventDefault();
        alert('Terms and conditions page would open here');
    });
}

// ==================== INITIALIZE ON PAGE LOAD ====================
document.addEventListener('DOMContentLoaded', function() {
    // Check which page we're on and run appropriate init
    if (document.getElementById('registerForm')) {
        initRegistrationPage();
    }
    

});




// ==================== HOME PAGE JS ====================
function initHomePage() {
    const heroSection = document.querySelector('.hero');
    if (!heroSection) return; // Not on home page
    
    // Search functionality
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });
    }
    
    // Add click handlers to category cards
    document.querySelectorAll('.category-card').forEach(card => {
        card.style.cursor = 'pointer';
        card.addEventListener('click', function() {
            const type = this.querySelector('h3').textContent.toLowerCase();
            if (type.includes('skill')) {
                window.location.href = 'browse.jsp?type=skill';
            } else if (type.includes('tool')) {
                window.location.href = 'browse.jsp?type=tool';
            } else if (type.includes('job')) {
                window.location.href = 'browse.jsp?type=job';
            }
        });
    });
    
    // Add click handlers to listing cards
    document.querySelectorAll('.listing-card').forEach(card => {
        card.style.cursor = 'pointer';
        card.addEventListener('click', function() {
            const category = this.querySelector('.listing-category').textContent.toLowerCase();
            window.location.href = `browse.jsp?type=${category}`;
        });
    });
}

function performSearch() {
    const searchInput = document.getElementById('searchInput');
    const query = searchInput ? searchInput.value.trim() : '';
    
    if (!query) {
        alert('Please enter a search term');
        return;
    }
    
    // Redirect to browse page with search query
    window.location.href = `browse.jsp?search=${encodeURIComponent(query)}`;
}

// ==================== INITIALIZE ON PAGE LOAD ====================
document.addEventListener('DOMContentLoaded', function() {
    // Check which page we're on and run appropriate init
    if (document.querySelector('.hero')) {
        initHomePage();
    }
    
    // Mobile menu toggle (should be in your main.js already)
    const menuToggle = document.getElementById('menuToggle');
    const navLinks = document.getElementById('navLinks');
    
    if (menuToggle && navLinks) {
        menuToggle.addEventListener('click', function() {
            navLinks.classList.toggle('show');
        });
    }
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.navbar') && navLinks && navLinks.classList.contains('show')) {
            navLinks.classList.remove('show');
        }
    });
    
    // Add CSS for home page if not already present
    addHomePageStyles();
});

function addHomePageStyles() {
    // Add home page specific CSS if not already present
    if (!document.getElementById('home-styles')) {
        const style = document.createElement('style');
        style.id = 'home-styles';
        style.textContent = `
            /* Home page specific styles */
            .hero {
                text-align: center;
                padding: 4rem 1rem;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                margin-bottom: 3rem;
            }
            
            .hero h1, .hero h2 {
                font-size: 2.5rem;
                margin-bottom: 1rem;
            }
            
            .hero p {
                font-size: 1.2rem;
                margin-bottom: 2rem;
                opacity: 0.9;
            }
            
            .search-box {
                max-width: 600px;
                margin: 0 auto 2rem;
                display: flex;
                gap: 0.5rem;
            }
            
            .search-box input {
                flex: 1;
                padding: 1rem;
                border: none;
                border-radius: 5px;
                font-size: 1rem;
            }
            
            .search-box button {
                padding: 1rem 2rem;
                background: #28a745;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 1rem;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }
            
            .search-box button:hover {
                background: #218838;
            }
            
            .hero-actions {
                display: flex;
                gap: 1rem;
                justify-content: center;
                margin-top: 2rem;
            }
            
            .btn-primary {
                background: #28a745;
                color: white;
            }
            
            .btn-secondary {
                background: transparent;
                border: 2px solid white;
                color: white;
            }
            
            /* Categories */
            .categories {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 2rem;
                padding: 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }
            
            .category-card {
                background: white;
                border-radius: 10px;
                padding: 2rem;
                text-align: center;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: transform 0.3s, box-shadow 0.3s;
            }
            
            .category-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            }
            
            .category-icon {
                width: 80px;
                height: 80px;
                background: #667eea;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1rem;
                color: white;
                font-size: 2rem;
            }
            
            .category-card h3 {
                margin: 1rem 0;
                color: #333;
            }
            
            .category-card p {
                color: #666;
                margin-bottom: 1.5rem;
            }
            
            /* Featured Listings */
            .featured {
                padding: 3rem 1rem;
                background: #f8f9fa;
            }
            
            .section-title {
                text-align: center;
                margin-bottom: 2rem;
                color: #333;
            }
            
            .featured-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 2rem;
                max-width: 1200px;
                margin: 0 auto 2rem;
            }
            
            .listing-card {
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                transition: transform 0.3s;
            }
            
            .listing-card:hover {
                transform: translateY(-5px);
            }
            
            .listing-image {
                height: 150px;
                background: #4a6fa5;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-size: 3rem;
            }
            
            .listing-content {
                padding: 1.5rem;
            }
            
            .listing-title {
                margin: 0 0 0.5rem 0;
                color: #333;
            }
            
            .listing-price {
                font-size: 1.5rem;
                font-weight: bold;
                color: #28a745;
                margin: 0 0 0.5rem 0;
            }
            
            .listing-rating {
                margin: 0.5rem 0;
                color: #f39c12;
            }
            
            .listing-description {
                color: #666;
                margin: 1rem 0;
                line-height: 1.5;
            }
            
            .listing-meta {
                display: flex;
                justify-content: space-between;
                color: #666;
                font-size: 0.9rem;
            }
            
            .listing-category {
                background: #e3f2fd;
                color: #1976d2;
                padding: 0.25rem 0.75rem;
                border-radius: 12px;
            }
            
            .view-all {
                text-align: center;
                margin-top: 2rem;
            }
            
            /* How It Works */
            .how-it-works {
                padding: 3rem 1rem;
            }
            
            .steps-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 2rem;
                max-width: 1200px;
                margin: 0 auto;
            }
            
            .step-card {
                text-align: center;
                padding: 2rem;
                background: white;
                border-radius: 10px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            .step-number {
                width: 50px;
                height: 50px;
                background: #667eea;
                color: white;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                font-weight: bold;
                margin: 0 auto 1rem;
            }
            
            .step-card h3 {
                margin: 1rem 0;
                color: #333;
            }
            
            .step-card p {
                color: #666;
                line-height: 1.5;
            }
            
            /* Footer */
            .footer {
                background: #333;
                color: white;
                padding: 2rem 1rem;
                text-align: center;
            }
            
            .footer-links {
                margin: 1rem 0;
            }
            
            .footer-links a {
                color: #ddd;
                text-decoration: none;
                margin: 0 0.5rem;
            }
            
            .footer-links a:hover {
                color: white;
            }
            
            .footer-tech {
                margin-top: 1rem;
                font-size: 0.9rem;
                color: #aaa;
            }
            
            @media (max-width: 768px) {
                .hero h1, .hero h2 {
                    font-size: 2rem;
                }
                
                .search-box {
                    flex-direction: column;
                }
                
                .hero-actions {
                    flex-direction: column;
                }
                
                .categories {
                    padding: 1rem;
                }
                
                .featured-grid {
                    grid-template-columns: 1fr;
                }
            }
        `;
        document.head.appendChild(style);
    }
}