<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Ask Customer Service</title></head>
<body>
  <h2>Submit a Question</h2>
  <form action="askQuestionAction.jsp" method="post">
    <textarea name="content" rows="5" cols="50"
              placeholder="How can we help you?" required></textarea><br><br>
    <button type="submit">Send Question</button>
  </form>
  <p><a href="customerDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>
