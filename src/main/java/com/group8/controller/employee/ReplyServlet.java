@WebServlet("/employee/reply")
public class ReplyServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");
        String repSSN = (String) session.getAttribute("userSSN");

        if (!"rep".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
            return;
        }

        int msgId = Integer.parseInt(request.getParameter("id"));
        String reply = request.getParameter("reply_text");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "UPDATE Message SET reply_text=?, customer_rep_ssn=? WHERE message_id=?")) {

            ps.setString(1, reply);
            ps.setString(2, repSSN);
            ps.setInt(3, msgId);
            ps.executeUpdate();

        } catch (SQLException ignored) {}

        response.sendRedirect(request.getContextPath() + "/employee/repMessages.jsp");
    }
}
