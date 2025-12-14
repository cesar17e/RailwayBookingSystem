<%-- 
  Page: editRep.jsp

  Purpose:
    - Displays a pre-filled form allowing the admin to update
      a customer representative’s details.
    - Data is provided by EditRepServlet (doGet).

  Notes:
    - Submits changes back to EditRepServlet (doPost) for database update.
    - Restricted to admin users only.
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Customer Representative</title>
</head>
<body>

<%
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
    return;
  }
%>

<h2>Edit Customer Representative</h2>

<form method="post" action="${pageContext.request.contextPath}/admin/edit-rep">

  <!-- SSN must be preserved for POST -->
  <input type="hidden" name="ssn" value="${ssn}">

  First Name:
  <input type="text" name="first_name" value="${firstName}" required><br><br>

  Last Name:
  <input type="text" name="last_name" value="${lastName}" required><br><br>

  Username:
  <input type="text" name="username" value="${username}" required><br><br>

  Password:
  <input type="password" name="password" value="${password}" required><br><br>

  <button type="submit">Update Representative</button>
</form>

<p>
  <a href="${pageContext.request.contextPath}/admin/manageReps.jsp">
    ← Back to Manage Reps
  </a>
</p>

</body>
</html>
