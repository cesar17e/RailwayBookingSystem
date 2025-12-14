<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%
    String idStr = request.getParameter("schedule_id");
    String departureStr = request.getParameter("departure_datetime");
    String arrivalStr = request.getParameter("arrival_datetime");

    if (idStr == null || departureStr == null || arrivalStr == null ||
        idStr.isEmpty() || departureStr.isEmpty() || arrivalStr.isEmpty()) {
%>
    <p>Missing required fields.</p>
    <a href="manageSchedules.jsp">Back</a>
<%
        return;
    }

    try {
        int scheduleId = Integer.parseInt(idStr);

        try (
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE TrainSchedule SET departure_datetime = ?, arrival_datetime = ? WHERE schedule_id = ?")
        ) {
            ps.setString(1, departureStr.replace("T", " ") + ":00");
            ps.setString(2, arrivalStr.replace("T", " ") + ":00");
            ps.setInt(3, scheduleId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
%>
            <p>Schedule updated.</p>
            <a href="manageSchedules.jsp">Back</a>
<%
            } else {
%>
            <p>Failed to update schedule.</p>
            <a href="editSchedule.jsp?id=<%= scheduleId %>">Try Again</a>
<%
            }
        }
    } catch (Exception e) {
%>
    <p>Error: <%= e.getMessage() %></p>
    <a href="manageSchedules.jsp">Back</a>
<%
    }
%>
