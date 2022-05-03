<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Probation home page</title>
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
				
				// insert probation_reasons
				if (action != null && action.equals("insert-reason")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO probation_reasons VALUES (?)"));
					
					pstmt.setString(1, request.getParameter("REASON"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update probation_reasons
				if (action != null && action.equals("update-reason")) {
					conn.setAutoCommit(false);
					
					// insert new reason into probation_reasons
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO probation_reasons VALUES (?);"));
					pstmt.setString(1, request.getParameter("NEW_REASON"));
					pstmt.executeUpdate();
					
					// replace old reason with new reason in on_probation
					pstmt = conn.prepareStatement(("UPDATE on_probation SET reason = ? WHERE reason = ?;"));
					pstmt.setString(1, request.getParameter("NEW_REASON"));
					pstmt.setString(2, request.getParameter("OLD_REASON"));
					pstmt.executeUpdate();
					
					// delete old reason from probation_reasons
					pstmt = conn.prepareStatement("DELETE FROM probation_reasons WHERE reason = ?;");
					pstmt.setString(1, request.getParameter("OLD_REASON"));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete probation_reasons
				if (action != null && action.equals("delete-reason")) {
					conn.setAutoCommit(false);
					
					// delete all instances of reason from on_probation
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM on_probation WHERE reason = ?;");
					pstmt.setString(1, request.getParameter("REASON"));
					pstmt.executeUpdate();
					
					// delete reason from probation_reasons
					pstmt = conn.prepareStatement("DELETE FROM probation_reasons WHERE reason = ?;");
					pstmt.setString(1, request.getParameter("REASON"));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert on_probation
				if (action != null && action.equals("insert-on")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO on_probation VALUES (?, ?, ?)");
					
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("REASON"));
					pstmt.setString(3, request.getParameter("DATE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update on_probation
				if (action != null && action.equals("update-on")) {
					conn.setAutoCommit(false);
					
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE on_probation SET reason = ?, date = ? WHERE ssn = ?;"));
					pstmt.setString(1, request.getParameter("REASON"));
					pstmt.setString(2, request.getParameter("DATE"));
					pstmt.setString(3, request.getParameter("SSN"));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete on_probation
				if (action != null && action.equals("delete-on")) {
					conn.setAutoCommit(false);
					
					// delete all instances of reason from on_probation
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM on_probation WHERE ssn = ? AND reason = ? AND date = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("REASON"));
					pstmt.setString(3, request.getParameter("DATE"));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Probation Reasons Form</h3>
				<table>
					<tr>
						<th>Reason</th>
					</tr>
					<%--Insert probation_reasons Code--%>
					<tr>
						<form action="probation.jsp" method="get">
							<input type="hidden" value="insert-reason" name="action">
							<th><input value="" name="REASON" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Delete probation_reasons Code--%>
					<tr>
						<form action="probation.jsp" method="get">
							<input type="hidden" value="delete-reason" name="action">
							<th><input value="" name="REASON" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					<tr>
						<th>Old Reason</th>
						<th>New Reason</th>
					</tr>
					<%--Update probation_reasons Code--%>
					<tr>
						<form action="probation.jsp" method="get">
							<input type="hidden" value="update-reason" name="action">
							<th><input value="" name="OLD_REASON" size="10"></th>
							<th><input value="" name="NEW_REASON" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
				</table>
				
				<h3>Under Probation Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Reason</th>
						<th>Date</th>
					</tr>
					<%--Insert on_probation Code--%>
					<tr>
						<form action="probation.jsp" method="get">
							<input type="hidden" value="insert-on" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="REASON" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update on_probation Code--%>
					<tr>
						<form action="probation.jsp" method="get">
							<input type="hidden" value="update-on" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="REASON" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete on_probation Code--%>
					<tr>
						<form action="probation.jsp" method="get">
							<input type="hidden" value="delete-on" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="REASON" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>