<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.Listing" %>
<%@ page import="com.multihub.dao.ListingDAO" %>
<%@ page import="java.util.UUID" %>

<%
    String id = request.getParameter("id");
    ListingDAO dao = new ListingDAO();
    Listing listing = dao.getListingById(UUID.fromString(id));
    
    // Security: Only allow owner to edit
    com.multihub.models.User user = (com.multihub.models.User) session.getAttribute("user");
    if (listing == null || !listing.getUserId().equals(user.getId())) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Listing - Multi-Hub</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <h2>Edit Your Listing</h2>
        <form action="update-listing" method="post">
            <input type="hidden" name="id" value="<%= listing.getId() %>">
            
            <label>Title</label>
            <input type="text" name="title" value="<%= listing.getTitle() %>" required>
            
            <label>Price (Birr)</label>
            <input type="number" name="price" value="<%= listing.getPrice() %>" required>
            
            <label>Description</label>
            <textarea name="description" required><%= listing.getDescription() %></textarea>
            
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="dashboard.jsp">Cancel</a>
        </form>
    </div>
</body>
</html>