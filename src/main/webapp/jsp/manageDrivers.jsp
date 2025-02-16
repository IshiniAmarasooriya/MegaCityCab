<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ include file="header.jsp" %> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers</title>
   <!--  <link rel="stylesheet" type="text/css" href="../css/style.css">  -->
</head>
<body>
    <h2>Manage Drivers</h2>

    <h3>Driver List</h3>
    <table border="1">
        <tr>
            <th>Driver ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Action</th>
        </tr>
        <%
            try (Connection conn = com.vehicle.utils.DBConnection.getConnection()) {
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
                            <form action="../DeleteDriverServlet" method="post">
                                <input type="hidden" name="driver_id" value="<%= rs.getInt("id") %>">
                                <input type="submit" value="Delete">
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

    <h3>Add New Driver</h3>
    <form action="../AddDriverServlet" method="post">
        <label>Name:</label>
        <input type="text" name="name" required>
        <br>
        <label>Email:</label>
        <input type="email" name="email" required>
        <br>
        <label>Password:</label>
        <input type="password" name="password" required>
        <br>
        <input type="submit" value="Add Driver">
    </form>
</body>
</html>
