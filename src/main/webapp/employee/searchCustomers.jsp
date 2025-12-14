<%-- 
  Page: searchCustomers.jsp

  Purpose:
    - Provides a search interface for employees (admin/rep) to look up customers by transit line and date.
    - Allows employees to find specific customer reservations.

  Notes:
    - Submits data to searchCustomersResult.jsp for displaying search results.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Search Customers by Line and Date</title>
</head>
<body>
  <h2>Search Customers by Transit Line and Date</h2>
  
  <form action="searchCustomersResult.jsp" method="get">
    <label for="line">Select Transit Line:</label>
    <select name="line" required>
      <option value="">-- Choose a line --</option>
      <%
        String lineSQL = "SELECT transit_line_name FROM TransitLine ORDER BY transit_line_name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(lineSQL);
             ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
      %>
            <option value="<%= rs.getString("transit_line_name") %>">
              <%= rs.getString("transit_line_name") %>
            </option>
      <%
          }
        } catch (SQLException e) {
          out.println("<p style='color:red;'>Error loading lines: " + e.getMessage() + "</p>");
        }
      %>
    </select>
    <br><br>

    <label for="date">Reservation Date:</label>
    <input type="date" name="date" required />
    <br><br>

    <input type="submit" value="Search" />
  </form>
</body>
</html>
