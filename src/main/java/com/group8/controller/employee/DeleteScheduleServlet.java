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
 * Servlet: DeleteScheduleServlet
 * URL: /employee/delete-schedule
 *
 * Purpose:
 *  - Deletes a schedule record from the TrainSchedule table.
 *  - Ensures that only reps can delete schedules.
 *  - Uses a simple GET request triggered by a "Delete" link.
 *
 * Notes:
 *  - The JSP uses a JavaScript confirm(), but deletion still occurs here.
 *  - If the schedule does not exist, nothing breaks — deletion simply returns 0 rows.
 *  - Redirects to manageSchedules.jsp upon completion.
 */

@WebServlet("/employee/delete-schedule")
public class DeleteScheduleServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (!"rep".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
            return;
        }

        String id = request.getParameter("id");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps =
                 conn.prepareStatement("DELETE FROM TrainSchedule WHERE schedule_id=?")) {

            ps.setInt(1, Integer.parseInt(id));
            ps.executeUpdate();

        } catch (SQLException ignored) {}

        response.sendRedirect(request.getContextPath() + "/employee/manageSchedules.jsp");
    }
}
