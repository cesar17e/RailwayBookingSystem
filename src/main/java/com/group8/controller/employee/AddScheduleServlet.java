package com.group8.controller.employee;

import com.group8.util.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;


/**
 * Servlet: AddScheduleServlet
 * URL: /employee/add-schedule
 *
 * Purpose:
 *  - Allows a customer representative (role = "rep") to create a new
 *    train schedule entry.
 *  - Takes: train_id, departure_datetime, arrival_datetime.
 *  - Inserts a new row into TrainSchedule.
 *
 * Notes:
 *  - Only reps are allowed (session role check).
 *  - Datetime-local input from JSP comes in "yyyy-MM-ddTHH:mm", so
 *    the servlet converts "T" → " " for SQL compatibility.
 *  - On success, redirects to manageSchedules.jsp.
 */


@WebServlet("/employee/add-schedule")
public class AddScheduleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (!"rep".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
            return;
        }

        String trainId = request.getParameter("train_id");
        String departure = request.getParameter("departure_datetime");
        String arrival = request.getParameter("arrival_datetime");

        if (trainId == null || departure == null || arrival == null ||
            trainId.isEmpty() || departure.isEmpty() || arrival.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/employee/addSchedule.jsp?error=Missing+fields");
            return;
        }

        String sql =
            "INSERT INTO TrainSchedule (departure_datetime, arrival_datetime, train_id) " +
            "VALUES (?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, departure.replace("T", " ") + ":00");
            ps.setString(2, arrival.replace("T", " ") + ":00");
            ps.setInt(3, Integer.parseInt(trainId));
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/employee/manageSchedules.jsp");

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/employee/addSchedule.jsp?error=Database+error");
        }
    }
}
