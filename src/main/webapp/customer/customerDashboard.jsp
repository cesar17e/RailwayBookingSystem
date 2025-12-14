<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Welcome</title></head>
<body>
  <%
    String name = (String) session.getAttribute("userName");
    if (name == null) {
      response.sendRedirect("login.jsp");
      return;
    }
  %>
  <h2>Welcome, <%= name %>!</h2>
  <p>This is your dashboard. From here, you can:</p>
  <ul>
    <li><a href="search.jsp">Search and Reserve a Trip</a></li>
    <li><a href="myReservations.jsp">View or Cancel Reservations</a></li>
    <li><a href="askQuestion.jsp">Ask Customer Service</a></li>
    <li><a href="customerInbox.jsp">View Messages</a></li>
    <a href="${pageContext.request.contextPath}/auth/logout">Logout</a>
  </ul>
</body>
</html>
