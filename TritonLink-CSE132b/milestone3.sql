/* a */
SELECT ssn, first_name, middle_name, last_name
FROM student
WHERE ssn = x;

SELECT c.*, e.units_taken
FROM enroll e, classes c
WHERE e.quarter = 'SP' AND e.year = 2018
AND e.ssn = x AND e.class_id = c.class_id;

/* b */
WITH
SELECT course_id, quarter, year
FROM classes
WHERE title = y
AS class_info;

SELECT *
FROM class_info;

SELECT s.*, e.units_taken, e.grade_option
FROM enroll e, student s, class_info c
WHERE e.course_id = c.course_id AND s.ssn = e.ssn;

/* c */
SELECT ssn, first_name, middle_name, last_name
FROM student
WHERE ssn = x;

WITH
SELECT c.*, e.grade, e.units_taken
FROM enroll e, student s, class c
WHERE s.ssn = x AND s.ssn = e.ssn AND c.class_id = e.class_id
ORDER BY e.quarter, e.year
AS classes_taken;

SELECT c.quarter, c.year, AVG(number_grade)
FROM classes_taken c, grade_conversion g
WHERE c.grade = g.letter_grade
GROUP BY quarter, year;

SELECT AVG(number_grade)
FROM classes_taken c, grade_conversion g
WHERE c.grade = g.letter_grade;

d. Assist an undergraduate student X in figuring out remaining degree requirements for a bachelors in Y:

The form has two HTML SELECT controls, one with all undergraduate student names enrolled in the current quarter, and one with all BSC degrees. 
Display the SSN, FIRSTNAME, MIDDLENAME and LASTNAME attributes of STUDENT, but pass to the request only the SSN attribute. 
Similarly, display the NAME and TYPE attributes of DEGREEs, but pass to the request only the NAME attribute of DEGREE.

/* add attribute to undergrad table for bachelors of science, arts, etc. ?????*/
SELECT e.ssn, u.first_name, u.middle_name, u.last_name
FROM undergraduate u, enroll e
WHERE u.ssn = e.ssn AND u.ssn = x
AND e.quarter = 'SP' AND e.year = 2018;

/* Y = department name */ /* change student type options under student table */
SELECT ud.total_units
FROM department d, student s, ucsd_degree ud
WHERE d.dname = Y AND d.dno = s.dno
AND ud.dno = s.dno AND s.ssn = X
AND s.student_type = ud.type;

WITH unitsPerCategory AS
(SELECT category, number_units
FROM degree_requirement
WHERE degree_number = ?),
WITH coursesTaken AS
(SELECT e.course_id, e.units_taken
FROM enroll e
WHERE e.ssn = ?),
WITH unitsTakenPerCategory AS
(SELECT category, SUM(units_taken) AS takenUnits
FROM coursesTaken ct, category_requirements cr
WHERE degree_number = ? AND ct.course_id = cr.course_id
GROUP BY category)
SELECT category, u.number_units - ut.takenUnits AS units_left
FROM unitsPerCategory u, unitsTakenPerCategory ut
WHERE u.category = b.category;

WITH unitsPerCategory AS (SELECT category, number_units FROM degree_requirement WHERE degree_number = ?), WITH coursesTaken AS (SELECT e.course_id, e.units_taken FROM enroll e WHERE e.ssn = ?), WITH unitsTakenPerCategory AS (SELECT category, SUM(units_taken) AS takenUnits FROM coursesTaken ct, category_requirements cr WHERE degree_number = ? AND ct.course_id = cr.course_id GROUP category) SELECT category, u.number_units - ut.takenUnits FROM unitsPerCategory u, unitsTakenPerCategory ut WHERE u.category - b.category;

WITH enrolled_meetings AS
(SELECT m.day, m.start_time, m.end_time, m.course_id, m.class_id
FROM enroll e, meetings m
WHERE e.ssn = ? AND e.quarter = 'SP' AND e.year = 2022
AND e.course_id = m.course_id AND e.class_id = m.class_id AND e.quarter = m.quarter AND e.year = m.year),
meeting_options AS
(SELECT m.day, m.start_time, m.end_time, m.course_id, m.class_id
FROM meetings m
WHERE m.quarter = 'SP' AND m.year = 2022 AND NOT EXISTS
(SELECT * FROM enrolled_meetings em WHERE em.day = m.day AND em.start_time = m.start_time AND em.end_time = m.end_time AND em.course_id = m.course_id AND em.class_id = m.class_id)),
no_conflicts AS
(SELECT mo.day, mo.start_time, mo.end_time, mo.course_id, mo.class_id
FROM meeting_options mo, enrolled_meetings em
WHERE (mo.end_time <= em.start_time OR mo.start_time >= em.end_time) AND mo.day != em.day)
SELECT mo.course_id, mo.class_id
FROM no_conflicts
EXCEPT
SELECT mo.course_id, mo.class_id FROM meeting_options mo WHERE NOT EXISTS (SELECT * FROM no_conflicts nc WHERE mo.day = nc.day AND mo.start_time = nc.start_time AND mo.end_time = nc.end_time AND mo.course_id = nc.course_id AND mo.class_id = nc.class_id);

WITH enrolled_meetings AS (SELECT m.day, m.start_time, m.end_time, m.course_id, m.class_id FROM enroll e, meeting m WHERE e.ssn = ? AND e.quarter = 'SP' AND e.year = 2022 AND e.course_id = m.course_id AND e.class_id = m.class_id AND e.quarter = m.quarter AND e.year = m.year), meeting_options AS (SELECT m.day, m.start_time, m.end_time, m.course_id, m.class_id FROM meeting m WHERE m.quarter = 'SP' AND m.year = 2022), no_conflicts AS (SELECT mo.day, mo.start_time, mo.end_time, mo.course_id, mo.class_id FROM meeting_options mo, enrolled_meetings em WHERE (mo.end_time <= em.start_time OR mo.start_time >= em.end_time) AND mo.day != em.day) SELECT * FROM no_conflicts;

no_conflicts AS (SELECT mo.day, mo.start_time, mo.end_time, mo.course_id, mo.class_id FROM meeting_options mo, enrolled_meetings em WHERE (mo.end_time <= em.start_time OR mo.start_time >= em.end_time) AND mo.day != em.day)

















