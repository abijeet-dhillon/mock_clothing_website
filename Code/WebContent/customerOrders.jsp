<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>Valley Vibes Apparel Cutomer Order List</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<h1>Your Recent Orders</h1>

<%
try {
    // Get user's usedId
    String loggedInUserId = (String) session.getAttribute("authenticatedUser");
	// Make connection
    getConnection();
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    // Get customer's customer id 
    String getCustIdQuery = "SELECT customerId FROM customer WHERE userId=?";
    PreparedStatement pstmt = con.prepareStatement(getCustIdQuery);
    pstmt.setString(1, loggedInUserId);
    String customerId = "";
    ResultSet rst = pstmt.executeQuery();
    if (rst.next()) {
        customerId = rst.getString("customerId");
    }
	// Write query to retrieve all order summary records
	String sql_query1 = "SELECT orderId, orderDate, totalAmount FROM ordersummary WHERE customerId = ?;";
	PreparedStatement pstmt1 = con.prepareStatement(sql_query1);
    pstmt1.setString(1, customerId);
	ResultSet rst1 = pstmt1.executeQuery();
	// For each order in the ResultSet
	while(rst1.next()) {
		// Print out the order summary information
		String orderId = rst1.getString("orderId");
		String orderDate = rst1.getString("orderDate");
		String totalAmount = currFormat.format(rst1.getDouble("totalAmount"));
		out.println("<table border='1'>");
		out.println("<tr><th>Order Id</th><th>Order Date</th><th>Total Amount</th></tr>");
		out.println("<tr><td>" + orderId + "</td><td>" + orderDate + "</td><td>" + totalAmount + "</td></tr>");
		out.println("</tr><table border='1'>");
		out.println("<th>Product Id</th><th>Quantity</th><th>Price</th></tr>");
		// Write a query to retrieve the products in the order
		String sql_query2 = "SELECT p.productName, op.quantity, op.price from orderproduct op join product p on op.productId = p.productId "
                            + " join ordersummary os on op.orderId = os.orderId where os.customerId = ?;";
		// Use a PreparedStatement as will repeat this query many times
		PreparedStatement pstmt2 = con.prepareStatement(sql_query2);
		pstmt2.setString(1, customerId);
		ResultSet rst2 = pstmt2.executeQuery();
		// For each product in the order
		while(rst2.next()) {
			// Write out product information 
			String productId = rst2.getString("productName");
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

