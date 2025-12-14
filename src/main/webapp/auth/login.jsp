<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Log In</title>
</head>
<body>
  <h2>Log In</h2>
  <form action="loginAction.jsp" method="post">
    <label for="username">Username</label><br>
    <input id="username" type="text" name="username" required><br><br>

    <label for="password">Password</label><br>
    <input id="password" type="password" name="password" required><br><br>

    <button type="submit">Log In</button>
  </form>

  <p>Don’t have an account? <a href="register.jsp">Sign up here</a></p>
  <p><a href="employeeLogin.jsp">Employee / Manager Login</a></p>
</body>
</html>
