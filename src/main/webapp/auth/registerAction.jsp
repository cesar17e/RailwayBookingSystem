<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Registration Result</title>
</head>
<body>
<%
  // Get form data
  String firstName = request.getParameter("first_name");
  String lastName  = request.getParameter("last_name");
  String email     = request.getParameter("email");
  String username  = request.getParameter("username");
  String password  = request.getParameter("password");
  String dob       = request.getParameter("date_of_birth");

  // validation
  if (firstName == null || lastName == null || email == null ||
      username == null || password == null || dob == null ||
      firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() ||
      username.isEmpty() || password.isEmpty() || dob.isEmpty()) {
%>
  <p style="color:red;">Error: All fields are required.</p>
  <a href="register.jsp">Go Back</a>
<%
  } else {
    String sql = "INSERT INTO Customer (first_name, last_name, email, username, password, date_of_birth) VALUES (?,?,?,?,?,?)";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setString(1, firstName);
      ps.setString(2, lastName);
      ps.setString(3, email);
      ps.setString(4, username);
      ps.setString(5, password);
      ps.setDate(6, java.sql.Date.valueOf(dob));

      int rows = ps.executeUpdate();
      if (rows > 0) {
%>
        <p style="color:green;">Registration successful! <a href="login.jsp">Log in</a></p>
<%
      } else {
%>
        <p style="color:red;">Registration failed. Please try again.</p>
        <a href="register.jsp">Go Back</a>
<%
      }
    } catch (SQLException e) {
%>
      <p style="color:red;">Error: <%= e.getMessage() %></p>
      <a href="register.jsp">Go Back</a>
<%
    }
  }
%>
</body>
</html>
