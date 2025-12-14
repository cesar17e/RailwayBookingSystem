package com.group8.controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Servlet: LogoutServlet
 * URL: /auth/logout
 *
 * Purpose:
 *  - Ends the current session for any user type (customer, rep, admin).
 *  - Redirects to login.jsp after logout.
 *
 * Notes:
 *  - Works universally because customers and employees both use sessions.
 *  - Session invalidation ensures proper access protection after logout.
 */

@WebServlet("/auth/logout")
public class LogoutServlet extends HttpServlet {
    // Invalidate the current session
    // Redirect to main login page

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        response.sendRedirect(
            request.getContextPath() + "/auth/login.jsp"
        );
    }
}
