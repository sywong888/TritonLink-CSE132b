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
				
				%>
				<h3>Report I</h3>
				<h4>a)</h4>
				<h4>Students enrolled in the current quarter:</h4>
				<%
				
				// HTML select for students enrolled in the current quarter
				PreparedStatement currentStudentStmt = conn.prepareStatement("SELECT distinct s.ssn, s.first_name, s. middle_name, s.last_name FROM student s, enroll e WHERE s.ssn = e.ssn AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet currentStudentRset = currentStudentStmt.executeQuery();
				ArrayList<String> currentStudents = new ArrayList<>();
				
				while (currentStudentRset.next()) {
					currentStudents.add(currentStudentRset.getString("ssn"));
					%>
					<%--Display information for student currently enrolled--%>
					<table>
						<tr>
							<th>SSN</th>	
							<th>First Name</th>
							<th>Middle Name</th>
							<th>Last Name</th>
						</tr>
						<tr>
							<td><%= currentStudentRset.getString("ssn") %></td>
							<td><%= currentStudentRset.getString("first_name") %></td>
							<td><%= currentStudentRset.getString("middle_name") %></td>
							<td><%= currentStudentRset.getString("last_name") %></td>
						</tr>
					</table>
					<%
				}
				currentStudentRset.close();
				%>

				<%--HTML SELECT for student currently enrolled--%>
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
				
				<% 
				
				/* Reports I c */
				%>
				<h4>c)</h4>
				<h4>All students ever enrolled:</h4>
				<%
				
				// HTML select for all students ever enrolled
				PreparedStatement enrollStmt = conn.prepareStatement("SELECT distinct s.ssn, s.first_name, s.middle_name, s.last_name FROM enroll e, student s WHERE s.ssn = e.ssn;");
				ResultSet enrollRset = enrollStmt.executeQuery();
				ArrayList<String> allEnroll = new ArrayList<>();
				while (enrollRset.next()) {
					allEnroll.add(enrollRset.getString("ssn"));
					%>
					<%--Display information for all students ever enrolled--%>
					<table>
						<tr>
							<th>SSN</th>	
							<th>First Name</th>
							<th>Middle Name</th>
							<th>Last Name</th>
						</tr>
						<tr>
							<td><%= enrollRset.getString("ssn") %></td>
							<td><%= enrollRset.getString("first_name") %></td>
							<td><%= enrollRset.getString("middle_name") %></td>
							<td><%= enrollRset.getString("last_name") %></td>
						</tr>
					</table>
					<%
				}
				enrollRset.close();
				%>
				
				<table>
					<%--Report I c--%>
					<tr>
						<th>Select student that is or was enrolled:</th>	
					</tr>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-I-c" name="action">							
							<th><select name="SSN">
								<%  for(String enroll: allEnroll) { %>
  									 <option value="<%=enroll%>"><%=enroll%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<table>
					<% 
					if (action != null && action.equals("select-report-I-c")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_id = e.class_id ORDER BY e.quarter, e.year;");
						classesTaken.setString(1, ssn);
						ResultSet takenRset = classesTaken.executeQuery();
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
							<th>Grade</th>
						</tr>
						<%
						while (takenRset.next()) {	
							%>
							<tr>
								<td><%= takenRset.getString("course_id") %></td>
								<td><%= takenRset.getString("class_id") %></td>
								<td><%= takenRset.getString("instructor_id") %></td>
								<td><%= takenRset.getString("quarter") %></td>
								<td><%= takenRset.getString("year") %></td>
								<td><%= takenRset.getString("enrollment_limit") %></td>
								<td><%= takenRset.getString("title") %></td>
								<td><%= takenRset.getString("units_taken") %></td>
								<td><%= takenRset.getString("grade") %></td>
							</tr>
							<%
						}
						takenRset.close();
						
						PreparedStatement quarterStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_id = e.class_id ORDER BY e.quarter, e.year) SELECT c.quarter, c.year, AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade GROUP BY quarter, year;");
						quarterStmt.setString(1, ssn);
						ResultSet quarterRset = quarterStmt.executeQuery();
						%>
						<tr>
							<th>Quarter</th>
							<th>Year</th>
							<th>GPA</th>
						</tr>
						<%
						while (quarterRset.next()) {	
							%>
							<tr>
								<td><%= quarterRset.getString("quarter") %></td>
								<td><%= quarterRset.getString("year") %></td>
								<td><%= quarterRset.getString("average") %></td>
							</tr>
							<%
						}
						quarterRset.close();
						
						PreparedStatement cumulativeStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_id = e.class_id ORDER BY e.quarter, e.year) SELECT AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade;");
						cumulativeStmt.setString(1, ssn);
						ResultSet cumulativeRset = cumulativeStmt.executeQuery();
						%>
						<tr>
							<th>Cumulative GPA</th>
						</tr>
						<%
						while (cumulativeRset.next()) {	
							%>
							<tr>
								<td><%= cumulativeRset.getString("average") %></td>
							</tr>
							<%
						}
						cumulativeRset.close();
						
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
				</table>
				<% 
				
				/* Reports I d */
				%>
				<h4>d)</h4>
				<h4>All undergraduates currently enrolled:</h4>
				<%
				
				// HTML select for undergraduates enrolled in the current quarter
				PreparedStatement currentUndergradStmt = conn.prepareStatement("SELECT e.ssn, s.first_name, s.middle_name, s.last_name FROM student s, enroll e WHERE s.ssn = e.ssn AND (s.student_type = 'bsc' OR s.student_type = 'ba') AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet currentUndergradRset = currentUndergradStmt.executeQuery();
				ArrayList<String> currentUndergrads = new ArrayList<>();
				while (currentUndergradRset.next()) {
					currentUndergrads.add(currentUndergradRset.getString("ssn"));
					%>
					<%--Display information for all undergraduates currently enrolled--%>
					<table>
						<tr>
							<th>SSN</th>	
							<th>First Name</th>
							<th>Middle Name</th>
							<th>Last Name</th>
						</tr>
						<tr>
							<td><%= currentUndergradRset.getString("ssn") %></td>
							<td><%= currentUndergradRset.getString("first_name") %></td>
							<td><%= currentUndergradRset.getString("middle_name") %></td>
							<td><%= currentUndergradRset.getString("last_name") %></td>
						</tr>
					</table>
					<%
				}
				currentUndergradRset.close();
				
				// PreparedStatement selectId2 = conn.prepareStatement("SELECT d.dname FROM ucsd_degree u, department d WHERE degree_type = 'bsc' AND u.dno = d.dno;");
				PreparedStatement selectId2 = conn.prepareStatement("SELECT u.degree_number FROM ucsd_degree u WHERE u.degree_type = 'bsc';");
				ResultSet rsetId2 = selectId2.executeQuery();
				ArrayList<String> bscDegrees = new ArrayList<>();
				while (rsetId2.next()) {
					// bscDegrees.add(rsetId2.getString("dname"));
					bscDegrees.add(rsetId2.getString("degree_number"));
					
				}
				rsetId2.close();
				%>
			
				<table>
					<%--Report I d--%>
					<tr>
						<th>Select undergraduate enrolled in current quarter:</th>	
						<th>Select bsc degree:</th>	
					</tr>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-I-d" name="action">							
							<th><select name="SSN">
								<%  for(String undergradInfo: currentUndergrads) { %>
  									 <option value="<%=undergradInfo%>"><%=undergradInfo%></option>
  								<% } %>
							</select></th>
							<th><select name="DNAME">
								<%  for(String bscDegree: bscDegrees) { %>
  									 <option value="<%=bscDegree%>"><%=bscDegree%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<table>
					<% 
					if (action != null && action.equals("select-report-I-d")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						String dname = request.getParameter("DNAME");
						
						// PreparedStatement unitStmt = conn.prepareStatement("SELECT u.total_units FROM ucsd_degree u, department d WHERE degree_type = 'bsc' AND d.dname = ? AND d.dno = u.dno;");
						PreparedStatement unitStmt = conn.prepareStatement("SELECT u.total_units FROM ucsd_degree u WHERE u.degree_number = ?;");
						unitStmt.setInt(1, Integer.parseInt(dname));
						ResultSet unitRset = unitStmt.executeQuery();
						while (unitRset.next()) {
							%>
							<tr>
								<th>Undergraduate student must take this many units to earn the degree:</th>
							</tr>
							<tr>
								<td><%= unitRset.getString("total_units") %></td>
							</tr>
							<%
						}
						unitRset.close();
						
						PreparedStatement unitsLeft = conn.prepareStatement("WITH unitsPerCategory AS (SELECT category, number_units FROM degree_requirement WHERE degree_number = ?), coursesTaken AS (SELECT e.course_id, e.units_taken FROM enroll e WHERE e.ssn = ?), unitsTakenPerCategory AS (SELECT cr.category, SUM(units_taken) AS takenUnits FROM coursesTaken ct, category_requirements cr WHERE degree_number = ? AND ct.course_id = cr.course_id GROUP BY cr.category) (SELECT ut.category, u.number_units - ut.takenUnits AS units_left FROM unitsPerCategory u, unitsTakenPerCategory ut WHERE u.category = ut.category);");
						unitsLeft.setInt(1, Integer.parseInt(dname));
 						unitsLeft.setString(2, ssn);
						unitsLeft.setInt(3, Integer.parseInt(dname));
						ResultSet unitsLeftRset = unitsLeft.executeQuery();
						while (unitsLeftRset.next()) {
							%>
							<tr>
								<td><%= unitsLeftRset.getString("category") %></td>
								<td><%= unitsLeftRset.getString("units_left") %></td>
							</tr>
							<%
						}
						unitsLeftRset.close();
						
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
				</table>
				<%
				
				/* Reports I e */
				%>
				<h4>d)</h4>
				<h4>All master's students currently enrolled:</h4>
				<%
				
				// HTML select for master's students enrolled in the current quarter
				PreparedStatement currentMastersStmt = conn.prepareStatement("SELECT e.ssn, s.first_name, s.middle_name, s.last_name FROM student s, enroll e WHERE s.ssn = e.ssn AND s.student_type = 'masters' AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet currentMastersRset = currentMastersStmt.executeQuery();
				ArrayList<String> currentMasters = new ArrayList<>();
				%>
				
				<%
				/* Reports I e */
				%>
				<h3>Report II</h3>
				<h4>d)</h4>
				<h4>All master's students currently enrolled:</h4>
				
			</td>
		</tr>	
	</table>
</body>
</html>