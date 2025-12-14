<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String role = (String) session.getAttribute("role");
    if (!"rep".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
        return;
    }

    String scheduleIdStr = request.getParameter("id");
    if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
        out.println("<p>No schedule ID provided.</p>");
        return;
    }

    int scheduleId = Integer.parseInt(scheduleIdStr);

    String departure = "";
    String arrival = "";
    String lineName = "";

    String sql =
        "SELECT s.departure_datetime, s.arrival_datetime, tl.transit_line_name " +
        "FROM TrainSchedule s " +
        "JOIN Train t ON s.train_id = t.train_id " +
        "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id " +
        "WHERE s.schedule_id = ?";

    try (Connection con = DBUtil.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, scheduleId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
                out.println("<p>Schedule not found.</p>");
                return;
            }
            departure = rs.getString("departure_datetime").replace(" ", "T");
            arrival   = rs.getString("arrival_datetime").replace(" ", "T");
            lineName  = rs.getString("transit_line_name");
        }
    }
%>

<h2>Edit Train Schedule</h2>

<p><strong>Transit Line:</strong> <%= lineName %></p>

<form method="post"
      action="<%= request.getContextPath() %>/employee/edit-schedule">

    <input type="hidden" name="schedule_id" value="<%= scheduleId %>" />

    <label>Departure:</label><br>
    <input type="datetime-local" name="departure_datetime"
           value="<%= departure %>" required><br><br>

    <label>Arrival:</label><br>
    <input type="datetime-local" name="arrival_datetime"
           value="<%= arrival %>" required><br><br>

    <button type="submit">Update Schedule</button>
    <a href="manageSchedules.jsp">Cancel</a>
</form>
