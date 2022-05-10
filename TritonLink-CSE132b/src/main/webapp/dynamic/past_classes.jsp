<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Past Classes Page</title>
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
				
				// insert enroll
				if (action != null && action.equals("insert-enroll")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO enroll VALUES (?, ?, ?, ?, ?, ?, 'enroll', ?)");
					
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(3, request.getParameter("CLASS_ID"));
					pstmt.setString(4, request.getParameter("QUARTER"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("UNITS_TAKEN")));
					pstmt.setString(7, request.getParameter("GRADE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update enroll
				if (action != null && action.equals("update-enroll")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE enroll SET units_taken = ?, grade = ? WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITS_TAKEN")));
					pstmt.setString(2, request.getParameter("GRADE"));
					pstmt.setString(3, request.getParameter("SSN"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(5, request.getParameter("CLASS_ID"));
					pstmt.setString(6, request.getParameter("QUARTER"));
					pstmt.setInt(7, Integer.parseInt(request.getParameter("YEAR")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete enroll
				if (action != null && action.equals("delete-enroll")) {
					conn.setAutoCommit(false);
					
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM enroll WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(3, request.getParameter("CLASS_ID"));
					pstmt.setString(4, request.getParameter("QUARTER"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Past Classes Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Units Taken</th>
						<th>Grade</th>
					</tr>
					
					<%--Insert enroll Code--%>
					<tr>
						<form action="past_classes.jsp" method="get">
							<input type="hidden" value="insert-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update enroll Code--%>
					<tr>
						<form action="past_classes.jsp" method="get">
							<input type="hidden" value="update-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete enroll Code--%>
					<tr>
						<form action="past_classes.jsp" method="get">
							<input type="hidden" value="delete-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<tr>
						<th>SSN</th>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Units Taken</th>
						<th>Grade</th>
					</tr>
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM enroll;");
					ResultSet rset = pstmt.executeQuery();
				
					while (rset.next()) {
					%>
						
						<tr>
							<td><%= rset.getString("SSN") %></td>
							<td><%= rset.getString("COURSE_ID") %></td>
							<td><%= rset.getString("CLASS_ID") %></td>
							<td><%= rset.getString("QUARTER") %></td>
							<td><%= rset.getString("YEAR") %></td>
							<td><%= rset.getString("UNITS_TAKEN") %></td>
							<td><%= rset.getString("GRADE") %></td>
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