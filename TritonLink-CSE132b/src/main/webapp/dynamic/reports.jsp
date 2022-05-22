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
							<input type="hidden" value="select-report-I-a" name="action">							
							<th><select name="SSN">
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
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.section_id, e.units_taken FROM enroll e, classes c WHERE e.quarter = 'SP' AND e.year = 2022 AND e.ssn = ? AND e.class_title = c.class_title;");
						classesTaken.setString(1, ssn);
						ResultSet classesRset = classesTaken.executeQuery();
						
						while (classesRset.next()) {
							%>
							<tr>
								<th>Course ID</th>
								<th>Class Title</th>
								<th>Quarter</th>
								<th>Year</th>
								<th>Title</th>
								<th>Units Taken</th>
							</tr>
							<tr>
								<td><%= classesRset.getString("course_id") %></td>
								<td><%= classesRset.getString("class_title") %></td>
								<td><%= classesRset.getString("quarter") %></td>
								<td><%= classesRset.getString("year") %></td>
								<td><%= classesRset.getString("section_id") %></td>
								<td><%= classesRset.getString("units_taken") %></td>
							</tr>
							<%
						}

						classesRset.close();
						conn.commit();
						conn.setAutoCommit(true);
					
					}
					%>
				</table>
				<%
				
				/* Reports I b */
				%>
				<h4>b)</h4>
				<h4>All classes:</h4>
				<table>
						<tr>
							<th>Course ID</th>	
							<th>Class Title</th>
							<th>Quarter</th>
							<th>Year</th>
						</tr>
				<%
				
				// HTML select for all classes
				PreparedStatement classesStmt = conn.prepareStatement("SELECT c.course_id, c.class_title, c.quarter, c.year FROM classes c;");
				ResultSet classesRset = classesStmt.executeQuery();
				ArrayList<String> classes = new ArrayList<>();
				while (classesRset.next()) {
					classes.add(classesRset.getString("class_title"));
					%>
					<%--Display information for all students ever enrolled--%>
						<tr>
							<td><%= classesRset.getString("course_id") %></td>
							<td><%= classesRset.getString("class_title") %></td>
							<td><%= classesRset.getString("quarter") %></td>
							<td><%= classesRset.getString("year") %></td>
						</tr>
					<%
				}
				%>
				</table>
				<%
				classesRset.close();
				%>
			
				<table>
					<%--Report I b--%>
					<tr>
						<th>Select a class:</th>	
					</tr>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-I-b" name="action">							
							<th><select name="TITLE">
								<%  for(String title: classes) { %>
  									 <option value="<%=title%>"><%=title%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<table>
					<% 
					if (action != null && action.equals("select-report-I-b")) {
						conn.setAutoCommit(false);
						String title = request.getParameter("TITLE");
						
						PreparedStatement rosterStmt = conn.prepareStatement("SELECT s.*, e.units_taken, e.grade_option FROM enroll e, student s WHERE e.class_title = ? AND s.ssn = e.ssn;");
						rosterStmt.setString(1, title);
						ResultSet rosterRset = rosterStmt.executeQuery();
						%>
						<tr>
							<th>SSN</th>
							<th>First Name</th>
							<th>Middle Name</th>
							<th>Last Name</th>
							<th>Student ID</th>
							<th>Student Type</th>
							<th>Resident Type</th>
							<th>Department Number</th>
							<th>Currently Enrolled?</th>
							<th>Units Taken</th>
							<th>Grade Option</th>
						</tr>
						<%
						while (rosterRset.next()) {	
							%>
							<tr>
								<td><%= rosterRset.getString("ssn") %></td>
								<td><%= rosterRset.getString("first_name") %></td>
								<td><%= rosterRset.getString("middle_name") %></td>
								<td><%= rosterRset.getString("last_name") %></td>
								<td><%= rosterRset.getString("student_id") %></td>
								<td><%= rosterRset.getString("student_type") %></td>
								<td><%= rosterRset.getString("resident_type") %></td>
								<td><%= rosterRset.getString("dno") %></td>
								<td><%= rosterRset.getString("enrolled") %></td>
								<td><%= rosterRset.getString("units_taken") %></td>
								<td><%= rosterRset.getString("grade_option") %></td>
							</tr>
							<%
						}
						rosterRset.close();
						
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
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year;");
						classesTaken.setString(1, ssn);
						ResultSet takenRset = classesTaken.executeQuery();
						%>
						<tr>
							<th>Course ID</th>
							<th>Class Title</th>
							<th>Quarter</th>
							<th>Year</th>
							<th>Units Taken</th>
							<th>Grade</th>
						</tr>
						<%
						while (takenRset.next()) {	
							%>
							<tr>
								<td><%= takenRset.getString("course_id") %></td>
								<td><%= takenRset.getString("class_title") %></td>
								<td><%= takenRset.getString("quarter") %></td>
								<td><%= takenRset.getString("year") %></td>
								<td><%= takenRset.getString("units_taken") %></td>
								<td><%= takenRset.getString("grade") %></td>
							</tr>
							<%
						}
						takenRset.close();
						
						PreparedStatement quarterStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) SELECT c.quarter, c.year, AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade GROUP BY quarter, year;");
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
						
						PreparedStatement cumulativeStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) SELECT AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade;");
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
				
				PreparedStatement selectId2 = conn.prepareStatement("SELECT u.degree_number FROM ucsd_degree u WHERE u.degree_type = 'bsc';");
				ResultSet rsetId2 = selectId2.executeQuery();
				ArrayList<String> bscDegrees = new ArrayList<>();
				while (rsetId2.next()) {
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
							<th><select name="DEGREE_NUMBER">
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
						String degreeNumber = request.getParameter("DEGREE_NUMBER");
						
						PreparedStatement unitStmt = conn.prepareStatement("SELECT u.total_units FROM ucsd_degree u WHERE u.degree_number = ?;");
						unitStmt.setInt(1, Integer.parseInt(degreeNumber));
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
						
						
						%>
						<tr>
							<th>Category</th>
							<th>Units Left</th>
						</tr>
						<%
						PreparedStatement unitsLeft = conn.prepareStatement("WITH unitsPerCategory AS (SELECT category, number_units FROM degree_requirement WHERE degree_number = ?), coursesTaken AS (SELECT e.course_id, e.units_taken FROM enroll e WHERE e.ssn = ?), unitsTakenPerCategory AS (SELECT cr.category, SUM(units_taken) AS taken_units FROM coursesTaken ct, category_requirements cr WHERE degree_number = ? AND ct.course_id = cr.course_id GROUP BY cr.category), join_units AS (SELECT upc.category, upc.number_units, utpc.taken_units FROM unitsPerCategory upc LEFT JOIN unitsTakenPerCategory utpc ON upc.category = utpc.category) SELECT ju.category, ju.number_units - COALESCE(ju.taken_units,0) AS units_left FROM join_units ju WHERE ju.number_units - ju.taken_units > 0 OR ju.number_units - ju.taken_units IS NULL");
						unitsLeft.setInt(1, Integer.parseInt(degreeNumber));
 						unitsLeft.setString(2, ssn);
						unitsLeft.setInt(3, Integer.parseInt(degreeNumber));
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
				<h4>e)</h4>
				<h4>All master's students currently enrolled:</h4>
				<table>
					<tr>
						<th>SSN</th>	
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
					</tr>
				<%
				
				// HTML select for master's students enrolled in the current quarter
				PreparedStatement currentMastersStmt = conn.prepareStatement("SELECT e.ssn, s.first_name, s.middle_name, s.last_name FROM student s, enroll e WHERE s.ssn = e.ssn AND s.student_type = 'masters' AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet currentMastersRset = currentMastersStmt.executeQuery();
				ArrayList<String> currentMasters = new ArrayList<>();
				while (currentMastersRset.next()) {
					currentMasters.add(currentMastersRset.getString("ssn"));
					%>
					<%--Display information for master's students currently enrolled--%>
						<tr>
							<td><%= currentMastersRset.getString("ssn") %></td>
							<td><%= currentMastersRset.getString("first_name") %></td>
							<td><%= currentMastersRset.getString("middle_name") %></td>
							<td><%= currentMastersRset.getString("last_name") %></td>
						</tr>
					</table>
					<%
				}
				currentMastersRset.close();
				%>
				
				<%
				PreparedStatement mastersDegreeStmt = conn.prepareStatement("SELECT u.degree_number FROM ucsd_degree u WHERE u.degree_type = 'masters';");
				ResultSet mastersDegreeRset = mastersDegreeStmt.executeQuery();
				ArrayList<String> mastersDegrees = new ArrayList<>();
				while (mastersDegreeRset.next()) {
					// bscDegrees.add(rsetId2.getString("dname"));
					mastersDegrees.add(mastersDegreeRset.getString("degree_number"));
					
				}
				mastersDegreeRset.close();
				%>
			
				<table>
					<%--Report I e--%>
					<tr>
						<th>Select Master's student enrolled in current quarter:</th>	
						<th>Select Master's degree:</th>	
					</tr>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-I-e" name="action">							
							<th><select name="SSN">
								<%  for(String ssn: currentMasters) { %>
  									 <option value="<%=ssn%>"><%=ssn%></option>
  								<% } %>
							</select></th>
							<th><select name="DEGREE_NUMBER">
								<%  for(String mastersDegree: mastersDegrees) { %>
  									 <option value="<%=mastersDegree%>"><%=mastersDegree%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				
 				<table>
					<% 
					if (action != null && action.equals("select-report-I-e")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						int degreeNumber = Integer.parseInt(request.getParameter("DEGREE_NUMBER"));
						
						PreparedStatement concentrationStmt = conn.prepareStatement("WITH units AS (SELECT cr.name, SUM(e.units_taken) AS total_units_taken FROM enroll e, concentration_requirements cr WHERE e.ssn = ? AND e.grade != 'IN' AND cr.degree_number = ? AND e.course_id = cr.course_id GROUP BY cr.name), gpa AS (SELECT cr.name, AVG(gc.number_grade) AS concentration_gpa FROM enroll e, concentration_requirements cr, grade_conversion gc WHERE e.ssn = ? AND e.grade != 'IN' AND cr.degree_number = ? AND e.course_id = cr.course_id AND e.grade = gc.letter_grade AND e.grade_option = 'letter' GROUP BY cr.name), units_gpa AS (SELECT units.name, units.total_units_taken, gpa.concentration_gpa FROM units JOIN gpa ON units.name = gpa.name) SELECT c.name FROM units_gpa ug, concentration c WHERE c.degree_number = ? AND c.name = ug.name AND ug.total_units_taken >= c.min_units AND ug.concentration_gpa >= c.min_gpa;");
						concentrationStmt.setString(1, ssn);
						concentrationStmt.setInt(2, degreeNumber);
 						concentrationStmt.setString(3, ssn);
						concentrationStmt.setInt(4, degreeNumber);
 						concentrationStmt.setInt(5, degreeNumber);
						ResultSet concentrationRset = concentrationStmt.executeQuery();
						
						%>
						<tr>
							<th>Concentration Name</th>
						</tr>
						<%
						
						while (concentrationRset.next()) {
							%>
								<tr>
									<td><%= concentrationRset.getString("name") %></td>
								</tr>
							</table>
							<table>
							<%
						}
						
						PreparedStatement coursesLeftStmt = conn.prepareStatement("WITH y_concentration AS (SELECT c.* FROM concentration c WHERE degree_number = ?), courses_taken AS (SELECT e.course_id FROM enroll e WHERE e.ssn = ? AND e.grade != 'IN'), courses_left AS (SELECT cr.name, cr.course_id FROM concentration_requirements cr, y_concentration y WHERE cr.degree_number = y.degree_number AND cr.name = y.name AND cr.course_id NOT IN (SELECT * FROM courses_taken)), future_classes AS (SELECT c.course_id, c.quarter, c.year FROM classes c WHERE c.year > 2022 OR (c.year = 2022 AND c.quarter = 'FA')), earliest_classes AS (SELECT fc1.course_id, fc1.quarter, fc1.year FROM future_classes fc1 WHERE NOT EXISTS (SELECT * FROM future_classes fc2 WHERE fc1.course_id = fc2.course_id AND fc1.quarter != fc2.quarter AND fc1.year != fc2.year AND (fc2.quarter >= fc1.quarter AND fc2.year <= fc1.year))) SELECT * FROM courses_left cl LEFT JOIN earliest_classes ec ON cl.course_id = ec.course_id;");
						coursesLeftStmt.setInt(1, degreeNumber);
						coursesLeftStmt.setString(2, ssn);
						ResultSet coursesLeftRset = coursesLeftStmt.executeQuery();
						
						%>
						<tr>
							<th>Concentration Name</th>
							<th>Course ID</th>
							<th>Quarter</th>
							<th>Year</th>
						</tr>
						<%
						
						while (coursesLeftRset.next()) {
							%>
								<tr>
									<td><%= coursesLeftRset.getString("name") %></td>
									<td><%= coursesLeftRset.getString("course_id") %></td>
									<td><%= coursesLeftRset.getString("quarter") %></td>
									<td><%= coursesLeftRset.getString("year") %></td>
								</tr>
							</table>
							<%
						}
						
						coursesLeftRset.close();
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
				</table>
				<%
				
				/* Reports II a */
				%>
				<h3>Report II</h3>
				<h4>a)</h4>
				<h4>Students enrolled in the current quarter:</h4>
				<table>
					<tr>
						<th>SSN</th>	
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
					</tr>
				<%
				
				// HTML select for students enrolled in the current quarter
				PreparedStatement currentStudentsStmt2 = conn.prepareStatement("SELECT distinct s.ssn, s.first_name, s. middle_name, s.last_name FROM student s, enroll e WHERE s.ssn = e.ssn AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet currentStudents2Rset = currentStudentsStmt2.executeQuery();
				ArrayList<String> currentStudents2 = new ArrayList<>();
				
				while (currentStudents2Rset.next()) {
					currentStudents2.add(currentStudents2Rset.getString("ssn"));
					%>
					<%--Display information for students currently enrolled--%>
						<tr>
							<td><%= currentStudents2Rset.getString("ssn") %></td>
							<td><%= currentStudents2Rset.getString("first_name") %></td>
							<td><%= currentStudents2Rset.getString("middle_name") %></td>
							<td><%= currentStudents2Rset.getString("last_name") %></td>
						</tr>
					</table>
					<%
				}
				currentStudents2Rset.close();
				%>
				
				<%--HTML SELECT for student currently enrolled--%>
				<table>
					<tr>
						<th>Select student enrolled in current quarter:</th>	
					</tr>
					
					<%--Report II a--%>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-II-a" name="action">							
							<th><select name="SSN">
								<%  for(String ssn: currentStudents2) { %>
  									 <option value="<%=ssn%>"><%=ssn%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<table>
					<tr>
						<th>Course ID</th>	
						<th>Class ID</th>
					</tr>
					<% 
					if (action != null && action.equals("select-report-II-a")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement conflictStmt = conn.prepareStatement("WITH enrolled_meetings AS (SELECT m.quarter, m.year, m.day, m.start_time, m.end_time, m.course_id, m.class_title, m.section_id FROM enroll e, meeting m  WHERE e.ssn = ? AND e.quarter = 'SP' AND e.year = 2022 AND e.course_id = m.course_id  AND e.class_title = m.class_title AND e.section_id = e.section_id AND e.quarter = m.quarter AND e.year = m.year), meeting_options AS (SELECT m.quarter, m.year, m.day, m.start_time, m.end_time, m.course_id, m.class_title, m.section_id FROM meeting m  WHERE m.quarter = 'SP' AND m.year = 2022 AND NOT EXISTS (SELECT * FROM enrolled_meetings em  WHERE em.day = m.day AND em.start_time = m.start_time AND em.end_time = m.end_time  AND em.course_id = m.course_id AND em.class_title = m.class_title AND em.section_id = m.section_id)) SELECT c.class_title FROM classes c WHERE c.quarter = 'SP' AND c.year = 2022 AND NOT EXISTS (SELECT * FROM section s WHERE c.course_id = s.course_id AND c.class_title = s.class_title AND c.quarter = s.quarter AND c.year = s.year AND NOT EXISTS (SELECT * FROM meeting_options mo, enrolled_meetings em WHERE s.course_id = mo.course_id AND s.class_title = mo.class_title AND s.quarter = mo.quarter AND s.year = mo.year AND s.section_id = mo.section_id AND mo.day = em.day AND ((mo.start_time > em.start_time AND mo.start_time < em.end_time) OR (mo.end_time > em.start_time AND mo.end_time < em.end_time) OR (mo.start_time < em.start_time AND mo.end_time > em.end_time) OR (mo.start_time > em.start_time AND mo.end_time < em.end_time))));");
						conflictStmt.setString(1, ssn);
						ResultSet conflictRset = conflictStmt.executeQuery();
						
						while (conflictRset.next()) {
							%>
							<%--Display information for students currently enrolled--%>
								<tr>
									<td><%= conflictRset.getString("class_title") %></td>
								</tr>
							</table>
							<%
						}
						
						conflictRset.close();
						
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
				</table>
				<%
				
				/* Reports II b */
				%>
				<h4>b)</h4>
				<h4>Sections given in the given quarter:</h4>
				<table>
					<tr>
						<th>Course ID</th>	
						<th>Section ID</th>
					</tr>
				<%
				
				// HTML select for sections given in the current quarter
				PreparedStatement sectionStmt = conn.prepareStatement("SELECT s.course_id, s.section_id FROM section s WHERE s.quarter = 'SP' AND s.year = 2022;");
				ResultSet sectionRset = sectionStmt.executeQuery();
				ArrayList<String> sections = new ArrayList<>();
				
				while (sectionRset.next()) {
					sections.add(sectionRset.getString("section_id"));
					%>
					<%--Display information for students currently enrolled--%>
						<tr>
							<td><%= sectionRset.getString("course_id") %></td>
							<td><%= sectionRset.getString("section_id") %></td>
						</tr>
					</table>
					<%
				}
				sectionRset.close();
				%>
				
				<%--HTML SELECT for student currently enrolled--%>
				<table>
					<tr>
						<th>Select section given in the current quarter:</th>	
					</tr>
					
					<%--Report II a--%>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-II-b" name="action">							
							<th><select name="SSN">
								<%  for(String section: sections) { %>
  									 <option value="<%=section%>"><%=section%></option>
  								<% } %>
							</select></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<%
				
				/* Reports III a */
				%>
				<h4>a)</h4>
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
						<form action="reports.jsp" method="get">
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
						
						PreparedStatement countStmt1 = conn.prepareStatement("WITH profSections AS (SELECT s.section_id FROM section s WHERE s.quarter = ? AND s.year = ? AND s.instructor_id = ? AND s.course_id = ?), studentGrades AS (SELECT e.grade FROM enroll e WHERE e.quarter = ? AND e.year = ? AND e.course_id = ? AND e.section_id IN (SELECT * FROM profSections)) (SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A') UNION (SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B') UNION SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' UNION SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' UNION SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';");
						countStmt1.setString(1, quarter);
						countStmt1.setInt(2, year);
						countStmt1.setInt(3, faculty);
						countStmt1.setInt(4, course);
						countStmt1.setString(5, quarter);
						countStmt1.setInt(6, year);
						countStmt1.setInt(7, course);
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
						
						PreparedStatement countStmt2 = conn.prepareStatement("WITH profSections AS (SELECT s.section_id, s.quarter, s.year FROM section s WHERE s.instructor_id = ? AND s.course_id = ?), studentGrades AS (SELECT e.grade FROM enroll e WHERE EXISTS (SELECT * FROM profSections ps WHERE e.course_id = ? AND ps.section_id = e.section_id AND ps.quarter = e.quarter AND ps.year = e.year)) SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A' UNION SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B' UNION SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' UNION SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' UNION SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';");
						countStmt2.setInt(1, faculty);
						countStmt2.setInt(2, course);
						countStmt2.setInt(3, course);
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
						
						PreparedStatement countStmt3 = conn.prepareStatement("WITH allSections AS (SELECT s.section_id FROM section s WHERE s.course_id = ?), studentGrades AS (SELECT e.grade FROM enroll e WHERE e.course_id = ? AND e.section_id IN (SELECT * FROM allSections)) SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A' UNION SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B' UNION SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' UNION SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' UNION SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';");
						countStmt3.setInt(1, course);
						countStmt3.setInt(2, course);
						ResultSet countRset3 = countStmt3.executeQuery();
						
						%>
						<h4>Produce the count of grades given to students in course X over the years:</h4>
						<table>
							<tr>
								<th>Grade</th>
								<th>Count</th>
							</tr>
						<%
						
						while (countRset3.next()) {
							%>
								<tr>
									<td><%= countRset3.getString("grade") %></td>
									<td><%= countRset3.getString("count") %></td>
								</tr>
							<%
						}
						%></table><%
						countRset3.close();
						
						PreparedStatement countStmt4 = conn.prepareStatement("WITH profSections AS (SELECT s.section_id, s.quarter, s.year FROM section s WHERE s.instructor_id = ? AND s.course_id = ?) SELECT AVG(gc.number_grade) AS gpa FROM enroll e, grade_conversion gc WHERE EXISTS (SELECT * FROM profSections ps WHERE e.course_id = ? AND ps.section_id = e.section_id AND ps.quarter = e.quarter AND ps.year = e.year) AND gc.letter_grade = e.grade;");
						countStmt4.setInt(1, faculty);
						countStmt4.setInt(2, course);
						countStmt4.setInt(3, course);
						ResultSet countRset4 = countStmt4.executeQuery();
						
						%>
						<h4>Produce the grade point average that professor Y has given at course X over the years:</h4>
						<table>
							<tr>
								<th>Grade Point Average</th>
							</tr>
						<%
						
						while (countRset4.next()) {
							%>
								<tr>
									<td><%= countRset4.getString("gpa") %></td>
								</tr>
							<%
						}
						%></table><%
						countRset4.close();
						
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
				
				
			</td>
		</tr>	
	</table>
</body>
</html>