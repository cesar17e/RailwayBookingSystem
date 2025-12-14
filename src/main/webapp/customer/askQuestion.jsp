<%-- 
  Page: askQuestion.jsp

  Purpose:
    - Provides a form for customers to submit their questions or inquiries to customer service.
    - The form is submitted to the askQuestionAction.jsp page for processing.

  Notes:
    - Includes a textarea for customers to write their query.
    - Validates that the content is not empty before submission.
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>Ask Customer Service</title></head>
<body>
  <h2>Submit a Question</h2>
  <form action="${pageContext.request.contextPath}/customer/ask-question" method="post">
    <textarea name="content" rows="5" cols="50"
              placeholder="How can we help you?" required></textarea><br><br>
    <button type="submit">Send Question</button>
  </form>
  <p><a href="customerDashboard.jsp">← Back to Dashboard</a></p>
</body>
</html>