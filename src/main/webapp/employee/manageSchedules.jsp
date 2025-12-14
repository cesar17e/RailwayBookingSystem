<%-- 
  Page: manageSchedules.jsp

  Purpose:
    - Displays a list of all train schedules for employees to manage.
    - Allows employees to edit or delete existing schedules.

  Notes:
    - The table includes options to edit or delete each schedule.
    - The add new schedule button links to addSchedule.jsp for creating new entries.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // Role protection
    String role = (String) session.getAttribute("role");
    if (!"rep".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Train Schedules</title>
</head>
<body>

<h2>Manage Train Schedules</h2>

<p>
    <a href="addSchedule.jsp">+ Add New Schedule</a>
</p>

<table border="1" cellpadding="6">
    <tr>
        <th>ID</th>
        <th>Departure</th>
        <th>Arrival</th>
        <th>Transit Line</th>
        <th>Actions</th>
    </tr>

<%
    String sql =
        "SELECT s.schedule_id, s.departure_datetime, s.arrival_datetime, tl.transit_line_name " +
        "FROM TrainSchedule s " +
        "JOIN Train t ON s.train_id = t.train_id " +
        "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id " +
        "ORDER BY s.departure_datetime";

    try (Connection conn = DBUtil.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {

        while (rs.next()) {
            int id = rs.getInt("schedule_id");
%>
    <tr>
        <td><%= id %></td>
        <td><%= rs.getString("departure_datetime") %></td>
        <td><%= rs.getString("arrival_datetime") %></td>
        <td><%= rs.getString("transit_line_name") %></td>
        <td>
            <a href="<%= request.getContextPath() %>/employee/edit-schedule?id=<%= id %>">
                Edit
            </a>
            |
            <a href="<%= request.getContextPath() %>/employee/delete-schedule?id=<%= id %>"
               onclick="return confirm('Are you sure you want to delete this schedule?');">
                Delete
            </a>
        </td>
    </tr>
<%
        }
    } catch (SQLException e) {
%>
    <tr>
        <td colspan="5" style="color:red;">
            Error loading schedules: <%= e.getMessage() %>
        </td>
    </tr>
<%
    }
%>
</table>

<p>
    <a href="repDashboard.jsp">← Back to Dashboard</a>
</p>

</body>
</html>
