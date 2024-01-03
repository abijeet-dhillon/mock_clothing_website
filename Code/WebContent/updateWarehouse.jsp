<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="jdbc.jsp"%>

<%
    int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
    String newWarehouseName = request.getParameter("newWarehouseName");

    try {
        getConnection();

        String sql = "UPDATE warehouse SET warehouseName = ? WHERE warehouseId = ?;";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, newWarehouseName);
        pstmt.setInt(2, warehouseId);

        pstmt.executeUpdate();
    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    } finally {
        closeConnection();
    }

    response.sendRedirect("admin.jsp"); // Redirect to the admin page
%>