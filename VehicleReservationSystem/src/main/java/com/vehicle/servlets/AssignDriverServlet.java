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

@WebServlet("/AssignDriverServlet")
public class AssignDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        int driverId = Integer.parseInt(request.getParameter("driver_id"));

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            String sql = "UPDATE bookings SET driver_id=?, status='confirmed' WHERE booking_id=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            stmt.setInt(2, bookingId);

            int rowsUpdated = stmt.executeUpdate();
            if (rowsUpdated > 0) {
                response.sendRedirect("jsp/admin_dashboard.jsp?message=Driver Assigned Successfully");
            } else {
                response.sendRedirect("jsp/admin_dashboard.jsp?error=Assignment Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/admin_dashboard.jsp?error=Server Error");
        }
    }
}
