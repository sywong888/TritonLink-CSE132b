<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty home page</title>
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
				if (action != null && action.equals("insert")) {
					conn.setAutoCommit(false);
					
					// pstmt for student table
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO student VALUES (?, ?, ?, ?, ?, ?, ?, ?);"));
			
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("FIRST_NAME"));
					pstmt.setString(3, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(4, request.getParameter("LAST_NAME"));
					pstmt.setString(5, request.getParameter("STUDENT_ID"));
					pstmt.setString(6, request.getParameter("RESIDENT_TYPE"));
					pstmt.setInt(7, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(8, request.getParameter("ENROLLED"));
					
					pstmt.executeUpdate();
					
					// pstmt for student type specific tables
					String studentType = request.getParameter("STUDENT_TYPE");
					
 					if (studentType.equals("undergraduate")) {
						pstmt = conn.prepareStatement(("INSERT INTO undergraduate (ssn) VALUES (?);"));
					} else if (studentType.equals("masters")) {
						pstmt = conn.prepareStatement(("INSERT INTO masters (ssn) VALUES (?);"));
					} else {
						pstmt = conn.prepareStatement(("INSERT INTO graduate (ssn) VALUES (?);"));
					}
 					pstmt.setString(1, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
/*  				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE student SET first_name = ?, middle_name = ?, last_name = ?, ;"));
					
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("FIRST_NAME"));
					pstmt.setString(3, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(4, request.getParameter("LAST_NAME"));
					pstmt.setString(5, request.getParameter("STUDENT_ID"));
					pstmt.setString(6, request.getParameter("RESIDENT_TYPE"));
					pstmt.setInt(7, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(8, request.getParameter("ENROLLED"));
					
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				} 
				
 				if (action != null && action.equals("update")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE faculty SET first_name = ?, middle_name = ?, last_name = ?, title = ? WHERE faculty_id = ?;"));
					
					pstmt.setString(1, request.getParameter("FIRST_NAME"));
					pstmt.setString(2, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(3, request.getParameter("LAST_NAME"));
					pstmt.setString(4, request.getParameter("TITLE"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("FACULTY_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				if (action != null && action.equals("delete")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM faculty WHERE faculty_id = ?;"));
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}  */
				
				conn.close();
				%>

				<%--Presentation Code--%>
				<table>
					<tr>
						<th>SSN</th>
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
						<th>Student ID</th>
						<th>Type</th>
						<th>Resident Type</th>
						<th>Department Number</th>
						<th>Enrolled</th>
					</tr>
					
					<%--Insert Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FIRST_NAME" size="10"></th>
							<th><input value="" name="MIDDLE_NAME" size="10"></th>
							<th><input value="" name="LAST_NAME" size="10"></th>
							<th><input value="" name="STUDENT_ID" size="10"></th>
							<th><select name="STUDENT_TYPE">
								<option value="undergraduate">Undergraduate</option>
								<option value="masters">Master's</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><select name="RESIDENT_TYPE">
								<option value="California">California Resident</option>
								<option value="foreign">Foreign Student</option>
								<option value="non-CA US">non-CA US Student</option>
							</select></th>
							<th><input value="" name="DNO" size=10></th>
							<th><select name="ENROLLED">
								<option value="y">Yes</option>
								<option value="n">No</option>
							</select></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update Code--%>
 					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="insert" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FIRST_NAME" size="10"></th>
							<th><input value="" name="MIDDLE_NAME" size="10"></th>
							<th><input value="" name="LAST_NAME" size="10"></th>
							<th><input value="" name="STUDENT_ID" size="10"></th>
							<th><select name="RESIDENT_TYPE">
								<option value="California">California Resident</option>
								<option value="foreign">Foreign Student</option>
								<option value="non-CA US">non-CA US Student</option>
							</select></th>
							<th><input value="" name="DNO" size=10></th>
							<th><select name="ENROLLED">
								<option value="y">Yes</option>
								<option value="n">No</option>
							</select></th>
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
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>