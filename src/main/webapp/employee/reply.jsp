<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String role = (String) session.getAttribute("role");
  if (!"rep".equals(role)) {
    response.sendRedirect("employeeLogin.jsp");
    return;
  }
  String repSSN = (String) session.getAttribute("userSSN");
  int msgId = Integer.parseInt(request.getParameter("id"));

  if ("POST".equalsIgnoreCase(request.getMethod())) {
    String reply = request.getParameter("reply_text");
    String sql = "UPDATE Message SET reply_text=?, customer_rep_ssn=? WHERE message_id=?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setString(1, reply);
      ps.setString(2, repSSN);
      ps.setInt(3, msgId);
      ps.executeUpdate();
      response.sendRedirect("repMessages.jsp");
      return;
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
  }
%>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Reply to Question</title></head>
<body>
  <h2>Write Your Reply</h2>
  <form method="post">
    <textarea name="reply_text" rows="5" cols="50" required></textarea><br><br>
    <button type="submit">Submit Reply</button>
  </form>
  <p><a href="repMessage.jsp">← Back to Questions</a></p>
</body>
</html>
