<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Optional external styles -->
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 600px;">
            <div class="card-body">
                <h2 class="card-title text-center mb-4">Payment Invoice</h2>
                <%
                    String bookingId = request.getParameter("booking_id");
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = com.vehicle.utils.DBConnection.getInstance().getConnection();
                        String sql = "SELECT b.*, p.payment_method, p.amount FROM bookings b " +
                                     "JOIN payments p ON b.booking_id = p.booking_id WHERE b.booking_id=?";
                        stmt = conn.prepareStatement(sql);
                        stmt.setString(1, bookingId);
                        rs = stmt.executeQuery();

                        if (rs.next()) {
                %>
                <div class="mb-3">
                    <p class="mb-1"><strong>Booking ID:</strong> <%= rs.getInt("booking_id") %></p>
                    <p class="mb-1"><strong>Customer ID:</strong> <%= rs.getInt("customer_id") %></p>
                    <p class="mb-1"><strong>Pickup Location:</strong> <%= rs.getString("pickup_location") %></p>
                    <p class="mb-1"><strong>Destination:</strong> <%= rs.getString("destination") %></p>
                    <p class="mb-1"><strong>Fare:</strong> $<%= rs.getDouble("fare") %></p>
                    <p class="mb-1"><strong>Payment Method:</strong> <%= rs.getString("payment_method") %></p>
                    <p class="mb-1"><strong>Status:</strong> Paid</p>
                </div>
                <div class="d-grid gap-2">
                    <button onclick="window.print()" class="btn btn-secondary">Print Invoice</button>
                </div>
                <%
                        } else {
                            out.println("<p class='text-center text-danger'>No invoice found.</p>");
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </div>
        <div class="text-center mt-3">
            <a href="customer_dashboard.jsp" class="btn btn-link">Back to Dashboard</a>
        </div>
    </div>
    <!-- Bootstrap JS (optional) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
