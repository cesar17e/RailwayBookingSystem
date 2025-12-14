<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  
  Integer customerId = (Integer) session.getAttribute("userId");
  int resId = Integer.parseInt(request.getParameter("id"));
  if (customerId == null) {
    response.sendRedirect("login.jsp");
    return;
  }

  // Update it
  String sql = "UPDATE Reservation SET status='cancelled' "
             + "WHERE reservation_id=? AND customer_id=?";
  try (Connection conn = DBUtil.getConnection();
       PreparedStatement ps = conn.prepareStatement(sql)) {
    ps.setInt(1, resId);
    ps.setInt(2, customerId);
    ps.executeUpdate();
  } catch (SQLException e) {
    // ignore or log
  }

  // 3. Go back to the list
  response.sendRedirect("myReservations.jsp");
%>
