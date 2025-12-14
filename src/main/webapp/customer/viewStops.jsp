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
    // Validate parameters
    String originParam = request.getParameter("origin");
    String destParam   = request.getParameter("dest");
    String date        = request.getParameter("travelDate");
    if (originParam == null || destParam == null || date == null ||
        originParam.isEmpty() || destParam.isEmpty() || date.isEmpty()) {
      out.println("<p style='color:red;'>Invalid search parameters.</p>");
      return;
    }
    int origin = Integer.parseInt(originParam);
    int dest   = Integer.parseInt(destParam);

    String sql =
      "SELECT ts.schedule_id, tl.transit_line_name, " +
      "       ts.departure_datetime, ts.arrival_datetime, tl.base_fare " +
      "FROM TrainSchedule ts " +
      "JOIN Train t ON ts.train_id = t.train_id " +
      "JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id " +
      "WHERE tl.origin_station_id = ? " +
      "  AND tl.dest_station_id   = ? " +
      "  AND DATE(ts.departure_datetime) = ? " +
      "ORDER BY ts.departure_datetime";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

      ps.setInt(1, origin);
      ps.setInt(2, dest);
      ps.setDate(3, Date.valueOf(date));

      try (ResultSet rs = ps.executeQuery()) {
        out.println("<table border='1' cellpadding='5'>"
                  + "<tr><th>Line</th><th>Depart</th><th>Arrive</th><th>Fare</th><th>Actions</th></tr>");

        boolean hasResults = false;
        while (rs.next()) {
          hasResults = true;
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
            +   "<a href='viewStops.jsp?schedule=" + schedId
            + "&origin=" + origin
            + "&dest=" + dest
            + "&travelDate=" + date + "'>View Stops</a> | "
            +   "<a href='reserve.jsp?schedule=" + schedId + "'>Book</a>"
            + "</td>"
            + "</tr>");
        }

        if (!hasResults) {
          out.println("<tr><td colspan='5'>No schedules found for this search.</td></tr>");
        }

        out.println("</table>");
      }

    } catch (SQLException e) {
      out.println("<p style='color:red;'>Unable to load schedules. Please try again.</p>");
    }
  %>

  <p><a href="search.jsp">← Back to Search</a></p>
</body>
</html>
