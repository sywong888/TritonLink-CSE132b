<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Past Classes Page</title>
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
					
					int course_id = Integer.parseInt(request.getParameter("COURSE_ID"));
					PreparedStatement pstmt = conn.prepareStatement("SELECT co.possible_units, co.grading_method FROM classes cl, courses co WHERE cl.course_id = co.course_id AND co.course_id = ?;");
					pstmt.setInt(1, course_id);
					ResultSet courseInfo = pstmt.executeQuery();
					courseInfo.next();
					
					// user specific information
					String unitsTaken = request.getParameter("UNITS_TAKEN");
					String gradeMethodSelected = String.valueOf(request.getParameter("GRADE_OPTION"));
					
					// course specfic information
					String possibleUnits = courseInfo.getString("possible_units");
					String gradeMethod = courseInfo.getString("grading_method");
					
					// put unit options into list					
					List<String> listOfUnits = new ArrayList<String>(Arrays.asList(possibleUnits.split(",")));
						
					// Check if the user inputted values are valid
					if (listOfUnits.contains(unitsTaken) && (gradeMethod.contains(gradeMethodSelected) || gradeMethod.equals("both"))) {
						pstmt = conn.prepareStatement("INSERT INTO enroll VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'enroll', ?)");
						
						pstmt.setString(1, request.getParameter("SSN"));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
						pstmt.setString(3, request.getParameter("CLASS_TITLE"));
						pstmt.setString(4, request.getParameter("QUARTER"));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
						pstmt.setString(6, request.getParameter("SECTION_ID"));
						pstmt.setInt(7, Integer.parseInt(request.getParameter("UNITS_TAKEN")));
						pstmt.setString(8, request.getParameter("GRADE_OPTION"));
						pstmt.setString(9, request.getParameter("GRADE"));
						
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
					String gradeMethodSelected = String.valueOf(request.getParameter("GRADE_OPTION"));
					
					// course specfic information
					String possibleUnits = courseInfo.getString("possible_units");
					String gradeMethod = courseInfo.getString("grading_method");
					System.out.println(possibleUnits);
					System.out.println(gradeMethod);
					
					// put unit options into list					
					List<String> listOfUnits = new ArrayList<String>(Arrays.asList(possibleUnits.split(",")));
						
					// Check if the user inputted values are valid
					if (listOfUnits.contains(unitsTaken) && (gradeMethod.contains(gradeMethodSelected) || gradeMethod.equals("both"))) {
						pstmt = conn.prepareStatement("UPDATE enroll SET units_taken = ?, grade_option = ?, grade = ? WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
						
						pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITS_TAKEN")));
						pstmt.setString(2, request.getParameter("GRADE_OPTION"));
						pstmt.setString(3, request.getParameter("GRADE"));
						pstmt.setString(4, request.getParameter("SSN"));
						pstmt.setInt(5, Integer.parseInt(request.getParameter("COURSE_ID")));
						pstmt.setString(6, request.getParameter("CLASS_TITLE"));
						pstmt.setString(7, request.getParameter("QUARTER"));
						pstmt.setInt(8, Integer.parseInt(request.getParameter("YEAR")));
						
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
					
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM enroll WHERE ssn = ? AND course_id = ? AND class_id = ? AND quarter = ? AND year = ?;");
					pstmt.setString(1, request.getParameter("SSN"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					pstmt.setString(3, request.getParameter("CLASS_TITLE"));
					pstmt.setString(4, request.getParameter("QUARTER"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("YEAR")));
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Past Classes Form</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Course ID</th>
						<th>Class Title</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Units Taken</th>
						<th>Grade Option</th>
						<th>Grade</th>
					</tr>
					
					<%--Insert enroll Code--%>
					<tr>
						<form action="past_classes.jsp" method="get">
							<input type="hidden" value="insert-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_TITLE" size="10"></th>
							<th><select name="QUARTER">
								<option value="FA">Fall</option>
								<option value="WI">Winter</option>
								<option value="SP">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="SECTION_ID" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><select name="GRADE_OPTION">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
							</select></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update enroll Code--%>
					<tr>
						<form action="past_classes.jsp" method="get">
							<input type="hidden" value="update-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_TITLE" size="10"></th>
							<th><select name="QUARTER">
								<option value="FA">Fall</option>
								<option value="WI">Winter</option>
								<option value="SP">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="SECTION_ID" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><select name="GRADE_OPTION">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
							</select></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete enroll Code--%>
					<tr>
						<form action="past_classes.jsp" method="get">
							<input type="hidden" value="delete-enroll" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input value="" name="CLASS_TITLE" size="10"></th>
							<th><select name="QUARTER">
								<option value="FA">Fall</option>
								<option value="WI">Winter</option>
								<option value="SP">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input value="" name="SECTION_ID" size="10"></th>
							<th><input value="" name="UNITS_TAKEN" size="10"></th>
							<th><select name="GRADE_OPTION">
								<option value="letter">Letter</option>
								<option value="s/u">S/U</option>
							</select></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<tr>
						<th>SSN</th>
						<th>Course ID</th>
						<th>Class Title</th>
						<th>Quarter</th>
						<th>Year</th>
						<th>Section ID</th>
						<th>Units Taken</th>
						<th>Grade Option</th>
						<th>Grade</th>
					</tr>
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM enroll;");
					ResultSet rset = pstmt.executeQuery();
				
					while (rset.next()) {
					%>
						
						<tr>
							<td><%= rset.getString("SSN") %></td>
							<td><%= rset.getString("COURSE_ID") %></td>
							<td><%= rset.getString("CLASS_TITLE") %></td>
							<td><%= rset.getString("QUARTER") %></td>
							<td><%= rset.getString("YEAR") %></td>
							<td><%= rset.getString("SECTION_ID") %></td>
							<td><%= rset.getString("UNITS_TAKEN") %></td>
							<td><%= rset.getString("GRADE_OPTION") %></td>
							<td><%= rset.getString("GRADE") %></td>
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