<%@ page import="java.sql.Connection, java.sql.SQLException" %>
<%@ page import="com.group8.util.DBUtil" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Test DB Connection</title>
</head>
<body>
  <h2>Database Connection Test</h2>
  <%
    try (Connection conn = DBUtil.getConnection()) {
      out.println("<p style='color:green;'> Connection successful!</p>");
    } catch (SQLException e) {
      out.println("<p style='color:red;'> Connection failed:</p>");
      out.println("<pre>" + e.getMessage() + "</pre>");
    }
  %>
</body>
</html>
