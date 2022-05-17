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