/* CPQG */
CREATE VIEW all_grades AS
(SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'A' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'B' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'C' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'D' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'other' AS grade
FROM section s)
ORDER BY instructor_id, course_id, quarter, year, grade;

CREATE VIEW prof_and_course AS
(SELECT s.instructor_id, e.course_id, e.quarter, e.year, e.grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade = 'A' OR e.grade = 'B' OR e.grade = 'C' OR e.grade = 'D')
GROUP BY s.instructor_id, e.course_id, e.quarter, e.year, e.grade
UNION
SELECT s.instructor_id, e.course_id, e.quarter, e.year, 'other' AS grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade != 'A' AND e.grade != 'B' AND e.grade != 'C' AND e.grade != 'D')
GROUP BY s.instructor_id, e.course_id, e.quarter, e.year, e.grade)
ORDER BY instructor_id, course_id, quarter, year, grade;

CREATE VIEW counts AS
SELECT all_grades.instructor_id, all_grades.course_id, all_grades.quarter, all_grades.year, all_grades.grade, COALESCE(prof_and_course.count, 0) AS count
FROM all_grades
LEFT JOIN
prof_and_course
ON all_grades.instructor_id = prof_and_course.instructor_id AND all_grades.course_id = prof_and_course.course_id 
AND all_grades.quarter = prof_and_course.quarter AND all_grades.year = prof_and_course.year AND all_grades.grade = prof_and_course.grade
ORDER BY instructor_id, course_id, quarter, year, grade;

/* final CPQG */
CREATE TABLE CPQG AS
WITH all_grades AS
((SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'A' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'B' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'C' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'D' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, s.quarter, s.year, 'other' AS grade
FROM section s)
ORDER BY instructor_id, course_id, quarter, year, grade),
prof_and_course AS
((SELECT s.instructor_id, e.course_id, e.quarter, e.year, e.grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade = 'A' OR e.grade = 'B' OR e.grade = 'C' OR e.grade = 'D')
GROUP BY s.instructor_id, e.course_id, e.quarter, e.year, e.grade
UNION
SELECT s.instructor_id, e.course_id, e.quarter, e.year, 'other' AS grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade != 'A' AND e.grade != 'B' AND e.grade != 'C' AND e.grade != 'D')
GROUP BY s.instructor_id, e.course_id, e.quarter, e.year, e.grade)
ORDER BY instructor_id, course_id, quarter, year, grade)
SELECT all_grades.instructor_id, all_grades.course_id, all_grades.quarter, all_grades.year, all_grades.grade, COALESCE(prof_and_course.count, 0) AS count
FROM all_grades
LEFT JOIN
prof_and_course
ON all_grades.instructor_id = prof_and_course.instructor_id AND all_grades.course_id = prof_and_course.course_id 
AND all_grades.quarter = prof_and_course.quarter AND all_grades.year = prof_and_course.year AND all_grades.grade = prof_and_course.grade
ORDER BY instructor_id, course_id, quarter, year, grade;

/* Decision Support Query */
WITH profSections AS 
(SELECT s.section_id FROM section s WHERE s.quarter = ? AND s.year = ? AND s.instructor_id = ? AND s.course_id = ?), 
studentGrades AS 
(SELECT e.grade FROM enroll e WHERE e.quarter = ? AND e.year = ? AND e.course_id = ? AND e.section_id IN (SELECT * FROM profSections)) 
(SELECT 'A' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'A') UNION 
(SELECT 'B' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'B') UNION 
SELECT 'C' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'C' UNION 
SELECT 'D' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade = 'D' UNION 
SELECT 'other' AS grade, COUNT(*) AS count FROM studentGrades sg WHERE sg.grade != 'A' AND sg.grade != 'B' AND sg.grade != 'C' AND sg.grade != 'D';

SELECT *
FROM CPQG c
WHERE c.course_id = ? AND c.instructor_id = ? AND c.quarter = ? AND c.year = ?
ORDER BY grade;