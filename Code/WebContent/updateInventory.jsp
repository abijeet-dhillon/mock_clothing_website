<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>

<%
if (!authenticated) {
    String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
    session.setAttribute("loginMessage", loginMessage);
    response.sendRedirect("login.jsp"); // Redirect to login page
}
%>

<%
try {
    getConnection();

    // Retrieve parameters from the form
    String productName = request.getParameter("productName");
    String warehouseName = request.getParameter("warehouseName");
    int newQuantity = Integer.parseInt(request.getParameter("newQuantity"));

    // Update the inventory in the database
    String updateInventoryQuery = "UPDATE productinventory " +
                                  "SET quantity = ? " +
                                  "WHERE productId IN (SELECT productId FROM product WHERE productName = ?) " +
                                  "AND warehouseId IN (SELECT warehouseId FROM warehouse WHERE warehouseName = ?)";
    PreparedStatement updateInventoryStmt = con.prepareStatement(updateInventoryQuery);
    updateInventoryStmt.setInt(1, newQuantity);
    updateInventoryStmt.setString(2, productName);
    updateInventoryStmt.setString(3, warehouseName);
    updateInventoryStmt.executeUpdate();

    // Redirect back to the admin page
    response.sendRedirect("admin.jsp");

} catch (SQLException | NumberFormatException ex) {
    out.println(ex);
} finally {
    closeConnection();
}
%>
