<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{
    out.println("<H1>Your shopping cart is empty!</H1>");
    productList = new HashMap<String, ArrayList<Object>>();
}
else
{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<form method='post' action='updateCart.jsp'>");
    out.print("<table border='1'>");
    out.print("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th><th>Remove</th></tr>");
    double total = 0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext())
    {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        String productId = entry.getKey();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        if (product.size() < 4)
        {
            out.println("Expected product with four entries. Got: " + product);
            continue;
        }

        out.print("<tr><td>" + productId + "</td>");
        out.print("<td>" + product.get(1) + "</td>");

        // Add input field for quantity with data validation
        out.print("<td align=\"center\"><input type='number' name='quantity_" + productId + "' value='" + product.get(3) + "' min='1' required></td>");

        Object price = product.get(2);
        Object itemqty = product.get(3);
        double pr = 0;
        int qty = 0;

        try
        {
            pr = Double.parseDouble(price.toString());
        }
        catch (Exception e)
        {
            out.println("Invalid price for product: " + productId + " price: " + price);
        }
        try
        {
            qty = Integer.parseInt(itemqty.toString());
        }
        catch (Exception e)
        {
            out.println("Invalid quantity for product: " + productId + " quantity: " + qty);
        }

        out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
        out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>");
        out.print("<td><a href='removeCart.jsp?id=" + productId + "'>Remove</a></td></tr>");
        total = total + pr * qty;
    }
    out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
            + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
    out.println("</table>");
    out.println("<input type='submit' value='Update Cart'></form>");

    out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
}
%>
<h2><a href="listprod.jsp">Continue Shopping</a></h2>
</body>
</html>
