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

@WebServlet("/auth/employee-login")
public class EmployeeLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (username == null || password == null || role == null ||
            username.isEmpty() || password.isEmpty()) {
            response.sendRedirect("employeeLogin.jsp?error=Missing+credentials");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {

            PreparedStatement ps;
            ResultSet rs;

            if ("rep".equals(role)) {
                ps = conn.prepareStatement(
                    "SELECT ssn, first_name FROM CustomerRep WHERE username=? AND password=?"
                );
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userSSN", rs.getString("ssn"));
                    session.setAttribute("userName", rs.getString("first_name"));
                    session.setAttribute("role", "rep");

                    response.sendRedirect(
                        request.getContextPath() + "/employee/repDashboard.jsp"
                    );
                    return;
                }

            } else if ("admin".equals(role)) {
                ps = conn.prepareStatement(
                    "SELECT ssn, first_name FROM Manager WHERE username=? AND password=?"
                );
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userSSN", rs.getString("ssn"));
                    session.setAttribute("userName", rs.getString("first_name"));
                    session.setAttribute("role", "admin");

                    response.sendRedirect(
                        request.getContextPath() + "/admin/adminDashboard.jsp"
                    );
                    return;
                }
            }

            response.sendRedirect(
                "employeeLogin.jsp?error=Invalid+username+password+or+role"
            );

        } catch (SQLException e) {
            response.sendRedirect("employeeLogin.jsp?error=Database+error");
        }
    }
}
