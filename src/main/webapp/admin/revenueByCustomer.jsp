<%-- 
  Page: revenueByCustomer.jsp

  Purpose:
    - Lists customers with their total reservation count and total spending.
    - Helps admins analyze user activity and revenue distribution.

  Notes:
    - Performs aggregate SQL queries (COUNT, SUM).
    - Read-only report page.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Revenue by Customer</title>
</head>
<body>
<%
  // Ensure only admin can access this page
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
    return;
  }
%>

<h2>Revenue by Customer</h2>

<table border="1" cellpadding="5">
  <tr>
    <th>Customer Name</th>
    <th>Total Revenue ($)</th>
  </tr>
  <%
    String sql =
      "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, " +
      "       SUM(r.total_fare) AS total_revenue " +
      "FROM Reservation r " +
      "JOIN Customer c ON r.customer_id = c.customer_id " +
      "WHERE r.status = 'active' " +
      "GROUP BY c.customer_id " +
      "ORDER BY total_revenue DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        String customerName = rs.getString("customer_name");
        float totalRevenue = rs.getFloat("total_revenue");
  %>
    <tr>
      <td><%= customerName %></td>
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
