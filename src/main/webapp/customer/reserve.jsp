<%-- 
  Page: reserve.jsp

  Purpose:
    - Provides a form for customers to confirm their reservation details before booking.
    - Includes options for selecting trip type and passenger type.

  Notes:
    - Fetches schedule details for a particular trip.
    - Calculates total fare based on selected options.
    - Submits the reservation to reserveAction.jsp.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Book This Trip</title>
</head>
<body>
  <h2>Confirm Your Booking</h2>
  <%
    int schedId = Integer.parseInt(request.getParameter("schedule"));

    // Fetch schedule & fare info
    String q = 
      "SELECT tl.transit_line_name, ts.departure_datetime, ts.arrival_datetime, "
    + "       tl.base_fare, tl.discount_child, tl.discount_senior, tl.discount_disabled, "
    + "       tl.origin_station_id, tl.dest_station_id "
    + "FROM TrainSchedule ts "
    + " JOIN Train t ON ts.train_id = t.train_id "
    + " JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id "
    + "WHERE ts.schedule_id = ?";
    
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(q)) {
      ps.setInt(1, schedId);
      ResultSet rs = ps.executeQuery();
      if (rs.next()) {
        String lineName = rs.getString("transit_line_name");
        Timestamp dep   = rs.getTimestamp("departure_datetime");
        Timestamp arr   = rs.getTimestamp("arrival_datetime");
        float baseFare  = rs.getFloat("base_fare");
        float dc = rs.getFloat("discount_child"),
              ds = rs.getFloat("discount_senior"),
              dd = rs.getFloat("discount_disabled");
        int originId = rs.getInt("origin_station_id"),
            destId   = rs.getInt("dest_station_id");
  %>
  <p><strong>Line:</strong> <%=lineName%></p>
  <p><strong>Depart:</strong> <%=dep%><br/>
     <strong>Arrive:</strong> <%=arr%></p>
    <form action="${pageContext.request.contextPath}/customer/reserve" method="post">
      <!-- Hidden data -->
    <input type="hidden" name="schedule_id" value="<%=schedId%>"/>
    <input type="hidden" name="base_fare"    value="<%=baseFare%>"/>
    <input type="hidden" name="origin_id"    value="<%=originId%>"/>
    <input type="hidden" name="dest_id"      value="<%=destId%>"/>

    Trip type:
    <select name="tripType">
      <option value="one-way">One-way</option>
      <option value="round-trip">Round-trip</option>
    </select><br><br>

    Passenger type:
    <select name="passengerType">
      <option value="adult">Adult</option>
      <option value="child">Child</option>
      <option value="senior">Senior</option>
      <option value="disabled">Disabled</option>
    </select><br><br>

    <button type="submit">Confirm Booking</button>
  </form>
  <%
      } else {
        out.println("<p style='color:red;'>Schedule not found.</p>");
      }
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
  %>
  <p><a href="search.jsp">← Back to Search</a></p>
</body>
</html>
