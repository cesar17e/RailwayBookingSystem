package com.group8.controller.auth;

import com.group8.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/auth/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null ||
            username.isEmpty() || password.isEmpty()) {
            response.sendRedirect("login.jsp?error=Missing+credentials");
            return;
        }

        String sql =
            "SELECT customer_id, first_name, date_of_birth " +
            "FROM Customer WHERE username=? AND password=?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userId", rs.getInt("customer_id"));
                    session.setAttribute("userName", rs.getString("first_name"));
                    session.setAttribute("userDOB", rs.getDate("date_of_birth"));

                    response.sendRedirect(
                        request.getContextPath() + "/customer/customerDashboard.jsp"
                    );
                    return;
                }
            }

            response.sendRedirect("login.jsp?error=Invalid+username+or+password");

        } catch (SQLException e) {
            response.sendRedirect("login.jsp?error=Database+error");
        }
    }
}
