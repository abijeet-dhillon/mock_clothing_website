<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="jdbc.jsp"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
</head>

<%
// Retrieve form data
int productId = Integer.parseInt(request.getParameter("productId"));

try {
    getConnection();

    // Delete product from the product table
    String deleteProductQuery = "DELETE FROM product WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(deleteProductQuery);
    pstmt.setInt(1, productId);

    int affectedRows = pstmt.executeUpdate();

    if (affectedRows > 0) {
        // Display success message
        out.println("<h2>Product "+ productId +" removed successfully!</h2>");
        response.setHeader("Refresh", "5;url=http://localhost/shop/admin.jsp");
        return;    
    } else {
        // Display error message
        out.println("<h2>Error removing the product</h2>");
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