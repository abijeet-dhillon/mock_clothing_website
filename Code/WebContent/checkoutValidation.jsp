<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
    <title>Valley Vibes Apparel - Confirmation Page</title>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%
// Retrieve customer details
String custId = request.getParameter("customerId");
String pass = request.getParameter("password");
String paymentType = request.getParameter("paymentType");
String paymentNumber = request.getParameter("paymentNumber");
String expirationDate = request.getParameter("expirationDate");
String loggedInUserId = (String) session.getAttribute("authenticatedUser");
String customerPaymentType = "";
String customerPaymentNumber = "";
String customerAddress;
String customerCity;
String customerState;
String customerPostalCode;
String customerCountry;
String customerFullName;

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered and right customer id and password was entered 
try {
    getConnection();
	String sql_query = "SELECT * FROM customer WHERE customerId = ?;";
	PreparedStatement pstmt = con.prepareStatement(sql_query);
	pstmt.setString(1, custId);
	ResultSet rst = pstmt.executeQuery();
	// Display error if customer id is not in database
	if(!rst.next()) {
		out.println("ERROR: Customer ID is not found. You will be redirected in 10 seconds.");
		response.setHeader("Refresh", "10;url=http://localhost/shop/checkout.jsp");
		return;
	} else if (!rst.getString("userId").equals(loggedInUserId)) {
        out.println("ERROR: Customer ID entered is associated with another account. You will be redirected in 10 seconds.");
		response.setHeader("Refresh", "10;url=http://localhost/shop/checkout.jsp");
		return;
    } else if (!rst.getString("password").equals(pass)) {
        out.println("ERROR: Wrong password entered. You will be redirected in 10 seconds.");
		response.setHeader("Refresh", "10;url=http://localhost/shop/checkout.jsp");
		return;
    }
	// Retrieve and store customer's information for ordersummary table
	customerAddress = rst.getString("address");
	customerCity = rst.getString("city");
	customerState = rst.getString("state");
	customerPostalCode = rst.getString("postalCode");
	customerCountry = rst.getString("country");
	customerFullName = rst.getString("firstName") + " " + rst.getString("lastName");
} catch (NumberFormatException e) {
	// Display error if customer id is not a number
	out.println("ERROR: Customer ID must be a number. You will be redirected in 10 seconds.");
	response.setHeader("Refresh", "10;url=http://localhost/shop/checkout.jsp");
	return;
}

// Determine if there are products in the shopping cart
if(productList.isEmpty()) {
	// Display error if shopping cart is empty
	out.println("ERROR: Your cart is empty. You will be redirected in 10 seconds.");
	response.setHeader("Refresh", "10;url=http://localhost/shop/listprod.jsp");
	return;
}

// Insert payment info into table
try {
    // Make connection
    getConnection();
    // Insert payment information into the paymentMethod table
    String insertQuery = "INSERT INTO paymentmethod (customerId, paymentType, paymentNumber, paymentExpiryDate) VALUES (?, ?, ?, ?)";
    try (PreparedStatement preparedStatement = con.prepareStatement(insertQuery)) {
        preparedStatement.setString(1, custId);
        preparedStatement.setString(2, paymentType);
        preparedStatement.setString(3, paymentNumber);
        preparedStatement.setString(4, expirationDate);
        // Execute the query
        preparedStatement.executeUpdate();
    }
// Close the database connection
closeConnection();
} catch (SQLException e) {
    out.println(e);
}

// Print out payment info
try {
    // Establish the connection
    getConnection();
    // Retrieve customer details
    String customerQuery = "SELECT paymentType, paymentNumber FROM paymentmethod WHERE customerId = ?;";
    try (PreparedStatement customerStatement = con.prepareStatement(customerQuery)) {
        customerStatement.setString(1, custId);
        ResultSet customerResult = customerStatement.executeQuery();
        if (customerResult.next()) {
            customerPaymentType = customerResult.getString("paymentType");
            customerPaymentNumber = customerResult.getString("paymentNumber");
        }
    }
    // Close the database connection
    closeConnection();
} catch (SQLException e) {
    out.println(e);
}
%>

    <h2 style="text-align: center;">Confirm placement of order?</h2>

    <h3>Customer Details</h3>
    <p><b>Customer:</b> <%= customerFullName %></p>
    <p><b>Address:</b> <%= customerAddress %></p>
    <p><b>Payment Type:</b> <%= customerPaymentType %></p>
    <p><b>Payment Number:</b> <%= customerPaymentNumber %></p>

    <h3>Order Details</h3>
    <ul>
        <%
        if (productList != null) {
            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

            for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                String productId = entry.getKey();
                ArrayList<Object> product = entry.getValue();
                // Display product details
        %>
                <li><b>Product ID:</b> <%= productId %></li>
                <li><b>Product Name:</b> <%= product.get(1) %></li>
                <li><b>Quantity:</b> <%= product.get(3) %></li>
                <li><b>Price:</b> <%= currFormat.format(Double.parseDouble(product.get(2).toString())) %></li>
                <li><b>Subtotal:</b> <%= currFormat.format(Double.parseDouble(product.get(2).toString()) * Integer.parseInt(product.get(3).toString())) %></li><br>
        <%
            }
        }
        %>
    </ul>

    <form method="post" action="order.jsp?customerId=<%= custId %>">
        <input type="hidden" name="custId" value="<%= custId %>">
        <input type="hidden" name="customerAddress" value="<%= customerAddress %>">
        <input type="hidden" name="customerCity" value="<%= customerCity %>">
        <input type="hidden" name="customerState" value="<%= customerState %>">
        <input type="hidden" name="customerPostalCode" value="<%= customerPostalCode %>">
        <input type="hidden" name="customerCountry" value="<%= customerCountry %>">
        <input type="hidden" name="customerFullName" value="<%= customerFullName %>">
        <input type="hidden" name="customerPaymentType" value="<%= customerPaymentType %>">
        <input type="submit" value="Confirm Order">
    </form>
    
    <form method="post" action="showcart.jsp">
        <input type="submit" value="Cancel Order">
    </form>

</body>
</html>
