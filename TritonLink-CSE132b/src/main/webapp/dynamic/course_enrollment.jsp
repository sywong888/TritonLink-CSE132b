<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Course Enrollment Page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	<%@ page import="java.util.*" %>
	
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
					/*
						Should throw an exception if the student is enrolling in a class for an invalid amount of units (not among the parsed values)
						or for an invalid grading option
					*/
					
					/*
						1. Find the grading options and possible units for a course
						3. Split the possible units (comma separated) into a list
						4. Check if student is enrolling with the proper grading option and # of units
					*/
					
					int course_id = Integer.parseInt(request.getParameter("COURSE_ID"));
					PreparedStatement pstmt = conn.prepareStatement("SELECT co.possible_units, co.grading_method FROM classes cl, courses co WHERE cl.course_id = co.course_id AND co.course_id = ?;");
					pstmt.setInt(1, course_id);
					ResultSet courseInfo = pstmt.executeQuery();
					courseInfo.next();
					
					// user specific information
					String unitsTaken = request.getParameter("UNITS_TAKEN");
					String gradeMethodSelected = request.getParameter("GRADING_METHOD");
					
					// course specfic information
					String possibleUnits = courseInfo.getString("possible_units");
					String gradeMethod = courseInfo.getString("grading_method");
					
					// put unit options into list					
					List<String> listOfUnits = new ArrayList<String>(Arrays.asList(possibleUnits.split(",")));
						
					// Check if the user inputted values are valid
					if (listOfUnits.contains(unitsTaken) && (gradeMethod.contains(gradeMethodSelected) || gradeMethod.equals("both"))) {
						pstmt = conn.prepareStatement("INSERT INTO enroll VALUES (?, ?, ?, 'S', 2022, ?, ?, ?, NULL)");
						
						pstmt.setString(1, request.getParameter("SSN"));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
						pstmt.setString(3, request.getParameter("CLASS_ID"));
						pstmt.setString(4, request.getParameter("UNITS_TAKEN"));
						pstmt.setString(5, request.getParameter("GRADING_METHOD"));
						pstmt.setString(6, request.getParameter("STATUS"));
							
						pstmt.executeUpdate();
							
						conn.commit();
						conn.setAutoCommit(true);
					} else {
						System.out.println("ERROR: make sure you are enrolling with the allowed number of units and grading option");
					}
				}
				
				// update enroll
				if (action != null && action.equals("update-enroll")) {
					conn.setAutoCommit(false);
					
					int course_id = Integer.parseInt(request.getParameter("COURSE_ID"));
					PreparedStatement pstmt = conn.prepareStatement("SELECT co.possible_units, co.grading_method FROM classes cl, courses co WHERE cl.course_id = co.course_id AND co.course_id = ?;");
					pstmt.setInt(1, course_id);
					ResultSet courseInfo = pstmt.executeQuery();
					courseInfo.next();
					
					// user specific information
					String unitsTaken = request.getParameter("UNITS_TAKEN");
					String gradeMethodSelected = request.getParameter("GRADING_METHOD");
					
					// course specfic information
					String possibleUnits = courseInfo.getString("possible_units");
					String gradeMethod = courseInfo.getString("grading_method");
					
					// put unit options into list					
					List<String> listOfUnits = new ArrayList<String>(Arrays.asList(possibleUnits.split(",")));
						
					// Check if the user inputted values are valid
					if (listOfUnits.contains(unitsTaken) && (gradeMethod.contains(gradeMethodSelected) || gradeMethod.equals("both"))) {
						pstmt = conn.prepareStatement("UPDATE enroll SET units_taken = ?, grade_option = ?, status = ? WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = 'S' AND year = 2022;");
						
						pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITS_TAKEN")));
						pstmt.setString(2, request.getParameter("GRADING_METHOD"));
						pstmt.setString(3, request.getParameter("STATUS"));
						pstmt.setString(4, request.getParameter("SSN"));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("COURSE_ID")));
						pstmt.setString(6, request.getParameter("CLASS_ID"));
							
						pstmt.executeUpdate();
							
						conn.commit();
						conn.setAutoCommit(true);
					} else {
						System.out.println("ERROR: make sure you are enrolling with the allowed number of units and grading option");
					}
				}
				
				// delete enroll
				if (action != null && action.equals("delete-enroll")) {
					conn.setAutoCommit(false);
					
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM enroll WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = 'S' AND year = 2022;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(3, request.getParameter("CLASS_ID"));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Course Enrollment Form</h3>
				<h4>enroll below for the current quarter (S22)</h4>
				<table>
					<tr>
						<th>SSN</th>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Units Taken</th>
						<th>Grading Method</th>
						<th>Status</th>
					</tr>
					
					<%--Insert enroll Code--%>
					<tr>
						<form action="course_enrollment.jsp" method="get">
							<input type="hidden" value="insert-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><select name="GRADING_METHOD">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
							</select></th>
							<th><select name="STATUS">
								<option value="enroll">Enroll</option>
								<option value="waitlist">Waitlist</option>
							</select></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update enroll Code--%>
					<tr>
						<form action="course_enrollment.jsp" method="get">
							<input type="hidden" value="update-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><select name="GRADING_METHOD">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
							</select></th>
							<th><select name="STATUS">
								<option value="enroll">Enroll</option>
								<option value="waitlist">Waitlist</option>
							</select></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete enroll Code--%>
					<tr>
						<form action="course_enrollment.jsp" method="get">
							<input type="hidden" value="delete-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_ID" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><select name="GRADING_METHOD">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
							</select></th>
							<th><select name="STATUS">
								<option value="enroll">Enroll</option>
								<option value="waitlist">Waitlist</option>
							</select></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all enrollments in course -->
					<tr>
						<th>SSN</th>
						<th>Course ID</th>
						<th>Class ID</th>
						<th>Units Taken</th>
						<th>Grading Method</th>
						<th>Status</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM enroll;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("ssn") %></td>
							<td><%= rset.getString("course_id") %></td>
							<td><%= rset.getString("class_id") %></td>
							<td><%= rset.getString("units_taken") %></td>
							<td><%= rset.getString("grade_option") %></td>
							<td><%= rset.getString("status") %></td>
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