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
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO event VALUES (?, ?, ?, ?, ?)");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(2, request.getParameter("TITLE"));
					pstmt.setString(3, request.getParameter("DATE"));
					pstmt.setString(4, request.getParameter("TIME"));
					pstmt.setString(5, request.getParameter("LOCATION"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE event SET title = ?, date = ?, time = ?, location = ? WHERE org_id = ? AND title = ? AND date = ?;"));
					
					
					pstmt.setString(1, request.getParameter("NEW_TITLE"));
					pstmt.setString(2, request.getParameter("NEW_DATE"));					
					pstmt.setString(3, request.getParameter("NEW_TIME"));
					pstmt.setString(4, request.getParameter("NEW_LOCATION"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(6, request.getParameter("TITLE"));
					pstmt.setString(7, request.getParameter("DATE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM event WHERE org_id = ? AND title = ? AND date = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("ORG_ID")));
					pstmt.setString(2, request.getParameter("TITLE"));
					pstmt.setString(3, request.getParameter("DATE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				conn.close();
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Student Organization ID</th>
						<th>Event Name</th>
						<th>Event Date</th>
						<th>Event Time</th>
						<th>Event Location</th> 
						<th>New Event Name</th>
						<th>New Event Date</th>
						<th>New Event Time</th>
						<th>New Event Location</th>
					
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="event.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input value="" name="TIME" size="10"></th>
							<th><input value="" name="LOCATION" size="10"></th>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
 					<tr>
						<form action="event.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input value="" name="TIME" size="10"></th>
							<th><input value="" name="LOCATION" size="10"></th>
							<th><input value="" name="NEW_TITLE" size="10"></th>
							<th><input value="" name="NEW_DATE" size="10"></th>
							<th><input value="" name="NEW_TIME" size="10"></th>
							<th><input value="" name="NEW_LOCATION" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="event.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="ORG_ID" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input value="" name="TIME" size="10"></th>
							<th><input value="" name="LOCATION" size="10"></th>
							<th></th>
							<th></th>
							<th></th>
							<th></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>