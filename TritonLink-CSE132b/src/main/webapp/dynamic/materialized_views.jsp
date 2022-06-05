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
				<h2>Redesigned Decision Support Queries</h2>
				<h3>Report III</h3>
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
							<input type="hidden" value="select-report-III-a" name="action">							
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
					if (action != null && action.equals("select-report-III-a")) {
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
				
			</td>
		</tr>	
	</table>
</body>
</html>