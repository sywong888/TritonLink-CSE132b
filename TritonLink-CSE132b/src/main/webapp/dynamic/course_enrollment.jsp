<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Classes Home Page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	<%@ page import="java.util.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());

				// Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
				
				// insert enroll
				if (action != null && action.equals("insert-enroll")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO enroll VALUES (?, ?, ?, 'S', 2022, ?, ?, NULL)");
					
					
					/*
						Trying to insert a class based on existing course
						Should throw an exception if the student is taking the class for an invalid amount of units (not among the parsed values)
					*/
					
					/*
						1. Get the relation of course that matches the class
						2. Get the possible_units attribute of the relation
						3. Spit it into its values
						4. Logic to check if the user inputted value is valid
					*/
					
					String courseUnitsQuery = "SELECT co.possible_units FROM classes cl, courses co WHERE cl.course_id = co.course_id";
					PreparedStatement unitsStatement = conn.prepareStatement(courseUnitsQuery);
					ResultSet possibleUnitsTuple = unitsStatement.executeQuery();
					
					String unitsTaken = request.getParameter("UNITS_TAKEN");
					
					// Check that there is a matching row from the query
					if (possibleUnitsTuple.next()) {
						String possibleUnits = possibleUnitsTuple.getString("possible_units");
						// Should get comma-separated values of units					
						List<String> listOfUnits = new ArrayList<String>(Arrays.asList(possibleUnits.split(",")));
						
						// Check if the user inputted value is valid
						if (listOfUnits.contains(unitsTaken)) {
							pstmt.setString(1, request.getParameter("SSN"));
							pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
							pstmt.setString(3, request.getParameter("CLASS_ID"));
							pstmt.setString(4, request.getParameter("UNITS_TAKEN"));
							pstmt.setString(5, request.getParameter("STATUS"));
							
							pstmt.executeUpdate();
							
							conn.commit();
							conn.setAutoCommit(true);
						}
						else {
							System.out.println("WRONG WRONG WRONG WRONG WRONG WRONG WRONG WRONG WRONG");
						}
					}
					else {
						System.out.println("No matches");
					}


				}
				
				// update enroll
				if (action != null && action.equals("update-enroll")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE enroll SET units_taken = ?, status = ? WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = 'S' AND year = 2022;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITS_TAKEN")));
					pstmt.setString(2, request.getParameter("STATUS"));
					pstmt.setString(3, request.getParameter("SSN"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(5, request.getParameter("CLASS_ID"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
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
						<th>Status</th>
						<th></th>
						<th></th>
						<th></th>
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