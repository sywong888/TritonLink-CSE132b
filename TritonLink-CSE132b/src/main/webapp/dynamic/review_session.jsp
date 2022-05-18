<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Review Session Page</title>
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
			
				// insert review_session
				if (action != null && action.equals("insert-review")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO review_session VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_TITLE"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setString(5, request.getParameter("SECTION_ID"));
					pstmt.setString(6, request.getParameter("DATE"));
					pstmt.setString(7, request.getParameter("START_TIME"));
					pstmt.setString(8, request.getParameter("END_TIME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
/* 				// update review_session - remove because primary key is all attributes
				if (action != null && action.equals("update-review")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE review_session SET date = ?, time = ?, duration = ? WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ? AND date = ? AND time = ?;");
					
					pstmt.setString(1, request.getParameter("NEW_DATE"));
					pstmt.setString(2, request.getParameter("NEW_TIME"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("NEW_DURATION")));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(5, request.getParameter("CLASS_ID"));
					pstmt.setString(6, request.getParameter("QUARTER"));
					pstmt.setInt(7, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setString(8, request.getParameter("OLD_DATE"));
					pstmt.setString(9, request.getParameter("OLD_TIME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				} */
				
				// delete review_session
				if (action != null && action.equals("delete-review")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM review_session WHERE course_id = ? AND class_title = ? AND quarter = ? AND year = ? AND section_id = ? AND date = ? AND start_time = ? AND end_time = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_TITLE"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setString(5, request.getParameter("SECTION_ID"));
					pstmt.setString(6, request.getParameter("DATE"));
					pstmt.setString(7, request.getParameter("START_TIME"));
					pstmt.setString(8, request.getParameter("END_TIME"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Review Session Form</h3>
				<table>
					<tr>
						<th>Course ID</th>
						<th>Class Title</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Date</th>
						<th>Start Time</th>
						<th>End Time</th>
					</tr>
					
					<%--Insert review_session Code--%>
					<tr>
						<form action="review_session.jsp" method="get">
							<input type="hidden" value="insert-review" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_TITLE" size="10"></th>
							<th><select name="QUARTER">
								<option value="FA">Fall</option>
								<option value="WI">Winter</option>
								<option value="SP">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="SECTION_ID" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input value="" name="START_TIME" size="10"></th>
							<th><input value="" name="END_TIME" size="10"></th>							
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Delete review_session Code--%>
					<tr>
						<form action="review_session.jsp" method="get">
							<input type="hidden" value="delete-review" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="FA">Fall</option>
								<option value="WI">Winter</option>
								<option value="SP">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="SECTION_ID" size="10"></th>
							<th><input value="" name="DATE" size="10"></th>
							<th><input value="" name="START_TIME" size="10"></th>
							<th><input value="" name="END_TIME" size="10"></th>							
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
<%-- 					<tr>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Old Date</th>
						<th>New Date</th>
						<th>Old Time</th>
						<th>New Time</th>
						<th>New Duration</th>
					</tr>
					
					Update review_session date Code - remove because primary key is all attributes
					<tr>
						<form action="review_session.jsp" method="get">
							<input type="hidden" value="update-review" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="OLD_DATE" size="10"></th>
							<th><input value="" name="NEW_DATE" size="10"></th>
							<th><input value="" name="OLD_TIME" size="10"></th>
							<th><input value="" name="NEW_TIME" size="10"></th>
							<th><input value="" name="NEW_DURATION" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr> --%>
					
					<tr>
						<th>Course ID</th>
						<th>Class Title</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Date</th>
						<th>Start Time</th>
						<th>End Time</th>
					</tr>
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM review_session;");
					ResultSet rset = pstmt.executeQuery();
				
					while (rset.next()) {
					%>
						
						<tr>
							<td><%= rset.getString("course_id") %></td>
							<td><%= rset.getString("class_title") %></td>
							<td><%= rset.getString("quarter") %></td>
							<td><%= rset.getString("year") %></td>
							<td><%= rset.getString("section_id") %></td>
							<td><%= rset.getString("date") %></td>
							<td><%= rset.getString("start_time") %></td>
							<td><%= rset.getString("end_time") %></td>							
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