<%-- 
  Page: myReservations.jsp

  Purpose:
    - Displays a list of the customer's existing reservations.
    - Allows customers to view and manage their reservations, including canceling.

  Notes:
    - Includes the ability to cancel active reservations.
    - Shows detailed reservation info such as dates, status, and total fare.
--%>


<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>My Reservations</title>
</head>
<body>

<h2>Your Reservations</h2>

<%
    Integer customerId = (Integer) session.getAttribute("userId");
    if (customerId == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }

    String sql =
        "SELECT r.reservation_id, r.reservation_date, r.reservation_type, " +
        "       r.status, r.total_fare, r.passenger_type, " +
        "       o.station_name AS origin, d.station_name AS dest " +
        "FROM Reservation r " +
        "JOIN Station o ON r.origin_station_id = o.station_id " +
        "JOIN Station d ON r.dest_station_id   = d.station_id " +
        "WHERE r.customer_id = ? " +
        "ORDER BY r.reservation_date DESC";

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, customerId);
        ResultSet rs = ps.executeQuery();

        out.println("<table border='1' cellpadding='5'>");
        out.println("<tr>"
                  + "<th>Date</th>"
                  + "<th>Trip</th>"
                  + "<th>Type</th>"
                  + "<th>Fare</th>"
                  + "<th>Passenger</th>"
                  + "<th>Status</th>"
                  + "<th>Action</th>"
                  + "</tr>");

        while (rs.next()) {
            int resId = rs.getInt("reservation_id");
            String status = rs.getString("status");

            out.println("<tr>"
              + "<td>" + rs.getDate("reservation_date") + "</td>"
              + "<td>" + rs.getString("origin") + " → " + rs.getString("dest") + "</td>"
              + "<td>" + rs.getString("reservation_type") + "</td>"
              + "<td>$" + String.format("%.2f", rs.getFloat("total_fare")) + "</td>"
              + "<td>" + rs.getString("passenger_type") + "</td>"
              + "<td>" + status + "</td>"
              + "<td>");

            if ("active".equals(status)) {
                out.println(
                    "<a href='" + request.getContextPath()
                    + "/customer/cancel-reservation?id=" + resId + "'>"
                    + "Cancel</a>"
                );
            }

            out.println("</td></tr>");
        }

        out.println("</table>");

    } catch (SQLException e) {
        out.println("<p style='color:red;'>Error loading reservations: "
                    + e.getMessage() + "</p>");
    }
%>

<p>
  <a href="${pageContext.request.contextPath}/customer/customerDashboard.jsp">
    ← Back to Dashboard
  </a>
</p>

</body>
</html>
