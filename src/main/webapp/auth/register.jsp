<%-- 
  Page: register.jsp

  Purpose:
    - Provides a registration form for new users (admin, customer rep).
    - Allows creation of new employee accounts (admin/rep roles).

  Notes:
    - Data collected here is submitted to RegisterServlet for account creation.
    - Input validation to prevent missing or incorrect data.
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <title>Sign Up</title>
</head>
<body>
  <h2>Create Your Account</h2>
  <form action="${pageContext.request.contextPath}/auth/register" method="post">
    <label for="first_name">First Name:</label>
    <input id="first_name" type="text" name="first_name" required>
    <br><br>

    <label for="last_name">Last Name:</label>
    <input id="last_name" type="text" name="last_name" required>
    <br><br>

    <label for="email">Email:</label>
    <input id="email" type="email" name="email" required>
    <br><br>

    <label for="username">Username:</label>
    <input id="username" type="text" name="username" required>
    <br><br>

    <label for="password">Password:</label>
    <input id="password" type="password" name="password" required>
    <br><br>

    <label for="date_of_birth">Date of Birth:</label>
    <input id="date_of_birth" type="date" name="date_of_birth" required>
    <br><br>

    <button type="submit">Sign Up</button>
  </form>
  
  <p>Already have an account? <a href="login.jsp">Log in here</a></p>
</body>
</html>
