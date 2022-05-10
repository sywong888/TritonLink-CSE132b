<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Company home page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());
				// Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
				if (action != null && action.equals("insert")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO company VALUES (?, ?, ?)");
					
					pstmt.setString(1, request.getParameter("NAME"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("DONATION_AMOUNT")));

					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE company SET donation_amount = ? WHERE org_id = ? AND name = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DONATION_AMOUNT")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(3, request.getParameter("NAME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM company WHERE org_id = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// conn.close();
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Company Name</th>
						<th>Student Organization ID</th>
						<th>Company Donation Amount</th>
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="company.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="NAME" size="10"></th>
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="DONATION_AMOUNT" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
 					<tr>
						<form action="company.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="NAME" size="10"></th>
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="DONATION_AMOUNT" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="company.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="NAME" size="10"></th>
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="DONATION_AMOUNT" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					
					<!-- Reading in all companies that sponsor student organizations-->
					<tr>
						<th>Company Name</th>
						<th>Student Organization ID</th>
						<th>Company Donation Amount</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM company;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("name") %></td>
							<td><%= rset.getString("org_id") %></td>
							<td><%= rset.getString("donation_amount") %></td>
						</tr>
					<%
					}
					rset.close();
					conn.close();
					%>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>