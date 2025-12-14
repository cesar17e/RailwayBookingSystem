<%-- 
  Page: searchResults.jsp

  Purpose:
    - Displays the search results of available train schedules based on the customer's query (origin, destination, and date).
    - Allows the customer to view detailed schedule info and proceed to book a reservation.

  Notes:
    - Displays train schedule information such as departure/arrival times, fare, and available options.
    - Links to reserve.jsp for booking a selected schedule.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Search Results</title>
</head>
<body>
  <h2>Available Schedules</h2>
  <%
    int origin = Integer.parseInt(request.getParameter("origin"));
    int dest   = Integer.parseInt(request.getParameter("dest"));
    String date = request.getParameter("travelDate");

    String sql =
      "SELECT ts.schedule_id, tl.transit_line_name, " +
      "       ts.departure_datetime, ts.arrival_datetime, tl.base_fare " +
      "FROM TrainSchedule ts " +
      "JOIN Train t ON ts.train_id=t.train_id " +
      "JOIN TransitLine tl ON t.transit_line_id=tl.transit_line_id " +
      "WHERE tl.origin_station_id=? " +
      "  AND tl.dest_station_id=? " +
      "  AND DATE(ts.departure_datetime)=? " +
      "ORDER BY ts.departure_datetime";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
      ps.setInt(1, origin);
      ps.setInt(2, dest);
      ps.setDate(3, Date.valueOf(date));
      ResultSet rs = ps.executeQuery();

      out.println("<table border='1'><tr>"
                + "<th>Line</th><th>Depart</th><th>Arrive</th><th>Fare</th>"
                + "<th>Actions</th></tr>");

      while (rs.next()) {
        int schedId = rs.getInt("schedule_id");
        String line = rs.getString("transit_line_name");
        Timestamp dep = rs.getTimestamp("departure_datetime");
        Timestamp arr = rs.getTimestamp("arrival_datetime");
        float fare  = rs.getFloat("base_fare");

        out.println("<tr>"
          + "<td>" + line + "</td>"
          + "<td>" + dep + "</td>"
          + "<td>" + arr + "</td>"
          + "<td>$" + String.format("%.2f", fare) + "</td>"
          + "<td>"
          +   "<a href='viewStops.jsp?"
          + "schedule=" + schedId
          + "&origin="    + origin
          + "&dest="      + dest
          + "&travelDate="+ date
          + "'>View Stops</a> | "
          +   "<a href='reserve.jsp?schedule=" + schedId + "'>Book</a>"
          + "</td>"
          + "</tr>");
      }

      out.println("</table>");
    } catch (SQLException e) {
      out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
  %>
  <p>
    <a href="search.jsp">← Back to Search</a>
  </p>
</body>
</html>
