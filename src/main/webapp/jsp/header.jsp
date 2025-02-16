<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    HttpSession sessionObj = request.getSession(false);
    String role = (sessionObj != null) ? (String) sessionObj.getAttribute("role") : null;
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <a class="navbar-brand" href="#">Vehicle Reservation</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <% if ("customer".equals(role)) { %>
                    <li class="nav-item"><a class="nav-link" href="customer_dashboard.jsp">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="bookRide.jsp">Book a Ride</a></li>
                <% } else if ("admin".equals(role)) { %>
                    <li class="nav-item"><a class="nav-link" href="admin_dashboard.jsp">Admin Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="manageDrivers.jsp">Manage Drivers</a></li>
                    <li class="nav-item"><a class="nav-link" href="manageVehicles.jsp">Manage Vehicles</a></li>
                <% } else if ("driver".equals(role)) { %>
                    <li class="nav-item"><a class="nav-link" href="driver_dashboard.jsp">Driver Dashboard</a></li>
                <% } %>
                <% if (sessionObj != null && role != null) { %>
                    <li class="nav-item"><a class="nav-link" href="../LogoutServlet">Logout</a></li>
                <% } else { %>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">Login</a></li>
                <% } %>
            </ul>
        </div>
    </div>
</nav>

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
