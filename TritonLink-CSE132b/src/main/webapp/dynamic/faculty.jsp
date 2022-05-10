<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty Page</title>
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
				
				// insert faculty
				if (action != null && action.equals("insert")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO faculty VALUES (?, ?, ?, ?, ?, ?)"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
					pstmt.setString(2, request.getParameter("FIRST_NAME"));
					pstmt.setString(3, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(4, request.getParameter("LAST_NAME"));
					pstmt.setString(5, request.getParameter("TITLE"));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("DNO")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update faculty
				if (action != null && action.equals("update-faculty")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE faculty SET first_name = ?, middle_name = ?, last_name = ?, title = ?, dno = ? WHERE faculty_id = ?;"));
					
					pstmt.setString(1, request.getParameter("FIRST_NAME"));
					pstmt.setString(2, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(3, request.getParameter("LAST_NAME"));
					pstmt.setString(4, request.getParameter("TITLE"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("FACULTY_ID")));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("DNO")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete faculty
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					
					// delete from classes to avoid foreign key violations
 					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM classes WHERE instructor_id = ?;");
 					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
 					pstmt.executeUpdate();
 					
 					// delete from thesis_committee to avoid foreign key violations
 					pstmt = conn.prepareStatement("DELETE FROM thesis_committee WHERE faculty_id = ?;");
 					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
 					pstmt.executeUpdate();
 					
					pstmt = conn.prepareStatement(("DELETE FROM faculty WHERE faculty_id = ?;"));
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
						<th>Department Number</th>
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
							<th><input value="" name="DNO" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update Code--%>
					<tr>
						<form action="faculty.jsp" method="get">
							<input type="hidden" value="update-faculty" name="action">
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><input value="" name="FIRST_NAME" size="10"></th>
							<th><input value="" name="MIDDLE_NAME" size="10"></th>
							<th><input value="" name="LAST_NAME" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input value="" name="DNO" size="10"></th>
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
							<th><input value="" name="DNO" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<tr>
						<th>Faculty ID</th>
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
						<th>Title</th>
						<th>Department Number</th>
					</tr>
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM faculty;");
					ResultSet rset = pstmt.executeQuery();
				
					while (rset.next()) {
					%>
						
						<tr>
							<td><%= rset.getString("FACULTY_ID") %></td>
							<td><%= rset.getString("FIRST_NAME") %></td>
							<td><%= rset.getString("MIDDLE_NAME") %></td>
							<td><%= rset.getString("LAST_NAME") %></td>
							<td><%= rset.getString("TITLE") %></td>
							<td><%= rset.getString("DNO") %></td>
						</tr>
					<%
					}
					rset.close();
					%>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>