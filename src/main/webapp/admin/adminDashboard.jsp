<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard</title>
  <%
    String name = (String) session.getAttribute("userName");
    String role = (String) session.getAttribute("role");
    if (name == null || !"admin".equals(role)) {
      response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
      return;
    }
  %>

  <h2>Welcome, Admin <%= name %>!</h2>
  <p>Select an action:</p>
  <ul>
    <li>
      <a href="${pageContext.request.contextPath}/admin/manageReps.jsp">
        Manage Customer Representatives
      </a>
    </li>    <li><a href="monthlySales.jsp">View Monthly Sales Report</a></li>
    <li><a href="reservationsByLine.jsp">Reservations by Transit Line</a></li>
    <li><a href="reservationsByCustomer.jsp">Reservations by Customer</a></li>
    <li><a href="revenueByLine.jsp">Revenue per Transit Line</a></li>
    <li><a href="revenueByCustomer.jsp">Revenue per Customer</a></li>
    <li><a href="bestCustomer.jsp">Best Customer</a></li>
    <li><a href="topTransitLines.jsp">Top 5 Transit Lines</a></li>
  </ul>
  <a href="${pageContext.request.contextPath}/auth/logout">Logout</a>
</body>
</html>
