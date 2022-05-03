<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Degree Requirements'Info Submission Page</title>
</head>
<body>
	<%@ page language="java" import="java.sql.*" %>
	
	<table>
		<tr>
			<td>
				<% 
				DriverManager.registerDriver(new org.postgresql.Driver());

				Connection conn = DriverManager.getConnection("jdbc:postgresql:tritonlink?user=postgres&password=Beartown123!");
				//Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
			
				// insert ucsd_degree
				if (action != null && action.equals("insert-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO ucsd_degree VALUES (?, ?, ?, ?);");
					
					pstmt.setString(1, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DNO")));
					if (request.getParameter("CONCENTRATION") == null) {
						pstmt.setString(3, "");
					} else {
						pstmt.setString(3, request.getParameter("CONCENTRATION"));
					}
					pstmt.setInt(4, Integer.parseInt(request.getParameter("TOTAL_UNITS")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update ucsd_degree
				if (action != null && action.equals("update-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE ucsd_degree SET total_units = ? WHERE degree_type = ? AND dno = ? AND concentration = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("TOTAL_UNITS")));
					pstmt.setString(2, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(4, request.getParameter("CONCENTRATION"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete ucsd_degree
				if (action != null && action.equals("delete-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM ucsd_degree WHERE degree_type = ? AND dno = ? AND concentration = ?;");
					
					pstmt.setString(1, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setString(3, request.getParameter("CONCENTRATION"));

					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert requirement
				if (action != null && action.equals("insert-requirement")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO degree_requirement VALUES (?, ?, ?, ?, ?, ?);");
					
					pstmt.setString(1, request.getParameter("CATEGORY"));
					pstmt.setString(2, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("DNO")));
					if (request.getParameter("CONCENTRATION") == null) {
						pstmt.setString(4, "");
					} else {
						pstmt.setString(4, request.getParameter("CONCENTRATION"));
					}
					pstmt.setInt(5, Integer.parseInt(request.getParameter("UNITS")));
					pstmt.setInt(6, Integer.parseInt(request.getParameter("AVERAGE")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update degree_requirement
				if (action != null && action.equals("update-requirement")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE degree_requirement SET number_units = ?, required_average = ? WHERE category = ? AND degree_type = ? AND dno = ? AND concentration = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITS")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("AVERAGE")));
					pstmt.setString(3, request.getParameter("CATEGORY"));
					pstmt.setString(4, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(5, Integer.parseInt(request.getParameter("DNO")));
					if (request.getParameter("CONCENTRATION") == null) {
						pstmt.setString(6, "");
					} else {
						pstmt.setString(6, request.getParameter("CONCENTRATION"));
					}
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete degree_requirement
				if (action != null && action.equals("delete-requirement")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM degree_requirement WHERE category = ? AND degree_type = ? AND dno = ? AND concentration = ?;");
					
					pstmt.setString(1, request.getParameter("CATEGORY"));
					pstmt.setString(2, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("DNO")));
					if (request.getParameter("CONCENTRATION") == null) {
						pstmt.setString(4, "");
					} else {
						pstmt.setString(4, request.getParameter("CONCENTRATION"));
					}

					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert concentration
				if (action != null && action.equals("insert-concentration")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO concentration VALUES (?, ?);");
					
					pstmt.setString(1, request.getParameter("CONCENTRATION"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update concentration name
				if (action != null && action.equals("update-concentration-name")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration SET concentration = ? WHERE concentration = ? AND course_id = ?;");
					
					pstmt.setString(1, request.getParameter("NEW_CONCENTRATION"));
					pstmt.setString(2, request.getParameter("OLD_CONCENTRATION"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update concentration course
				if (action != null && action.equals("update-concentration-name")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration SET course_id = ? WHERE concentration = ? AND course_id = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("NEW_COURSE_ID")));
					pstmt.setString(2, request.getParameter("CONCENTRATION"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("OLD_COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update concentration course
				if (action != null && action.equals("delete-concentration")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM concentration WHERE concentration = ? AND course_id = ?;");
					
					pstmt.setString(1, request.getParameter("CONCENTRATION"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Create Degree Form</h3>
				<table>
					<tr>
						<th>Degree Type</th>
						<th>Department Number</th>
						<th>Concentration</th>
						<th>Total Units</th>
					</tr>
					<%--Insert ucsd_degree Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-degree" name="action">
							<th><select name="DEGREE_TYPE">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="TOTAL_UNITS" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update ucsd_degree Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="update-degree" name="action">
							<th><select name="DEGREE_TYPE">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="TOTAL_UNITS" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete ucsd_degree Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-degree" name="action">
							<th><select name="DEGREE_TYPE">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="TOTAL_UNITS" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all UCSD degrees-->
					<tr>
						<th>Degree Type</th>
						<th>Department Number</th>
						<th>Concentration</th>
						<th>Total Units</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM ucsd_degree;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("degree_type") %></td>
							<td><%= rset.getString("dno") %></td>
							<td><%= rset.getString("concentration") %></td>
							<td><%= rset.getString("total_units") %></td>
						</tr>
					<%
					}
					rset.close();
					// conn.close();
					%>
				</table>					
					
				</table>
				
				<h3>Requirements Form</h3>
				<table>
					<tr>
						<th>Category</th>
						<th>Degree Type</th>
						<th>Department Number</th>
						<th>Concentration</th>
						<th>Number Units</th>
						<th>Required Average</th>
					</tr>
					<%--Insert degree_requirement Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-requirement" name="action">
							<th><input value="" name="CATEGORY" size="10"></th>
							<th><select name="DEGREE_TYPE">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="UNITS" size="10"></th>
							<th><input value="" name="AVERAGE" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update degree_requirement Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="update-requirement" name="action">
							<th><input value="" name="CATEGORY" size="10"></th>
							<th><select name="DEGREE_TYPE">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="UNITS" size="10"></th>
							<th><input value="" name="AVERAGE" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete degree_requirement Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-requirement" name="action">
							<th><input value="" name="CATEGORY" size="10"></th>
							<th><select name="DEGREE_TYPE">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="UNITS" size="10"></th>
							<th><input value="" name="AVERAGE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all degree requirements-->
					<tr>
						<th>Category</th>
						<th>Degree Type</th>
						<th>Department Number</th>
						<th>Concentration</th>
						<th>Number Units</th>
						<th>Required Average</th>
					</tr>
					
 					<%
					pstmt = conn.prepareStatement("SELECT * FROM degree_requirement;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("category") %></td>
							<td><%= rset.getString("degree_type") %></td>
							<td><%= rset.getString("dno") %></td>
							<td><%= rset.getString("concentration") %></td>
							<td><%= rset.getString("number_units") %></td>
							<td><%= rset.getString("required_average") %></td>

						</tr>
					<%
					}
					rset.close();
					%>			
				</table>
				
				<h3>Concentration Form</h3>
				<table>
					<tr>
						<th>Concentration</th>
						<th>Course ID</th>
					</tr>
					
					<%--Insert concentration Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-concentration" name="action">
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Delete concentration Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-concentration" name="action">
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
				
					<tr>
						<th>Old Concentration</th>
						<th>New Concentration</th>
					</tr>
					
					<%--Update concentration name Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="update-concentration-name" name="action">
							<th><input value="" name="OLD_CONCENTRATION" size="10"></th>
							<th><input value="" name="NEW_CONCENTRATION" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<tr>
						<th>Concentration</th>
						<th>Old Course ID</th>
						<th>New Course ID</th>
					</tr>

					<%--Update concentration name Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="update-concentration-course" name="action">
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="OLD_COURSE_ID" size="10"></th>
							<th><input value="" name="NEW_COURSE_ID" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<!-- Reading in all degree requirements-->
					<tr>
						<th>Concentration</th>
						<th>Course ID</th>
					</tr>
					
					<%
					pstmt = conn.prepareStatement("SELECT * FROM concentration;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("name") %></td>
							<td><%= rset.getString("COURSE_ID") %></td>
						</tr>
					<%
					}
					rset.close();
					// conn.close();
					%>					
					
				</table>
			</td>
		</tr>	
	</table>
</body>
</html>