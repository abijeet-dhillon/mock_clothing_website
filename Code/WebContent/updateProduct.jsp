<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="jdbc.jsp"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
</head>

<%
// Retrieve form data
int productId = Integer.parseInt(request.getParameter("productId"));
String productName = request.getParameter("newProductName");
double productPrice = Double.parseDouble(request.getParameter("newProductPrice"));
String productDesc = request.getParameter("newProductDesc");
int categoryId = Integer.parseInt(request.getParameter("newProductCategoryId"));

try {
    getConnection();

    // Update product in the product table
    String updateProductQuery = "UPDATE product SET productName = ?, productPrice = ?, productDesc = ?, categoryId = ? WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(updateProductQuery);
    pstmt.setString(1, productName);
    pstmt.setDouble(2, productPrice);
    pstmt.setString(3, productDesc);
    pstmt.setInt(4, categoryId);
    pstmt.setInt(5, productId);

    int affectedRows = pstmt.executeUpdate();

    if (affectedRows > 0) {
        // Display success message
        out.println("<h2>Product updated successfully!</h2>");
        out.println("<p>Product ID: " + productId + "</p>");
        out.println("<p>Name: " + productName + "</p>");
        out.println("<p>Price: $" + productPrice + "</p>");
        out.println("<p>Description: " + productDesc + "</p>");
        out.println("<p>Category ID: " + categoryId + "</p>");
        response.setHeader("Refresh", "5;url=http://localhost/shop/admin.jsp");
        return;    
    } else {
        // Display error message
        out.println("<h2>Error updating the product</h2>");
        response.setHeader("Refresh", "5;url=http://localhost/shop/admin.jsp");
        return;    
    }
} catch (SQLException ex) {
    out.println(ex);
} finally {
    closeConnection();
}
%>

<h2><a href="admin.jsp">Back to Admin Page</a></h2>

