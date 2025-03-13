<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%
    HttpSession sessionOb = request.getSession(false);
    if (sessionOb == null || sessionOb.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers</title>
    <!-- Inline CSS for page-specific styling (optional) -->
    <style>
        body {
            background-color: #f8f9fa; /* Light background */
        }
        .page-heading {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .card-header {
            background-color: #fff; /* White card header */
            border-bottom: 1px solid #dee2e6; /* Subtle border */
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Page Title -->
        <h1 class="text-center page-heading">Manage Drivers</h1>

        <!-- Driver List Section -->
        <div class="card shadow mb-4">
            <div class="card-header">
                <h4 class="mb-0">Driver List</h4>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-primary">
                            <tr>
                                <th>Driver ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th style="width: 120px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection conn = com.vehicle.utils.DBConnection.getInstance().getConnection()) {
                                    String sql = "SELECT * FROM users WHERE role='driver'";
                                    PreparedStatement stmt = conn.prepareStatement(sql);
                                    ResultSet rs = stmt.executeQuery();

                                    while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("id") %></td>
                                <td><%= rs.getString("name") %></td>
                                <td><%= rs.getString("email") %></td>
                                <td>
                                    <form action="../DeleteDriverServlet" method="post" class="d-inline">
                                        <input type="hidden" name="driver_id" value="<%= rs.getInt("id") %>">
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Add New Driver Section -->
        <div class="card shadow mb-4">
            <div class="card-header">
                <h4 class="mb-0">Add New Driver</h4>
            </div>
            <div class="card-body">
                <form action="../AddDriverServlet" method="post">
                    <div class="mb-3">
                        <label class="form-label">Name:</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email:</label>
                        <input type="email" name="email" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password:</label>
                        <input type="password" name="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        Add Driver
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> -->
</body>
</html>
