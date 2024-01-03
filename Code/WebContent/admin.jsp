<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
    <link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp"%>

<%
if(!authenticated) {
    String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
    session.setAttribute("loginMessage", loginMessage);
}
%>

<%
try {
    getConnection();
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    // Print out total order amount by day
    String sql_query1 = "SELECT YEAR(orderDate) AS Year, MONTH(orderDate) AS Month, DAY(orderDate) AS Day, SUM(totalAmount) AS Total FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate);";
    PreparedStatement pstmt1 = con.prepareStatement(sql_query1);
    ResultSet rst1 = pstmt1.executeQuery();

    // Set table attributes for total order amount
    out.println("<h1>Administrator Sales Report By Day</h1>");
    out.println("<table border='1'>");
    out.println("<tr><th style='width: 85px;'>Order Date</th><th style='width: 145px;'>Total Order Amount</th></tr>");

    while(rst1.next()) {
        String orderDate = rst1.getString("Year") + "-" + rst1.getString("Month") + "-" + rst1.getString("Day");
        String totalAmount = currFormat.format(rst1.getDouble("Total")); 
        out.println("<tr><td style='text-align: center;'>" + orderDate + "</td><td style='text-align: left;'>" + totalAmount + "</td></tr>");
    }
    out.println("</table>");
    // Print out item inventory by store/warehouse and be able to edit it
    String sql_query2 = "SELECT p.productName, pi.quantity, w.warehouseName " +
                   "FROM productinventory pi " +
                   "JOIN product p ON pi.productId = p.productId " +
                   "JOIN warehouse w ON pi.warehouseId = w.warehouseId";
    Statement stmt1 = con.createStatement();
    ResultSet rst2 = stmt1.executeQuery(sql_query2);

    // Set table attributes for item inventory
    out.println("<h1>Product Inventory</h1>");
    out.println("<form method='post' action='updateInventory.jsp'>");
    out.println("<table border='1'>");
    out.println("<tr><th>Product</th><th>Warehouse</th><th>Current Inventory</th><th>New Inventory</th></tr>");
    while (rst2.next()) {
        String productName = rst2.getString("productName");
        int quantity = rst2.getInt("quantity");
        String warehouseName = rst2.getString("warehouseName");
        // Query to get the current quantity for the specified product and warehouse
        String sql_query3 = "SELECT quantity FROM productinventory " +
                                    "JOIN product p ON productinventory.productId = p.productId " +
                                    "JOIN warehouse w ON productinventory.warehouseId = w.warehouseId " +
                                    "WHERE p.productName = ? AND w.warehouseName = ?";
        PreparedStatement pstmt2 = con.prepareStatement(sql_query3);
        pstmt2.setString(1, productName);
        pstmt2.setString(2, warehouseName);
        ResultSet rst3 = pstmt2.executeQuery();
        int currentQuantity = 0;
        if (rst3.next()) {
            currentQuantity = rst3.getInt("quantity");
        }
        out.println("<tr>");
        out.println("<td>" + productName + "</td>");
        out.println("<td>" + warehouseName + "</td>");
        out.println("<td>" + currentQuantity + "</td>");
        out.println("<td><input type='number' name='newQuantity' value='" + currentQuantity + "' min='0' required></td>");
        out.println("</tr>");
        out.println("<input type='hidden' name='productName' value='" + productName + "'>");
        out.println("<input type='hidden' name='warehouseName' value='" + warehouseName + "'>");
    }
    out.println("</table>");
    out.println("<input type='submit' value='Update Inventory'>");
    out.println("</form>");
    
    // List all customers
    String customerQuery = "SELECT * FROM customer";
    Statement customerStatement = con.createStatement();
    ResultSet customerResult = customerStatement.executeQuery(customerQuery); %>
    <h1>Customer List</h1>
    <table border='1'>
    <tr><th>Customer ID</th><th>Name</th><th>Email</th></tr>
    <% while (customerResult.next()) { %>
        <tr>
        <td><%= customerResult.getString("customerId") %></td>
        <td><%= customerResult.getString("firstName") + " " + customerResult.getString("lastName") %></td>
        <td><%= customerResult.getString("email") %></td>
        </tr>
    <% } %>
    </table>
    <%
    // Form to add a new product
    out.println("<form method='post' action='addProduct.jsp' style='text-align: left;'>");
    out.println("<h1>Add New Product</h1>");
    out.println("<table>");
    out.println("<tr><td><label for='productName'>Product Name:</label></td>");
    out.println("<td><input type='text' name='productName' required></td></tr>");
    out.println("<tr><td><label for='productPrice'>Product Price:</label></td>");
    out.println("<td><input type='number' name='productPrice' min='0' step='0.01' required></td></tr>");
    out.println("<tr><td><label for='productDesc'>Product Description:</label></td>");
    out.println("<td><textarea name='productDesc' rows='4' required></textarea></td></tr>");
    out.println("<tr><td><label for='categoryId'>Category ID:</label></td>");
    out.println("<td><input type='number' name='categoryId' min='1' required></td></tr>");
    out.println("</table>");
    out.println("<input type='submit' value='Add Product'>");
    out.println("</form>");
    // Update product
    out.println("<h1>Update Product</h1>");
    try {
        getConnection();
        // Fetch the list of products for the dropdown
        String productQuery = "SELECT productId, productName FROM product";
        PreparedStatement productStmt = con.prepareStatement(productQuery);
        ResultSet productResultSet = productStmt.executeQuery();
        // Form to update a product
        out.println("<form method='post' action='updateProduct.jsp'>");
        out.println("<table>");
        out.println("<tr><td><label for='productId'>Select Product:</label></td>");
        out.println("<td><select name='productId'>");
        while (productResultSet.next()) {
            out.println("<option value='" + productResultSet.getInt("productId") + "'>" + productResultSet.getString("productName") + "</option>");
        }
        out.println("</select></td></tr>");
        out.println("<tr><td><label for='newProductName'>New Product Name:</label></td>");
        out.println("<td><input type='text' name='newProductName' required></td></tr>");
        out.println("<tr><td><label for='newProductPrice'>New Product Price:</label></td>");
        out.println("<td><input type='number' name='newProductPrice' required></td></tr>");
        out.println("<tr><td><label for='newProductDesc'>New Product Desc:</label></td>");
        out.println("<td><input type='text' name='newProductDesc' required></td></tr>");
        out.println("<tr><td><label for='newProductCategoryId'>New Product Category ID:</label></td>");
        out.println("<td><input type='text' name='newProductCategoryId' required></td></tr>");
        out.println("</table>");
        out.println("<input type='submit' value='Update Product'>");
            out.println("</form>");
            
    } catch (SQLException ex) {
        out.println(ex);
    } finally {
        closeConnection();
    }
    // Dropdown to remove product
    out.println("<h1>Remove Product</h1>");
    try {
        getConnection();
        // Fetch the list of products for the dropdown
        String productQuery = "SELECT productId, productName FROM product";
        PreparedStatement productStmt = con.prepareStatement(productQuery);
        ResultSet productResultSet = productStmt.executeQuery();
        out.println("<form method='post' action='removeProduct.jsp'>");
            out.println("    <label for='productId'>Select Product:</label>");
            out.println("    <select name='productId'>");
            while (productResultSet.next()) {
                out.println("        <option value='" + productResultSet.getInt("productId") + "'>" + productResultSet.getString("productName") + "</option>");
            }
            out.println("    </select>");
            out.println("    <br>");
            out.println("    <input type='submit' value='Remove Product'>");
            out.println("</form>");
    } catch (SQLException ex) {
        out.println(ex);
    } finally {
        closeConnection();
    }
    // Add customer
    out.println("<h1>Add Customer</h1>");
    out.println("<form method='post' action='addCustomer.jsp'>");
    out.println("<table>");
    out.println("<tr><td><label for='newFirstName'>New First Name:</label></td>");
    out.println("<td><input type='text' name='newFirstName' required></td></tr>");
    out.println("<tr><td><label for='newLastName'>New Last Name:</label></td>");
    out.println("<td><input type='text' name='newLastName' required></td></tr>");
    out.println("<tr><td><label for='newEmail'>New Email:</label></td>");
    out.println("<td><input type='text' name='newEmail' required></td></tr>");
    out.println("<tr><td><label for='newPhoneNum'>New Phone Number:</label></td>");
    out.println("<td><input type='text' name='newPhoneNum' required></td></tr>");
    out.println("<tr><td><label for='newAddress'>New Address:</label></td>");
    out.println("<td><input type='text' name='newAddress' required></td></tr>");
    out.println("<tr><td><label for='newCity'>New City:</label></td>");
    out.println("<td><input type='text' name='newCity' required></td></tr>");
    out.println("<tr><td><label for='newState'>New State:</label></td>");
    out.println("<td><input type='text' name='newState' required></td></tr>");
    out.println("<tr><td><label for='newPostalCode'>New Postal Code:</label></td>");
    out.println("<td><input type='text' name='newPostalCode' required></td></tr>");
    out.println("<tr><td><label for='newCountry'>New Country:</label></td>");
    out.println("<td><input type='text' name='newCountry' required></td></tr>");
    out.println("<tr><td><label for='newUserId'>New User ID:</label></td>");
    out.println("<td><input type='text' name='newUserId' required></td></tr>");
    out.println("<tr><td><label for='newPassword'>New Password:</label></td>");
    out.println("<td><input type='text' name='newPassword' required></td></tr>");
    out.println("</table>");
    out.println("<input type='submit' value='Add Customer'>");
    out.println("</form>");    
    // Update customer
    try {
        getConnection();
        out.println("<h1>Update Customer</h1>");
        out.println("<form method='post' action='updateCustomer.jsp'>");
        out.println("<table>");
        out.println("<tr><td><label for='customerId'>Select Customer ID:</label></td>");
        out.println("<td><select name='customerId'>");
        String customerQuery2 = "SELECT customerId, firstName, lastName FROM customer";
        PreparedStatement customerStmt = con.prepareStatement(customerQuery2);;
        ResultSet customerResultSet = customerStmt.executeQuery();;
        while (customerResultSet.next()) {
            int customerId = customerResultSet.getInt("customerId");
            String customerName = customerResultSet.getString("firstName") + " " + customerResultSet.getString("lastName");
            out.println("<option value='" + customerId + "'>" + customerName + "</option>");
        }
        out.println("</select></td></tr>");
        out.println("<table>");
        out.println("<tr><td><label for='newFirstName'>New First Name:</label></td>");
        out.println("<td><input type='text' name='newFirstName' required></td></tr>");
        out.println("<tr><td><label for='newLastName'>New Last Name:</label></td>");
        out.println("<td><input type='text' name='newLastName' required></td></tr>");
        out.println("<tr><td><label for='newEmail'>New Email:</label></td>");
        out.println("<td><input type='text' name='newEmail' required></td></tr>");
        out.println("<tr><td><label for='newPhoneNum'>New Phone Number:</label></td>");
        out.println("<td><input type='text' name='newPhoneNum' required></td></tr>");
        out.println("<tr><td><label for='newAddress'>New Address:</label></td>");
        out.println("<td><input type='text' name='newAddress' required></td></tr>");
        out.println("<tr><td><label for='newCity'>New City:</label></td>");
        out.println("<td><input type='text' name='newCity' required></td></tr>");
        out.println("<tr><td><label for='newState'>New State:</label></td>");
        out.println("<td><input type='text' name='newState' required></td></tr>");
        out.println("<tr><td><label for='newPostalCode'>New Postal Code:</label></td>");
        out.println("<td><input type='text' name='newPostalCode' required></td></tr>");
        out.println("<tr><td><label for='newCountry'>New Country:</label></td>");
        out.println("<td><input type='text' name='newCountry' required></td></tr>");
        out.println("<tr><td><label for='newUserId'>New User ID:</label></td>");
        out.println("<td><input type='text' name='newUserId' required></td></tr>");
        out.println("<tr><td><label for='newPassword'>New Password:</label></td>");
        out.println("<td><input type='text' name='newPassword' required></td></tr>");
        out.println("</table>");
        out.println("<input type='submit' value='Add Customer'>");
        out.println("</form>");    
    } catch (SQLException ex) {
        out.println(ex);
    } finally {
        closeConnection();
    }
    // Add warehouse
    out.println("<h1>Add Warehouse</h1>");
    out.println("<form method='post' action='addWarehouse.jsp'>");
    out.println("<table>");
    out.println("<tr><td><label for='warehouseName'>Warehouse Name:</label></td>");
    out.println("<td><input type='text' name='warehouseName' required></td></tr>");
    out.println("</table>");
    out.println("<input type='submit' value='Add Warehouse'>");
    out.println("</form>");    
    // Update warehouse
    try {
        getConnection();
        out.println("<h1>Update Warehouse</h1>");
        out.println("<form method='post' action='updateWarehouse.jsp'>");
        out.println("<table>");
        out.println("<tr><td><label for='warehouseId'>Select Warehouse:</label></td>");
        out.println("<td><select name='warehouseId'>");
        String warehouseQuery = "SELECT warehouseId, warehouseName FROM warehouse;";
        PreparedStatement warehouseStmt = con.prepareStatement(warehouseQuery);
        ResultSet warehouseResultSet = warehouseStmt.executeQuery();
        while (warehouseResultSet.next()) {
            out.println("<option value='" + warehouseResultSet.getInt("warehouseId") + "'>" + warehouseResultSet.getString("warehouseName") + "</option>");
        }
        out.println("</select></td></tr>");
        out.println("<tr><td><label for='newWarehouseName'>New Warehouse Name:</label></td>");
        out.println("<td><input type='text' name='newWarehouseName' required></td></tr>");
        out.println("</table>");
        out.println("<input type='submit' value='Update Warehouse'>");
        out.println("</form>");        
    } catch (SQLException ex) {
        out.println(ex);
    } finally {
        closeConnection();
    }
} catch (SQLException ex) {
    out.println(ex);
} finally {
    closeConnection();
}
%>

</body>
</html>
