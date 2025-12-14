<%-- 
  Page: customerDashboard.jsp

  Purpose:
    - Displays the customer dashboard with various options for managing reservations, viewing messages, and asking questions.
    - Provides navigation to other customer-specific pages (e.g., My Reservations, Search, Ask Customer Service).

  Notes:
    - Accessible once the customer is logged in.
    - Links to sections where the customer can interact with the system (reserve, view messages, etc.).
--%>

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
