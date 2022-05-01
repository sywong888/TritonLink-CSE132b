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

				// Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
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
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE courses SET department_number = ?, current_number = ?, old_number = ?, grading_method = ?, possible_units = ? WHERE faculty_id = ?;"));
					
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
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>Course Id</th>
						<th>Department Number</th>
						<th>Current Number</th>
						<th>Old Number</th>
						<th>Grading Method</th>
						<th>Possible Units</th>
					</tr>
					<%--Insert Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="DEPARTMENT_NUMBER" size="10"></th>
							<th><input value="" name="CURRENT_NUMBER" size="10"></th>
							<th><input value="" name="OLD_NUMBER" size="10"></th>
							<th><input value="" name="GRADING_METHOD" size="10"></th>
							<th><input value="" name="POSSIBLE_UNITS" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="update" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="DEPARTMENT_NUMBER" size="10"></th>
							<th><input value="" name="CURRENT_NUMBER" size="10"></th>
							<th><input value="" name="OLD_NUMBER" size="10"></th>
							<th><input value="" name="GRADING_METHOD" size="10"></th>
							<th><input value="" name="POSSIBLE_UNITS" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete Code--%>
					<tr>
						<form action="courses.jsp" method="get">
							<input type="hidden" value="delete" name="action">
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="DEPARTMENT_NUMBER" size="10"></th>
							<th><input value="" name="CURRENT_NUMBER" size="10"></th>
							<th><input value="" name="OLD_NUMBER" size="10"></th>
							<th><input value="" name="GRADING_METHOD" size="10"></th>
							<th><input value="" name="POSSIBLE_UNITS" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>