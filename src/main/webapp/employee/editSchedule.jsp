<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%
    String scheduleIdStr = request.getParameter("id");
    if (scheduleIdStr == null || scheduleIdStr.isEmpty()) {
%>
    <p>No schedule ID provided.</p>
    <a href="manageSchedules.jsp">Back</a>
<%
        return;
    }

    int scheduleId = Integer.parseInt(scheduleIdStr);

    try (
        Connection con = DBUtil.getConnection();
        PreparedStatement ps = con.prepareStatement(
            "SELECT s.departure_datetime, s.arrival_datetime, s.train_id, tl.transit_line_name " +
            "FROM TrainSchedule s " +
            "JOIN Train t ON s.train_id = t.train_id " +
            "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id " +
            "WHERE s.schedule_id = ?")
    ) {
        ps.setInt(1, scheduleId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) {
%>
    <p>Schedule not found.</p>
    <a href="manageSchedules.jsp">Back</a>
<%
                return;
            }

            String departure = rs.getString("departure_datetime").replace(" ", "T");
            String arrival = rs.getString("arrival_datetime").replace(" ", "T");
            int trainId = rs.getInt("train_id");
%>

<h2>Edit Train Schedule</h2>

<form action="editScheduleAction.jsp" method="post">
    <input type="hidden" name="schedule_id" value="<%= scheduleId %>" />

    <p>Train ID: <%= trainId %> (Line: <%= rs.getString("transit_line_name") %>)</p>

    <label for="departure_datetime">Departure Date & Time:</label>
    <input type="datetime-local" name="departure_datetime" value="<%= departure %>" required />
    <br><br>

    <label for="arrival_datetime">Arrival Date & Time:</label>
    <input type="datetime-local" name="arrival_datetime" value="<%= arrival %>" required />
    <br><br>

    <input type="submit" value="Update Schedule" />
    <a href="manageSchedules.jsp">Cancel</a>
</form>

<%
        }
    } catch (SQLException e) {
%>
    <p>Error: <%= e.getMessage() %></p>
    <a href="manageSchedules.jsp">Back</a>
<%
    }
%>
