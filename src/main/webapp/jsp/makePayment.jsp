<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Make Payment</title>
    <link rel="stylesheet" type="text/css" href="../css/style.css">
</head>
<body>
    <h2>Make Payment</h2>

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
            conn = com.vehicle.utils.DBConnection.getConnection();
            String sql = "SELECT * FROM bookings WHERE booking_id=? AND customer_id=? AND status='completed'";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, bookingId);
            stmt.setInt(2, customerId);
            rs = stmt.executeQuery();

            if (rs.next()) {
    %>
                <form action="../MakePaymentServlet" method="post">
                    <input type="hidden" name="booking_id" value="<%= bookingId %>">
                    <label>Amount to Pay: $<%= rs.getDouble("fare") %></label>
                    <br>
                    <label>Payment Method:</label>
                    <select name="payment_method" required>
                        <option value="cash">Cash</option>
                        <option value="credit_card">Credit Card</option>
                        <option value="online">Online</option>
                    </select>
                    <br>
                    <input type="submit" value="Pay Now">
                </form>
    <%
            } else {
                out.println("<p>No completed bookings available for payment.</p>");
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
