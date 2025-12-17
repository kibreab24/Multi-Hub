package com.multihub.servlets;

import com.multihub.models.User;
import com.multihub.dao.UserDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        // Initialize database connection
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getPathInfo();
        
        if (action == null) action = "";
        
        switch (action) {
            case "/register":
                handleRegister(request, response);
                break;
            case "/login":
                handleLogin(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String role = request.getParameter("role");
        
        // Basic validation
        if (email == null || password == null || fullName == null || role == null) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Create user
        User user = new User(email, fullName, role);
        // TODO: Hash password, save to database
        
        // Redirect to login
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
    
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // TODO: Validate credentials against database
        
        // For now, simulate successful login
        HttpSession session = request.getSession();
        User user = new User(email, "Test User", "provider");
        session.setAttribute("user", user);
        
        // Redirect to dashboard
        response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
    }
}
