<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp"%>

<!DOCTYPE html>
<html>
<head>
<title>Valley Vibes Apparel</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>
		
	<h1>Search for the products you want to buy:</h1>
	
	<form method="get" action="listprod.jsp">
	<input type="text" name="productName" size="50">
	<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
	</form>
	
	<% // Get product name to search for
	String name = request.getParameter("productName");
			
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
		// Make the connection
		getConnection();
		NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		// Write query to retrieve products filtered by product name
		PreparedStatement pstmt1 = null;
		if(name != null) {
			String sql_query1 = "SELECT productId, productName, productPrice FROM product WHERE productName LIKE ?;";
			pstmt1 = con.prepareStatement(sql_query1);
			pstmt1.setString(1, "%"+name+"%");
		} else {
			String sql_query1 = "SELECT productId, productName, productPrice FROM product;";
			pstmt1 = con.prepareStatement(sql_query1);
		}
		ResultSet rst1 = pstmt1.executeQuery();
		out.println("<table border='1'>");
		out.println("<tr><th style='width: 300px;'>Product Name</th><th style='width: 75px;'>Price</th><th style='width: 85px;'>Add to Cart</th></tr>");
		// Print out the ResultSet
		while(rst1.next()) {
			// For each product, print its name, price, and add to cart link
			String productId = rst1.getString("productId");
			String productName = rst1.getString("productName");
			String productPrice = rst1.getString("productPrice");
			String productPriceFormatted = currFormat.format(rst1.getDouble("productPrice"));
			String productPictureLink = "product.jsp?id="+productId;
			String addToCartLink = "addcart.jsp?id="+productId+"&name="+productName+"&price="+productPrice;
			out.println("<tr><td style='text-align: left;'><a href=\"" + productPictureLink + "\" >"+productName+"</a></td><td>"+productPriceFormatted+"</td><td style='text-align: center;'><a href=\"" + addToCartLink + "\" >Add to Cart</a></td></tr>");
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