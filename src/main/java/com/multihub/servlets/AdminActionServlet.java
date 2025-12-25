package com.multihub.servlets;

import com.multihub.dao.ListingDAO;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin-action")
public class AdminActionServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Security check: Only admins can trigger this
        HttpSession session = request.getSession();
        com.multihub.models.User user = (com.multihub.models.User) session.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String id = request.getParameter("id");
        String action = request.getParameter("action"); // "approved" or "rejected"

        ListingDAO dao = new ListingDAO();
        boolean approve = "approved".equalsIgnoreCase(action);
        if (dao.updateListingStatus(id, approve)) {
            response.sendRedirect("admin-dashboard.jsp?success=Listing " + (approve ? "approved" : "rejected"));
        } else {
            response.sendRedirect("admin-dashboard.jsp?error=Action failed");
        }
    }
}