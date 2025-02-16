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
    <!--<link rel="stylesheet" type="text/css" href="../css/style.css"> -->
</head>
<body>
    <h2>Admin Dashboard</h2>
    
    <h3>All Bookings (Assign Drivers)</h3>
    <table border="1">
        <tr>
            <th>Booking ID</th>
            <th>Customer ID</th>
            <th>Pickup</th>
            <th>Destination</th>
            <th>Fare</th>
            <th>Status</th>
            <th>Assign Driver</th>
        </tr>
        <%
            try (Connection conn = com.vehicle.utils.DBConnection.getConnection()) {
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
                            <form action="../AssignDriverServlet" method="post">
                                <input type="hidden" name="booking_id" value="<%= bookingId %>">
                                <select name="driver_id">
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
                                <input type="submit" value="Assign">
                            </form>
                        </td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </table>
</body>
</html>
