<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%
    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        con = DBUtil.getConnection(); 
        stmt = con.createStatement();
        rs = stmt.executeQuery(
            "SELECT s.schedule_id, s.departure_datetime, s.arrival_datetime, " +
            "t.transit_line_id, tl.transit_line_name " +
            "FROM TrainSchedule s " +
            "JOIN Train t ON s.train_id = t.train_id " +
            "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id");
%>

<h2>Manage Train Schedules</h2>
<a href="addSchedule.jsp">+ Add New Schedule</a>
<table border="1">
    <tr>
        <th>ID</th><th>Departure</th><th>Arrival</th><th>Line</th><th>Actions</th>
    </tr>
<%
        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("schedule_id") %></td>
        <td><%= rs.getString("departure_datetime") %></td>
        <td><%= rs.getString("arrival_datetime") %></td>
        <td><%= rs.getString("transit_line_name") %></td>
        <td>
            <a href="editSchedule.jsp?id=<%= rs.getInt("schedule_id") %>">Edit</a> |
            <a href="deleteSchedule.jsp?id=<%= rs.getInt("schedule_id") %>">Delete</a>
        </td>
    </tr>
<%
        }
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (con != null) con.close();
    }
%>
</table>
<a href="repDashboard.jsp"> Back to Dashboard</a>

