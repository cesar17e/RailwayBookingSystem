<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%
    String idStr = request.getParameter("id");

    if (idStr == null || idStr.isEmpty()) {
%>
    <p>No schedule ID provided.</p>
    <a href="manageSchedules.jsp">Back</a>
<%
        return;
    }

    int scheduleId = Integer.parseInt(idStr);

    // If user clicked "Confirm", perform deletion
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try (
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM TrainSchedule WHERE schedule_id = ?")
        ) {
            ps.setInt(1, scheduleId);
            int rows = ps.executeUpdate();

            if (rows > 0) {
%>
                <p>Schedule deleted successfully.</p>
                <a href="manageSchedules.jsp">Back to Schedule Management</a>
<%
            } else {
%>
                <p>Could not delete schedule. It may not exist.</p>
                <a href="manageSchedules.jsp">Back</a>
<%
            }
        } catch (SQLException e) {
%>
            <p>Error: <%= e.getMessage() %></p>
            <a href="manageSchedules.jsp">Back</a>
<%
        }
        return;
    }
%>

<h2>Confirm Delete</h2>
<p>Are you sure you want to delete schedule ID: <%= scheduleId %>?</p>

<form method="post">
    <input type="submit" value="Yes, Delete" />
    <a href="manageSchedules.jsp">Cancel</a>
</form>
