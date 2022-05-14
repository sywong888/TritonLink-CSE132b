<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reports Page</title>
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
				
				/* Reports I a */
				
				// HTML select for students enrolled in the current quarter
				PreparedStatement pstmt = conn.prepareStatement("SELECT distinct s.ssn FROM student s, enroll e WHERE s.ssn = e.ssn AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet rset = pstmt.executeQuery();
				ArrayList<String> currentStudents = new ArrayList<>();
				while (rset.next()) {
					currentStudents.add(rset.getString("ssn"));
				}
				rset.close();
				%>

				<%--Presentation Code--%>
				<h3>Report I</h3>
				<h4>a)</h4>
				<table>
					<tr>
						<th>Select student enrolled in current quarter:</th>	
					</tr>
					
					<%--Report I a--%>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-I-a" name="action">							<th><select name="SSN">
								<%  for(String ssn: currentStudents) { %>
  									 <option value="<%=ssn%>"><%=ssn%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<table>
					
					<% 
					if (action != null && action.equals("select-report-I-a")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement studentStmt = conn.prepareStatement("SELECT ssn, first_name, middle_name, last_name FROM student WHERE ssn = ?;");
						studentStmt.setString(1, ssn);
						ResultSet studentRset = studentStmt.executeQuery();
						while (studentRset.next()) {
			
							%>
							<tr>
								<th>SSN</th>
								<th>First Name</th>
								<th>Middle Name</th>
								<th>Last Name</th>
							</tr>
							<tr>
								<td><%= studentRset.getString("ssn") %></td>
								<td><%= studentRset.getString("first_name") %></td>
								<td><%= studentRset.getString("middle_name") %></td>
								<td><%= studentRset.getString("last_name") %></td>
							</tr>
							<%
						}
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.units_taken FROM enroll e, classes c WHERE e.quarter = 'SP' AND e.year = 2022 AND e.ssn = ? AND e.class_id = c.class_id;");
						classesTaken.setString(1, ssn);
						ResultSet classesRset = classesTaken.executeQuery();
						
						while (classesRset.next()) {
							%>
							<tr>
								<th>Course ID</th>
								<th>Class ID</th>
								<th>Instructor ID</th>
								<th>Quarter</th>
								<th>Year</th>
								<th>Enrollment Limit</th>
								<th>Title</th>
								<th>Units Taken</th>
							</tr>
							<tr>
								<td><%= classesRset.getString("course_id") %></td>
								<td><%= classesRset.getString("class_id") %></td>
								<td><%= classesRset.getString("instructor_id") %></td>
								<td><%= classesRset.getString("quarter") %></td>
								<td><%= classesRset.getString("year") %></td>
								<td><%= classesRset.getString("enrollment_limit") %></td>
								<td><%= classesRset.getString("title") %></td>
								<td><%= classesRset.getString("units_taken") %></td>
							</tr>
							<%
						}

						studentRset.close();
						conn.commit();
						conn.setAutoCommit(true);
					
					}
					%>
				</table>
				
			</td>
		</tr>	
	</table>
</body>
</html>