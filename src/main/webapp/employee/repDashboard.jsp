<%@ page import="java.sql.*" %>
<%
    // Check if rep is logged in
    String role = (String) session.getAttribute("role");
    if (!"rep".equals(role)) {
        response.sendRedirect("employeeLogin.jsp");
        return;
    }

    String repUser = (String) session.getAttribute("userName");
%>


<!DOCTYPE html>
<html>
<head>
    <title>Customer Rep Dashboard</title>
    <style>
        body {
            font-family: Arial;
            padding: 20px;
            background: #f9f9f9;
        }
        h1 {
            color: #444;
        }
        .card {
            border: 1px solid #ccc;
            padding: 20px;
            margin: 12px 0;
            background: white;
            border-radius: 8px;
            width: fit-content;
        }
        a.button {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 16px;
            background: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
        }
        a.button:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>

<h1>Welcome, <%= repUser %>!</h1>

<div class="card">
    <h3>Train Schedule Management</h3>
    <a class="button" href="manageSchedules.jsp">Manage Train Schedules</a>
</div>

<div class="card">
    <h3>Messages</h3>
    <a class="button" href="repMessages.jsp">Inbox</a>
</div>

<div class="card">
    <h3>Search Customers by Line & Date</h3>
    <a class="button" href="searchCustomers.jsp">Find Customers</a>
</div>

<div class="card">
    <h3>Logout</h3>
    <a class="button" href="${pageContext.request.contextPath}/auth/logout">Logout</a>

</div>

</body>
</html>
