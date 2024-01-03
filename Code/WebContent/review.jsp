<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<html>
<head>
<title>Valley Vibes Apparel - Review Confirmation</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%
String userId = (String) session.getAttribute("authenticatedUser");
String productId = request.getParameter("productId");
String reviewComment = request.getParameter("reviewComment");
int reviewRating = Integer.parseInt(request.getParameter("reviewRating"));
int custId = 0;
try {
    getConnection();
    // Get user's customerId
    String s = "select customerId from customer where userId = ?;";
    PreparedStatement p = con.prepareStatement(s);
    p.setString(1, userId);
    ResultSet r = p.executeQuery();
    if(r.next()) {
        custId = r.getInt("customerId");
    }
    // Check if the user has already submitted a review for the product
    String existingReviewQuery = "SELECT * FROM review WHERE productId = ? AND customerId = ?;";
    PreparedStatement existingReviewStmt = con.prepareStatement(existingReviewQuery);
    existingReviewStmt.setString(1, productId);
    existingReviewStmt.setInt(2, custId);
    ResultSet existingReviewResult = existingReviewStmt.executeQuery();
    if (existingReviewResult.next()) {
        // User has already submitted a review for this product
        out.println("<h2>You have already submitted a review for this product. You will be redirected in 5 seconds.</h2>");
        String pageUrl = "http://localhost/shop/product.jsp?id="+productId;
        response.setHeader("Refresh", "5;url="+pageUrl);
        return;
    } else {
        // Insert the new review into the database
        String insertReviewQuery = "INSERT INTO review (productId, customerId, reviewComment, reviewRating, reviewDate) VALUES (?, ?, ?, ?, GETDATE());";
        try (PreparedStatement insertReviewStmt = con.prepareStatement(insertReviewQuery)) {
            insertReviewStmt.setString(1, productId);
            insertReviewStmt.setInt(2, custId);
            insertReviewStmt.setString(3, reviewComment);
            insertReviewStmt.setInt(4, reviewRating);
            insertReviewStmt.executeUpdate();
            out.println("<h2>Review submitted successfully. You will be redirected in 5 seconds.</h2>");
            String pageUrl = "http://localhost/shop/product.jsp?id="+productId;
            response.setHeader("Refresh", "5;url="+pageUrl);
            return;
        }
    }
} catch (SQLException e) {
    out.println(e);
}
%>