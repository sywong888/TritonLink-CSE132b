/* 1a */
SELECT c.*, e.section_id, e.units_taken FROM enroll e, classes c 
WHERE e.quarter = 'SP' AND e.year = 2022 AND e.ssn = ? AND e.class_title = c.class_title;

/* 1b */
SELECT s.*, e.units_taken, e.grade_option FROM enroll e, student s 
WHERE e.class_title = ? AND s.ssn = e.ssn;

/* 1c */
SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c 
WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year;

WITH classes_taken AS 
(SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c 
WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) 
SELECT c.quarter, c.year, AVG(number_grade) AS average FROM classes_taken c, grade_conversion g 
WHERE c.grade = g.letter_grade GROUP BY quarter, year;

WITH classes_taken AS 
(SELECT c.*, e.grade, e.units_taken FROM enroll e, student s, classes c 
WHERE s.ssn = ? AND s.ssn = e.ssn AND c.class_title = e.class_title ORDER BY e.quarter, e.year) 
SELECT AVG(number_grade) AS average FROM classes_taken c, grade_conversion g WHERE c.grade = g.letter_grade;

/* 1d */
SELECT u.total_units FROM ucsd_degree u WHERE u.degree_number = ?;

WITH unitsPerCategory AS 
(SELECT category, number_units FROM degree_requirement WHERE degree_number = ?), 
coursesTaken AS 
(SELECT e.course_id, e.units_taken FROM enroll e WHERE e.ssn = ?), 
unitsTakenPerCategory AS 
(SELECT cr.category, SUM(units_taken) AS taken_units FROM coursesTaken ct, category_requirements cr 
WHERE degree_number = ? AND ct.course_id = cr.course_id GROUP BY cr.category), 
join_units AS 
(SELECT upc.category, upc.number_units, utpc.taken_units 
FROM unitsPerCategory upc LEFT JOIN unitsTakenPerCategory utpc ON upc.category = utpc.category)
SELECT ju.category, ju.number_units - COALESCE(ju.taken_units,0) AS units_left FROM join_units ju 
WHERE ju.number_units - ju.taken_units > 0 OR ju.number_units - ju.taken_units IS NULL;

/* 1e */
WITH units AS 
(SELECT cr.name, SUM(e.units_taken) AS total_units_taken FROM enroll e, concentration_requirements cr 
WHERE e.ssn = ? AND e.grade != 'IN' AND cr.degree_number = ? AND e.course_id = cr.course_id GROUP BY cr.name), 
gpa AS 
(SELECT cr.name, AVG(gc.number_grade) AS concentration_gpa FROM enroll e, concentration_requirements cr, grade_conversion gc 
WHERE e.ssn = ? AND e.grade != 'IN' AND cr.degree_number = ? AND e.course_id = cr.course_id AND e.grade = gc.letter_grade 
AND e.grade_option = 'letter' GROUP BY cr.name), 
units_gpa AS 
(SELECT units.name, units.total_units_taken, gpa.concentration_gpa FROM units JOIN gpa ON units.name = gpa.name) 
SELECT c.name FROM units_gpa ug, concentration c 
WHERE c.degree_number = ? AND c.name = ug.name AND ug.total_units_taken >= c.min_units AND ug.concentration_gpa >= c.min_gpa;

WITH y_concentration AS 
(SELECT c.* FROM concentration c WHERE degree_number = ?), 
courses_taken AS 
(SELECT e.course_id FROM enroll e WHERE e.ssn = ? AND e.grade != 'IN'), 
courses_left AS 
(SELECT cr.name, cr.course_id FROM concentration_requirements cr, y_concentration y 
WHERE cr.degree_number = y.degree_number AND cr.name = y.name AND cr.course_id NOT IN 
(SELECT * FROM courses_taken)), 
future_classes AS 
(SELECT c.course_id, c.quarter, c.year FROM classes c WHERE c.year > 2022 OR (c.year = 2022 AND c.quarter = 'FA')), 
earliest_classes AS 
(SELECT fc1.course_id, fc1.quarter, fc1.year FROM future_classes fc1 WHERE NOT EXISTS 
(SELECT * FROM future_classes fc2 
WHERE fc1.course_id = fc2.course_id AND fc1.quarter != fc2.quarter AND fc1.year != fc2.year 
AND (fc2.quarter >= fc1.quarter AND fc2.year <= fc1.year))) 
SELECT * FROM courses_left cl LEFT JOIN earliest_classes ec ON cl.course_id = ec.course_id;

/* 2a */
WITH enrolled_meetings AS 
(SELECT m.quarter, m.year, m.day, m.start_time, m.end_time, m.course_id, m.class_title, m.section_id 
FROM enroll e, meeting m  
WHERE e.ssn = ? AND e.quarter = 'SP' AND e.year = 2022 AND e.course_id = m.course_id AND e.class_title = m.class_title 
AND e.section_id = e.section_id AND e.quarter = m.quarter AND e.year = m.year), 
meeting_options AS 
(SELECT m.quarter, m.year, m.day, m.start_time, m.end_time, m.course_id, m.class_title, m.section_id FROM meeting m 
WHERE m.quarter = 'SP' AND m.year = 2022 AND NOT EXISTS 
(SELECT * FROM enrolled_meetings em 
WHERE em.day = m.day AND em.start_time = m.start_time AND em.end_time = m.end_time AND em.course_id = m.course_id 
AND em.class_title = m.class_title AND em.section_id = m.section_id)) 
SELECT c.class_title FROM classes c WHERE c.quarter = 'SP' AND c.year = 2022 AND NOT EXISTS 
(SELECT * FROM section s WHERE c.course_id = s.course_id AND c.class_title = s.class_title AND c.quarter = s.quarter 
AND c.year = s.year AND NOT EXISTS 
(SELECT * FROM meeting_options mo, enrolled_meetings em 
WHERE s.course_id = mo.course_id AND s.class_title = mo.class_title AND s.quarter = mo.quarter AND s.year = mo.year 
AND s.section_id = mo.section_id AND mo.day = em.day 
AND ((mo.start_time > em.start_time AND mo.start_time < em.end_time) 
OR (mo.end_time > em.start_time AND mo.end_time < em.end_time) 
OR (mo.start_time < em.start_time AND mo.end_time > em.end_time) 
OR (mo.start_time > em.start_time AND mo.end_time < em.end_time))));

/* 3a */
WITH profSections AS 
(SELECT s.section_id FROM section s 
WHERE s.quarter = ? AND s.year = ? AND s.instructor_id = ? AND s.course_id = ?), 
studentGrades AS 
(SELECT e.grade FROM enroll e 
WHERE e.quarter = ? AND e.year = ? AND e.course_id = ? AND e.section_id IN (SELECT * FROM profSections)) 
SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A'
UNION
SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B'
UNION 
SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' 
UNION 
SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' 
UNION 
SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg 
WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';

WITH profSections AS 
(SELECT s.section_id, s.quarter, s.year FROM section s 
WHERE s.instructor_id = ? AND s.course_id = ?), 
studentGrades AS 
(SELECT e.grade FROM enroll e 
WHERE EXISTS (SELECT * FROM profSections ps 
WHERE e.course_id = ? AND ps.section_id = e.section_id AND ps.quarter = e.quarter AND ps.year = e.year))
SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A'
UNION
SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B'
UNION 
SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' 
UNION 
SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' 
UNION 
SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg 
WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';

WITH allSections AS 
(SELECT s.section_id FROM section s 
WHERE s.course_id = ?), 
studentGrades AS 
(SELECT e.grade FROM enroll e 
WHERE e.course_id = ? AND e.section_id IN (SELECT * FROM allSections)) 
SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A'
UNION
SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B'
UNION 
SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' 
UNION 
SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' 
UNION 
SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg 
WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';

WITH profSections AS 
(SELECT s.section_id, s.quarter, s.year FROM section s 
WHERE s.instructor_id = ? AND s.course_id = ?)
SELECT AVG(gc.number_grade) AS gpa FROM enroll e, grade_conversion gc
WHERE EXISTS 
(SELECT * FROM profSections ps 
WHERE e.course_id = ? AND ps.section_id = e.section_id AND ps.quarter = e.quarter AND ps.year = e.year)
AND gc.letter_grade = e.grade;

/* Init */

INSERT INTO department VALUES (1, 'CSE');
INSERT INTO faculty VALUES (1, 'faculty1', 'faculty1', 'faculty1', 'professor', 1);
INSERT INTO faculty VALUES (2, 'faculty2', 'faculty2', 'faculty2', 'professor', 1);
INSERT INTO faculty VALUES (3, 'faculty3', 'faculty3', 'faculty3', 'professor', 1);
INSERT INTO ucsd_degree VALUES (1, 'bs', 1, 32);
INSERT INTO degree_requirement VALUES ('upper division', 1, 12, 3.0);
INSERT INTO degree_requirement VALUES ('lower division', 1, 12, 3.0);
INSERT INTO degree_requirement VALUES ('technical electives', 1, 8, 3.0);
INSERT INTO department VALUES (2, 'MATH');
INSERT INTO ucsd_degree VALUES (2, 'bs', 2, 36);
INSERT INTO degree_requirement VALUES ('upper division', 2, 8, 3.0);
INSERT INTO degree_requirement VALUES ('lower division', 2, 16, 3.0);
INSERT INTO degree_requirement VALUES ('technical electives', 2, 12, 3.0);
INSERT INTO ucsd_degree VALUES (3, 'masters', 1, 32);
INSERT INTO concentration VALUES (3, 'Database', 6, 3.0);
INSERT INTO concentration VALUES (3, 'Systems', 12, 3.0);
INSERT INTO ucsd_degree VALUES (4, 'masters', 2, 32);
INSERT INTO concentration VALUES (4, 'Number Theory', 6, 3.0);
INSERT INTO concentration VALUES (4, 'Calculus', 12, 3.0);
INSERT INTO student VALUES ('111111111', 'student1', 'student1', 'student1', '111111111', 'bs', 'California', 1, 'y');
INSERT INTO undergraduate VALUES ('111111111', 'bs', 'computer science', 'economics', 'Sixth');
INSERT INTO student VALUES ('222222222', 'student2', 'student2', 'student2', '222222222', 'bs', 'California', 1, 'y');
INSERT INTO undergraduate VALUES ('222222222', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('333333333', 'student3', 'student3', 'student3', '333333333', 'bs', 'California', 1, 'y');
INSERT INTO undergraduate VALUES ('333333333', 'bs', 'math', 'aquatics', 'Sixth');
INSERT INTO courses VALUES (1, 1, '132A', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (1, 'CSE132A-1', 'SP', 2022);
INSERT INTO section VALUES (1, 'CSE132A-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO meeting VALUES (1, 'CSE132A-1', 'SP', 2022, 'A00', 'M', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (1, 'CSE132A-1', 'SP', 2022, 'A00', 'W', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (1, 'CSE132A-1', 'SP', 2022, 'A00', 'F', '13:00', '13:50', 'room1', 'discussion', 'n');
INSERT INTO classes VALUES (1, 'CSE132A-2', 'FA', 2017);
INSERT INTO section VALUES (1, 'CSE132A-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO meeting VALUES (1, 'CSE132A-2', 'FA', 2017, 'A00', 'M', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (1, 'CSE132A-2', 'FA', 2017, 'A00', 'W', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (1, 'CSE132A-2', 'FA', 2017, 'A00', 'F', '13:00', '13:50', 'room1', 'discussion', 'n');
INSERT INTO classes VALUES (1, 'CSE132A-3', 'FA', 2015);
INSERT INTO section VALUES (1, 'CSE132A-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO meeting VALUES (1, 'CSE132A-3', 'FA', 2015, 'A00', 'M', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (1, 'CSE132A-3', 'FA', 2015, 'A00', 'W', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (1, 'CSE132A-3', 'FA', 2015, 'A00', 'F', '13:00', '13:50', 'room1', 'discussion', 'n');
INSERT INTO courses VALUES (2, 1, '150A', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (2, 'CSE150A-1', 'SP', 2022);
INSERT INTO section VALUES (2, 'CSE150A-1', 'SP', 2022, 'A00', 2, 100);
INSERT INTO meeting VALUES (2, 'CSE150A-1', 'SP', 2022, 'A00', 'M', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO meeting VALUES (2, 'CSE150A-1', 'SP', 2022, 'A00', 'W', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO classes VALUES (2, 'CSE150A-2', 'FA', 2017);
INSERT INTO section VALUES (2, 'CSE150A-2', 'FA', 2017, 'A00', 2, 100);
INSERT INTO meeting VALUES (2, 'CSE150A-2', 'FA', 2017, 'A00', 'M', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO meeting VALUES (2, 'CSE150A-2', 'FA', 2017, 'A00', 'W', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO classes VALUES (2, 'CSE150A-3', 'FA', 2015);
INSERT INTO section VALUES (2, 'CSE150A-3', 'FA', 2015, 'A00', 2, 100);
INSERT INTO meeting VALUES (2, 'CSE150A-3', 'FA', 2015, 'A00', 'M', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO meeting VALUES (2, 'CSE150A-3', 'FA', 2015, 'A00', 'W', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO courses VALUES (3, 1, '124A', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (3, 'CSE124A-1', 'SP', 2022);
INSERT INTO section VALUES (3, 'CSE124A-1', 'SP', 2022, 'A00', 2, 100);
INSERT INTO meeting VALUES (3, 'CSE124A-1', 'SP', 2022, 'A00', 'T', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (3, 'CSE124A-1', 'SP', 2022, 'A00', 'R', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (3, 'CSE124A-1', 'SP', 2022, 'A00', 'M', '12:00', '12:50', 'room3', 'discussion', 'n');
INSERT INTO classes VALUES (3, 'CSE124A-2', 'FA', 2017);
INSERT INTO section VALUES (3, 'CSE124A-2', 'FA', 2017, 'A00', 2, 100);
INSERT INTO meeting VALUES (3, 'CSE124A-2', 'FA', 2017, 'A00', 'T', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (3, 'CSE124A-2', 'FA', 2017, 'A00', 'R', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (3, 'CSE124A-2', 'FA', 2017, 'A00', 'M', '12:00', '12:50', 'room3', 'discussion', 'n');
INSERT INTO classes VALUES (3, 'CSE124A-3', 'FA', 2015);
INSERT INTO section VALUES (3, 'CSE124A-3', 'FA', 2015, 'A00', 2, 100);
INSERT INTO meeting VALUES (3, 'CSE124A-3', 'FA', 2015, 'A00', 'T', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (3, 'CSE124A-3', 'FA', 2015, 'A00', 'R', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (3, 'CSE124A-3', 'FA', 2015, 'A00', 'M', '12:00', '12:50', 'room3', 'discussion', 'n');
INSERT INTO courses VALUES (4, 1, '132B', NULL, 'both', '1,2,3,4');
INSERT INTO classes VALUES (4, 'CSE132B-1', 'SP', 2022);
INSERT INTO section VALUES (4, 'CSE132B-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO meeting VALUES (4, 'CSE132B-1', 'SP', 2022, 'A00', 'T', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO meeting VALUES (4, 'CSE132B-1', 'SP', 2022, 'A00', 'R', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO classes VALUES (4, 'CSE132B-2', 'FA', 2017);
INSERT INTO section VALUES (4, 'CSE132B-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO meeting VALUES (4, 'CSE132B-2', 'FA', 2017, 'A00', 'T', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO meeting VALUES (4, 'CSE132B-2', 'FA', 2017, 'A00', 'R', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO classes VALUES (4, 'CSE132B-3', 'FA', 2015);
INSERT INTO section VALUES (4, 'CSE132B-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO meeting VALUES (4, 'CSE132B-3', 'FA', 2015, 'A00', 'T', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO meeting VALUES (4, 'CSE132B-3', 'FA', 2015, 'A00', 'R', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO courses VALUES (5, 1, '132C', NULL, 'both', '1,2,3,4');
INSERT INTO classes VALUES (5, 'CSE132C-1', 'SP', 2022);
INSERT INTO section VALUES (5, 'CSE132C-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO classes VALUES (5, 'CSE132C-2', 'FA', 2017);
INSERT INTO section VALUES (5, 'CSE132C-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO classes VALUES (5, 'CSE132C-3', 'FA', 2015);
INSERT INTO section VALUES (5, 'CSE132C-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO courses VALUES (6, 1, '130', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (6, 'CSE130-1', 'SP', 2022);
INSERT INTO section VALUES (6, 'CSE130-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO meeting VALUES (6, 'CSE130-1', 'SP', 2022, 'A00', 'T', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (6, 'CSE130-1', 'SP', 2022, 'A00', 'R', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (6, 'CSE130-1', 'SP', 2022, 'A00', 'F', '09:00', '10:00', 'room5', 'discussion', 'n');
INSERT INTO classes VALUES (6, 'CSE130-2', 'FA', 2017);
INSERT INTO section VALUES (6, 'CSE130-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO meeting VALUES (6, 'CSE130-2', 'FA', 2017, 'A00', 'T', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (6, 'CSE130-2', 'FA', 2017, 'A00', 'R', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (6, 'CSE130-2', 'FA', 2017, 'A00', 'F', '09:00', '10:00', 'room5', 'discussion', 'n');
INSERT INTO classes VALUES (6, 'CSE130-3', 'FA', 2015);
INSERT INTO section VALUES (6, 'CSE130-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO meeting VALUES (6, 'CSE130-3', 'FA', 2015, 'A00', 'T', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (6, 'CSE130-3', 'FA', 2015, 'A00', 'R', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (6, 'CSE130-3', 'FA', 2015, 'A00', 'F', '09:00', '10:00', 'room5', 'discussion', 'n');
INSERT INTO courses VALUES (7, 1, '005', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (7, 'CSE005-1', 'SP', 2022);
INSERT INTO section VALUES (7, 'CSE005-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (7, 'CSE005-2', 'FA', 2017);
INSERT INTO section VALUES (7, 'CSE005-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (7, 'CSE005-3', 'FA', 2015);
INSERT INTO section VALUES (7, 'CSE005-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (8, 1, '000', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (8, 'CSE000-1', 'SP', 2022);
INSERT INTO section VALUES (8, 'CSE000-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (8, 'CSE000-2', 'FA', 2017);
INSERT INTO section VALUES (8, 'CSE000-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (8, 'CSE000-3', 'FA', 2015);
INSERT INTO section VALUES (8, 'CSE000-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (9, 1, '007', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (9, 'CSE007-1', 'SP', 2022);
INSERT INTO section VALUES (9, 'CSE007-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (9, 'CSE007-2', 'FA', 2017);
INSERT INTO section VALUES (9, 'CSE007-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (9, 'CSE007-3', 'FA', 2015);
INSERT INTO section VALUES (9, 'CSE007-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (10, 1, '008', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (10, 'CSE008-1', 'SP', 2022);
INSERT INTO section VALUES (10, 'CSE008-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (10, 'CSE008-2', 'FA', 2017);
INSERT INTO section VALUES (10, 'CSE008-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (10, 'CSE008-3', 'FA', 2015);
INSERT INTO section VALUES (10, 'CSE008-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (11, 2, '132A', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (11, 'MATH132A-1', 'SP', 2022);
INSERT INTO section VALUES (11, 'MATH132A-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO meeting VALUES (11, 'MATH132A-1', 'SP', 2022, 'A00', 'M', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (11, 'MATH132A-1', 'SP', 2022, 'A00', 'W', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (11, 'MATH132A-1', 'SP', 2022, 'A00', 'F', '13:00', '13:50', 'room1', 'discussion', 'n');
INSERT INTO classes VALUES (11, 'MATH132A-2', 'FA', 2017);
INSERT INTO section VALUES (11, 'MATH132A-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO meeting VALUES (11, 'MATH132A-2', 'FA', 2017, 'A00', 'M', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (11, 'MATH132A-2', 'FA', 2017, 'A00', 'W', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (11, 'MATH132A-2', 'FA', 2017, 'A00', 'F', '13:00', '13:50', 'room1', 'discussion', 'n');
INSERT INTO classes VALUES (11, 'MATH132A-3', 'FA', 2015);
INSERT INTO section VALUES (11, 'MATH132A-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO meeting VALUES (11, 'MATH132A-3', 'FA', 2015, 'A00', 'M', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (11, 'MATH132A-3', 'FA', 2015, 'A00', 'W', '13:00', '15:00', 'room1', 'lecture', 'n');
INSERT INTO meeting VALUES (11, 'MATH132A-3', 'FA', 2015, 'A00', 'F', '13:00', '13:50', 'room1', 'discussion', 'n');
INSERT INTO courses VALUES (12, 2, '150A', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (12, 'MATH150A-1', 'SP', 2022);
INSERT INTO section VALUES (12, 'MATH150A-1', 'SP', 2022, 'A00', 2, 100);
INSERT INTO meeting VALUES (12, 'MATH150A-1', 'SP', 2022, 'A00', 'M', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO meeting VALUES (12, 'MATH150A-1', 'SP', 2022, 'A00', 'W', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO classes VALUES (12, 'MATH150A-2', 'FA', 2017);
INSERT INTO section VALUES (12, 'MATH150A-2', 'FA', 2017, 'A00', 2, 100);
INSERT INTO meeting VALUES (12, 'MATH150A-2', 'FA', 2017, 'A00', 'M', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO meeting VALUES (12, 'MATH150A-2', 'FA', 2017, 'A00', 'W', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO classes VALUES (12, 'MATH150A-3', 'FA', 2015);
INSERT INTO section VALUES (12, 'MATH150A-3', 'FA', 2015, 'A00', 2, 100);
INSERT INTO meeting VALUES (12, 'MATH150A-3', 'FA', 2015, 'A00', 'M', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO meeting VALUES (12, 'MATH150A-3', 'FA', 2015, 'A00', 'W', '14:00', '16:00', 'room2', 'lecture', 'n');
INSERT INTO courses VALUES (13, 2, '124A', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (13, 'MATH124A-1', 'SP', 2022);
INSERT INTO section VALUES (13, 'MATH124A-1', 'SP', 2022, 'A00', 2, 100);
INSERT INTO meeting VALUES (13, 'MATH124A-1', 'SP', 2022, 'A00', 'T', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (13, 'MATH124A-1', 'SP', 2022, 'A00', 'R', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (13, 'MATH124A-1', 'SP', 2022, 'A00', 'M', '12:00', '12:50', 'room3', 'discussion', 'n');
INSERT INTO classes VALUES (13, 'MATH124A-2', 'FA', 2017);
INSERT INTO section VALUES (13, 'MATH124A-2', 'FA', 2017, 'A00', 2, 100);
INSERT INTO meeting VALUES (13, 'MATH124A-2', 'FA', 2017, 'A00', 'T', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (13, 'MATH124A-2', 'FA', 2017, 'A00', 'R', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (13, 'MATH124A-2', 'FA', 2017, 'A00', 'M', '12:00', '12:50', 'room3', 'discussion', 'n');
INSERT INTO classes VALUES (13, 'MATH124A-3', 'FA', 2015);
INSERT INTO section VALUES (13, 'MATH124A-3', 'FA', 2015, 'A00', 2, 100);
INSERT INTO meeting VALUES (13, 'MATH124A-3', 'FA', 2015, 'A00', 'T', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (13, 'MATH124A-3', 'FA', 2015, 'A00', 'R', '20:00', '21:20', 'room3', 'lecture', 'n');
INSERT INTO meeting VALUES (13, 'MATH124A-3', 'FA', 2015, 'A00', 'M', '12:00', '12:50', 'room3', 'discussion', 'n');
INSERT INTO courses VALUES (14, 2, '132B', NULL, 'both', '1,2,3,4');
INSERT INTO classes VALUES (14, 'MATH132B-1', 'SP', 2022);
INSERT INTO section VALUES (14, 'MATH132B-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO meeting VALUES (14, 'MATH132B-1', 'SP', 2022, 'A00', 'T', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO meeting VALUES (14, 'MATH132B-1', 'SP', 2022, 'A00', 'R', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO classes VALUES (14, 'MATH132B-2', 'FA', 2017);
INSERT INTO section VALUES (14, 'MATH132B-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO meeting VALUES (14, 'MATH132B-2', 'FA', 2017, 'A00', 'T', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO meeting VALUES (14, 'MATH132B-2', 'FA', 2017, 'A00', 'R', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO classes VALUES (14, 'MATH132B-3', 'FA', 2015);
INSERT INTO section VALUES (14, 'MATH132B-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO meeting VALUES (14, 'MATH132B-3', 'FA', 2015, 'A00', 'T', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO meeting VALUES (14, 'MATH132B-3', 'FA', 2015, 'A00', 'R', '15:00', '17:00', 'room4', 'lecture', 'n');
INSERT INTO courses VALUES (15, 2, '132C', NULL, 'both', '1,2,3,4');
INSERT INTO classes VALUES (15, 'MATH132C-1', 'SP', 2022);
INSERT INTO section VALUES (15, 'MATH132C-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO classes VALUES (15, 'MATH132C-2', 'FA', 2017);
INSERT INTO section VALUES (15, 'MATH132C-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO classes VALUES (15, 'MATH132C-3', 'FA', 2015);
INSERT INTO section VALUES (15, 'MATH132C-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO courses VALUES (16, 2, '130', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (16, 'MATH130-1', 'SP', 2022);
INSERT INTO section VALUES (16, 'MATH130-1', 'SP', 2022, 'A00', 1, 100);
INSERT INTO meeting VALUES (16, 'MATH130-1', 'SP', 2022, 'A00', 'T', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (16, 'MATH130-1', 'SP', 2022, 'A00', 'R', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (16, 'MATH130-1', 'SP', 2022, 'A00', 'F', '09:00', '10:00', 'room5', 'discussion', 'n');
INSERT INTO classes VALUES (16, 'MATH130-2', 'FA', 2017);
INSERT INTO section VALUES (16, 'MATH130-2', 'FA', 2017, 'A00', 1, 100);
INSERT INTO meeting VALUES (16, 'MATH130-2', 'FA', 2017, 'A00', 'T', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (16, 'MATH130-2', 'FA', 2017, 'A00', 'R', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (16, 'MATH130-2', 'FA', 2017, 'A00', 'F', '09:00', '10:00', 'room5', 'discussion', 'n');
INSERT INTO classes VALUES (16, 'MATH130-3', 'FA', 2015);
INSERT INTO section VALUES (16, 'MATH130-3', 'FA', 2015, 'A00', 1, 100);
INSERT INTO meeting VALUES (16, 'MATH130-3', 'FA', 2015, 'A00', 'T', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (16, 'MATH130-3', 'FA', 2015, 'A00', 'R', '10:00', '13:00', 'room5', 'lecture', 'n');
INSERT INTO meeting VALUES (16, 'MATH130-3', 'FA', 2015, 'A00', 'F', '09:00', '10:00', 'room5', 'discussion', 'n');
INSERT INTO courses VALUES (17, 2, '005', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (17, 'MATH005-1', 'SP', 2022);
INSERT INTO section VALUES (17, 'MATH005-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (17, 'MATH005-2', 'FA', 2017);
INSERT INTO section VALUES (17, 'MATH005-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (17, 'MATH005-3', 'FA', 2015);
INSERT INTO section VALUES (17, 'MATH005-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (18, 2, '000', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (18, 'MATH000-1', 'SP', 2022);
INSERT INTO section VALUES (18, 'MATH000-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (18, 'MATH000-2', 'FA', 2017);
INSERT INTO section VALUES (18, 'MATH000-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (18, 'MATH000-3', 'FA', 2015);
INSERT INTO section VALUES (18, 'MATH000-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (19, 2, '007', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (19, 'MATH007-1', 'SP', 2022);
INSERT INTO section VALUES (19, 'MATH007-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (19, 'MATH007-2', 'FA', 2017);
INSERT INTO section VALUES (19, 'MATH007-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (19, 'MATH007-3', 'FA', 2015);
INSERT INTO section VALUES (19, 'MATH007-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO courses VALUES (20, 2, '008', NULL, 'letter', '1,2,3,4');
INSERT INTO classes VALUES (20, 'MATH008-1', 'SP', 2022);
INSERT INTO section VALUES (20, 'MATH008-1', 'SP', 2022, 'A00', 3, 100);
INSERT INTO classes VALUES (20, 'MATH008-2', 'FA', 2017);
INSERT INTO section VALUES (20, 'MATH008-2', 'FA', 2017, 'A00', 3, 100);
INSERT INTO classes VALUES (20, 'MATH008-3', 'FA', 2015);
INSERT INTO section VALUES (20, 'MATH008-3', 'FA', 2015, 'A00', 3, 100);
INSERT INTO enroll VALUES ('111111111', 1, 'CSE132A-1', 'SP', 2022, 'A00', 4, 'letter', 'enroll', 'IN');
INSERT INTO enroll VALUES ('222222222', 1, 'CSE132A-1', 'SP', 2022, 'A00', 2, 'letter', 'enroll', 'IN');
INSERT INTO enroll VALUES ('333333333', 1, 'CSE132A-1', 'SP', 2022, 'A00', 2, 'letter', 'enroll', 'IN');
INSERT INTO enroll VALUES ('111111111', 6, 'CSE130-1', 'SP', 2022, 'A00', 4, 'letter', 'enroll', 'IN');
INSERT INTO enroll VALUES ('111111111', 4, 'CSE132B-3', 'FA', 2015, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('222222222', 4, 'CSE132B-3', 'FA', 2015, 'A00', 2, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('333333333', 4, 'CSE132B-3', 'FA', 2015, 'A00', 2, 'letter', 'enroll', 'C');
INSERT INTO enroll VALUES ('111111111', 5, 'CSE132C-3', 'FA', 2015, 'A00', 3, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('222222222', 5, 'CSE132C-3', 'FA', 2015, 'A00', 4, 'letter', 'enroll', 'C');
INSERT INTO enroll VALUES ('333333333', 5, 'CSE132C-3', 'FA', 2015, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO student VALUES ('444444444', 'student4', 'student4', 'student4', '444444444', 'masters', 'California', 1, 'y');
INSERT INTO graduate VALUES ('444444444');
INSERT INTO masters VALUES ('444444444');
INSERT INTO student VALUES ('555555555', 'student5', 'student5', 'student5', '555555555', 'masters', 'California', 2, 'y');
INSERT INTO graduate VALUES ('555555555');
INSERT INTO masters VALUES ('555555555');
INSERT INTO concentration_requirements VALUES (3, 'Database', 1);
INSERT INTO concentration_requirements VALUES (3, 'Database', 4);
INSERT INTO concentration_requirements VALUES (3, 'Database', 5);
INSERT INTO concentration_requirements VALUES (3, 'Systems', 6);
INSERT INTO concentration_requirements VALUES (3, 'Systems', 8);
INSERT INTO concentration_requirements VALUES (3, 'Systems', 9);
INSERT INTO concentration_requirements VALUES (3, 'Systems', 4);
INSERT INTO concentration_requirements VALUES (4, 'Number Theory', 11);
INSERT INTO concentration_requirements VALUES (4, 'Number Theory', 14);
INSERT INTO concentration_requirements VALUES (4, 'Number Theory', 15);
INSERT INTO concentration_requirements VALUES (4, 'Calculus', 16);
INSERT INTO concentration_requirements VALUES (4, 'Calculus', 18);
INSERT INTO concentration_requirements VALUES (4, 'Calculus', 19);
INSERT INTO concentration_requirements VALUES (4, 'Calculus', 14);
INSERT INTO student VALUES ('666666666', 'student6', 'student6', 'student6', '666666666', 'bs', 'foreign', 1, 'y');
INSERT INTO undergraduate VALUES ('666666666', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('777777777', 'student7', 'student7', 'student7', '777777777', 'bs', 'foreign', 1, 'y');
INSERT INTO undergraduate VALUES ('777777777', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('888888888', 'student8', 'student8', 'student8', '888888888', 'bs', 'foreign', 1, 'y');
INSERT INTO undergraduate VALUES ('888888888', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('999999999', 'student9', 'student9', 'student9', '999999999', 'bs', 'foreign', 1, 'y');
INSERT INTO undergraduate VALUES ('999999999', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('121212121', 'student10', 'student10', 'student10', '121212121', 'bs', 'foreign', 1, 'y');
INSERT INTO undergraduate VALUES ('121212121', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('232323232', 'student11', 'student11', 'student11', '232323232', 'bs', 'non-CA US', 1, 'y');
INSERT INTO undergraduate VALUES ('232323232', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('343434343', 'student12', 'student12', 'student12', '343434343', 'bs', 'non-CA US', 1, 'y');
INSERT INTO undergraduate VALUES ('343434343', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('454545454', 'student13', 'student13', 'student13', '454545454', 'bs', 'non-CA US', 1, 'y');
INSERT INTO undergraduate VALUES ('454545454', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('565656565', 'student14', 'student14', 'student14', '565656565', 'bs', 'non-CA US', 1, 'y');
INSERT INTO undergraduate VALUES ('565656565', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO student VALUES ('676767676', 'student15', 'student15', 'student15', '676767676', 'bs', 'non-CA US', 1, 'y');
INSERT INTO undergraduate VALUES ('676767676', 'bs', 'computer science', 'math', 'Sixth');
INSERT INTO enroll VALUES ('666666666', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('777777777', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('888888888', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('999999999', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('121212121', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'C');
INSERT INTO enroll VALUES ('232323232', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'C');
INSERT INTO enroll VALUES ('343434343', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'C');
INSERT INTO enroll VALUES ('454545454', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'D');
INSERT INTO enroll VALUES ('565656565', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'D');
INSERT INTO enroll VALUES ('676767676', 10, 'CSE008-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'D');
INSERT INTO enroll VALUES ('666666666', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('777777777', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('888888888', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('999999999', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('121212121', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('232323232', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('343434343', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('454545454', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('565656565', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('676767676', 7, 'CSE005-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'C');
INSERT INTO enroll VALUES ('666666666', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('777777777', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('888888888', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('999999999', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('121212121', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'A');
INSERT INTO enroll VALUES ('232323232', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('343434343', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('454545454', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('565656565', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'B');
INSERT INTO enroll VALUES ('676767676', 2, 'CSE150A-2', 'FA', 2017, 'A00', 4, 'letter', 'enroll', 'C');
INSERT INTO category_requirements VALUES ('upper division', 1, 1);
INSERT INTO category_requirements VALUES ('upper division', 1, 2);
INSERT INTO category_requirements VALUES ('upper division', 1, 3);
INSERT INTO category_requirements VALUES ('upper division', 1, 4);
INSERT INTO category_requirements VALUES ('upper division', 1, 5);
INSERT INTO category_requirements VALUES ('upper division', 1, 6);
INSERT INTO category_requirements VALUES ('lower division', 1, 7);
INSERT INTO category_requirements VALUES ('lower division', 1, 8);
INSERT INTO category_requirements VALUES ('lower division', 1, 9);
INSERT INTO category_requirements VALUES ('lower division', 1, 10);
INSERT INTO category_requirements VALUES ('technical electives', 1, 1);
INSERT INTO category_requirements VALUES ('technical electives', 1, 2);
INSERT INTO category_requirements VALUES ('technical electives', 1, 3);
INSERT INTO category_requirements VALUES ('technical electives', 1, 4);
INSERT INTO category_requirements VALUES ('technical electives', 1, 5);
INSERT INTO category_requirements VALUES ('technical electives', 1, 6);
INSERT INTO category_requirements VALUES ('technical electives', 1, 7);
INSERT INTO category_requirements VALUES ('technical electives', 1, 8);
INSERT INTO category_requirements VALUES ('technical electives', 1, 9);
INSERT INTO category_requirements VALUES ('technical electives', 1, 10);
INSERT INTO category_requirements VALUES ('upper division', 2, 11);
INSERT INTO category_requirements VALUES ('upper division', 2, 12);
INSERT INTO category_requirements VALUES ('upper division', 2, 13);
INSERT INTO category_requirements VALUES ('upper division', 2, 14);
INSERT INTO category_requirements VALUES ('upper division', 2, 15);
INSERT INTO category_requirements VALUES ('upper division', 2, 16);
INSERT INTO category_requirements VALUES ('lower division', 2, 17);
INSERT INTO category_requirements VALUES ('lower division', 2, 18);
INSERT INTO category_requirements VALUES ('lower division', 2, 19);
INSERT INTO category_requirements VALUES ('lower division', 2, 20);
INSERT INTO category_requirements VALUES ('technical electives', 2, 11);
INSERT INTO category_requirements VALUES ('technical electives', 2, 12);
INSERT INTO category_requirements VALUES ('technical electives', 2, 13);
INSERT INTO category_requirements VALUES ('technical electives', 2, 14);
INSERT INTO category_requirements VALUES ('technical electives', 2, 15);
INSERT INTO category_requirements VALUES ('technical electives', 2, 16);
INSERT INTO category_requirements VALUES ('technical electives', 2, 17);
INSERT INTO category_requirements VALUES ('technical electives', 2, 18);
INSERT INTO category_requirements VALUES ('technical electives', 2, 19);
INSERT INTO category_requirements VALUES ('technical electives', 2, 20);






 












