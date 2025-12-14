<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Processing Booking</title>
</head>
<body>
<%
  //make sure customer is logged in
  Integer customerId = (Integer) session.getAttribute("userId");
  if (customerId == null) {
      response.sendRedirect("login.jsp?error=Please+log+in+first");
      return;
  }

  //read inputs
  String schedParam     = request.getParameter("schedule_id");
  String baseFareParam  = request.getParameter("base_fare");
  String originParam    = request.getParameter("origin_id");
  String destParam      = request.getParameter("dest_id");
  String tripType       = request.getParameter("tripType");
  String passengerType  = request.getParameter("passengerType");

  if (schedParam == null || baseFareParam == null
   || originParam == null || destParam == null
   || tripType == null || schedParam.isEmpty()
   || baseFareParam.isEmpty() || originParam.isEmpty()
   || destParam.isEmpty() || tripType.isEmpty()) {
    out.println("<p style='color:red;'>Missing booking information.</p>");
    out.println("<p><a href='search.jsp'>Back to Search</a></p>");
    return;
  }

  int scheduleId;
  float baseFare;
  int originId;
  int destId;
  try {
      scheduleId = Integer.parseInt(schedParam);
      baseFare   = Float.parseFloat(baseFareParam);
      originId   = Integer.parseInt(originParam);
      destId     = Integer.parseInt(destParam);
  } catch (NumberFormatException e) {
      out.println("<p style='color:red;'>Invalid numeric data provided.</p>");
      out.println("<p><a href='search.jsp'>Back to Search</a></p>");
      return;
  }

  //Compute fare (no discounts, round-trip ×2)
  float fare = baseFare;
  if ("round-trip".equals(tripType)) {
      fare *= 2;
  }

  // Insert the reservation
  String sql =
    "INSERT INTO Reservation " +
    "(reservation_date, reservation_type, status, total_fare, " +
    " passenger_type, origin_station_id, dest_station_id, schedule_id, customer_id) " +
    "VALUES (CURRENT_DATE, ?, 'active', ?, ?, ?, ?, ?, ?)";

  try (Connection conn = DBUtil.getConnection();
       PreparedStatement ps = conn.prepareStatement(sql)) {
      
      ps.setString(1, tripType);
      ps.setFloat(2, fare);
      ps.setString(3, passengerType);
      ps.setInt(4, originId);
      ps.setInt(5, destId);
      ps.setInt(6, scheduleId);
      ps.setInt(7, customerId);
      ps.executeUpdate();

      // 5. Success → show reservations
      response.sendRedirect("myReservations.jsp");
      return;

  } catch (SQLException e) {
      out.println("<p style='color:red;'>Unable to complete booking. Please try again.</p>");
      out.println("<p><a href='search.jsp'>Back to Search</a></p>");
  }
%>
</body>
</html>
