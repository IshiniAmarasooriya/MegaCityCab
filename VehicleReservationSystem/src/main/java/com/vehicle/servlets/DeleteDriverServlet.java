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

@WebServlet("/DeleteDriverServlet")
public class DeleteDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Retrieve the driver ID from the form submission
        int driverId = Integer.parseInt(request.getParameter("driver_id"));
        
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Delete only if the role is 'driver'
            String sql = "DELETE FROM users WHERE id=? AND role='driver'";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, driverId);
            
            int rowsDeleted = stmt.executeUpdate();
            if (rowsDeleted > 0) {
                response.sendRedirect("jsp/manageDrivers.jsp?message=Driver deleted successfully");
            } else {
                response.sendRedirect("jsp/manageDrivers.jsp?error=Failed to delete driver");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/manageDrivers.jsp?error=Server error");
        }
    }
}
