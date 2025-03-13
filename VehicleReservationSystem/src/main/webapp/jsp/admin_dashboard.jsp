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
    <title>Admin Dashboard</title>
    <!-- Bootstrap CSS is already imported in header.jsp -->

    <style>
        body {
            background-color: #f8f9fa; /* Light background */
        }
        .dashboard-heading {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        /* Card styling for quick stats */
        .stats-card {
            border: none;
            transition: transform 0.2s ease;
        }
        .stats-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        .stats-card .card-body {
            text-align: center;
        }
        .stats-title {
            font-size: 1.2rem;
            margin-bottom: 0.5rem;
        }
        .stats-value {
            font-size: 1.8rem;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Main Heading -->
        <h1 class="dashboard-heading text-center">Admin Dashboard</h1>

        <!-- Example row of "quick stats" (replace placeholder values with real queries) -->
        <div class="row g-3 mb-4">
            <!-- Example: Total Drivers -->
            <div class="col-md-3">
                <div class="card stats-card shadow-sm">
                    <div class="card-body">
                        <div class="stats-title">Total Drivers</div>
                        <div class="stats-value">
                            <!-- Replace with a dynamic query for total drivers -->
                            10
                        </div>
                    </div>
                </div>
            </div>
            <!-- Example: Total Vehicles -->
            <div class="col-md-3">
                <div class="card stats-card shadow-sm">
                    <div class="card-body">
                        <div class="stats-title">Total Vehicles</div>
                        <div class="stats-value">
                            <!-- Replace with a dynamic query for total vehicles -->
                            25
                        </div>
                    </div>
                </div>
            </div>
            <!-- Example: Total Bookings -->
            <div class="col-md-3">
                <div class="card stats-card shadow-sm">
                    <div class="card-body">
                        <div class="stats-title">Total Bookings</div>
                        <div class="stats-value">
                            <!-- Replace with a dynamic query for total bookings -->
                            120
                        </div>
                    </div>
                </div>
            </div>
            <!-- Example: Pending Bookings -->
            <div class="col-md-3">
                <div class="card stats-card shadow-sm">
                    <div class="card-body">
                        <div class="stats-title">Pending Bookings</div>
                        <div class="stats-value">
                            <!-- Replace with a dynamic query for pending bookings -->
                            8
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bookings Section -->
        <div class="card shadow mb-4">
            <div class="card-header bg-white">
                <h3 class="mb-0">All Bookings (Assign Drivers)</h3>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-primary">
                            <tr>
                                <th>Booking ID</th>
                                <th>Customer ID</th>
                                <th>Pickup</th>
                                <th>Destination</th>
                                <th>Fare</th>
                                <th>Status</th>
                                <th>Assign Driver</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                try (Connection conn = com.vehicle.utils.DBConnection.getInstance().getConnection()) {
                                    String sql = "SELECT * FROM bookings WHERE status='pending'";
                                    PreparedStatement stmt = conn.prepareStatement(sql);
                                    ResultSet rs = stmt.executeQuery();

                                    while (rs.next()) {
                                        int bookingId = rs.getInt("booking_id");
                            %>
                            <tr>
                                <td><%= bookingId %></td>
                                <td><%= rs.getInt("customer_id") %></td>
                                <td><%= rs.getString("pickup_location") %></td>
                                <td><%= rs.getString("destination") %></td>
                                <td>$<%= rs.getDouble("fare") %></td>
                                <td><%= rs.getString("status") %></td>
                                <td>
                                    <form action="../AssignDriverServlet" method="post" class="d-inline">
                                        <input type="hidden" name="booking_id" value="<%= bookingId %>">
                                        <div class="input-group">
                                            <select name="driver_id" class="form-select">
                                                <%
                                                    // Fetch available drivers
                                                    String driverSql = "SELECT * FROM users WHERE role='driver'";
                                                    PreparedStatement driverStmt = conn.prepareStatement(driverSql);
                                                    ResultSet driverRs = driverStmt.executeQuery();
                                                    while (driverRs.next()) {
                                                %>
                                                <option value="<%= driverRs.getInt("id") %>">
                                                    <%= driverRs.getString("name") %>
                                                </option>
                                                <%
                                                    }
                                                %>
                                            </select>
                                            <button type="submit" class="btn btn-success">Assign</button>
                                        </div>
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
    </div>
    
    <!-- Bootstrap JS (required for responsive navbar and some components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
