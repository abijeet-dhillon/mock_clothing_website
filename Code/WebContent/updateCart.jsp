<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Iterator" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<%
// Get the current list of products from the session
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList != null) {
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        String productId = entry.getKey();
        ArrayList<Object> product = entry.getValue();

        // Get the quantity parameter from the request
        String quantityParam = request.getParameter("quantity_" + productId);

        if (quantityParam != null) {
            try {
                int newQuantity = Integer.parseInt(quantityParam);

                // Update the quantity in the product list
                product.set(3, newQuantity);

                // If the quantity is set to 0 or less, remove the product from the cart
                if (newQuantity <= 0) {
                    iterator.remove();
                }
            } catch (NumberFormatException e) {
                // Handle the case where the quantity parameter is not a valid integer
                // You can add error handling or logging here
            }
        }
    }

    // Update the session attribute with the modified product list
    session.setAttribute("productList", productList);
}

// Redirect back to the showcart.jsp page
response.sendRedirect("showcart.jsp");
%>
