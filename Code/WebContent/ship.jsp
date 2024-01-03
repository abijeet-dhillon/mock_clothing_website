<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Valley Vibes Apparel Shipment Processing</title>
<link rel="stylesheet" type="text/css" href="css/style.css" />
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id
    String orderId = request.getParameter("orderId");
	try {
		// Make connection
		getConnection();

		// TODO: Check if valid order id in database
		String sql_query1 = "SELECT * FROM ordersummary WHERE orderId = ?;";
		PreparedStatement pstmt1 = con.prepareStatement(sql_query1);
		pstmt1.setString(1, orderId);
		ResultSet rst1 = pstmt1.executeQuery();
		if(!rst1.next()) {
			out.println("<h2>ERROR: Order ID is not found in records.</h2>");
			out.println("<p>You will be redirected to the main page in 10 seconds.</p>");
			response.setHeader("Refresh", "10;url=http://localhost/shop/index.jsp");
			return;
		}

		// TODO: Start a transaction (turn-off auto-commit)
		con.setAutoCommit(false);

		// TODO: Retrieve all items in order with given id
		String sql_query2 = "SELECT * FROM orderproduct WHERE orderId = ?;";
		PreparedStatement pstmt2 = con.prepareStatement(sql_query2);
		pstmt2.setString(1, orderId);
		ResultSet rst2 = pstmt2.executeQuery();

		// TODO: Create a new shipment record.
		String sql_query3 = "INSERT INTO shipment (shipmentDate, warehouseId) VALUES (GETDATE(), 1);";
		PreparedStatement pstmt3 = con.prepareStatement(sql_query3, Statement.RETURN_GENERATED_KEYS);
		pstmt3.executeUpdate();

		// TODO: For each item verify sufficient quantity available in warehouse 1.
		while(rst2.next()) {
			// Get productid and quantity
			int productId = rst2.getInt("productId");
			int quantity = rst2.getInt("quantity");
			// Execute SQL query to get product quantity in warehouse 1
			String sql_query4 = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1;";
			PreparedStatement pstmt4 = con.prepareStatement(sql_query4);
			pstmt4.setInt(1, productId);
			ResultSet rst4 = pstmt4.executeQuery();
			// If product quantity found
			if(rst4.next()) {
				int warehouseQuantity = rst4.getInt("quantity");
				// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
				if(quantity > warehouseQuantity) {
					con.rollback();
					out.println("<h2>Shipment not processed. Insufficient inventory for product id: "+productId+"</h2>");
					out.println("<p>You will be redirected to the main page in 10 seconds.</p>");
					response.setHeader("Refresh", "10;url=http://localhost/shop/index.jsp");
					return;
				} else {
					String sql_query5 = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1;";
					PreparedStatement pstmt5 = con.prepareStatement(sql_query5);
					pstmt5.setInt(1, quantity);
					pstmt5.setInt(2, productId);
					pstmt5.executeUpdate();
					out.println("<h3>Ordered product: "+productId+" Qty: "+quantity+" Previous Quantity: "+warehouseQuantity+" New inventory: "+(warehouseQuantity-quantity)+"</h3><br>");
				}
			} else {
				// If product quantity is not found
				con.rollback();
				out.println("<h2>Shipment not processed. There is no inventory record for product of id "+productId+" this order.</h2>");
				out.println("<p>You will be redirected to the main page in 10 seconds.</p>");
				response.setHeader("Refresh", "10;url=http://localhost/shop/index.jsp");
				return;
			}
		}
		// Commit and print success message
		con.commit();
		out.println("<h2>Shipment successfully processed.</h2>");
	} catch (SQLException ex) {
    out.println(ex);
	}
	finally
	{
		// TODO: Auto-commit should be turned back on
		con.setAutoCommit(true);
		// Close connection
		closeConnection();
	}
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>
