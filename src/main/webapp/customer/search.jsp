<%@ page import="java.sql.Connection, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Search Schedules</title>
</head>
<body>
  <h2>Find a Train Schedule</h2>
  <form action="searchResults.jsp" method="get">
    Origin:
    <select name="origin" required>
      <option value="">-- pick station --</option>
      <%
        // Populate origins from Station table
        String sql = "SELECT station_id, station_name FROM Station ORDER BY station_name";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
            int id = rs.getInt("station_id");
            String name = rs.getString("station_name");
      %>
        <option value="<%=id%>"><%=name%></option>
      <%
          }
        } catch (SQLException e) {
          out.println("<option disabled>Error loading stations</option>");
        }
      %>
    </select><br><br>
    Destination:
    <select name="dest" required>
      <option value="">-- pick station --</option>
      <%
        // Same query for destinations
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
            int id = rs.getInt("station_id");
            String name = rs.getString("station_name");
      %>
        <option value="<%=id%>"><%=name%></option>
      <%
          }
        } catch (SQLException e) {
          out.println("<option disabled>Error loading stations</option>");
        }
      %>
    </select><br><br>
    Travel Date: <input type="date" name="travelDate" required><br><br>
    <button type="submit">Search</button>
  </form>
    
    <p>
  <a href="customerDashboard.jsp">← Back to Dashboard</a>
</p>
  
</body>
</html>
