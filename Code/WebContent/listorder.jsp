<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Valley Vibes Apparel Order List</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%@ include file="header.jsp" %>

<h1>Order List</h1>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}


try {
	// Make connection
	getConnection();
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	// Write query to retrieve all order summary records
	String sql_query1 = "SELECT o.orderId, o.orderDate, c.customerId, c.firstName, c.lastName, o.totalAmount FROM ordersummary o join customer c on o.customerId = c.customerId;";
	PreparedStatement pstmt1 = con.prepareStatement(sql_query1);
	ResultSet rst1 = pstmt1.executeQuery();
	// For each order in the ResultSet
	while(rst1.next()) {
		// Print out the order summary information
		String orderId = rst1.getString("orderId");
		String orderDate = rst1.getString("orderDate");
		String customerId = rst1.getString("customerId");
		String customerName = rst1.getString("firstName")+" "+rst1.getString("lastName");
		String totalAmount = currFormat.format(rst1.getDouble("totalAmount"));
		out.println("<table border='1'>");
		out.println("<tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
		out.println("<tr><td>" + orderId + "</td><td>" + orderDate + "</td><td>" + customerId + "</td><td>"+ customerName + "</td><td>" + totalAmount + "</td></tr>");
		out.println("</tr><table border='1'>");
		out.println("<th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
		// Write a query to retrieve the products in the order
		String sql_query2 = "SELECT op.productId, op.quantity, op.price from orderproduct op join ordersummary os on op.orderId = os.orderId where op.orderId = ?;";
		// Use a PreparedStatement as will repeat this query many times
		PreparedStatement pstmt2 = con.prepareStatement(sql_query2);
		pstmt2.setString(1, orderId);
		ResultSet rst2 = pstmt2.executeQuery();
		// For each product in the order
		while(rst2.next()) {
			// Write out product information 
			String productId = rst2.getString("productId");
			String quantity = rst2.getString("quantity");
			String price = currFormat.format(rst2.getDouble("price"));
			out.println("<tr><td>" + productId + "</td><td>" + quantity + "</td><td>"+ price + "</td></tr>");		}
	}
} catch(SQLException ex1) {
	out.println(ex1);
} finally {
	// Close connection
	closeConnection();
}

%>

</body>
</html>

