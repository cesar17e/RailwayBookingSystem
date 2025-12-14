<%-- 
  Page: employeeLogin.jsp

  Purpose:
    - Provides the login form for employee users (admin/rep).
    - Allows users to authenticate using their credentials (username, password).

  Notes:
    - On successful login, redirects to the appropriate dashboard (admin/rep).
    - On failed login, displays an error message and prompts for retry.
    - Works in conjunction with LoginServlet for authentication.
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Employee Login</title>
</head>
<body>
  <h2>Employee Login</h2>
  <form action="${pageContext.request.contextPath}/auth/employee-login" method="post">
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
