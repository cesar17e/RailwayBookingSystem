<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Monthly Sales Report</title>
</head>
<body>
<%

  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect("employeeLogin.jsp");
    return;
  }
%>

<h2>Monthly Sales Report</h2>

<table border="1" cellpadding="5">
  <tr>
    <th>Month</th>
    <th>Total Revenue ($)</th>
  </tr>
  <%
    String sql = "SELECT DATE_FORMAT(reservation_date, '%Y-%m') AS month, " +
                 "SUM(total_fare) AS total_revenue " +
                 "FROM Reservation " +
                 "WHERE status = 'active' " +
                 "GROUP BY DATE_FORMAT(reservation_date, '%Y-%m') " +
                 "ORDER BY month DESC";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        String month = rs.getString("month");
        float totalRevenue = rs.getFloat("total_revenue");
  %>
    <tr>
      <td><%= month %></td>
      <td>$<%= String.format("%.2f", totalRevenue) %></td>
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
