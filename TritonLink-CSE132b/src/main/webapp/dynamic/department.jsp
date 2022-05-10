<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty home page</title>
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
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO department VALUES (?, ?)");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(2, request.getParameter("DNAME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE department SET dname = ? WHERE dno = ? AND dname = ?;");
					
					pstmt.setString(1, request.getParameter("NEW_DNAME"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(3, request.getParameter("OLD_DNAME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// conn.close();
				%>

				<%--Presentation Code--%>
				<h3>Department Form</h3>
				<table>
					<tr>
						<th>Department Number</th>
						<th>Department Name</th>
					</tr>
					<%--Insert department Code--%>
					<tr>
						<form action="department.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="DNAME" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>

					<tr>
						<th>Department Number</th>
						<th>Old Department Name</th>
						<th>New Department Name</th>
					</tr>
					
					<%--Update department Code--%>
 					<tr>
						<form action="department.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="OLD_DNAME" size="30"></th>
							<th><input value="" name="NEW_DNAME" size="30"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<!-- Reading in all departments-->
					<tr>
						<th>Department Number</th>
						<th>Department Name</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM department;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("dno") %></td>
							<td><%= rset.getString("dname") %></td>
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