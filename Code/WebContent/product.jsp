<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Valley Vibes Apparel - Product Information</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%@ include file="header.jsp" %>

<%
// TODO: Retrieve and display info for the product
// Set variables
String productId = request.getParameter("id");
try {
	// Make the connection
    getConnection();
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    // Execute SQL query to get product info
    String sql_query = "SELECT productId, productDesc, productName, productPrice, productImageURL, productImage FROM product WHERE productId = ?;";
    PreparedStatement pstmt = con.prepareStatement(sql_query);
    pstmt.setString(1, productId);
    ResultSet rst = pstmt.executeQuery();
    if (rst.next()) {
        // Print out product name, id, and price
        String productName = rst.getString("productName");
        String productDesc = rst.getString("productDesc");
        String productPrice = rst.getString("productPrice");
        String productPriceFormatted = currFormat.format(rst.getDouble("productPrice"));
        String productImageURL = rst.getString("productImageURL");
        //byte[] productImageBin = rst.getBytes("productImage");
        out.println("<h2><strong>"+productName+"</strong></h2>");
        out.println("<p><strong>Product Description:</strong> "+productDesc+"<br><strong>Product Id:</strong> "+productId+"<br><strong>Price:</strong> "+productPriceFormatted+"</p>");
        // TODO: If there is a productImageURL, display using IMG tag
        if(productImageURL != null) {
            out.println("<img src='"+productImageURL+"' alt='"+productName+"' width=350 height=300>");
        }
//        // TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
//        if(productImageBin != null) {
//            out.println("<img src='displayImage.jsp?id="+productId+"' alt='"+productName+"'>");
//        }
        // TODO: Add links to Add to Cart and Continue Shopping
        out.println("<h3><a href='addcart.jsp?id="+productId+"&name="+productName+"&price="+productPrice+"'>Add to Cart</a></h3>");
        out.println("<h3><a href='listprod.jsp'>Browse Other Items</a></h3>");
    } else {
        out.println("<p>Product not found</p>");
    }
    out.println("<h3>Product Reviews:</h3>");
    String customerId = "";
    String reviewComment = "";
    int reviewRating = 0;
    String reviewDate = "";
    // Retrieve and display reviews for the product
    String reviewQuery = "SELECT customerId, reviewComment, reviewRating, reviewDate FROM review WHERE productId = ?;";
    PreparedStatement reviewStmt = con.prepareStatement(reviewQuery);
    reviewStmt.setString(1, productId);
    ResultSet reviewResult = reviewStmt.executeQuery();
    while (reviewResult.next()) {
        customerId = reviewResult.getString("customerId");
        reviewComment = reviewResult.getString("reviewComment");
        reviewRating = reviewResult.getInt("reviewRating");
        reviewDate = reviewResult.getString("reviewDate");
        out.println("<p><strong>Customer "+customerId+":</strong>"+reviewComment+" (Rating: "+reviewRating+") (Date: "+reviewDate+")</p>");
    }
} catch(SQLException ex) {
	out.println(ex);
} finally {
	closeConnection();
}
%>

<!-- Form to submit a new review -->
<h3>Submit a Review:</h3>
<form method="post" action="review.jsp">
    <input type="hidden" name="productId" value="<%= productId %>">
    <textarea name="reviewComment" rows="4" cols="50" placeholder="Enter your review" required></textarea><br>
    <label for="reviewRating">Rating:</label>
    <select name="reviewRating" id="reviewRating" required>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
    </select> &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp;
    <input type="submit" value="Submit Review">
</form>

</body>
</html>

