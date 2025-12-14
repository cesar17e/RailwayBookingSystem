<%-- 
  Page: addSchedule.jsp

  Purpose:
    - Provides a form for employees (admin/rep) to add a new train schedule to the system.
    - Allows selection of the train and input of departure/arrival times.

  Notes:
    - The form submits the data to addScheduleAction.jsp for insertion into the database.
    - Only accessible to employees with admin/rep roles.
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.group8.util.DBUtil" %>
<%
    // Connect to the database to populate train options
    ResultSet rs = null;
    try (
        Connection con = DBUtil.getConnection();
        Statement stmt = con.createStatement()
    ) {
        rs = stmt.executeQuery(
            "SELECT t.train_id, tl.transit_line_name " +
            "FROM Train t JOIN TransitLine tl ON t.transit_line_id = tl.transit_line_id");
%>

<h2>Add New Train Schedule</h2>

<form action="${pageContext.request.contextPath}/employee/add-schedule" method="post">
    <label for="train_id">Select Train (Line):</label>
    <select name="train_id" required>
        <option value="">-- Choose a train --</option>
        <%
            while (rs.next()) {
        %>
            <option value="<%= rs.getInt("train_id") %>">
                Train <%= rs.getInt("train_id") %> - <%= rs.getString("transit_line_name") %>
            </option>
        <%
            }
        %>
    </select>
    <br><br>

    <label for="departure_datetime">Departure Date & Time:</label>
    <input type="datetime-local" name="departure_datetime" required />
    <br><br>

    <label for="arrival_datetime">Arrival Date & Time:</label>
    <input type="datetime-local" name="arrival_datetime" required />
    <br><br>

    <input type="submit" value="Add Schedule" />
    <a href="manageSchedules.jsp">Cancel</a>
</form>

<%
    } catch (SQLException e) {
        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
    }
%>
