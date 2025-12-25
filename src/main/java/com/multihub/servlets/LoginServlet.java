/* 

package com.multihub.servlets;

import com.multihub.dao.UserDAO;
import com.multihub.models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.loginUser(email, password);

        if (user != null) {
            // Create session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId().toString());
            session.setAttribute("userRole", user.getRole());
            session.setAttribute("userName", user.getFullName());

            // Set session timeout to 30 minutes
            session.setMaxInactiveInterval(30 * 60);

            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("dashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}



*/