<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Product Page</title>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%
// Retrieve form data
String productName = request.getParameter("productName");
double productPrice = Double.parseDouble(request.getParameter("productPrice"));
String productDesc = request.getParameter("productDesc");
int categoryId = Integer.parseInt(request.getParameter("categoryId"));

try {
    getConnection();

    // Insert new product into the product table
    String insertProductQuery = "INSERT INTO product (productName, productPrice, productDesc, categoryId) VALUES (?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(insertProductQuery, Statement.RETURN_GENERATED_KEYS);
    pstmt.setString(1, productName);
    pstmt.setDouble(2, productPrice);
    pstmt.setString(3, productDesc);
    pstmt.setInt(4, categoryId);

    int affectedRows = pstmt.executeUpdate();

    if (affectedRows > 0) {
        // Get the generated productId
        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        if (generatedKeys.next()) {
            int productId = generatedKeys.getInt(1);

            // Display success message
            out.println("<h2>Product added successfully!</h2>");
            out.println("<p>Product ID: " + productId + "</p>");
            out.println("<p>Name: " + productName + "</p>");
            out.println("<p>Price: $" + productPrice + "</p>");
            out.println("<p>Description: " + productDesc + "</p>");
            out.println("<p>Category ID: " + categoryId + "</p>");
            response.setHeader("Refresh", "5;url=http://localhost/shop/admin.jsp");
            return;    
        }
    } else {
        // Display error message
        out.println("<h2>Error adding the product</h2>");
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
