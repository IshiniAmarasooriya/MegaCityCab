package com.vehicle.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.vehicle.utils.DBConnection;

@WebServlet("/BookRideServlet")
public class BookRideServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer customerId = (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.sendRedirect("jsp/login.jsp");
            return;
        }

        String pickupLocation = request.getParameter("pickup_location");
        String destination = request.getParameter("destination");
        int vehicleId = Integer.parseInt(request.getParameter("vehicle_id"));
        double fare = Double.parseDouble(request.getParameter("fare"));

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            String sql = "INSERT INTO bookings (customer_id, vehicle_id, pickup_location, destination, fare, status) VALUES (?, ?, ?, ?, ?, 'pending')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, customerId);
            stmt.setInt(2, vehicleId);
            stmt.setString(3, pickupLocation);
            stmt.setString(4, destination);
            stmt.setDouble(5, fare);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("jsp/customer_dashboard.jsp?message=Ride booked successfully!");
            } else {
                response.sendRedirect("jsp/bookRide.jsp?error=Booking failed.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/bookRide.jsp?error=Server error.");
        }
    }
}
