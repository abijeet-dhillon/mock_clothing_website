<!DOCTYPE html>
<html>
<head>
    <title>Valley Vibes Apparel</title>
    <style>
        body {
            font-family: cursive;
        }
        h1 {
            text-align: center;
            color: #3399FF;
        }
        ul.navbar {
            list-style-type: none;
            margin: 0;
            padding: 0;
            overflow: hidden;
            background-color: #f1f1f1;
        }
        ul.navbar li a {
            display: inline-block;
            text-align: center;
            padding: 14px 16px;
            text-decoration: none;
            color: #333;
        }
        ul.navbar li a:hover{
            background-color: #ddd;
        }
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>

<h1><a href="index.jsp">Valley Vibes Apparel</a></h1>
<hr>

<ul class="navbar">
        <li><a href="index.jsp">Home</a></li>
        <%
        if (session.getAttribute("authenticatedUser") != null) {
            out.println("<li><a href='customer.jsp' class='menubtn'>Account</a></li>");
            if(request.getRequestURI().endsWith("showcart.jsp") == false) {
                out.println("<li><a href='showcart.jsp' class='menubtn'>Cart</a></li>");
            }
            out.println("<li><a href='logout.jsp'>Logout</a></li>");
            out.println("<li>Logged in as " + session.getAttribute("authenticatedUser").toString() + "</li>");
        } else {
            if(request.getRequestURI().endsWith("login.jsp") == false) {
            out.println("<li><a href='login.jsp'>Login</a></li>");
            }
        }
        %>
</ul>

</body>
</html>
