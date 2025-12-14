<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%
    String trainIdStr = request.getParameter("train_id");
    String departureStr = request.getParameter("departure_datetime");
    String arrivalStr = request.getParameter("arrival_datetime");

    if (trainIdStr == null || departureStr == null || arrivalStr == null ||
        trainIdStr.isEmpty() || departureStr.isEmpty() || arrivalStr.isEmpty()) {
%>
        <p>Error: All fields are required.</p>
        <a href="addSchedule.jsp">Go Back</a>
<%
    } else {
        try (
            Connection con = DBUtil.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO TrainSchedule (departure_datetime, arrival_datetime, train_id) VALUES (?, ?, ?)")
        ) {
            ps.setString(1, departureStr.replace("T", " ") + ":00"); 
            ps.setString(2, arrivalStr.replace("T", " ") + ":00");
            ps.setInt(3, Integer.parseInt(trainIdStr));

            int rows = ps.executeUpdate();

            if (rows > 0) {
%>
                <p>Train schedule successfully added.</p>
                <a href="manageSchedules.jsp">Back to Schedule Management</a>
<%
            } else {
%>
                <p>Failed to add train schedule.</p>
                <a href="addSchedule.jsp">Try Again</a>
<%
            }
        } catch (SQLException e) {
%>
            <p>Error: <%= e.getMessage() %></p>
            <a href="addSchedule.jsp">Go Back</a>
<%
        }
    }
%>
