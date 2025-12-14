<%-- 
  Page: searchCustomersResult.jsp

  Purpose:
    - Displays the results of a customer search based on transit line and date.
    - Shows customer information (name, email) for reservations matching the criteria.

  Notes:
    - Only accessible by employees (admin/rep).
    - Displays customers' details for specific transit line reservations.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String line = request.getParameter("line");
  String date = request.getParameter("date");
%>

<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Search Results</title></head>
<body>
  <h2>Customers for Line: <%= line %>, Date: <%= date %></h2>
  <%
    String sql = 
      "SELECT c.first_name, c.last_name, c.email, r.reservation_date " +
      "FROM Customer c " +
      "JOIN Reservation r ON c.customer_id = r.customer_id " +
      "JOIN TrainSchedule s ON r.schedule_id = s.schedule_id " +
      "JOIN Train t ON s.train_id = t.train_id " +
      "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id " +
      "WHERE tl.transit_line_name = ? AND DATE(r.reservation_date) = ?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, line);
      ps.setString(2, date);
      try (ResultSet rs = ps.executeQuery()) {
        if (!rs.isBeforeFirst()) {
          out.println("<p><strong>No customers found for this search.</strong></p>");
        } else {
          out.println("<ul>");
          while (rs.next()) {
            String name = rs.getString("first_name") + " " + rs.getString("last_name");
            String email = rs.getString("email");
            out.println("<li>" + name + " (" + email + ")</li>");
          }
          out.println("</ul>");
        }
      }
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
  %>
  <p><a href="searchCustomers.jsp">← New Search</a></p>
</body>
</html>
