<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  String role = (String) session.getAttribute("role");
  String repSSN = (String) session.getAttribute("userSSN");

  if (!"rep".equals(role) || repSSN == null) {
    response.sendRedirect("employeeLogin.jsp");
    return;
  }

  String keyword = request.getParameter("keyword");
  if (keyword == null) keyword = "";
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Customer Messages</title>
  <style>
    body { font-family: Arial; background: #f9f9f9; padding: 20px; }
    h2 { color: #333; }
    table { border-collapse: collapse; width: 100%; background: white; margin-top: 20px; }
    th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
    th { background-color: #f2f2f2; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    .reply-button { color: white; background: #007BFF; padding: 5px 10px; border-radius: 5px; text-decoration: none; }
    .reply-button:hover { background: #0056b3; }
    .search-box { margin-bottom: 20px; }
  </style>
</head>
<body>

<h2>All Customer Messages</h2>

<form method="get" class="search-box">
  <label for="keyword">Search keyword:</label>
  <input type="text" name="keyword" id="keyword" value="<%= keyword %>" />
  <button type="submit">Search</button>
</form>

<table>
  <tr>
    <th>Customer</th>
    <th>Question</th>
    <th>Status / Action</th>
  </tr>
<%
  String sql = "SELECT m.message_id, m.content, m.reply_text, m.customer_rep_ssn, c.first_name, c.last_name " +
               "FROM Message m JOIN Customer c ON m.customer_id = c.customer_id " +
               "WHERE m.content LIKE ?";
  try (Connection conn = DBUtil.getConnection();
       PreparedStatement ps = conn.prepareStatement(sql)) {
    ps.setString(1, "%" + keyword + "%");
    try (ResultSet rs = ps.executeQuery()) {
      while (rs.next()) {
        int msgId = rs.getInt("message_id");
        String customer = rs.getString("first_name") + " " + rs.getString("last_name");
        String question = rs.getString("content");
        String reply = rs.getString("reply_text");
        String assignedSSN = rs.getString("customer_rep_ssn");

        out.println("<tr>");
        out.println("<td>" + customer + "</td>");
        out.println("<td>" + question + "</td>");

        if (reply == null || reply.trim().isEmpty()) {
          out.println("<td><a class='reply-button' href='reply.jsp?id=" + msgId + "'>Reply</a></td>");
        } else if (repSSN.equals(assignedSSN)) {
          out.println("<td><strong>You replied:</strong> " + reply + "</td>");
        } else {
          out.println("<td><em>Answered by another rep</em></td>");
        }

        out.println("</tr>");
      }
    }
  } catch (SQLException e) {
    out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
  }
%>
</table>

<p><a href="repDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>
