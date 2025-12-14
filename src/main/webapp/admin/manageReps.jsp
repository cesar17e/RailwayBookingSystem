<%-- 
  Page: manageReps.jsp

  Purpose:
    - Displays all customer representatives in the system.
    - Allows the admin to add, edit, or delete reps.
    - Interacts with AddRepServlet, EditRepServlet, and DeleteRepServlet.

  Notes:
    - Restricted to admin role.
    - Shows success/error messages by reading query parameters.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Customer Representatives</title>
</head>
<body>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
    return;
  }
%>

<h2>Manage Customer Representatives</h2>

<!-- Add Representative -->
<form method="post" action="${pageContext.request.contextPath}/admin/add-rep">
  <h3>Add New Representative</h3>

  SSN:
  <input type="text" name="ssn" required><br>

  First Name:
  <input type="text" name="first_name" required><br>

  Last Name:
  <input type="text" name="last_name" required><br>

  Username:
  <input type="text" name="username" required><br>

  Password:
  <input type="password" name="password" required><br>

  Action Type:
  <select name="action_type">
    <option value="support">Support</option>
    <option value="scheduling">Scheduling</option>
  </select><br><br>

  <button type="submit">Add Representative</button>
</form>

<hr>

<!-- Existing Representatives -->
<h3>Current Representatives</h3>

<table border="1" cellpadding="5">
  <tr>
    <th>SSN</th>
    <th>Name</th>
    <th>Username</th>
    <th>Action Type</th>
    <th>Actions</th>
  </tr>

<%
  try (Connection conn = DBUtil.getConnection();
       Statement stmt = conn.createStatement();
       ResultSet rs = stmt.executeQuery(
         "SELECT ssn, first_name, last_name, username, action_type FROM CustomerRep")) {

    while (rs.next()) {
      String ssn = rs.getString("ssn");
      String name = rs.getString("first_name") + " " + rs.getString("last_name");
      String username = rs.getString("username");
      String action = rs.getString("action_type");
%>
  <tr>
    <td><%= ssn %></td>
    <td><%= name %></td>
    <td><%= username %></td>
    <td><%= action %></td>
    <td>
      <a href="${pageContext.request.contextPath}/admin/edit-rep?ssn=<%= ssn %>">
        Edit
      </a>
      |
      <a href="${pageContext.request.contextPath}/admin/delete-rep?ssn=<%= ssn %>"
         onclick="return confirm('Are you sure you want to delete this representative?');">
        Delete
      </a>
    </td>
  </tr>
<%
    }
  } catch (SQLException e) {
%>
  <tr>
    <td colspan="5">Error loading representatives: <%= e.getMessage() %></td>
  </tr>
<%
  }
%>
</table>

<p>
  <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">
    ← Back to Dashboard
  </a>
</p>

</body>
</html>
