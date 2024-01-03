<%@ include file="jdbc.jsp" %>
<%@ include file="header.jsp" %>

<html>
<head>
    <title>Valley Vibes Apparel - Checkout</title>
</head>
<body>

<%
String customerId = "";
    // Check if the user is logged in
    if (session.getAttribute("authenticatedUser") == null) {
        out.println("<h2>Must sign in to place an order, you will be redirected now.</h2>");
        response.setHeader("Refresh", "5;url=http://localhost/shop/login.jsp");
        return;
    } else {
            out.println("<h2>Please fill in the fields below to complete your transaction:</h2>");
            out.println("<form method=\"post\" action=\"checkoutValidation.jsp\">");
            out.println("<table>");
            out.println("    <!-- Existing fields -->");
            out.println("    <tr>");
            out.println("        <td align=\"right\">Customer ID:</td>");
            out.println("        <td><input type=\"text\" name=\"customerId\" size=\"20\" pattern=\"\\d+\" title=\"Customer ID is numeric.\" value=\"" + customerId + "\" required></td>");
            out.println("    </tr>");
            out.println("    <tr>");
            out.println("        <td align=\"right\">Password:</td>");
            out.println("        <td><input type=\"password\" name=\"password\" size=\"20\" required></td>");
            out.println("    </tr>");
            out.println("    <!-- Payment Information -->");
            out.println("    <tr>");
            out.println("        <td align=\"right\">Payment Type:</td>");
            out.println("        <td><input type=\"text\" name=\"paymentType\" size=\"20\" required></td>");
            out.println("    </tr>");
            out.println("    <tr>");
            out.println("        <td align=\"right\">Payment Number:</td>");
            out.println("        <td><input type=\"text\" name=\"paymentNumber\" size=\"16\" pattern=\"\\d{16}\" title=\"Payment number is 16 numbers.\" required></td>");
            out.println("    </tr>");
            out.println("    <tr>");
            out.println("        <td align=\"right\">Expiration Date:</td>");
            out.println("        <td><input type=\"text\" name=\"expirationDate\" placeholder=\"MMYY\" size=\"4\" pattern=\"\\d{4}\" title=\"Expiration date is 4 numbers.\" required></td>");
            out.println("    </tr>");
            out.println("    <tr>");
            out.println("        <td><input type=\"submit\" value=\"Submit\"></td>");
            out.println("        <td><input type=\"reset\" value=\"Reset\"></td>");
            out.println("    </tr>");
            out.println("</table>");
            out.println("</form>");            
    }
%>
</body>
</html>
