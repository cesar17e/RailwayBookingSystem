<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Reservations by Customer</title>
</head>
<body>
<%
  // Ensure only admin can access this page
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect("employeeLogin.jsp");
    return;
  }
%>

<h2>Reservations by Customer</h2>

<table border="1" cellpadding="5">
  <tr>
    <th>Customer Name</th>
    <th>Total Reservations</th>
    <th>Total Spent ($)</th>
  </tr>
  <%
    String sql =
      "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, " +
      "       COUNT(r.reservation_id) AS total_reservations, " +
      "       SUM(r.total_fare) AS total_spent " +
      "FROM Reservation r " +
      "JOIN Customer c ON r.customer_id = c.customer_id " +
      "WHERE r.status = 'active' " +
      "GROUP BY c.customer_id " +
      "ORDER BY total_spent DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        String customerName = rs.getString("customer_name");
        int totalRes = rs.getInt("total_reservations");
        float totalSpent = rs.getFloat("total_spent");
  %>
    <tr>
      <td><%= customerName %></td>
      <td><%= totalRes %></td>
      <td>$<%= String.format("%.2f", totalSpent) %></td>
    </tr>
  <%
      }
    } catch (SQLException e) {
      out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
    }
  %>
</table>

<p><a href="adminDashboard.jsp">← Back to Dashboard</a></p>

</body>
</html>
