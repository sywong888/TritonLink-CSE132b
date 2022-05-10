<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Organization Participation Page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());
				Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				// Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
				if (action != null && action.equals("insert")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO student_organization_participation VALUES (?, ?, ?)"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(2, request.getParameter("SSN"));
					pstmt.setString(3, request.getParameter("POSITION"));	
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE student_organization_participation SET position = ? WHERE org_id = ? AND ssn = ? AND position = ?;"));
					
					pstmt.setString(1, request.getParameter("NEW_POSITION"));	
					pstmt.setInt(2, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(3, request.getParameter("SSN"));
					pstmt.setString(4, request.getParameter("POSITION"));	
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM student_organization_participation WHERE org_id = ? AND ssn = ? AND position = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(2, request.getParameter("SSN"));
					pstmt.setString(3, request.getParameter("POSITION"));					
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// conn.close();
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Organization ID</th>
						<th>Student SSN</th>
						<th>Position</th>
						<th>New Position</th>
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="student_organization_participation.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="POSITION" size="10"></th>
							<th></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
 					<tr>
						<form action="student_organization_participation.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="POSITION" size="10"></th>
							<th><input value="" name="NEW_POSITION" size="10"></th>							
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="student_organization_participation.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="POSITION" size="10"></th>
							<th></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all student participation in student organizations-->
					<tr>
						<th>Organization ID</th>
						<th>Student SSN</th>
						<th>Position</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM student_organization_participation;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("org_id") %></td>
							<td><%= rset.getString("ssn") %></td>
							<td><%= rset.getString("position") %></td>
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