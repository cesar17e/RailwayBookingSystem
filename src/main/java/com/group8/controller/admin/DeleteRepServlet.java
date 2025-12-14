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

@WebServlet("/admin/delete-rep")
public class DeleteRepServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (role == null || !"admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
            return;
        }

        String ssn = request.getParameter("ssn");
        if (ssn == null || ssn.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp?error=Missing+SSN");
            return;
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM CustomerRep WHERE ssn = ?")) {

            ps.setString(1, ssn);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp?success=Rep+deleted");

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp?error=Database+error");
        }
    }
}
