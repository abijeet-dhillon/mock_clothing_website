<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%@ include file="header.jsp" %>


<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
// Check if user is logged in before accessing the page
if(!authenticated) {
    String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
    session.setAttribute("loginMessage", loginMessage);
}
%>

<%
String userName = (String) session.getAttribute("authenticatedUser");
try {
	// Make conneciton
	getConnection();
    // Execute SQL query to get customer info
	String sql_query = "SELECT * FROM customer WHERE userId = ?;";
	PreparedStatement pstmt = con.prepareStatement(sql_query);
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	out.println("<h1>Customer Profile</h1>");
	out.println("<table border='1' style='text-align: center;'>");
	while(rst.next()) {
		// TODO: Print Customer information
		out.println("<tr><th style='text-align: center; width: 110px;'>Id</th><td style='text-align: left; width: 160px;'>"+rst.getString("customerId")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>First Name</th><td style='text-align: left; width: 160px;'>"+rst.getString("firstName")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>Last Name</th><td style='text-align: left; width: 160px;'>"+rst.getString("lastName")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>Email</th><td style='text-align: left; width: 160px;'>"+rst.getString("email")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>Phone</th><td style='text-align: left; width: 160px;'>"+rst.getString("phonenum")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>Address</th><td style='text-align: left; width: 160px;'>"+rst.getString("address")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>City</th><td style='text-align: left; width: 160px;'>"+rst.getString("city")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>State</th><td style='text-align: left; width: 160px;'>"+rst.getString("state")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>Postal Code</th><td style='text-align: left; width: 160px;'>"+rst.getString("postalCode")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>Country</th><td style='text-align: left; width: 160px;'>"+rst.getString("country")+"</td></tr>");
		out.println("<tr><th style='text-align: center; width: 110px;'>User Id</th><td style='text-align: left; width: 160px;'>"+rst.getString("userid")+"</td></tr>");
	}
	out.println("</table>");
} catch (SQLException ex) {
    out.println(ex);
}
finally
{
	// Make sure to close connection
    closeConnection();
}
%>

<div style="text-align: left;">
	<p>
	<a href="editAccount.jsp">Edit Account</a>&emsp;&emsp;&emsp;&emsp;&emsp;<a href="customerOrders.jsp">Order History</a>
	</p>
</div>

</body>
</html>

