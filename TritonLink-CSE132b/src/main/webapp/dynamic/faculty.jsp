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
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO faculty VALUES (?, ?, ?, ?, ?)"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
					pstmt.setString(2, request.getParameter("FIRST_NAME"));
					pstmt.setString(3, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(4, request.getParameter("LAST_NAME"));
					pstmt.setString(5, request.getParameter("TITLE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE faculty SET first_name = ?, middle_name = ?, last_name = ?, title = ? WHERE faculty_id = ?;"));
					
					pstmt.setString(1, request.getParameter("FIRST_NAME"));
					pstmt.setString(2, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(3, request.getParameter("LAST_NAME"));
					pstmt.setString(4, request.getParameter("TITLE"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("FACULTY_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM faculty WHERE faculty_id = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Faculty ID</th>
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
						<th>Title</th>
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="faculty.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><input value="" name="FIRST_NAME" size="10"></th>
							<th><input value="" name="MIDDLE_NAME" size="10"></th>
							<th><input value="" name="LAST_NAME" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
					<tr>
						<form action="faculty.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><input value="" name="FIRST_NAME" size="10"></th>
							<th><input value="" name="MIDDLE_NAME" size="10"></th>
							<th><input value="" name="LAST_NAME" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="faculty.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><input value="" name="FIRST_NAME" size="10"></th>
							<th><input value="" name="MIDDLE_NAME" size="10"></th>
							<th><input value="" name="LAST_NAME" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>