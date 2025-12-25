package com.multihub.servlets;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.multihub.dao.UserDAO;
import com.multihub.models.User;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String name = request.getParameter("full_name");
        String phone = request.getParameter("phone");

        UserDAO dao = new UserDAO();
        if (dao.updateUserProfile(user.getId(), name, phone)) {
            // Update the session user object so the changes show immediately
            user.setFullName(name);
            user.setPhone(phone);
            response.sendRedirect("dashboard.jsp?success=Profile updated!");
        } else {
            response.sendRedirect("dashboard.jsp?error=Update failed");
        }
    }
}