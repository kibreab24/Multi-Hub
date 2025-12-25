<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.multihub.models.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String userName = user.getFullName();
    String userRole = user.getRole();
    String defaultType = "skill";
    if ("tool_owner".equals(userRole)) defaultType = "tool";
    if ("employer".equals(userRole)) defaultType = "job";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Listing - Multi-Hub</title>
    <link rel="stylesheet" href="fonts/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Custom Upload Styling */
        .upload-box {
            border: 2px dashed #4A90E2;
            border-radius: 8px;
            padding: 25px;
            text-align: center;
            background: #fcfcfc;
            cursor: pointer;
            transition: 0.3s;
            margin-bottom: 15px;
        }
        .upload-box:hover {
            background: #f0f7ff;
            border-color: #357abd;
        }
        .upload-box i {
            font-size: 2.5rem;
            color: #4A90E2;
            margin-bottom: 10px;
        }
        #previewImage {
            max-width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: 8px;
            margin-top: 15px;
            display: none;
            border: 1px solid #ddd;
        }
        .status-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            background: #e1f5fe;
            color: #0288d1;
            font-size: 0.85rem;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <div class="logo"><i class="fas fa-hubspot"></i> Multi-Hub</div>
            <div class="nav-links">
                <a href="dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                <a href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <main class="container">
        <div class="form-container">
            <h1><i class="fas fa-plus-circle"></i> Create New Listing</h1>
            <p class="text-center">Logged in as: <strong><%= userName %></strong> (<%= userRole %>)</p>
            
            <form action="submit-listing" method="POST" id="createListingForm">
                <input type="hidden" name="category" id="listingType" value="<%= defaultType %>">
                <input type="hidden" name="imageUrl" id="listing-image-url"> 

                <div class="form-group">
                    <label for="title">Listing Title *</label>
                    <input type="text" name="title" id="title" class="form-control" placeholder="What are you offering?" required>
                </div>
                
                <div class="form-group">
                    <label>Product/Service Image</label>
                    <div class="upload-box" id="upload_widget">
                        <i class="fas fa-camera-retro"></i>
                        <p id="uploadStatus">Click to upload photo</p>
                        <img id="previewImage" src="" alt="Preview">
                    </div>
                </div>

                <div class="form-group">
                    <label for="description">Description *</label>
                    <textarea name="description" id="description" class="form-control" rows="4" placeholder="Tell users more about your listing..." required></textarea>
                </div>
                
                <div class="form-group">
                    <label for="price">Price/Rate (Birr) *</label>
                    <input type="number" step="0.01" name="price" id="price" class="form-control" placeholder="e.g., 500" required>
                </div>
                
                <div class="form-group">
                    <label for="location">Location *</label>
                    <input type="text" name="location" id="location" class="form-control" placeholder="e.g., Addis Ababa" required>
                </div>
                
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-paper-plane"></i> Submit for Approval
                    </button>
                    <a href="dashboard.jsp" class="btn btn-block" style="text-align: center; background: #eee;">Cancel</a>
                </div>
            </form>
        </div>
    </main>

    <script src="https://upload-widget.cloudinary.com/global/all.js" type="text/javascript"></script>

    <script>
        const myWidget = cloudinary.createUploadWidget({
            cloudName: 'dwgocofps', 
            uploadPreset: 'multihubpresets', 
            sources: ['local', 'url', 'camera'],
            multiple: false,
            clientAllowedFormats: ["png", "jpg", "jpeg"]
        }, (error, result) => { 
            if (!error && result && result.event === "success") { 
                console.log('Done! Here is the image info: ', result.info); 
                // Set the hidden input value
                document.getElementById("listing-image-url").value = result.info.secure_url;
                
                // Update UI
                document.getElementById("uploadStatus").innerHTML = '<span class="status-badge"><i class="fas fa-check"></i> Image Uploaded</span>';
                const preview = document.getElementById("previewImage");
                preview.src = result.info.secure_url;
                preview.style.display = "block";
            }
        });

        document.getElementById("upload_widget").addEventListener("click", function(){
            myWidget.open();
        }, false);
    </script>
</body>
</html>