package com.group8.controller.customer;

import com.group8.util.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet: ReserveServlet
 * URL: /customer/reserve
 *
 * Purpose:
 *  - Processes a customer's booking after they confirm trip details.
 *  - Reads schedule_id, fare, passenger type, and trip type from the form.
 *  - Computes the final fare (round-trip costs ×2).
 *  - Inserts a new row into Reservation with status='active'.
 *  - Redirects to My Reservations after successful booking.
 *
 * Notes:
 *  - Customer must be logged in (uses session userId).
 *  - Assumes input was validated on reserve.jsp.
 *  - Does not handle seat availability (not required for project).
 */

@WebServlet("/customer/reserve")
public class ReserveServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        int scheduleId = Integer.parseInt(request.getParameter("schedule_id"));
        float baseFare = Float.parseFloat(request.getParameter("base_fare"));
        int originId   = Integer.parseInt(request.getParameter("origin_id"));
        int destId     = Integer.parseInt(request.getParameter("dest_id"));
        String tripType = request.getParameter("tripType");
        String passengerType = request.getParameter("passengerType");

        float fare = "round-trip".equals(tripType) ? baseFare * 2 : baseFare;

        String sql =
            "INSERT INTO Reservation " +
            "(reservation_date, reservation_type, status, total_fare, " +
            " passenger_type, origin_station_id, dest_station_id, schedule_id, customer_id) " +
            "VALUES (CURRENT_DATE, ?, 'active', ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, tripType);
            ps.setFloat(2, fare);
            ps.setString(3, passengerType);
            ps.setInt(4, originId);
            ps.setInt(5, destId);
            ps.setInt(6, scheduleId);
            ps.setInt(7, customerId);

            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/customer/myReservations.jsp");

        } catch (SQLException e) {
            response.sendRedirect(request.getContextPath() + "/customer/search.jsp?error=Booking+failed");
        }
    }
}
