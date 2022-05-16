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
				// Connection conn = DriverManager.getConnection("jdbc:postgresql:cse_132b_db?currentSchema=cse_132b&user=postgres&password=BrPo#vPHu54f");
				
				String action = request.getParameter("action");
			
				// insert ucsd_degree
				if (action != null && action.equals("insert-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO ucsd_degree VALUES (?, ?, ?, ?);");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setString(2, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("TOTAL_UNITS")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update ucsd_degree
				if (action != null && action.equals("update-degree")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE ucsd_degree SET degree_type = ?, dno = ?, total_units = ? WHERE degree_number = ?;");
					
					pstmt.setString(1, request.getParameter("DEGREE_TYPE"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DNO")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("TOTAL_UNITS")));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete ucsd_degree
				if (action != null && action.equals("delete-degree")) {
					conn.setAutoCommit(false);
					
					// delete from degree_requirement to avoid foreign key violations
 					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM degree_requirement WHERE degree_number = ?;");
 					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
 					pstmt.executeUpdate();
 					
					pstmt = conn.prepareStatement("DELETE FROM ucsd_degree WHERE degree_number = ?;");
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));

					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert requirement
				if (action != null && action.equals("insert-requirement")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO degree_requirement VALUES (?, ?, ?, ?);");
					
					pstmt.setString(1, request.getParameter("CATEGORY"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("UNITS")));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("AVERAGE")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update degree_requirement
				if (action != null && action.equals("update-requirement")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE degree_requirement SET number_units = ?, required_average = ? WHERE category = ? AND degree_number = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("UNITS")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("AVERAGE")));
					pstmt.setString(3, request.getParameter("CATEGORY"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete degree_requirement
				if (action != null && action.equals("delete-requirement")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM degree_requirement WHERE category = ? AND degree_number = ?;");
					
					pstmt.setString(1, request.getParameter("CATEGORY"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));

					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert category_requirements
				if (action != null && action.equals("insert-category")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO category_requirements VALUES (?, ?, ?);");
					
					pstmt.setString(1, request.getParameter("CATEGORY"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete category_requirements
				if (action != null && action.equals("delete-category")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM category_requirements WHERE category = ? AND degree_number = ? AND course_id = ?;");
					
					pstmt.setString(1, request.getParameter("CATEGORY"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert concentration
				if (action != null && action.equals("insert-concentration")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO concentration VALUES (?, ?, ?, ?);");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setString(2, request.getParameter("CONCENTRATION"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("MIN_UNITS")));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("MIN_GPA")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// update concentration
 				if (action != null && action.equals("update-concentration")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("UPDATE concentration SET min_units = ?, min_gpa = ? WHERE degree_number = ? AND name = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("MIN_UNITS")));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("MIN_GPA")));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setString(4, request.getParameter("CONCENTRATION"));
					
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete concentration
				if (action != null && action.equals("delete-concentration")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM concentration WHERE degree_number = ? AND name = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setString(2, request.getParameter("CONCENTRATION"));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// insert concentration_requirements
				if (action != null && action.equals("insert-concentration-requirements")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("INSERT INTO concentration_requirements VALUES (?, ?, ?);");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setString(2, request.getParameter("CONCENTRATION"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				
				// delete concentration_requirements
				if (action != null && action.equals("delete-concentration-requirements")) {
					conn.setAutoCommit(false);
					PreparedStatement pstmt = conn.prepareStatement("DELETE FROM concentration_requirements WHERE degree_number = ? AND name = ? AND course_id = ?;");
					
					pstmt.setInt(1, Integer.parseInt(request.getParameter("DEGREE_NUMBER")));
					pstmt.setString(2, request.getParameter("CONCENTRATION"));
					pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_ID")));
					
					pstmt.executeUpdate();
					
					conn.commit();
					conn.setAutoCommit(true);
				}
				%>

				<%--Presentation Code--%>
				<h3>Create Degree Form</h3>
				<table>
					<tr>
						<th>Degree Number</th>
						<th>Degree Type</th>
						<th>Department Number</th>
						<th>Total Units</th>
					</tr>
					<%--Insert ucsd_degree Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-degree" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><select name="DEGREE_TYPE">
								<option value="bsc">BSC</option>
								<option value="ba">BA</option>
								<option value="masters">MS</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="TOTAL_UNITS" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Update ucsd_degree Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="update-degree" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><select name="DEGREE_TYPE">
								<option value="bsc">BSC</option>
								<option value="ba">BA</option>
								<option value="masters">MS</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="TOTAL_UNITS" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					<%--Delete ucsd_degree Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-degree" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><select name="DEGREE_TYPE">
								<option value="bsc">BSC</option>
								<option value="ba">BA</option>
								<option value="masters">MS</option>
								<option value="phd">PhD</option>
							</select></th>
							<th><input value="" name="DNO" size="10"></th>
							<th><input value="" name="TOTAL_UNITS" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all UCSD degrees-->
					<tr>
						<th>Degree Number</th>
						<th>Degree Type</th>
						<th>Department Number</th>
						<th>Total Units</th>
					</tr>
					
					<%
					PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM ucsd_degree;");
					ResultSet rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("degree_number") %></td>
							<td><%= rset.getString("degree_type") %></td>
							<td><%= rset.getString("dno") %></td>
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
						<th>Degree Number</th>
						<th>Number Units</th>
						<th>Required Average</th>
					</tr>
					<%--Insert degree_requirement Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-requirement" name="action">
							<th><input value="" name="CATEGORY" size="10"></th>
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
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
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
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
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="UNITS" size="10"></th>
							<th><input value="" name="AVERAGE" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all degree requirements-->
					<tr>
						<th>Category</th>
						<th>Degree Number</th>
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
							<td><%= rset.getString("degree_number") %></td>
							<td><%= rset.getString("number_units") %></td>
							<td><%= rset.getString("required_average") %></td>

						</tr>
					<%
					}
					rset.close();
					%>			
				</table>
				
				<h3>Courses to Fulfill Category Form</h3>
				<table>
					<tr>
						<th>Category</th>
						<th>Degree Number</th>
						<th>Course ID</th>
					</tr>
					<%--Insert category_requirements Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-category" name="action">
							<th><input value="" name="CATEGORY" size="10"></th>
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					<%--Delete category_requirements Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-category" name="action">
							<th><input value="" name="CATEGORY" size="10"></th>
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all category requirements-->
					<tr>
						<th>Category</th>
						<th>Degree Number</th>
						<th>Course ID</th>
					</tr>
					
 					<%
					pstmt = conn.prepareStatement("SELECT * FROM category_requirements;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("category") %></td>
							<td><%= rset.getString("degree_number") %></td>
							<td><%= rset.getString("course_id") %></td>
						</tr>
					<%
					}
					rset.close();
					%>			
				</table>
				
				<h3>Concentration Form</h3>
				<table>
					<tr>
						<th>Degree Number</th>
						<th>Concentration</th>
						<th>Minimum Units</th>
						<th>Minimum GPA</th>
					</tr>
					
					<%--Insert concentration Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-concentration" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="MIN_UNITS" size="10"></th>
							<th><input value="" name="MIN_GPA" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Update concentration Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="update-concentration" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="MIN_UNITS" size="10"></th>
							<th><input value="" name="MIN_GPA" size="10"></th>
							<th><input type="submit" value="Update"></th>
						</form>
					</tr>
					
					<%--Delete concentration Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-concentration" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="MIN_UNITS" size="10"></th>
							<th><input value="" name="MIN_GPA" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all concentration data-->
					<tr>
						<th>Degree Number</th>
						<th>Concentration</th>
						<th>Minimum Units</th>
						<th>Minimum GPA</th>
					</tr>
					
					<%
					pstmt = conn.prepareStatement("SELECT * FROM concentration;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("degree_number") %></td>
							<td><%= rset.getString("name") %></td>
							<td><%= rset.getString("min_units") %></td>
							<td><%= rset.getString("min_gpa") %></td>
						</tr>
					<%
					}
					rset.close();
					%>
				</table>		
					
				<h3>Courses to Fulfill Concentration Form</h3>
				<table>
					<tr>
						<th>Degree Number</th>
						<th>Concentration</th>
						<th>Course ID</th>
					</tr>
					
					<%--Insert concentration_requirements Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="insert-concentration-requirements" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input type="submit" value="Insert"></th>
						</form>
					</tr>
					
					<%--Delete concentration_requirements Code--%>
					<tr>
						<form action="degree_requirements.jsp" method="get">
							<input type="hidden" value="delete-concentration-requirements" name="action">
							<th><input value="" name="DEGREE_NUMBER" size="10"></th>
							<th><input value="" name="CONCENTRATION" size="10"></th>
							<th><input value="" name="COURSE_ID" size="10"></th>
							<th><input type="submit" value="Delete"></th>
						</form>
					</tr>
					
					<!-- Reading in all concentration_requirements data-->
					<tr>
						<th>Degree Number</th>
						<th>Concentration</th>
						<th>Course ID</th>
					</tr>
					
					<%
					pstmt = conn.prepareStatement("SELECT * FROM concentration_requirements;");
					rset = pstmt.executeQuery();
					
					while (rset.next()) {
					%>
						<tr>
							<td><%= rset.getString("degree_number") %></td>
							<td><%= rset.getString("name") %></td>
							<td><%= rset.getString("course_id") %></td>
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