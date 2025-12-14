package com.group8.controller.admin;

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
import java.sql.SQLException;

@WebServlet("/admin/add-rep")
public class AddRepServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
            return;
        }

        String ssn = request.getParameter("ssn");
        String first = request.getParameter("first_name");
        String last = request.getParameter("last_name");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String actionType = request.getParameter("action_type");
        String managerSSN = (String) session.getAttribute("userSSN");

        if (ssn == null || first == null || last == null ||
            user == null || pass == null || actionType == null ||
            ssn.isEmpty() || first.isEmpty() || last.isEmpty() ||
            user.isEmpty() || pass.isEmpty()) {

            response.sendRedirect(
                request.getContextPath() + "/admin/manageReps.jsp?error=Missing+fields"
            );
            return;
        }

        String sql =
            "INSERT INTO CustomerRep " +
            "(ssn, first_name, last_name, username, password, action_type, manager_ssn) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ssn);
            ps.setString(2, first);
            ps.setString(3, last);
            ps.setString(4, user);
            ps.setString(5, pass);
            ps.setString(6, actionType);
            ps.setString(7, managerSSN);

            ps.executeUpdate();

            response.sendRedirect(
                request.getContextPath() + "/admin/manageReps.jsp?success=Rep+added"
            );

        } catch (SQLException e) {
            response.sendRedirect(
                request.getContextPath() + "/admin/manageReps.jsp?error=Database+error"
            );
        }
    }
}
