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
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/admin/edit-rep")
public class EditRepServlet extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp");
            return;
        }

        String sql =
            "SELECT first_name, last_name, username, password " +
            "FROM CustomerRep WHERE ssn=?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ssn);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("ssn", ssn);
                request.setAttribute("firstName", rs.getString("first_name"));
                request.setAttribute("lastName", rs.getString("last_name"));
                request.setAttribute("username", rs.getString("username"));
                request.setAttribute("password", rs.getString("password"));

                request.getRequestDispatcher("/admin/editRep.jsp")
                       .forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp");
            }

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp?error=Database+error");
        }
    }

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

        String sql =
            "UPDATE CustomerRep " +
            "SET first_name=?, last_name=?, username=?, password=? " +
            "WHERE ssn=?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, first);
            ps.setString(2, last);
            ps.setString(3, user);
            ps.setString(4, pass);
            ps.setString(5, ssn);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp?success=Rep+updated");

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/manageReps.jsp?error=Update+failed");
        }
    }
}
