<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  
    String u = request.getParameter("username");
    String p = request.getParameter("password");
    if (u == null || p == null || u.isEmpty() || p.isEmpty()) {
        response.sendRedirect("login.jsp?error=Missing+credentials");
        return;
    }

    String sql =
        "SELECT customer_id, first_name, date_of_birth " +
        "  FROM Customer " +
        " WHERE username=? AND password=?";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, u);
        ps.setString(2, p);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                // 3. Store in session
                session.setAttribute("userId", rs.getInt("customer_id"));
                session.setAttribute("userName", rs.getString("first_name"));
                session.setAttribute("userDOB", rs.getDate("date_of_birth"));
                // 4. Redirect *before* any output
                response.sendRedirect("customerDashboard.jsp");
                return;
            }
        }

        response.sendRedirect("login.jsp?error=Invalid+username+or+password");

    } catch (SQLException e) {
        response.sendRedirect("login.jsp?error=Database+error");
    }
%>
