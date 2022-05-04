<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Classes Home Page</title>
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
				
				// insert classes
				if (action != null && action.equals("insert-classes")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO classes VALUES (?, ?, ?, ?, ?, ?, ?)");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("INSTRUCTOR_ID")));
					pstmt.setString(4, request.getParameter("QUARTER"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("ENROLLMENT_LIMIT")));
					pstmt.setString(7, request.getParameter("TITLE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update classes
				if (action != null && action.equals("update-classes")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE classes SET instructor_id = ?, enrollment_limit = ?, title = ? WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("INSTRUCTOR_ID")));
 					pstmt.setInt(2, Integer.parseInt(request.getParameter("ENROLLMENT_LIMIT")));
 					pstmt.setString(3, request.getParameter("TITLE")); 
					pstmt.setInt(4, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(5, request.getParameter("CLASS_ID"));
 					pstmt.setString(6, request.getParameter("QUARTER"));
					pstmt.setInt(7, Integer.parseInt(request.getParameter("YEAR")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete classes
				if (action != null && action.equals("delete-classes")) {
					conn.setAutoCommit(false);
					
					// delete meeting instances to avoid foreign key violations
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM meeting WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.executeUpdate();
					
					// delete review_session instances to avoid foreign key violations
					pstmt = conn.prepareStatement("DELETE FROM review_session WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.executeUpdate();
					
					// delete from enroll to avoid foreign key violations
 					pstmt = conn.prepareStatement("DELETE FROM enroll WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
 					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.executeUpdate();

					pstmt = conn.prepareStatement("DELETE FROM classes WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert meeting
				if (action != null && action.equals("insert-meeting")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO meeting VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setString(5, request.getParameter("DAY"));
					pstmt.setString(6, request.getParameter("TIME"));
					pstmt.setString(7, request.getParameter("ROOM"));
					pstmt.setString(8, request.getParameter("TYPE"));
					pstmt.setString(9, request.getParameter("MANDATORY"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update meeting
				if (action != null && action.equals("update-meeting")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE meeting SET mandatory = ? WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ? AND day = ? AND time = ? AND room = ? AND type = ?;");
					
					pstmt.setString(1, request.getParameter("MANDATORY"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(3, request.getParameter("CLASS_ID"));
					pstmt.setString(4, request.getParameter("QUARTER"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setString(6, request.getParameter("DAY"));
					pstmt.setString(7, request.getParameter("TIME"));
					pstmt.setString(8, request.getParameter("ROOM"));
					pstmt.setString(9, request.getParameter("TYPE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete meeting
				if (action != null && action.equals("delete-meeting")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM meeting WHERE course_id = ? AND class_id = ? AND quarter = ? AND year = ? AND day = ? AND time = ? AND room = ? AND type = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(2, request.getParameter("CLASS_ID"));
					pstmt.setString(3, request.getParameter("QUARTER"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.setString(5, request.getParameter("DAY"));
					pstmt.setString(6, request.getParameter("TIME"));
					pstmt.setString(7, request.getParameter("ROOM"));
					pstmt.setString(8, request.getParameter("TYPE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				%>

				<%--Presentation Code--%>
				<h3>Classes Form</h3>
				<table>
					<tr>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Instructor ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Enrollment Limit</th>
						<th>Title</th>
					</tr>
					<%--Insert classes Code--%>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="insert-classes" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><input value="" name="INSTRUCTOR_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="ENROLLMENT_LIMIT" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update classes Code--%>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="update-classes" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><input value="" name="INSTRUCTOR_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="ENROLLMENT_LIMIT" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete classes Code--%>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="delete-classes" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><input value="" name="INSTRUCTOR_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="ENROLLMENT_LIMIT" size="10"></th>
							<th><input value="" name="TITLE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all classes -->
					<tr>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Instructor ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Enrollment Limit</th>
						<th>Title</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM classes;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("course_id") %></td>
							<td><%= rset.getString("class_id") %></td>
							<td><%= rset.getString("instructor_id") %></td>
							<td><%= rset.getString("quarter") %></td>
							<td><%= rset.getString("year") %></td>
							<td><%= rset.getString("enrollment_limit") %></td>
							<td><%= rset.getString("title") %></td>
						</tr>
					<%
					}
					rset.close();
					%>
				</table>

				<h3>Meeting Form</h3>
				<table>
					<tr>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Day</th>
						<th>Time</th>
						<th>Room</th>
						<th>Type</th>
						<th>Mandatory</th>
					</tr>
					<%--Insert meeting Code--%>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="insert-meeting" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="DAY" size="10"></th>
							<th><input value="" name="TIME" size="10"></th>
							<th><input value="" name="ROOM" size="10"></th>
							<th><select name="TYPE">
								<option value="lecture">Lecture</option>
								<option value="discussion">Discussion</option>
								<option value="lab">Lab</option>
							</select></th>
							<th><select name="MANDATORY">
								<option value="y">Yes</option>
								<option value="n">No</option>
							</select></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update meeting Code--%>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="update-meeting" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="DAY" size="10"></th>
							<th><input value="" name="TIME" size="10"></th>
							<th><input value="" name="ROOM" size="10"></th>
							<th><select name="TYPE">
								<option value="lecture">Lecture</option>
								<option value="discussion">Discussion</option>
								<option value="lab">Lab</option>
							</select></th>
							<th><select name="MANDATORY">
								<option value="y">Yes</option>
								<option value="n">No</option>
							</select></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete meeting Code--%>
					<tr>
						<form action="classes.jsp" method="get">
							<input type="hidden" value="delete-meeting" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><select name="QUARTER">
								<option value="F">Fall</option>
								<option value="W">Winter</option>
								<option value="S">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="DAY" size="10"></th>
							<th><input value="" name="TIME" size="10"></th>
							<th><input value="" name="ROOM" size="10"></th>
							<th><select name="TYPE">
								<option value="lecture">Lecture</option>
								<option value="discussion">Discussion</option>
								<option value="lab">Lab</option>
							</select></th>
							<th><select name="MANDATORY">
								<option value="y">Yes</option>
								<option value="n">No</option>
							</select></th>
							<th><input type="submit" value="Delete"></th>
						</form>
						
					<!-- Reading in all classes -->
					<tr>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Day</th>
						<th>Time</th>
						<th>Room</th>
						<th>Type</th>
						<th>Mandatory</th>
					</tr>
					
					<%
					pstmt = conn.prepareStatement("SELECT * FROM meeting;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("course_id") %></td>
							<td><%= rset.getString("class_id") %></td>
							<td><%= rset.getString("quarter") %></td>
							<td><%= rset.getString("year") %></td>
							<td><%= rset.getString("day") %></td>
							<td><%= rset.getString("time") %></td>
							<td><%= rset.getString("room") %></td>
							<td><%= rset.getString("type") %></td>
							<td><%= rset.getString("mandatory") %></td>
							
						</tr>
					<%
					}
					rset.close();
					%>						
						
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>