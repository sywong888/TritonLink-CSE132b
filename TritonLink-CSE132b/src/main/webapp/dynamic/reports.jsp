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
				
				%>
				<table>
						<tr>
							<th>SSN</th>	
							<th>First Name</th>
							<th>Middle Name</th>
							<th>Last Name</th>
						</tr>
				<%
				
				while (currentStudentRset.next()) {
					currentStudents.add(currentStudentRset.getString("ssn"));
					%>
					<%--Display information for student currently enrolled--%>
					
						<tr>
							<td><%= currentStudentRset.getString("ssn") %></td>
							<td><%= currentStudentRset.getString("first_name") %></td>
							<td><%= currentStudentRset.getString("middle_name") %></td>
							<td><%= currentStudentRset.getString("last_name") %></td>
						</tr>
					<%
				}
				currentStudentRset.close();
				%>
				</table>
				

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
				
					
					<% 
					if (action != null && action.equals("select-report-I-a")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.section_id, e.units_taken FROM enroll e, classes c WHERE e.quarter = 'SP' AND e.year = 2022 AND e.ssn = ? AND e.class_title = c.class_title;");
						classesTaken.setString(1, ssn);
						ResultSet classesRset = classesTaken.executeQuery();
						
						%>
						<table>
							<tr>
								<th>Course ID</th>
								<th>Class Title</th>
								<th>Quarter</th>
								<th>Year</th>
								<th>Section ID</th>
								<th>Units Taken</th>
							</tr>
						<%
						
						while (classesRset.next()) {
							%>
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
						%>
						</table>
						<%
						classesRset.close();
						conn.commit();
						conn.setAutoCommit(true);
					}
					

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
				classesRset.close();
				%>
				</table>
				
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
				
				%>
				<table>
					<tr>
						<th>SSN</th>	
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
					</tr>
				<%
				
				while (enrollRset.next()) {
					allEnroll.add(enrollRset.getString("ssn"));
					%>
					<%--Display information for all students ever enrolled--%>
						<tr>
							<td><%= enrollRset.getString("ssn") %></td>
							<td><%= enrollRset.getString("first_name") %></td>
							<td><%= enrollRset.getString("middle_name") %></td>
							<td><%= enrollRset.getString("last_name") %></td>
						</tr>
					<%
				}
				enrollRset.close();
				%>
				</table>
				
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
				
				<% 
				if (action != null && action.equals("select-report-I-c")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year;");
						classesTaken.setString(1, ssn);
						ResultSet takenRset = classesTaken.executeQuery();
						%>
						<table>
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
						%>
						</table>
						<% 
						
						PreparedStatement quarterStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) SELECT c.quarter, c.year, AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade GROUP BY quarter, year;");
						quarterStmt.setString(1, ssn);
						ResultSet quarterRset = quarterStmt.executeQuery();
						%>
						<table>
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
						%>
						</table>
						<%
						
						PreparedStatement cumulativeStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) SELECT AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade;");
						cumulativeStmt.setString(1, ssn);
						ResultSet cumulativeRset = cumulativeStmt.executeQuery();
						%>
						<table>
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
						%>
						</table>
						<%
						
						conn.commit();
						conn.setAutoCommit(true);
				}
				%>	
				
				<%
				/* Reports I d */
				%>
				<h4>d)</h4>
				<h4>All undergraduates currently enrolled:</h4>
				<%
				
				// HTML select for undergraduates enrolled in the current quarter
				PreparedStatement currentUndergradStmt = conn.prepareStatement("SELECT distinct e.ssn, s.first_name, s.middle_name, s.last_name FROM student s, enroll e WHERE s.ssn = e.ssn AND s.student_type = 'bs' AND e.quarter = 'SP' AND e.year = 2022;");
				ResultSet currentUndergradRset = currentUndergradStmt.executeQuery();
				ArrayList<String> currentUndergrads = new ArrayList<>();
				
				%>
				<table>
					<tr>
						<th>SSN</th>	
						<th>First Name</th>
						<th>Middle Name</th>
						<th>Last Name</th>
					</tr>
				<%
				
				while (currentUndergradRset.next()) {
					currentUndergrads.add(currentUndergradRset.getString("ssn"));
					%>
					<%--Display information for all undergraduates currently enrolled--%>
						<tr>
							<td><%= currentUndergradRset.getString("ssn") %></td>
							<td><%= currentUndergradRset.getString("first_name") %></td>
							<td><%= currentUndergradRset.getString("middle_name") %></td>
							<td><%= currentUndergradRset.getString("last_name") %></td>
						</tr>
					<%
				}
				
				currentUndergradRset.close();
				%>
				</table>
				
				<%
				PreparedStatement csDnoStmt = conn.prepareStatement("SELECT dno FROM department WHERE dname = 'CSE';");
				ResultSet csDnoRset = csDnoStmt.executeQuery();
				csDnoRset.next();
				int csDno = csDnoRset.getInt("dno");
				csDnoRset.close();
				
				PreparedStatement selectId2 = conn.prepareStatement("SELECT u.degree_number FROM ucsd_degree u WHERE u.degree_type = 'bs' AND u.dno = ?;");
				selectId2.setInt(1, 1);
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
				
				<% 
					if (action != null && action.equals("select-report-I-d")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						String degreeNumber = request.getParameter("DEGREE_NUMBER");
						
						%>
						<table>
						<%
						
						PreparedStatement totalUnitsLeft = conn.prepareStatement("WITH unitsPerCategory AS (SELECT category, number_units FROM degree_requirement WHERE degree_number = ?), coursesTaken AS (SELECT e.course_id, e.units_taken FROM enroll e WHERE e.ssn = ?), unitsTakenPerCategory AS (SELECT cr.category, SUM(units_taken) AS taken_units FROM coursesTaken ct, category_requirements cr WHERE degree_number = ? AND ct.course_id = cr.course_id GROUP BY cr.category), join_units AS (SELECT upc.category, upc.number_units, utpc.taken_units FROM unitsPerCategory upc LEFT JOIN unitsTakenPerCategory utpc ON upc.category = utpc.category), byCategory AS (SELECT ju.category, ju.number_units - COALESCE(ju.taken_units,0) AS units_left FROM join_units ju WHERE ju.number_units - ju.taken_units > 0 OR ju.number_units - ju.taken_units IS NULL) SELECT SUM(units_left) AS total_units FROM byCategory;");
						totalUnitsLeft.setInt(1, Integer.parseInt(degreeNumber));
						totalUnitsLeft.setString(2, ssn);
						totalUnitsLeft.setInt(3, Integer.parseInt(degreeNumber));
						ResultSet totalUnitsLeftRset = totalUnitsLeft.executeQuery();
						while (totalUnitsLeftRset.next()) {
							%>
							<tr>
								<th>Undergraduate student must take this many units to earn the degree:</th>
							</tr>
							<tr>
								<td><%= totalUnitsLeftRset.getString("total_units") %></td>
							</tr>
							<%
						}
						totalUnitsLeftRset.close();
						%>
						</table>
						
						<table>
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
						%>
						</table>
						<%
						
						conn.commit();
						conn.setAutoCommit(true);
					}
				
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
					<%
				}
				%>
				</table>
				<%
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
					<% 
					if (action != null && action.equals("select-report-II-a")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement conflictStmt = conn.prepareStatement("WITH enrolled_meetings AS (SELECT m.quarter, m.year, m.day, m.start_time, m.end_time, m.course_id, m.class_title, m.section_id FROM enroll e, meeting m  WHERE e.ssn = ? AND e.quarter = 'SP' AND e.year = 2022 AND e.course_id = m.course_id  AND e.class_title = m.class_title AND e.section_id = e.section_id AND e.quarter = m.quarter AND e.year = m.year), meeting_options AS (SELECT m.quarter, m.year, m.day, m.start_time, m.end_time, m.course_id, m.class_title, m.section_id FROM meeting m  WHERE m.quarter = 'SP' AND m.year = 2022 AND NOT EXISTS (SELECT * FROM enrolled_meetings em  WHERE em.day = m.day AND em.start_time = m.start_time AND em.end_time = m.end_time AND em.course_id = m.course_id AND em.class_title = m.class_title AND em.section_id = m.section_id)) SELECT c.class_title, c.course_id FROM classes c WHERE c.quarter = 'SP' AND c.year = 2022 AND NOT EXISTS (SELECT * FROM section s WHERE c.course_id = s.course_id AND c.class_title = s.class_title AND c.quarter = s.quarter AND c.year = s.year AND NOT EXISTS (SELECT * FROM meeting_options mo, enrolled_meetings em WHERE s.course_id = mo.course_id AND s.class_title = mo.class_title AND s.quarter = mo.quarter AND s.year = mo.year AND s.section_id = mo.section_id AND mo.day = em.day AND ((mo.start_time > em.start_time AND mo.start_time < em.end_time) OR (mo.end_time > em.start_time AND mo.end_time < em.end_time) OR (mo.start_time < em.start_time AND mo.end_time > em.end_time) OR (mo.start_time > em.start_time AND mo.end_time < em.end_time))));");
						conflictStmt.setString(1, ssn);
						ResultSet conflictRset = conflictStmt.executeQuery();
						
						%>
						<table>
							<tr>
								<th>Class Title</th>
								<th>Course ID</th>
							</tr>
						<%
						
						while (conflictRset.next()) {
							%>
							<%--Display information for students currently enrolled--%>
								<tr>
									<td><%= conflictRset.getString("class_title") %></td>
									<td><%= conflictRset.getString("course_id") %></td>
								</tr>
							<%
						}
						
						%>
						</table>
						<%
						conflictRset.close();
						
						conn.commit();
						conn.setAutoCommit(true);
					}
					%>
					
				<%
				
				/* Reports II b */
				%>
				<h4>b)</h4>
				<h4>Classes in the current quarter:</h4>
				<table>
					<tr>
						<th>Class Title</th>	
					</tr>
				<%
				
				// HTML select for classes given in the current quarter
				PreparedStatement currentClassesStmt = conn.prepareStatement("SELECT class_title FROM classes c WHERE c.quarter = 'SP' AND c.year = 2022;");
				ResultSet currentClassesRset = currentClassesStmt.executeQuery();
				ArrayList<String> currentClasses = new ArrayList<>();
				
				while (currentClassesRset.next()) {
					currentClasses.add(currentClassesRset.getString("class_title"));
					%>
					<%--Display information for faculty--%>
						<tr>
							<td><%= currentClassesRset.getString("class_title") %></td>
						</tr>
					<%
				}
				currentClassesRset.close();
				%>
				</table>
				
				<h4>Sections in the current quarter:</h4>
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
					<%
				}
				%>
				</table>
				<%
				sectionRset.close();
				%>
				
				<%--HTML SELECT for professor and section currently enrolled--%>
				<table>
					<tr>
						<th>Select class title:</th>
						<th>Select section given in the current quarter:</th>	
						<th>Enter first possible date:</th>
						<th>Enter last possible date:</th>
					</tr>
					
					<%--Report II b--%>
					<tr>
						<form action="reports.jsp" method="get">
							<input type="hidden" value="select-report-II-b" name="action">	
							<th><select name="CLASS_TITLE">
								<%  for(String c: currentClasses) { %>
  									 <option value="<%=c%>"><%=c%></option>
  								<% } %>
							</select></th>					
							<th><select name="SECTION_ID">
								<%  for(String section: sections) { %>
  									 <option value="<%=section%>"><%=section%></option>
  								<% } %>
							</select></th>
							<th><input value="" name="START_DATE" size="10"></th>
							<th><input value="" name="END_DATE" size="10"></th>
							<th><input type="submit" value="Submit"></th>
						</form>
					</tr>
				</table>
				<%
				
				if (action != null && action.equals("select-report-II-b")) {
					conn.setAutoCommit(false);
					
					LocalDate start = LocalDate.parse(request.getParameter("START_DATE"));
					LocalDate end = LocalDate.parse(request.getParameter("END_DATE")).plusDays(1);
					
					Statement createTableStmt = conn.createStatement();
					createTableStmt.executeUpdate("DROP TABLE IF EXISTS session_options;");
					createTableStmt.executeUpdate("CREATE TABLE session_options (date varchar(255), day varchar(255), start_time varchar(255), end_time varchar(255))");
					
					List<LocalDate> dates = start.datesUntil(end).collect(Collectors.toList());
					
					for (LocalDate ld: dates) {
						String date = "" + ld.getMonth() + " " + ld.getDayOfMonth() + ", " + ld.getYear();
						String dayCaps = "" + ld.getDayOfWeek();
						String day = "";
						switch (dayCaps) {
							case "MONDAY":
								day = "M";
								break;
							case "TUESDAY":
								day = "T";
								break;
							case "WEDNESDAY":
								day = "W";
								break;
							case "THURSDAY":
								day = "R";
								break;
							case "FRIDAY":
								day = "F";
								break;
							case "SATURDAY":
								day = "SAT";
								break;
							case "SUNDAY":
								day = "SUN";
								break;
						}
						int hour = 8;
						
						while (hour < 20) {
							String startTime = "";
							if (hour == 8 || hour == 9) {
								startTime += "0" + hour + ":00"; 
							} else {
								startTime += hour + ":00";
							}
							
							String endTime = "";
							if (hour == 8) {
								endTime += "0" + (hour + 1) + ":00"; 
							} else {
								endTime += (hour + 1) + ":00";
							}
							
							PreparedStatement insertStmt = conn.prepareStatement("INSERT INTO session_options VALUES(?, ?, ?, ?);");
							insertStmt.setString(1, date);
							insertStmt.setString(2, day);
							insertStmt.setString(3, startTime);
							insertStmt.setString(4, endTime);
							insertStmt.executeUpdate();
							
							hour++;
						}
					}
					
					PreparedStatement reviewTimesStmt = conn.prepareStatement("WITH students_in_section AS (SELECT e.ssn FROM enroll e WHERE e.class_title = ? AND e.section_id = ?), sections_of_students AS (SELECT e.class_title, e.section_id FROM enroll e, students_in_section sis WHERE e.ssn = e.ssn AND e.quarter = 'SP' AND e.year = 2022), meetings_of_students AS (SELECT m.day, m.start_time, m.end_time FROM sections_of_students sis, meeting m WHERE sis.class_title = m.class_title AND sis.section_id = m.section_id) SELECT so.date, so.day, so.start_time, so.end_time FROM session_options so WHERE NOT EXISTS (SELECT * FROM meetings_of_students mos WHERE so.day = mos.day AND ((so.start_time > mos.start_time AND so.start_time < mos.end_time) OR (so.end_time > mos.start_time AND so.end_time < mos.end_time) OR (so.start_time <= mos.start_time AND so.end_time >= mos.end_time) OR (so.start_time >= mos.start_time AND so.end_time <= mos.end_time)));");
					reviewTimesStmt.setString(1, request.getParameter("CLASS_TITLE"));
					reviewTimesStmt.setString(2, request.getParameter("SECTION_ID"));
					ResultSet reviewTimesRset = reviewTimesStmt.executeQuery();
 					
  					/* Statement createTableStmt = conn.createStatement();
  					createTableStmt.executeUpdate("DROP TABLE IF EXISTS yourtable;");
  					createTableStmt.executeUpdate("CREATE TABLE YourTable (start_d timestamp, end_d timestamp);"); */
  					
  					//String loop = "do $$ DECLARE start_date date := '" + start + "'; end_date date := '" + end + "'; start_time time := '08:00:00'; end_time time := '20:00:00'; first timestamp := cast(concat(start_date, ' ', start_time) as timestamp); second timestamp := cast(concat(start_date, ' ', end_time) as timestamp); diff_day integer := end_date - start_date; begin for r in 0..diff_day loop RAISE NOTICE 'iteration: %', r; INSERT INTO YourTable (start_d, end_d) VALUES (first, second); first := first + INTERVAL '1 day'; second := second + INTERVAL '1 day'; end loop; end $$;";
  					//createTableStmt.executeUpdate(loop);
 					//PreparedStatement datesBetweenStmt = conn.prepareStatement("do $$ DECLARE start_date date := ?; end_date date := ?; start_time time := '08:00:00'; end_time time := '20:00:00'; first timestamp := cast(concat(start_date, ' ', start_time) as timestamp); second timestamp := cast(concat(start_date, ' ', end_time) as timestamp); diff_day integer := end_date - start_date; begin for r in 0..diff_day loop RAISE NOTICE 'iteration: %', r; INSERT INTO YourTable (start_d, end_d) VALUES (first, second); first := first + INTERVAL '1 day'; second := second + INTERVAL '1 day'; end loop; end $$;");
/*  					datesBetweenStmt.setString(1, start);
 					datesBetweenStmt.setString(2, end);
 					datesBetweenStmt.executeQuery(); */
 					//PreparedStatement availableStmt = conn.prepareStatement("with RECURSIVE cte AS (SELECT TO_CHAR(start_d, 'MM-DD') AS month_day, CASE WHEN extract(isodow from start_d) = 1 THEN 'm' WHEN extract(isodow from start_d) = 2 THEN 't' WHEN extract(isodow from start_d) = 3 THEN 'w' WHEN extract(isodow from start_d) = 4 THEN 'r' WHEN extract(isodow from start_d) = 5 THEN 'f' WHEN extract(isodow from start_d) = 6 THEN 'sat' WHEN extract(isodow from start_d) = 7 THEN 'sun' END AS day_of_week, start_d, end_d, start_d::time as start_t, end_d::time as end_t FROM YourTable UNION  ALL SELECT TO_CHAR(start_d, 'MM-DD') AS month_day, CASE WHEN extract(isodow from start_d) = 1 THEN 'm' WHEN extract(isodow from start_d) = 2 THEN 't' WHEN extract(isodow from start_d) = 3 THEN 'w' WHEN extract(isodow from start_d) = 4 THEN 'r' WHEN extract(isodow from start_d) = 5 THEN 'f' WHEN extract(isodow from start_d) = 6 THEN 'sat' WHEN extract(isodow from start_d) = 7 THEN 'sun' END AS day_of_week, start_d + INTERVAL '1 hour', end_d, (start_d + INTERVAL '1 hour')::time as start_t, end_d::time as end_t FROM cte WHERE start_d < end_d - INTERVAL '1 hour'), student_in_section AS ( select e.ssn, e.course_id, e.class_title, e.section_id from enroll e where e.class_title = 'CSE998-1' and e.section_id = 'S998-1' ), all_student_section AS ( select e.* from enroll e, student_in_section sis where e.ssn = sis.ssn and e.quarter = 'SP' and e.year = 2022 ), all_student_section_time AS ( select distinct m.class_title, m.section_id, m.day, m.start_time::time, m.end_time::time, m.type from all_student_section all_ss, meeting m where all_ss.class_title = m.class_title and all_ss.section_id = m.section_id ), filtered_cte as ( SELECT month_day, day_of_week, start_d, start_d + INTERVAL '1 hour' AS end_d, start_d::time as start_t, (start_d + INTERVAL '1 hour')::time as end_t FROM cte ORDER BY start_d ) SELECT fc.month_day, fc.day_of_week, fc.start_t, fc.end_t FROM filtered_cte fc WHERE NOT EXISTS ( SELECT * from all_student_section_time all_sst WHERE fc.day_of_week = all_sst.day AND ( (all_sst.start_time < fc.start_t AND fc.start_t < all_sst.end_time) OR (all_sst.start_time < fc.end_t AND fc.end_t < all_sst.end_time) OR (fc.start_t < all_sst.start_time AND all_sst.end_time < fc.end_t) OR (all_sst.start_time <= fc.start_t AND fc.end_t <= all_sst.end_time) ) ) ORDER BY start_d;");
  					//datesBetweenStmt.executeUpdate("with RECURSIVE cte AS (SELECT TO_CHAR(start_d, 'MM-DD') AS month_day, CASE WHEN extract(isodow from start_d) = 1 THEN 'm' WHEN extract(isodow from start_d) = 2 THEN 't' WHEN extract(isodow from start_d) = 3 THEN 'w' WHEN extract(isodow from start_d) = 4 THEN 'r' WHEN extract(isodow from start_d) = 5 THEN 'f' WHEN extract(isodow from start_d) = 6 THEN 'sat' WHEN extract(isodow from start_d) = 7 THEN 'sun' END AS day_of_week, start_d, end_d, start_d::time as start_t, end_d::time as end_t FROM YourTable UNION  ALL SELECT TO_CHAR(start_d, 'MM-DD') AS month_day, CASE WHEN extract(isodow from start_d) = 1 THEN 'm' WHEN extract(isodow from start_d) = 2 THEN 't' WHEN extract(isodow from start_d) = 3 THEN 'w' WHEN extract(isodow from start_d) = 4 THEN 'r' WHEN extract(isodow from start_d) = 5 THEN 'f' WHEN extract(isodow from start_d) = 6 THEN 'sat' WHEN extract(isodow from start_d) = 7 THEN 'sun' END AS day_of_week, start_d + INTERVAL '1 hour', end_d, (start_d + INTERVAL '1 hour')::time as start_t, end_d::time as end_t FROM cte WHERE start_d < end_d - INTERVAL '1 hour'), student_in_section AS ( select e.ssn, e.course_id, e.class_title, e.section_id from enroll e where e.class_title = 'CSE998-1' -- need to input the class and e.section_id = 'S998-1' -- need to input the section ), all_student_section AS ( select e.* from enroll e, student_in_section sis where e.ssn = sis.ssn and e.quarter = 'SP' and e.year = 2022 ), all_student_section_time AS ( select distinct m.class_title, m.section_id, m.day, m.start_time::time, m.end_time::time, m.type from all_student_section all_ss, meeting m where all_ss.class_title = m.class_title and all_ss.section_id = m.section_id ), filtered_cte as ( SELECT month_day, day_of_week, start_d, start_d + INTERVAL '1 hour' AS end_d, start_d::time as start_t, (start_d + INTERVAL '1 hour')::time as end_t FROM cte ORDER BY start_d ) SELECT fc.month_day, fc.day_of_week, fc.start_t, fc.end_t FROM filtered_cte fc WHERE NOT EXISTS ( SELECT * from all_student_section_time all_sst WHERE fc.day_of_week = all_sst.day AND ( (all_sst.start_time < fc.start_t AND fc.start_t < all_sst.end_time) -- student_time before or at option start and end before option end OR (all_sst.start_time < fc.end_t AND fc.end_t < all_sst.end_time) -- OR (fc.start_t < all_sst.start_time AND all_sst.end_time < fc.end_t) -- student_time is entirely between option OR (all_sst.start_time <= fc.start_t AND fc.end_t <= all_sst.end_time) -- option is entirely between student_time ) ) ORDER BY start_d;");
					//ResultSet availableRset = availableStmt.executeQuery();
					
  					%>
 					<table>
						<tr>
							<th>Date</th>
							<th>Day</th>
							<th>Start Time</th>
							<th>End Time</th>
						</tr>
					<%
					
					while (reviewTimesRset.next()) {
						%>
							<tr>
								<td><%= reviewTimesRset.getString("date") %></td>
								<td><%= reviewTimesRset.getString("day") %></td>
								<td><%= reviewTimesRset.getString("start_time") %></td>
								<td><%= reviewTimesRset.getString("end_time") %></td>
							</tr>
						<%
					}
					
					%>
					</table>
					<%

					reviewTimesRset.close();
  					conn.commit();
					conn.setAutoCommit(true);
				} 
				
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
					
										<% 
					if (action != null && action.equals("select-report-I-c")) {
						conn.setAutoCommit(false);
						String ssn = request.getParameter("SSN");
						
						PreparedStatement classesTaken = conn.prepareStatement("SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year;");
						classesTaken.setString(1, ssn);
						ResultSet takenRset = classesTaken.executeQuery();
						%>
						<table>
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
						%>
						</table>
						<%
						
						PreparedStatement quarterStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) SELECT c.quarter, c.year, AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade GROUP BY quarter, year;");
						quarterStmt.setString(1, ssn);
						ResultSet quarterRset = quarterStmt.executeQuery();
						%>
						<table>
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
						%>
						</table>
						<%
						
						PreparedStatement cumulativeStmt = conn.prepareStatement("WITH classes_taken AS (SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) SELECT AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade;");
						cumulativeStmt.setString(1, ssn);
						ResultSet cumulativeRset = cumulativeStmt.executeQuery();
						%>
						<table>
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
						%>
						</table>
						<%
						
						conn.commit();
						conn.setAutoCommit(true);
					}
				%>

				
			</td>
		</tr>	
	</table>
</body>
</html>