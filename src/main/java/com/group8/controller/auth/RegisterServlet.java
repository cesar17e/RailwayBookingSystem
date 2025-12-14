package com.group8.controller.auth;

import com.group8.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/auth/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("first_name");
        String lastName  = request.getParameter("last_name");
        String email     = request.getParameter("email");
        String username  = request.getParameter("username");
        String password  = request.getParameter("password");
        String dob       = request.getParameter("date_of_birth");

        // Basic validation
        if (firstName == null || lastName == null || email == null ||
            username == null || password == null || dob == null ||
            firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() ||
            username.isEmpty() || password.isEmpty() || dob.isEmpty()) {

            response.sendRedirect("register.jsp?error=Missing+fields");
            return;
        }

        String sql =
            "INSERT INTO Customer " +
            "(first_name, last_name, email, username, password, date_of_birth) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, username);
            ps.setString(5, password);
            ps.setDate(6, java.sql.Date.valueOf(dob));

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.sendRedirect(
                    request.getContextPath() + "/auth/login.jsp?success=Account+created"
                );
            } else {
                response.sendRedirect("register.jsp?error=Registration+failed");
            }

        } catch (SQLException e) {
            response.sendRedirect("register.jsp?error=Database+error");
        }
    }
}
