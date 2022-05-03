<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Courses Home Page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());

				Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				//Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
				if (action != null && action.equals("insert")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO courses VALUES (?, ?, ?, ?, ?, ?)"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DEPARTMENT_NUMBER")));
					pstmt.setString(3, request.getParameter("CURRENT_NUMBER"));
					pstmt.setString(4, request.getParameter("OLD_NUMBER"));
					pstmt.setString(5, request.getParameter("GRADING_METHOD"));
					pstmt.setString(6, request.getParameter("POSSIBLE_UNITS"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE courses SET dno = ?, current_number = ?, old_number = ?, grading_method = ?, possible_units = ? WHERE course_id = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEPARTMENT_NUMBER")));
					pstmt.setString(2, request.getParameter("CURRENT_NUMBER"));
					pstmt.setString(3, request.getParameter("OLD_NUMBER"));
					pstmt.setString(4, request.getParameter("GRADING_METHOD"));
					pstmt.setString(5, request.getParameter("POSSIBLE_UNITS"));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("COURSE_ID")));

					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM courses WHERE course_id = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert prerequisites
				if (action != null && action.equals("insert-prereq")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO prerequisites VALUES (?, ?)");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("PREREQ_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update prerequisites
				if (action != null && action.equals("update-prereq")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE prerequisites SET prereq_id = ? WHERE course_id = ? AND prereq_id = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("NEW_PREREQ_ID")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("OLD_PREREQ_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete prerequisites
				if (action != null && action.equals("delete-prereq")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM prerequisites WHERE course_id = ? AND prereq_id = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("PREREQ_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Courses Form</h3>
				<table>
					<tr>
						<th>Course ID</th>
						<th>Department Number</th>
						<th>Current Number</th>
						<th>Old Number</th>
						<th>Grading Method</th>
						<th>Possible Units</th>
					</tr>
					<%--Insert courses Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="DEPARTMENT_NUMBER" size="10"></th>
							<th><input value="" name="CURRENT_NUMBER" size="10"></th>
							<th><input value="" name="OLD_NUMBER" size="10"></th>
							<th><select name="GRADING_METHOD">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
								<option value="both">Both</option>
							</select></th>
							<th><input value="" name="POSSIBLE_UNITS" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update courses Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="DEPARTMENT_NUMBER" size="10"></th>
							<th><input value="" name="CURRENT_NUMBER" size="10"></th>
							<th><input value="" name="OLD_NUMBER" size="10"></th>
							<th><select name="GRADING_METHOD">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
								<option value="both">Both</option>
							</select></th>
							<th><input value="" name="POSSIBLE_UNITS" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete courses Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="DEPARTMENT_NUMBER" size="10"></th>
							<th><input value="" name="CURRENT_NUMBER" size="10"></th>
							<th><input value="" name="OLD_NUMBER" size="10"></th>
							<th><select name="GRADING_METHOD">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
								<option value="both">Both</option>
							</select></th>
							<th><input value="" name="POSSIBLE_UNITS" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all companies that sponsor student organizations-->
					<tr>
						<th>Course Id</th>
						<th>Department Number</th>
						<th>Current Number</th>
						<th>Old Number</th>
						<th>Grading Method</th>
						<th>Possible Units</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM courses;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("course_id") %></td>
							<td><%= rset.getString("dno") %></td>
							<td><%= rset.getString("current_number") %></td>
							<td><%= rset.getString("old_number") %></td>
							<td><%= rset.getString("grading_method") %></td>
							<td><%= rset.getString("possible_units") %></td>
							
						</tr>
					<%
					}
					rset.close();
					%>						
					
				</table>

				<h3>Prerequisites Form</h3>
				<table>
					<tr>
						<th>Course ID</th>
						<th>Prerequisite ID</th>
					</tr>
					<%--Insert prerequisites Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="insert-prereq" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="PREREQ_ID" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Delete prerequisites Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="delete-prereq" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="PREREQ_ID" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					<tr>
						<th>Course ID</th>
						<th>Old Prerequisite ID</th>
						<th>New Prerequisite ID</th>
					</tr>
					<%--Update prerequisites Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="update-prereq" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="OLD_PREREQ_ID" size="10"></th>
							<th><input value="" name="NEW_PREREQ_ID" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<!-- Reading in all companies that sponsor student organizations-->
					<tr>
						<th>Course ID</th>
						<th>Prerequisite ID</th>
					</tr>
					
					<%
					pstmt = conn.prepareStatement("SELECT * FROM prerequisites;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("course_id") %></td>
							<td><%= rset.getString("prereq_id") %></td>							
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