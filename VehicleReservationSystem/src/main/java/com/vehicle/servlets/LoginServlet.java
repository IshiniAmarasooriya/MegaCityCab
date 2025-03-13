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
import javax.servlet.http.HttpSession;
import com.vehicle.utils.DBConnection;
import java.util.regex.Pattern;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Email validation regex pattern
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validation: Check if email and password are provided
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password cannot be empty.");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }

        // Validation: Check email format
        if (!Pattern.matches(EMAIL_REGEX, email)) {
            request.setAttribute("error", "Invalid email format.");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getInstance().getConnection()) {
            String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, password); // In production, store and compare hashed passwords

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("role", rs.getString("role"));

                // Redirect based on user role
                String role = rs.getString("role");
                if ("admin".equals(role)) {
                    response.sendRedirect("jsp/admin_dashboard.jsp");
                } else if ("driver".equals(role)) {
                    response.sendRedirect("jsp/driver_dashboard.jsp");
                } else {
                    response.sendRedirect("jsp/customer_dashboard.jsp");
                }
            } else {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error. Please try again later.");
            request.getRequestDispatcher("jsp/login.jsp").forward(request, response);
        }
    }
}
