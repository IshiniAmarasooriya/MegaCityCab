package com.vehicle.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.vehicle.utils.DBConnection;

@WebServlet("/MakePaymentServlet")
public class MakePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        String paymentMethod = request.getParameter("payment_method");

        try (Connection conn = DBConnection.getConnection()) {
            // Insert payment record
            String sql = "INSERT INTO payments (booking_id, amount, payment_method) " +
                         "SELECT booking_id, fare, ? FROM bookings WHERE booking_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, paymentMethod);
            stmt.setInt(2, bookingId);

            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                // Update booking status to 'paid'
                String updateSql = "UPDATE bookings SET status='paid' WHERE booking_id=?";
                PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, bookingId);
                updateStmt.executeUpdate();

                // Redirect to Invoice Page
                response.sendRedirect("jsp/invoice.jsp?booking_id=" + bookingId);
            } else {
                response.sendRedirect("jsp/makePayment.jsp?error=Payment failed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/makePayment.jsp?error=Server error.");
        }
    }
}
