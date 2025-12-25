package com.multihub.servlets;

import com.multihub.dao.ListingDAO;
import com.multihub.models.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/delete-listing")
public class DeleteListingServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // 1. Security Check
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String listingId = request.getParameter("id");
        ListingDAO dao = new ListingDAO();

        // 2. Perform Delete (The DAO checks if the ID belongs to this User)
        if (dao.deleteListing(listingId, user.getId())) {
            response.sendRedirect("dashboard.jsp?success=Listing deleted successfully");
        } else {
            response.sendRedirect("dashboard.jsp?error=Could not delete listing");
        }
    }
}