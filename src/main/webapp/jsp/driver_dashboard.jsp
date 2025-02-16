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
    <!-- <link rel="stylesheet" type="text/css" href="../css/style.css">-->
</head>
<body>
    <h2>Driver Dashboard</h2>

    <h3>Your Assigned Rides</h3>
    <table border="1">
        <tr>
            <th>Booking ID</th>
            <th>Customer ID</th>
            <th>Pickup</th>
            <th>Destination</th>
            <th>Fare</th>
            <th>Status</th>
            <th>Update Status</th>
        </tr>
        <%
            Integer driverId = (Integer) sessionOb.getAttribute("userId");

            if (driverId != null) {
                try (Connection conn = com.vehicle.utils.DBConnection.getConnection()) {
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
                                <form action="../UpdateRideStatusServlet" method="post">
                                    <input type="hidden" name="booking_id" value="<%= rs.getInt("booking_id") %>">
                                    <select name="status">
                                        <option value="accepted">Accepted</option>
                                        <option value="completed">Completed</option>
                                        <option value="cancelled">Cancelled</option>
                                    </select>
                                    <input type="submit" value="Update">
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
    </table>
</body>
</html>
