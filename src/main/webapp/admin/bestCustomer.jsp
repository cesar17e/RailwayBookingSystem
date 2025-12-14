<%-- 
  Page: bestCustomer.jsp

  Purpose:
    - Displays the customer with the highest total spending.
    - Helps admins analyze customer value and sales performance.

  Notes:
    - Runs an aggregate SQL query (SUM of total_fare).
    - Read-only analytics page.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Best Customer</title>
</head>
<body>
<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
    return;
  }
%>

<h2>Best Customer</h2>

<%
  String sql = 
    "SELECT CONCAT(c.first_name, ' ', c.last_name) AS customer_name, " +
    "       SUM(r.total_fare) AS total_revenue " +
    "FROM Reservation r " +
    "JOIN Customer c ON r.customer_id = c.customer_id " +
    "WHERE r.status = 'active' " +
    "GROUP BY c.customer_id " +
    "ORDER BY total_revenue DESC " +
    "LIMIT 1";

  try (Connection conn = DBUtil.getConnection();
       PreparedStatement ps = conn.prepareStatement(sql);
       ResultSet rs = ps.executeQuery()) {
    if (rs.next()) {
      String bestCustomer = rs.getString("customer_name");
      float revenue = rs.getFloat("total_revenue");
      out.println("<p><strong>" + bestCustomer + "</strong> is our top customer with $" 
                  + String.format("%.2f", revenue) + " spent!</p>");
    } else {
      out.println("<p>No reservations found.</p>");
    }
  } catch (SQLException e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
  }
%>

<p><a href="adminDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>
