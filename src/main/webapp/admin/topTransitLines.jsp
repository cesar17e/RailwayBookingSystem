<%-- 
  Page: topTransitLines.jsp

  Purpose:
    - Shows the most frequently used transit lines based on reservation count.
    - Useful for capacity planning and system performance evaluation.

  Notes:
    - Runs a GROUP BY transit_line_name sorted descending.
    - Analytics-only page for admins.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Top 5 Transit Lines</title>
</head>
<body>
<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
    return;
  }
%>

<h2>Top 5 Most Active Transit Lines</h2>

<table border="1" cellpadding="5">
  <tr>
    <th>Transit Line</th>
    <th>Total Reservations</th>
  </tr>
  <%
    String sql = 
      "SELECT tl.transit_line_name, COUNT(r.reservation_id) AS total_reservations " +
      "FROM Reservation r " +
      "JOIN TrainSchedule ts ON r.schedule_id = ts.schedule_id " +
      "JOIN Train t ON ts.train_id = t.train_id " +
      "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id " +
      "WHERE r.status = 'active' " +
      "GROUP BY tl.transit_line_name " +
      "ORDER BY total_reservations DESC " +
      "LIMIT 5";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        String lineName = rs.getString("transit_line_name");
        int totalRes = rs.getInt("total_reservations");
  %>
    <tr>
      <td><%= lineName %></td>
      <td><%= totalRes %></td>
    </tr>
  <%
      }
    } catch (SQLException e) {
      out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
    }
  %>
</table>

<p><a href="adminDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>
