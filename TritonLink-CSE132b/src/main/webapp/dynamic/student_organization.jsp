<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student Organization home page</title>
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
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO student_organization VALUES (?, ?, ?)"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(2, request.getParameter("NAME"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("YEARLY_BUDGET")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE student_organization SET name = ?, yearly_budget = ? WHERE org_id = ?;"));
					
					pstmt.setString(1, request.getParameter("NAME"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("YEARLY_BUDGET")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("ORG_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM student_organization WHERE org_id = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				conn.close();
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Organization ID</th>
						<th>Organization Name</th>
						<th>Organization Yearly Budget</th>
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="student_organization.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="NAME" size="10"></th>
							<th><input value="" name="YEARLY_BUDGET" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
 					<tr>
						<form action="student_organization.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="NAME" size="10"></th>
							<th><input value="" name="YEARLY_BUDGET" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="student_organization.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="NAME" size="10"></th>
							<th><input value="" name="YEARLY_BUDGET" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>