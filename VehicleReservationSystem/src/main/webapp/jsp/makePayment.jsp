<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Make Payment</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <!-- Optional external styles -->
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 500px;">
            <div class="card-body">
                <h2 class="card-title text-center mb-4">Make Payment</h2>
                <%
                    HttpSession sessionObj = request.getSession();
                    Integer customerId = (Integer) sessionObj.getAttribute("userId");
                    String bookingId = request.getParameter("booking_id");

                    if (customerId == null) {
                        response.sendRedirect("login.jsp");
                        return;
                    }

                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = com.vehicle.utils.DBConnection.getInstance().getConnection();
                        String sql = "SELECT * FROM bookings WHERE booking_id=? AND customer_id=? AND status='completed'";
                        stmt = conn.prepareStatement(sql);
                        stmt.setString(1, bookingId);
                        stmt.setInt(2, customerId);
                        rs = stmt.executeQuery();

                        if (rs.next()) {
                %>
                <form action="../MakePaymentServlet" method="post">
                    <input type="hidden" name="booking_id" value="<%= bookingId %>">
                    <div class="mb-3">
                        <label class="form-label">Amount to Pay:</label>
                        <p class="form-control-plaintext">$<%= rs.getDouble("fare") %></p>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Payment Method:</label>
                        <select name="payment_method" class="form-select" required>
                            <option value="cash">Cash</option>
                            <option value="credit_card">Credit Card</option>
                            <option value="online">Online</option>
                        </select>
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Pay Now</button>
                    </div>
                </form>
                <%
                        } else {
                            out.println("<p class='text-center text-danger'>No completed bookings available for payment.</p>");
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
