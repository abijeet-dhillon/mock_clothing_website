<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="jdbc.jsp"%>

<%
    String warehouseName = request.getParameter("warehouseName");

    try {
        getConnection();
        String sql = "INSERT INTO warehouse (warehouseName) VALUES (?);";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, warehouseName);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    } finally {
        closeConnection();
    }

    response.sendRedirect("admin.jsp"); // Redirect to the admin page
%>