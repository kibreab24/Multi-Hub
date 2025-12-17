package com.multihub.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Just simulate registration
        String email = request.getParameter("email");
        
        if (email != null && email.contains("@")) {
            response.sendRedirect("login.html?registered=1");
        } else {
            response.sendRedirect("register.html?error=1");
        }
    }
}
