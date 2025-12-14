<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  // Check admin role
  String role = (String) session.getAttribute("role");
  if (role == null || !"admin".equals(role)) {
    response.sendRedirect("employeeLogin.jsp");
    return;
  }

  String ssn = request.getParameter("ssn");
  if (ssn != null && !ssn.isEmpty()) {
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement("DELETE FROM CustomerRep WHERE ssn = ?")) {
      ps.setString(1, ssn);
      int rows = ps.executeUpdate();
      if (rows == 0) {
        out.println("<p style='color:red;'>No representative found with SSN: " + ssn + "</p>");
      }
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Error deleting representative: " + e.getMessage() + "</p>");
    }
  }

  // Redirect to the correct file
  response.sendRedirect("manageReps.jsp");
%>
