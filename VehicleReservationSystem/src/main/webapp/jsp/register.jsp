<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">
    <div class="card shadow p-4" style="max-width: 500px; width: 100%;">
        <h2 class="text-center mb-4">Register for Vehicle Reservation</h2>

        <!-- Display error messages -->
        <% String errorMessage = (String) request.getAttribute("error");
           String successMessage = (String) request.getAttribute("message");
           if (errorMessage != null) { %>
            <div class="alert alert-danger text-center">
                <%= errorMessage %>
            </div>
        <% } else if (successMessage != null) { %>
            <div class="alert alert-success text-center">
                <%= successMessage %>
            </div>
        <% } %>

        <!-- Use an absolute path for the form action -->
        <form action="<%= request.getContextPath() %>/RegisterServlet" method="post">
            <div class="mb-3">
                <label class="form-label">Name:</label>
                <input type="text" name="name" class="form-control" value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" class="form-control" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Password:</label>
                <input type="password" name="password" class="form-control" required>
                <small class="text-muted">Password must be at least 6 characters.</small>
            </div>
            <div class="mb-3">
                <label class="form-label">Role:</label>
                <select name="role" class="form-select" required>
                    <option value="customer" <%= "customer".equals(request.getParameter("role")) ? "selected" : "" %>>Customer</option>
                    <option value="driver" <%= "driver".equals(request.getParameter("role")) ? "selected" : "" %>>Driver</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">Register</button>
        </form>
        <p class="mt-3 text-center">
            Already have an account? <a href="login.jsp">Login here</a>
        </p>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
