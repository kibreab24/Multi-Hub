<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | Multi-Hub</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="form-container">
            <h1>Admin Portal</h1>
            <p>Secure login for Multi-Hub Administrators</p>
            
            <form action="AdminServlet" method="POST">
                <div class="form-group">
                    <label>Admin Username</label>
                    <input type="text" name="username" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-danger btn-block">Login as Admin</button>
            </form>
        </div>
    </div>
</body>
</html>