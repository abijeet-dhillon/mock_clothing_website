<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Valley Vibes Apparel Order Processing</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<% 
// Get variables
String custId = request.getParameter("customerId");
String address = request.getParameter("customerAddress");
String city = request.getParameter("customerCity");
String state = request.getParameter("customerState");
String postalCode = request.getParameter("customerPostalCode");
String country = request.getParameter("customerCountry");
String fullName = request.getParameter("customerFullName");
String paymentType = request.getParameter("customerPaymentType");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");


// Make connection
try {
	getConnection();
} catch(SQLException ex) {
	out.println(ex);
	return;
}

// Save order information to database
try {
	String sql_query1 = "INSERT INTO ordersummary(customerId, orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES (?, GETDATE(), ?, ?, ?, ?, ?, ?);";
	PreparedStatement pstmt1 = con.prepareStatement(sql_query1, Statement.RETURN_GENERATED_KEYS);
	pstmt1.setString(1, custId);
    pstmt1.setDouble(2, 0.0);
    pstmt1.setString(3, address);
    pstmt1.setString(4, city);
    pstmt1.setString(5, state);
    pstmt1.setString(6, postalCode);
    pstmt1.setString(7, country);
	int rows_affected = pstmt1.executeUpdate();
	if(rows_affected > 0) {
		// Retrieve auto-generated id
		ResultSet keys = pstmt1.getGeneratedKeys();
		keys.next();
		int orderId = keys.getInt(1);
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
		while (iterator.hasNext()) { 
			Map.Entry<String, ArrayList<Object>> entry = iterator.next();
			ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
			int productId = Integer.parseInt((String)product.get(0));
			String price = (String) product.get(2);
			double pr = Double.parseDouble(price);
			int qty = ( (Integer)product.get(3)).intValue();
			// Insert each item into OrderProduct table using OrderId from previous INSERT
			String sql_query2 = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?);";
			PreparedStatement pstmt2 = con.prepareStatement(sql_query2);
			pstmt2.setInt(1, orderId);
            pstmt2.setInt(2, productId);
            pstmt2.setInt(3, qty);
            pstmt2.setDouble(4, pr);
            pstmt2.executeUpdate();
		}
		// Update total amount for order in ordersummary table
		String sql_query3 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?;";
		PreparedStatement pstmt3 = con.prepareStatement(sql_query3);
		pstmt3.setDouble(1, calcTotalAmount(orderId, con));
		pstmt3.setInt(2, orderId);
		pstmt3.executeUpdate();

		// Print out order summary
		out.println("<h1>Order Information</h1>");
		out.println("<strong>Order Id:</strong> "+orderId+"<br><br>");
		Iterator<Map.Entry<String, ArrayList<Object>>> iterator2 = productList.entrySet().iterator();
		while (iterator2.hasNext()) { 
			Map.Entry<String, ArrayList<Object>> entry2 = iterator2.next();
			ArrayList<Object> product2 = (ArrayList<Object>) entry2.getValue();
			String productId = (String) product2.get(0);
			String productName = (String) product2.get(1);
			String price = (String) product2.get(2);
			String qty = String.valueOf(product2.get(3));
			out.println("<strong>Product Id: </strong>"+productId+"<strong>  Product Name: </strong> "+productName+" <strong>  Price Per 1 Item: </strong> "+price+"<strong>  Quantity: </strong> "+qty+"<br><br>");
		}
		out.println("<strong>Total Amount:</strong> $"+calcTotalAmount(orderId, con)+"<br><br>");
		out.println("<strong>Customer Name:</strong> "+fullName+"<br><br>");
		Date d = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String currentDate = df.format(d);
		out.println("<strong>Date: </strong> "+currentDate+"<br><br>");

		// Clear cart if order placed successfully
		out.println("<strong>Success, your order has been placed!</strong><br><br>");
		productList.clear();
		keys.close();
	} else {
		out.println("ERROR: An unexpected error has occured in the proccessing of your order.");
	}
} catch(SQLException ex) {
	out.println(ex);
} finally {
	// Close connection
	closeConnection();
}
%>

<%!
// Method to calculate the total amount of an order
private double calcTotalAmount(int orderId, Connection con) {
	try {
		String sql_query = "SELECT SUM(quantity*price) AS totalAmountCalculated FROM orderproduct WHERE orderId = ?;";
		PreparedStatement pstmt = con.prepareStatement(sql_query);
		pstmt.setInt(1, orderId);
		ResultSet rst = pstmt.executeQuery();
		if(rst.next()) {
			return rst.getDouble("totalAmountCalculated");
		} else {
			return 0;
		}
	} catch(SQLException ex) {
		return -1;
	}
}

%>

</BODY>
</HTML>

