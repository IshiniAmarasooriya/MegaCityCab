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
    <title>Driver Dashboard</title>
    <style>
        body {
            background-color: #f8f9fa; /* Light background */
        }
        .dashboard-heading {
            font-size: 2rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        .card-header {
            background-color: #fff;
            border-bottom: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <div class="container py-4">
        <!-- Main Heading -->
        <h1 class="text-center dashboard-heading">Driver Dashboard</h1>
        
        <!-- Assigned Rides Card -->
        <div class="card shadow mb-4">
            <div class="card-header">
                <h4 class="mb-0">Your Assigned Rides</h4>
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
                                <th>Update Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Integer driverId = (Integer) sessionOb.getAttribute("userId");
                                if (driverId != null) {
                                    try (Connection conn = com.vehicle.utils.DBConnection.getInstance().getConnection()) {
                                        String sql = "SELECT * FROM bookings WHERE driver_id=?";
                                        PreparedStatement stmt = conn.prepareStatement(sql);
                                        stmt.setInt(1, driverId);
                                        ResultSet rs = stmt.executeQuery();

                                        while (rs.next()) {
                            %>
                            <tr>
                                <td><%= rs.getInt("booking_id") %></td>
                                <td><%= rs.getInt("customer_id") %></td>
                                <td><%= rs.getString("pickup_location") %></td>
                                <td><%= rs.getString("destination") %></td>
                                <td>$<%= rs.getDouble("fare") %></td>
                                <td><%= rs.getString("status") %></td>
                                <td>
                                    <form action="../UpdateRideStatusServlet" method="post" class="d-flex">
                                        <input type="hidden" name="booking_id" value="<%= rs.getInt("booking_id") %>">
                                        <select name="status" class="form-select me-2">
                                            <option value="accepted">Accepted</option>
                                            <option value="completed">Completed</option>
                                            <option value="cancelled">Cancelled</option>
                                        </select>
                                        <button type="submit" class="btn btn-success">Update</button>
                                    </form>
                                </td>
                            </tr>
                            <%
                                        }
                                    } catch (Exception e) {
                                        e.printStackTrace();
                                    }
                                } else {
                                    response.sendRedirect("login.jsp");
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Optional Bootstrap JS (if not already included in header.jsp) -->
    <!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> -->
</body>
</html>
