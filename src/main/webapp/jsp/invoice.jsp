<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <h2>Payment Invoice</h2>

    <%
        String bookingId = request.getParameter("booking_id");
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = com.vehicle.utils.DBConnection.getConnection();
            String sql = "SELECT b.*, p.payment_method, p.amount FROM bookings b " +
                         "JOIN payments p ON b.booking_id = p.booking_id WHERE b.booking_id=?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookingId);
            rs = stmt.executeQuery();

            if (rs.next()) {
    %>
                <p><strong>Booking ID:</strong> <%= rs.getInt("booking_id") %></p>
                <p><strong>Customer ID:</strong> <%= rs.getInt("customer_id") %></p>
                <p><strong>Pickup Location:</strong> <%= rs.getString("pickup_location") %></p>
                <p><strong>Destination:</strong> <%= rs.getString("destination") %></p>
                <p><strong>Fare:</strong> $<%= rs.getDouble("fare") %></p>
                <p><strong>Payment Method:</strong> <%= rs.getString("payment_method") %></p>
                <p><strong>Status:</strong> Paid</p>

                <button onclick="window.print()">Print Invoice</button>
    <%
            } else {
                out.println("<p>No invoice found.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    %>

    <p><a href="customer_dashboard.jsp">Back to Dashboard</a></p>
</body>
</html>
