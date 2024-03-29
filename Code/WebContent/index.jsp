<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Valley Vibes Apparel Main Page</title>
  <link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>

  <header>
    <h1 align="center">Welcome to Valley Vibes Apparel</h1>
  </header>

  <nav>
    <%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName != null) {
        out.println("<h3 align=\"center\">Logged in as: " + userName + "</h3>");
        out.println("<h2 align=\"center\"><a href=\"listprod.jsp\">Begin Shopping</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"showcart.jsp\">View Cart</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"listorder.jsp\">List All Orders</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"customer.jsp\">Customer Info</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"admin.jsp\">Administrators</a></h2>");
        out.println("<h2 align=\"center\"><a href=\"logout.jsp\">Log out</a></h2>");
    } else {
      out.println("<h2 align=\"center\"><a href=\"login.jsp\">Login</a></h2>");
      out.println("<h2 align=\"center\"><a href=\"listprod.jsp\">Begin Shopping</a></h2>        ");
      out.println("<h2 align=\"center\"><a href=\"showcart.jsp\">View Cart</a></h2>");
    }
    %>
    <!-- <h2 align="center"><a href="login.jsp">Login</a></h2>
    <h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>
    <h2 align="center"><a href="showcart.jsp">View Cart</a></h2>
    <h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>
    <h2 align="center"><a href="customer.jsp">Customer Info</a></h2>
    <h2 align="center"><a href="admin.jsp">Administrators</a></h2>
    <h2 align="center"><a href="logout.jsp">Log out</a></h2> -->
<!-- 
    <h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>
    <h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4> -->
  </nav>

  <footer>
    <p align="center">&copy; 2023 Valley Vibes Apparel. All rights reserved.</p>
  </footer>

</body>
</html>
