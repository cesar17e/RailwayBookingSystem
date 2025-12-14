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
