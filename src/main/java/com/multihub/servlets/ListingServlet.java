package com.multihub.servlets;

import com.multihub.dao.ListingDAO;
import com.multihub.models.Listing;
import com.multihub.models.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.UUID; // Needed for ID generation

@WebServlet("/submit-listing")
public class ListingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 1. Capture parameters
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String imageUrl = request.getParameter("imageUrl");
        String priceRaw = request.getParameter("price");

        // 2. Safely convert Price
        double price = 0.0;
        try {
            if (priceRaw != null && !priceRaw.isEmpty()) {
                price = Double.parseDouble(priceRaw);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        // 3. Map everything to the Listing object
        Listing listing = new Listing();

        // --- THE CRITICAL FIXES ---
        listing.setId(UUID.randomUUID()); // Fixes the "id is null" DB error
        listing.setStatus("pending"); // Ensures it shows up for Admin
        // --------------------------

        listing.setUserId(user.getId());
        listing.setTitle(title);
        listing.setDescription(description);
        listing.setCategory(category);
        listing.setPrice(price);
        listing.setImageUrl(imageUrl);

        // 4. Send to DAO
        ListingDAO dao = new ListingDAO();
        if (dao.createListing(listing)) {
            // Success!
            response.sendRedirect("dashboard.jsp?success=1");
        } else {
            // Failure!
            response.sendRedirect("dashboard.jsp?error=1");
        }
    }
}