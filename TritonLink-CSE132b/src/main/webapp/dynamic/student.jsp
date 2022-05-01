<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Student home page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());
				

				// Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=&password=Beartown123!");
				Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
				
				// insert student
				if (action != null && action.equals("insert-student")) {
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
						pstmt = conn.prepareStatement(("INSERT INTO phd (ssn) VALUES (?);"));
					}
 					pstmt.setString(1, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update student
				if (action != null && action.equals("update-student")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE student SET first_name = ?, middle_name = ?, last_name = ?, student_id = ?, resident_type = ?, dno = ?, enrolled = ? WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("FIRST_NAME"));
					pstmt.setString(2, request.getParameter("MIDDLE_NAME"));
					pstmt.setString(3, request.getParameter("LAST_NAME"));
					pstmt.setString(4, request.getParameter("STUDENT_ID"));
					pstmt.setString(5, request.getParameter("RESIDENT_TYPE"));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(7, request.getParameter("ENROLLED"));
					pstmt.setString(8, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete student
				if (action != null && action.equals("delete-student")) {
					conn.setAutoCommit(false);
					
					// delete from student type specific tables to avoid foreign key violations
					String studentType = request.getParameter("STUDENT_TYPE");
					
					PreparedStatement pstmt = conn.prepareStatement("");
					
 					if (studentType.equals("undergraduate")) {
						pstmt = conn.prepareStatement(("DELETE FROM undergraduate WHERE SSN = ?;"));
					} else if (studentType.equals("masters")) {
						pstmt = conn.prepareStatement(("DELETE FROM masters WHERE SSN = ?;"));
					} else {
						pstmt = conn.prepareStatement(("DELETE FROM phd WHERE SSN = ?;"));
					}
 					pstmt.setString(1, request.getParameter("SSN"));
 					
 					pstmt.executeUpdate();
 					
 					// then delete from student table
					pstmt = conn.prepareStatement(("DELETE FROM student WHERE ssn = ?;"));
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update undergraduate
				if (action != null && action.equals("update-undergraduate")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE undergraduate SET major = ?, minor = ?, college = ? WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("MAJOR"));
					pstmt.setString(2, request.getParameter("MINOR"));
					pstmt.setString(3, request.getParameter("COLLEGE"));
					pstmt.setString(4, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete undergraduate
				if (action != null && action.equals("delete-undergraduate")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM undergraduate WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update phd
				if (action != null && action.equals("update-phd")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE phd SET candidate_type = ?, advisor = ? WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("CANDIDATE_TYPE"));
					pstmt.setString(2, request.getParameter("ADVISOR"));
					pstmt.setString(3, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete phd
				if (action != null && action.equals("delete-phd")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM phd WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert prev_degree
				if (action != null && action.equals("insert-prev-degree")) {
					conn.setAutoCommit(false);
					
					// pstmt for student table
					PreparedStatement pstmt = conn.prepareStatement(("INSERT INTO prev_degree VALUES (?, ?, ?, ?);"));
			
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("UNIVERSITY"));
					pstmt.setString(3, request.getParameter("TYPE"));
					pstmt.setString(4, request.getParameter("GRADUATION_DATE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update prev_degree
				if (action != null && action.equals("update-prev-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("UPDATE prev_degree SET university = ?, type = ?, graduation_date = ? WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("UNIVERSITY"));
					pstmt.setString(2, request.getParameter("TYPE"));
					pstmt.setString(3, request.getParameter("GRADUATION_DATE"));
					pstmt.setString(4, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete phd
				if (action != null && action.equals("delete-prev-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement(("DELETE FROM prev_degree WHERE ssn = ?;"));
					
					pstmt.setString(1, request.getParameter("SSN"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				conn.close();
				%>

				<%--Presentation Code--%>
				
				<%--student table--%>
				<h3>Student Form</h3>
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
					
					<%--Insert student Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="insert-student" name="action">
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
					
					<%--Update student Code--%>
 					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="update-student" name="action">
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
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete student Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="delete-student" name="action">
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
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
				
				<%--undergraduate table--%>
				<h3>Undergraduate Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Major</th>
						<th>Minor</th>
						<th>College</th>
					</tr>
					
					<%--Update Undergraduate Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="update-undergraduate" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="MAJOR" size="10"></th>
							<th><input value="" name="MINOR" size="10"></th>
							<th><select name="COLLEGE">
								<option value="Revelle">Revelle</option>
								<option value="Muir">Muir</option>
								<option value="Marshall">Marshall</option>
								<option value="Warren">Warren</option>
								<option value="Roosevelt">ERC</option>
								<option value="Sixth">Sixth</option>
								<option value="Seventh">Seventh</option>
							</select></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete Undergraduate Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="delete-undergraduate" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="MAJOR" size="10"></th>
							<th><input value="" name="MINOR" size="10"></th>
							<th><select name="COLLEGE">
								<option value="Revelle">Revelle</option>
								<option value="Muir">Muir</option>
								<option value="Marshall">Marshall</option>
								<option value="Warren">Warren</option>
								<option value="Roosevelt">ERC</option>
								<option value="Sixth">Sixth</option>
								<option value="Seventh">Seventh</option>
							</select></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
				
				<%--phd table--%>
				<h3>PhD Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Candidate Type</th>
						<th>Advisor</th>
					</tr>
					
					<%--Update phd Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="update-phd" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><select name="CANDIDATE_TYPE">
								<option value="pre-candidacy">Pre-Candidacy</option>
								<option value="candidate">Candidate</option>
							</select></th>
							<th><input value="" name="ADVISOR" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete phd Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="delete-phd" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><select name="CANDIDATE_TYPE">
								<option value="pre-candidacy">Pre-Candidacy</option>
								<option value="candidate">Candidate</option>
							</select></th>
							<th><input value="" name="ADVISOR" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
				
				<%--prev_degree table--%>
				<h3>Previous Degree Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>University</th>
						<th>Type</th>
						<th>Graduation Date</th>
					</tr>
					
					<%--Insert prev_degree Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="insert-prev-degree" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="UNIVERSITY" size="10"></th>
							<th><input value="" name="TYPE" size="10"></th>
							<th><input value="" name="GRADUATION_DATE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update prev_degree Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="update-prev-degree" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="UNIVERSITY" size="10"></th>
							<th><input value="" name="TYPE" size="10"></th>
							<th><input value="" name="GRADUATION_DATE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete prev_degree Code--%>
					<tr>
						<form action="student.jsp" method="get">
							<input type="hidden" value="delete-prev-degree" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="UNIVERSITY" size="10"></th>
							<th><input value="" name="TYPE" size="10"></th>
							<th><input value="" name="GRADUATION_DATE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
				
			</td>
		</tr>	
	</table>
</body>
</html>