<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Thesis Committee Page</title>
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
				
				// insert master's thesis_committee
				if (action != null && action.equals("insert-thesis-masters")) {
					conn.setAutoCommit(false);

					// get student's type and department
					PreparedStatement pstmt = conn.prepareStatement("SELECT student_type, dno FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					String studentType = rset.getString("student_type");
					int studentDno = rset.getInt("dno");
					
					// check if all faculty are in the same department as student
					pstmt = conn.prepareStatement("SELECT dno FROM faculty WHERE faculty_id = ? OR faculty_id = ? OR faculty_id = ?");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID_1")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_2")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("FACULTY_ID_3")));
					rset = pstmt.executeQuery();
					int sameFaculty = 0;
					while(rset.next()) {
						if (rset.getInt("dno") == studentDno) {
							sameFaculty++;
						}
					}
					
					if (studentType.equals("masters") && sameFaculty == 3) {
						pstmt = conn.prepareStatement("INSERT INTO thesis_committee VALUES (?, ?, ?);");
						pstmt.setString(1, request.getParameter("SSN"));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_1")));
						pstmt.setString(3, "masters");
						pstmt.executeUpdate();
						
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_2")));
						pstmt.executeUpdate();
						
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_3")));
						pstmt.executeUpdate();
					} else {
						System.out.println("ERROR: make sure the student is a Master's student and that all faculty members are apart of the same department as the student");
					}
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert phd thesis_committee
				if (action != null && action.equals("insert-thesis-phd")) {
					conn.setAutoCommit(false);

					// get student's type and department
					PreparedStatement pstmt = conn.prepareStatement("SELECT student_type, dno FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					String studentType = rset.getString("student_type");
					int studentDno = rset.getInt("dno");
					
					// check if all faculty are in the same department as student
					pstmt = conn.prepareStatement("SELECT dno FROM faculty WHERE faculty_id = ? OR faculty_id = ? OR faculty_id = ? OR faculty_id = ?");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID_1")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_2")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("FACULTY_ID_3")));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("FACULTY_ID_4")));
					rset = pstmt.executeQuery();
					int correctFaculty = 0;
					int difFaculty = 0;
					while(rset.next()) {
						if (rset.getInt("dno") == studentDno) {
							correctFaculty++;
						} else {
							difFaculty++;
						}
					}
					
					if (studentType.equals("phd") && correctFaculty == 3 && difFaculty == 1) {
						pstmt = conn.prepareStatement("INSERT INTO thesis_committee VALUES (?, ?, ?);");
						pstmt.setString(1, request.getParameter("SSN"));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_1")));
						pstmt.setString(3, "phd");
						pstmt.executeUpdate();
						
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_2")));
						pstmt.executeUpdate();
						
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_3")));
						pstmt.executeUpdate();
						
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID_4")));
						pstmt.executeUpdate();
					} else {
						System.out.println("ERROR: make sure the student is a PhD student and that 3 faculty members are apart of the same department as the student and that 1 faculty member is apart of a different department");
					}
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update (replace) thesis_committee
				if (action != null && action.equals("update-replace")) {
					conn.setAutoCommit(false);
					
					String type = request.getParameter("TYPE");
					
					// get student's department
					PreparedStatement pstmt = conn.prepareStatement("SELECT dno FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					int studentDno = rset.getInt("dno");
					
					// new faculty dno
					pstmt = conn.prepareStatement("SELECT dno FROM faculty WHERE faculty_id = ?;");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("NEW_FACULTY_ID")));
					rset = pstmt.executeQuery();
					rset.next();
					int newFacultyDno = rset.getInt("dno");
					
					// check which departments the current faculty in the thesis committee belong to
					pstmt = conn.prepareStatement("SELECT faculty_id FROM thesis_committee WHERE ssn = ? AND type = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("TYPE"));
					rset = pstmt.executeQuery();
					
					int sameFaculty = 0;
					int difFaculty = 0;
					while(rset.next()) {
						pstmt = conn.prepareStatement("SELECT dno FROM faculty WHERE faculty_id = ?;");
						pstmt.setInt(1, rset.getInt("faculty_id"));
						ResultSet rsetDno = pstmt.executeQuery();
						rsetDno.next();
						if (rsetDno.getInt("dno") == studentDno) {
							sameFaculty++;
						} else {
							difFaculty++;
						}
						rsetDno.close();
					}
					
					if (newFacultyDno == studentDno) {
						sameFaculty--;
					} else {
						difFaculty--;
					}
					
					if (type.equals("masters") && newFacultyDno == studentDno) {
						pstmt = conn.prepareStatement("UPDATE thesis_committee SET faculty_id = ? WHERE ssn = ? AND faculty_id = ? AND type = ?;");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("NEW_FACULTY_ID")));
						pstmt.setString(2, request.getParameter("SSN"));
						pstmt.setInt(3, Integer.parseInt(request.getParameter("OLD_FACULTY_ID")));
						pstmt.setString(4, request.getParameter("TYPE"));
						pstmt.executeUpdate();
					} 
					/* same >= 3 and dif >= 1
					   same >= 3 and dif = 0 and faculty dno must be different
					   same < 3 and dif >= 1 and faculty dno must be the same
					*/
					else if (type.equals("phd") && ((sameFaculty >= 3 && difFaculty >= 1) || (difFaculty == 0 && newFacultyDno != studentDno) || (sameFaculty < 3 && newFacultyDno == studentDno))) {
						pstmt = conn.prepareStatement("UPDATE thesis_committee SET faculty_id = ? WHERE ssn = ? AND faculty_id = ? AND type = ?;");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("NEW_FACULTY_ID")));
						pstmt.setString(2, request.getParameter("SSN"));
						pstmt.setInt(3, Integer.parseInt(request.getParameter("OLD_FACULTY_ID")));
						pstmt.setString(4, request.getParameter("TYPE"));
						pstmt.executeUpdate();
					} else {
						System.out.println("ERROR: replacing a faculty member with another faculty member must not violate any thesis committee requirements");
					}
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update (add) thesis_committee
				if (action != null && action.equals("update-add")) {
					conn.setAutoCommit(false);
					
					String type = request.getParameter("TYPE");
					System.out.println(type);
					
					// get student's department
					PreparedStatement pstmt = conn.prepareStatement("SELECT dno FROM student WHERE ssn = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					ResultSet rset = pstmt.executeQuery();
					rset.next();
					int studentDno = rset.getInt("dno");
					
					// get faculty dno
					pstmt = conn.prepareStatement("SELECT dno FROM faculty WHERE faculty_id = ?;");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("FACULTY_ID")));
					rset = pstmt.executeQuery();
					rset.next();
					int facultyDno = rset.getInt("dno");
					
					if ((type.equals("masters") && studentDno == facultyDno) || type.equals("phd")) {
						pstmt = conn.prepareStatement("INSERT INTO thesis_committee VALUES(?, ?, ?);");
						pstmt.setString(1, request.getParameter("SSN"));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("FACULTY_ID")));
						pstmt.setString(3, request.getParameter("TYPE"));
						pstmt.executeUpdate();
					} else {
						System.out.println("ERROR: if you are a Master's student, make sure the faculty member is apart of the same department as you");
					}
					
					conn.commit();
					conn.setAutoCommit(true);
				}

				// delete thesis_committee
				if (action != null && action.equals("delete-thesis")) {
					conn.setAutoCommit(false);
					
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM thesis_committee WHERE ssn = ? AND type = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setString(2, request.getParameter("TYPE"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Thesis Committee Submission Form</h3>
				<h4>Insert Master's Thesis Committee</h4>
				<table>
					<tr>
						<th>SSN</th>
						<th>Faculty ID 1</th>
						<th>Faculty ID 2</th>
						<th>Faculty ID 3</th>
					</tr>
					
					<%--Insert Master's thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="insert-thesis-masters" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FACULTY_ID_1" size="10"></th>
							<th><input value="" name="FACULTY_ID_2" size="10"></th>
							<th><input value="" name="FACULTY_ID_3" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
				</table>
				
				<h4>Insert PhD Thesis Committee</h4>
				<table>
					<tr>
						<th>SSN</th>
						<th>Faculty ID 1</th>
						<th>Faculty ID 2</th>
						<th>Faculty ID 3</th>
						<th>Faculty ID 4</th>
					</tr>
					
					<%--Insert PhD thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="insert-thesis-phd" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FACULTY_ID_1" size="10"></th>
							<th><input value="" name="FACULTY_ID_2" size="10"></th>
							<th><input value="" name="FACULTY_ID_3" size="10"></th>
							<th><input value="" name="FACULTY_ID_4" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
				</table>
				
				<h4>Replace Faculty in Thesis Committee</h4>
				<table>
					<tr>
						<th>SSN</th>
						<th>Old Faculty ID</th>
						<th>New Faculty ID</th>
						<th>Type</th>
					</tr>
					
					<%--Update (replace) thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="update-replace" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="OLD_FACULTY_ID" size="10"></th>
							<th><input value="" name="NEW_FACULTY_ID" size="10"></th>
							<th><select name="TYPE">
								<option value="masters">Master's</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
				</table>
				
				<h4>Add Faculty to Thesis Committee</h4>
				<table>
					<tr>
						<th>SSN</th>
						<th>Faculty ID</th>
						<th>Type</th>
					</tr>
					
					<%--Update (add) thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="update-add" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="FACULTY_ID" size="10"></th>
							<th><select name="TYPE">
								<option value="masters">Master's</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
				</table>
				
				<h4>Delete Thesis Committee</h4>
				<table>
					<tr>
						<th>SSN</th>
						<th>Type</th>
					</tr>
					
					<%--Delete thesis_committee Code--%>
					<tr>
						<form action="thesis_committee.jsp" method="get">
							<input type="hidden" value="delete-thesis" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><select name="TYPE">
								<option value="masters">Master's</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				</table>
				
				<table>
					<tr>
						<th>SSN</th>
						<th>Faculty ID</th>
						<th>Type</th>
					</tr>
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM thesis_committee;");
					ResultSet rset = pstmt.executeQuery();
				
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("SSN") %></td>
							<td><%= rset.getString("FACULTY_ID") %></td>
							<td><%= rset.getString("TYPE") %></td>
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