<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String username = request.getParameter("username");
  String password = request.getParameter("password");
  String role     = request.getParameter("role");

  try (Connection conn = DBUtil.getConnection()) {
    PreparedStatement ps;
    ResultSet rs;

    if ("rep".equals(role)) {
      ps = conn.prepareStatement("SELECT ssn, first_name FROM CustomerRep WHERE username=? AND password=?");
      ps.setString(1, username);
      ps.setString(2, password);
      rs = ps.executeQuery();
      if (rs.next()) {
        session.setAttribute("userSSN", rs.getString("ssn"));
        session.setAttribute("userName", rs.getString("first_name"));
        session.setAttribute("role", "rep");
        response.sendRedirect("repDashboard.jsp");
        return;
      }
    } else if ("admin".equals(role)) {
      ps = conn.prepareStatement("SELECT ssn, first_name FROM Manager WHERE username=? AND password=?");
      ps.setString(1, username);
      ps.setString(2, password);
      rs = ps.executeQuery();
      if (rs.next()) {
        session.setAttribute("userSSN", rs.getString("ssn"));
        session.setAttribute("userName", rs.getString("first_name"));
        session.setAttribute("role", "admin");
        response.sendRedirect("adminDashboard.jsp");
        return;
      }
    }

    out.println("<p style='color:red;'>Invalid username, password, or role.</p>");
    out.println("<p><a href='employeeLogin.jsp'>Try again</a></p>");

  } catch (SQLException e) {
    out.println("<p style='color:red;'>Database error: " + e.getMessage() + "</p>");
  }
%>
