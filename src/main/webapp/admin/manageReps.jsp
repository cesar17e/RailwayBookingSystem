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
      response.sendRedirect("employeeLogin.jsp");
      return;
    }

    // Handle add new rep form submission
    if ("POST".equalsIgnoreCase(request.getMethod())) {
      String ssn = request.getParameter("ssn");
      String first = request.getParameter("first_name");
      String last = request.getParameter("last_name");
      String user = request.getParameter("username");
      String pass = request.getParameter("password");
      String action = request.getParameter("action_type");
      String managerSSN = (String) session.getAttribute("userSSN"); // Admin's SSN

      try (Connection conn = DBUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement(
             "INSERT INTO CustomerRep (ssn, first_name, last_name, username, password, action_type, manager_ssn) VALUES (?,?,?,?,?,?,?)")) {
        ps.setString(1, ssn);
        ps.setString(2, first);
        ps.setString(3, last);
        ps.setString(4, user);
        ps.setString(5, pass);
        ps.setString(6, action);
        ps.setString(7, managerSSN);
        ps.executeUpdate();
      } catch (SQLException e) {
        out.println("<p style='color:red;'>Error adding rep: " + e.getMessage() + "</p>");
      }
    }
  %>

  <h2>Manage Customer Representatives</h2>
  
  <!-- Form to add a new rep -->
  <form method="post">
    <h3>Add New Representative</h3>
    SSN: <input type="text" name="ssn" required><br>
    First Name: <input type="text" name="first_name" required><br>
    Last Name: <input type="text" name="last_name" required><br>
    Username: <input type="text" name="username" required><br>
    Password: <input type="password" name="password" required><br>
    Action Type: 
    <select name="action_type">
      <option value="support">Support</option>
      <option value="scheduling">Scheduling</option>
    </select><br>
    <button type="submit">Add Representative</button>
  </form>

  <!-- Table of all current reps -->
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
           ResultSet rs = stmt.executeQuery("SELECT ssn, first_name, last_name, username, action_type FROM CustomerRep")) {
        while (rs.next()) {
          String ssn = rs.getString("ssn");
          String name = rs.getString("first_name") + " " + rs.getString("last_name");
          String username = rs.getString("username");
          String action = rs.getString("action_type");
    %>
    <tr>
      <td><%=ssn %></td>
      <td><%=name %></td>
      <td><%=username %></td>
      <td><%=action %></td>
      <td>
 	 		<a href="editRep.jsp?ssn=<%= ssn %>">Edit</a> | 
  			<a href="deleteRep.jsp?ssn=<%= ssn %>">Delete</a>
	  </td>		
    </tr>
    <%
        }
      } catch (SQLException e) {
        out.println("<tr><td colspan='5'>Error loading reps: " + e.getMessage() + "</td></tr>");
      }
    %>
  </table>

  <p><a href="adminDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>
