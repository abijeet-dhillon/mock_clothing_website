<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
// Get the current list of products from the session
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Get the product ID to remove from the request parameter
String productIdToRemove = request.getParameter("id");

if (productList != null && productIdToRemove != null) {
    // Remove the product with the specified ID from the cart
    productList.remove(productIdToRemove);

    // Update the session attribute with the modified product list
    session.setAttribute("productList", productList);
}

// Redirect back to the showcart.jsp page
String contextPath = request.getContextPath();
response.sendRedirect(contextPath + "/showcart.jsp");
%>
