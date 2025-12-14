<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Customer Representative</title>
</head>
<body>
<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect("employeeLogin.jsp");
    return;
  }

  String ssn = request.getParameter("ssn");

  String firstName = "", lastName = "", username = "", password = "";
  if (ssn != null && !"POST".equalsIgnoreCase(request.getMethod())) {
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
           "SELECT first_name, last_name, username, password FROM CustomerRep WHERE ssn=?")) {
      ps.setString(1, ssn);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        firstName = rs.getString("first_name");
        lastName = rs.getString("last_name");
        username = rs.getString("username");
        password = rs.getString("password");
      } else {
        out.println("<p style='color:red;'>Representative not found.</p>");
        return;
      }
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
  }

  // Handle form submission (Update)
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String newFirst = request.getParameter("first_name");
    String newLast = request.getParameter("last_name");
    String newUser = request.getParameter("username");
    String newPass = request.getParameter("password");

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
           "UPDATE CustomerRep SET first_name=?, last_name=?, username=?, password=? WHERE ssn=?")) {
      ps.setString(1, newFirst);
      ps.setString(2, newLast);
      ps.setString(3, newUser);
      ps.setString(4, newPass);
      ps.setString(5, ssn);
      ps.executeUpdate();
      response.sendRedirect("manageReps.jsp");
      return;
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Update error: " + e.getMessage() + "</p>");
    }
  }
%>

<h2>Edit Customer Representative</h2>
<form method="post">
  First Name: <input type="text" name="first_name" value="<%= firstName %>" required><br>
  Last Name: <input type="text" name="last_name" value="<%= lastName %>" required><br>
  Username: <input type="text" name="username" value="<%= username %>" required><br>
  Password: <input type="password" name="password" value="<%= password %>" required><br>
  <button type="submit">Update Representative</button>
</form>

<p><a href="manageReps.jsp">← Back to Manage Reps</a></p>
</body>
</html>
