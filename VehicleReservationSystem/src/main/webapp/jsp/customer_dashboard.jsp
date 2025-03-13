<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    HttpSession sessionOb = request.getSession(false);
    if (sessionOb == null || sessionOb.getAttribute("role") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%><!-- This includes the navigation bar -->

<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ include file="header.jsp" %> 

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <!--  <link rel="stylesheet" type="text/css" href="../css/style.css"> -->
</head>
<body>
    <div class="container mt-5">
        <h2 class="text-center">Welcome, Customer</h2>
        <a href="bookRide.jsp" class="btn btn-success mb-3">Book a New Ride</a>

        <h3>Your Bookings</h3>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Booking ID</th>
                    <th>Pickup</th>
                    <th>Destination</th>
                    <th>Fare</th>
                    <th>Status</th>
                    <th>Action</th>
                    <th>Vehicle</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Integer customerId = (Integer) sessionOb.getAttribute("userId");

                    if (customerId != null) {
                        try (Connection conn = com.vehicle.utils.DBConnection.getInstance().getConnection()) {
                            String sql = "SELECT * FROM bookings WHERE customer_id=?";
                            PreparedStatement stmt = conn.prepareStatement(sql);
                            stmt.setInt(1, customerId);
                            ResultSet rs = stmt.executeQuery();

                            while (rs.next()) {
                                int bookingId = rs.getInt("booking_id");
                                String status = rs.getString("status");
                %>
                                <tr>
                                    <td><%= bookingId %></td>
                                    <td><%= rs.getString("pickup_location") %></td>
                                    <td><%= rs.getString("destination") %></td>
                                    <td>$<%= rs.getDouble("fare") %></td>
                                    <td><%= status %></td>
                                    <td>
                                        <% if ("completed".equals(status)) { %>
                                            <a href="makePayment.jsp?booking_id=<%= bookingId %>" class="btn btn-warning">Make Payment</a>
                                        <% } else if ("paid".equals(status)) { %>
                                            <a href="invoice.jsp?booking_id=<%= bookingId %>" class="btn btn-success">View Invoice</a>
                                        <% } else { %>
                                            <span>-</span>
                                        <% } %>
                                    </td>
                                    <td>
									     <%
									         int vehicleId = rs.getInt("vehicle_id");
									         try (Connection conn2 = com.vehicle.utils.DBConnection.getInstance().getConnection()) {
									             String vehicleQuery = "SELECT model FROM vehicles WHERE vehicle_id=?";
									             PreparedStatement vehicleStmt = conn2.prepareStatement(vehicleQuery);
									             vehicleStmt.setInt(1, vehicleId);
									             ResultSet vehicleRs = vehicleStmt.executeQuery();
									             if (vehicleRs.next()) {
									                 out.print(vehicleRs.getString("model"));
									             }
									         }
									     %>
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
</body>
</html>
