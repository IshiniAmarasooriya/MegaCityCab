package com.vehicle.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.vehicle.utils.DBConnection;
import java.util.regex.Pattern;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Regular expression for email validation
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Validation: Ensure all fields are filled
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }

        // Validation: Check email format
        if (!Pattern.matches(EMAIL_REGEX, email)) {
            request.setAttribute("error", "Invalid email format.");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }

        // Validation: Check password length (minimum 6 characters)
        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            // Check if email is already registered
            String checkEmailQuery = "SELECT * FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailQuery)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next()) {
                    request.setAttribute("error", "Email is already registered.");
                    request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
                    return;
                }
            }

            // Insert new user with plain text password (not recommended for production)
            String insertQuery = "INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(insertQuery)) {
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, password); // **Plain text password**
                stmt.setString(4, role);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    // Use sendRedirect to prevent form resubmission issues
                    response.sendRedirect("jsp/login.jsp?message=Registration successful! Please log in.");
                } else {
                    request.setAttribute("error", "Registration failed. Try again.");
                    request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error. Please try again.");
            request.getRequestDispatcher("jsp/register.jsp").forward(request, response);
        }
    }
}
