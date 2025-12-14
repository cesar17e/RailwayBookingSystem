<%-- 
  Page: customerInbox.jsp

  Purpose:
    - Displays the customer's message inbox.
    - Allows customers to view responses to their questions from customer service.

  Notes:
    - Displays a list of messages and their statuses.
    - If a reply is available, it shows the response; otherwise, indicates that the message is still awaiting a reply.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  Integer custId = (Integer) session.getAttribute("userId");
  if (custId == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Your Message Inbox</title>
  <style>
    body { font-family: Arial; padding: 20px; background: #f9f9f9; }
    h2 { color: #333; }
    table { border-collapse: collapse; width: 100%; margin-top: 20px; background: white; }
    th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
    th { background-color: #f2f2f2; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    .back { margin-top: 20px; display: inline-block; }
  </style>
</head>
<body>
  <h2>Your Support Messages</h2>

  <table>
    <tr>
      <th>Your Question</th>
      <th>Response</th>
    </tr>
  <%
    String sql = "SELECT content, reply_text FROM Message WHERE customer_id = ?";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, custId);
      try (ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
          String question = rs.getString("content");
          String reply = rs.getString("reply_text");
  %>
    <tr>
      <td><%= question %></td>
      <td><%= (reply != null && !reply.trim().isEmpty()) ? reply : "Awaiting response..." %></td>
    </tr>
  <%
        }
      }
    } catch (SQLException e) {
      out.println("<tr><td colspan='2' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
    }
  %>
  </table>

  <a class="back" href="customerDashboard.jsp">← Back to Dashboard</a>
</body>
</html>
