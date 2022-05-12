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