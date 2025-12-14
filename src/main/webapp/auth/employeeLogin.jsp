<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Employee Login</title>
</head>
<body>
  <h2>Employee Login</h2>
  <form action="employeeLoginAction.jsp" method="post">
    <label for="username">Username</label><br>
    <input id="username" type="text" name="username" required><br><br>

    <label for="password">Password</label><br>
    <input id="password" type="password" name="password" required><br><br>

    <label for="role">Login as:</label><br>
    <select id="role" name="role" required>
      <option value="rep">Customer Rep</option>
      <option value="admin">Manager/Admin</option>
    </select><br><br>

    <button type="submit">Log In</button>
  </form>

  <p><a href="login.jsp">← Back to Customer Login</a></p>
</body>
</html>
