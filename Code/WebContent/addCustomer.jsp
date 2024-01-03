<%@ page import="java.sql.*" %>
<%@ page import="java.io.IOException" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ include file="jdbc.jsp"%>

<%
    String firstName = request.getParameter("newFirstName");
    String lastName = request.getParameter("newLastName");
    String email = request.getParameter("newEmail");
    String phoneNumber = request.getParameter("newPhoneNum");
    String address = request.getParameter("newAddress");
    String city = request.getParameter("newCity");
    String state = request.getParameter("newState");
    String postalCode = request.getParameter("newPostalCode");
    String country = request.getParameter("newCountry");
    String userid = request.getParameter("newUserId");
    String password = request.getParameter("newPassword");

    try {
        getConnection();

        String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, " +
        "address, city, state, postalCode, country, userid, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, phoneNumber);
        pstmt.setString(5, address);
        pstmt.setString(6, city);
        pstmt.setString(7, state);
        pstmt.setString(8, postalCode);
        pstmt.setString(9, country);
        pstmt.setString(10, userid);
        pstmt.setString(11, password);
        pstmt.executeUpdate();
    } catch (SQLException e) {
        out.println("Error: " + e.getMessage());
    } finally {
        closeConnection();
    }

    response.sendRedirect("admin.jsp"); // Redirect to the admin page
%>