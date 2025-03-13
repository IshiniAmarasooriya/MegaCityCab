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

@WebServlet("/AddDriverServlet")
public class AddDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Retrieve form parameters for the new driver
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Insert a new user with role 'driver'
            String sql = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, 'driver')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, password);  // Storing plain text (not recommended in production)
            
            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.sendRedirect("jsp/manageDrivers.jsp?message=Driver added successfully");
            } else {
                response.sendRedirect("jsp/manageDrivers.jsp?error=Failed to add driver");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("jsp/manageDrivers.jsp?error=Server error");
        }
    }
}
