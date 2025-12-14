package com.group8.controller.customer;

import com.group8.util.DBUtil;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.ServletException;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/customer/ask-question")
public class AskQuestionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session == null) ? null : (Integer) session.getAttribute("userId");

        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        String content = request.getParameter("content");
        if (content == null || content.trim().isEmpty()) {
            response.sendRedirect(
                request.getContextPath() + "/customer/askQuestion.jsp?error=Empty+question"
            );
            return;
        }

        String sql = "INSERT INTO Message (content, customer_id) VALUES (?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, content.trim());
            ps.setInt(2, customerId);
            ps.executeUpdate();

            response.sendRedirect(request.getContextPath() + "/customer/customerDashboard.jsp");

        } catch (SQLException e) {
            response.sendRedirect(
                request.getContextPath() + "/customer/askQuestion.jsp?error=Database+error"
            );
        }
    }
}
