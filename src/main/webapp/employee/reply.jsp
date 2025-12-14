<%@ page contentType="text/html; charset=UTF-8" %>

<%
    String role = (String) session.getAttribute("role");
    if (!"rep".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/auth/employeeLogin.jsp");
        return;
    }

    String msgId = request.getParameter("id");
    if (msgId == null) {
        out.println("<p>Missing message ID.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reply to Customer</title>
</head>
<body>

<h2>Reply to Question</h2>

<form method="post"
      action="<%= request.getContextPath() %>/employee/reply?id=<%= msgId %>">

    <textarea name="reply_text" rows="5" cols="60" required></textarea><br><br>

    <button type="submit">Send Reply</button>
</form>

<p>
    <a href="repMessages.jsp">← Back to Messages</a>
</p>

</body>
</html>
