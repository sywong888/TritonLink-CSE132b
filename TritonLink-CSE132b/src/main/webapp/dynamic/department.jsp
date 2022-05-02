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

				Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				
				String action = request.getParameter("action");
				if (action != null && action.equals("insert")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO department VALUES (?, ?)"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(2, request.getParameter("DNAME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE department SET dname = ? WHERE dno = ?;"));
					
					pstmt.setString(1, request.getParameter("DNAME"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DNO")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM department WHERE dno = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DNO")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				conn.close();
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Department Number</th>
						<th>Department Name</th>
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="department.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="DNAME" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
 					<tr>
						<form action="department.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="DNAME" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="department.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="DNAME" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>