<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thesis Committee Submission Page</title>
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
			
				// insert thesis_committee
				if (action != null && action.equals("insert-thesis")) {
					conn.setAutoCommit(false);
					
					// determine what type of student matches the ssn
					PreparedStatement pstmt = conn.prepareStatement("SELECT student_type FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					String student_type = rset.getString("student_type");
					
					pstmt = conn.prepareStatement("INSERT INTO thesis_committee VALUES (?, ?, ?);");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID")));
					pstmt.setString(3, student_type);
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update thesis_committee
				if (action != null && action.equals("update-thesis")) {
					conn.setAutoCommit(false);
					
					// determine what type of student matches the ssn
					PreparedStatement pstmt = conn.prepareStatement("SELECT student_type FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					String student_type = rset.getString("student_type");
					
					pstmt = conn.prepareStatement("UPDATE thesis_committee SET faculty_id = ? WHERE ssn = ? AND faculty_id = ? AND type = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("NEW_FACULTY_ID")));
					pstmt.setString(2, request.getParameter("SSN"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("OLD_FACULTY_ID")));
					pstmt.setString(4, student_type);
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete thesis_committee
				if (action != null && action.equals("delete-thesis")) {
					conn.setAutoCommit(false);
					
					// determine what type of student matches the ssn
					PreparedStatement pstmt = conn.prepareStatement("SELECT student_type FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					String student_type = rset.getString("student_type");
					
					pstmt = conn.prepareStatement("DELETE FROM thesis_committee WHERE ssn = ? AND faculty_id = ? AND type = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID")));
					pstmt.setString(3, student_type);
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Thesis Committee Submission Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Faculty ID</th>
					</tr>
					<%--Insert thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="insert-thesis" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Delete thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="delete-thesis" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					<tr>
						<th>SSN</th>
						<th>Old Faculty ID</th>
						<th>New Faculty ID</th>
					</tr>
					<%--Update thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="update-thesis" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="OLD_FACULTY_ID" size="10"></th>
							<th><input value="" name="NEW_FACULTY_ID" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>