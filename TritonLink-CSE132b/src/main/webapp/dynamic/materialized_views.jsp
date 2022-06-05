<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Materialized Views Page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	<%@ page import="java.util.*" %>
	<%@ page import="java.time.*" %>
	<%@ page import="java.util.stream.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());

				Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				// Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
				
				/* Reports III a */
				%>
				<h2>Milestone 5</h2>
				<h3>Redesigned Design Support Queries for Report III</h3>
				<%
				
				// HTML select for courses, professors, quarters, years
				PreparedStatement courseStmt = conn.prepareStatement("SELECT c.course_id FROM courses c;");
				ResultSet courseRset = courseStmt.executeQuery();
				ArrayList<String> courses = new ArrayList<>();
				
				while (courseRset.next()) {
					courses.add(courseRset.getString("course_id"));
				}
				courseRset.close();
				
				PreparedStatement professorStmt = conn.prepareStatement("SELECT f.faculty_id FROM faculty f;");
				ResultSet professorRset = professorStmt.executeQuery();
				ArrayList<String> profs = new ArrayList<>();
				
				while (professorRset.next()) {
					profs.add(professorRset.getString("faculty_id"));
				}
				professorRset.close();
				%>
				
				<%--HTML SELECT--%>
				<table>
					<tr>
						<th>Course:</th>	
						<th>Professor:</th>
						<th>Quarter:</th>
						<th>Year:</th>
					</tr>
					
					<%--Report III a--%>
					<tr>
						<form action="materialized_views.jsp" method="get">
							<input type="hidden" value="mv-counts" name="action">							
							<th><select name="COURSE_ID">
								<%  for(String course: courses) { %>
  									 <option value="<%=course%>"><%=course%></option>
  								<% } %>
							</select></th>
							<th><select name="FACULTY_ID">
								<%  for(String prof: profs) { %>
  									 <option value="<%=prof%>"><%=prof%></option>
  								<% } %>
							</select></th>
							<th><select name="QUARTER">
								<option value="FA">Fall</option>
								<option value="WI">Winter</option>
								<option value="SP">Spring</option>
							</select></th>
							<th><input value="" name="YEAR" size="10"></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				
					<% 
					if (action != null && action.equals("mv-counts")) {
						conn.setAutoCommit(false);
						int course = Integer.parseInt(request.getParameter("COURSE_ID"));
						int faculty = Integer.parseInt(request.getParameter("FACULTY_ID"));
						String quarter = request.getParameter("QUARTER");
						int year = Integer.parseInt(request.getParameter("YEAR"));
						
						PreparedStatement countStmt1 = conn.prepareStatement("SELECT * FROM CPQG c WHERE c.course_id = ? AND c.instructor_id = ? AND c.quarter = ? AND c.year = ? ORDER BY grade;");
						countStmt1.setInt(1, course);
						countStmt1.setInt(2, faculty);
						countStmt1.setString(3, quarter);
						countStmt1.setInt(4, year);

						ResultSet countRset1 = countStmt1.executeQuery();
						
						%>
						<h4>Produce the count of grades that professor Y gave at quarter Z to the students taking course X:</h4>
						<table>
							<tr>
								<th>Grade</th>
								<th>Count</th>
							</tr>
						<%
						
						while (countRset1.next()) {
							%>
								<tr>
									<td><%= countRset1.getString("grade") %></td>
									<td><%= countRset1.getString("count") %></td>
								</tr>
							<%
						}
						%></table><%
						countRset1.close();
						
						PreparedStatement countStmt2 = conn.prepareStatement("SELECT * FROM CPG c WHERE c.course_id = ? AND c.instructor_id = ? ORDER BY grade;");
						countStmt2.setInt(1, course);
						countStmt2.setInt(2, faculty);
						ResultSet countRset2 = countStmt2.executeQuery();
						
						%>
						<h4>Produce the count of grades that professor Y has given for course X over the years:</h4>
						<table>
							<tr>
								<th>Grade</th>
								<th>Count</th>
							</tr>
						<%
						
						while (countRset2.next()) {
							%>
								<tr>
									<td><%= countRset2.getString("grade") %></td>
									<td><%= countRset2.getString("count") %></td>
								</tr>
							<%
						}
						%></table><%
						countRset2.close();
					}
				%>
				<h3>Insert into enroll to update CPQG and CPG</h3>
				<table>
					<tr>
						<th>SSN</th>
						<th>Class Title</th>
						<th>Section ID</th>
						<th>Grade</th>
					</tr>
					
					<tr>
						<form action="materialized_views.jsp" method="get">
							<input type="hidden" value="mv-insert" name="action">
							<th><input value="" name="SSN" size="10"></th>
							<th><input value="" name="CLASS_TITLE" size="10"></th>
							<th><input value="" name="SECTION_ID" size="10"></th>
							<th><input value="" name="GRADE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
				</table>
				
				<% 
					if (action != null && action.equals("mv-insert")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						String classTitle = request.getParameter("CLASS_TITLE");
						String section = request.getParameter("SECTION_ID");
						String grade = request.getParameter("GRADE");
						
						PreparedStatement findValues = conn.prepareStatement("SELECT s.course_id, s.quarter, s.year FROM section s WHERE s.class_title = ? AND s.section_id = ?");
						findValues.setString(1, classTitle);
						findValues.setString(2, section);
						ResultSet findValuesRset = findValues.executeQuery();
						findValuesRset.next();
						
						int course = Integer.parseInt(findValuesRset.getString("course_id"));
						String quarter = findValuesRset.getString("quarter");
						int year = Integer.parseInt(findValuesRset.getString("year"));
						
 						PreparedStatement insertEnroll = conn.prepareStatement("INSERT INTO enroll VALUES (?, ?, ?, ?, ?, ?, NULL, 'letter', 'enroll', ?)");
						insertEnroll.setString(1, ssn);
						insertEnroll.setInt(2, course);
						insertEnroll.setString(3, classTitle);
						insertEnroll.setString(4, quarter);
						insertEnroll.setInt(5, year);
						insertEnroll.setString(6, section);
						insertEnroll.setString(7, grade);
						insertEnroll.executeUpdate(); 

						findValuesRset.close();
						
						conn.commit();
						conn.setAutoCommit(true);
					}
				%>

				
			</td>
		</tr>	
	</table>
</body>
</html>