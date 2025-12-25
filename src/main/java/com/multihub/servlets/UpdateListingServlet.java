package com.multihub.servlets;

import java.io.IOException;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.multihub.dao.ListingDAO;

@WebServlet("/update-listing")
public class UpdateListingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String id = request.getParameter("id");
        String title = request.getParameter("title");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");

        ListingDAO dao = new ListingDAO();
        // We set status back to 'pending' so Admin can re-verify the changes
        if (dao.updateListingDetails(id, title, price, description)) {
            response.sendRedirect("dashboard.jsp?success=Listing updated and sent for re-approval");
        } else {
            response.sendRedirect("dashboard.jsp?error=Update failed");
        }
    }
}