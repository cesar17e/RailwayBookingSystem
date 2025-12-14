<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    //Ensure the user is logged in
    Integer custId = (Integer) session.getAttribute("userId");
    if (custId == null) {
        response.sendRedirect("login.jsp?error=Please+log+in+first");
        return;
    }

    //Validate the question
    String content = request.getParameter("content");
    if (content == null || content.trim().isEmpty()) {
        response.sendRedirect("askQuestions.jsp?error=Question+cannot+be+empty");
        return;
    }

    // Insert it into the message
    String sql = "INSERT INTO Message (content, customer_id) VALUES (?, ?)";
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, content.trim());
        ps.setInt(2, custId);
        ps.executeUpdate();
        response.sendRedirect("customerDashboard.jsp");
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Unable to send your question. Please try again.</p>");
        out.println("<a href='askQuestions.jsp'>Go Back</a>");
    }
%>
