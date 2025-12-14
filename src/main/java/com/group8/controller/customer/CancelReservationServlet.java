package com.group8.controller.customer;

import com.group8.util.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/customer/cancel-reservation")
public class CancelReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String resIdParam = request.getParameter("id");
        if (resIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/customer/myReservations.jsp");
            return;
        }

        String sql =
            "UPDATE Reservation SET status='cancelled' " +
            "WHERE reservation_id=? AND customer_id=?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, Integer.parseInt(resIdParam));
            ps.setInt(2, customerId);
            ps.executeUpdate();

        } catch (SQLException e) {
            // optional logging
        }

        response.sendRedirect(request.getContextPath() + "/customer/myReservations.jsp");
    }
}
