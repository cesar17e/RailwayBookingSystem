@WebServlet("/employee/edit-schedule")
public class EditScheduleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        String role = (session == null) ? null : (String) session.getAttribute("role");

        if (!"rep".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
            return;
        }

        String id = request.getParameter("schedule_id");
        String dep = request.getParameter("departure_datetime");
        String arr = request.getParameter("arrival_datetime");

        String sql =
            "UPDATE TrainSchedule SET departure_datetime=?, arrival_datetime=? WHERE schedule_id=?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dep.replace("T", " ") + ":00");
            ps.setString(2, arr.replace("T", " ") + ":00");
            ps.setInt(3, Integer.parseInt(id));
            ps.executeUpdate();

        } catch (SQLException ignored) {}

        response.sendRedirect(request.getContextPath() + "/employee/manageSchedules.jsp");
    }
}
