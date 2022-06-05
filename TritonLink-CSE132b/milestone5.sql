/* CPQG */

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
GROUP BY s.instructor_id, e.course_id, e.quarter, e.year, e.section_id, e.grade
UNION
SELECT s.instructor_id, e.course_id, e.quarter, e.year, 'other' AS grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade != 'A' AND e.grade != 'B' AND e.grade != 'C' AND e.grade != 'D')
GROUP BY s.instructor_id, e.course_id, e.quarter, e.year, e.section_id, e.grade)
ORDER BY instructor_id, course_id, quarter, year, grade)
SELECT all_grades.instructor_id, all_grades.course_id, all_grades.quarter, all_grades.year, all_grades.grade, COALESCE(prof_and_course.count, 0) AS count
FROM all_grades
LEFT JOIN
prof_and_course
ON all_grades.instructor_id = prof_and_course.instructor_id AND all_grades.course_id = prof_and_course.course_id 
AND all_grades.quarter = prof_and_course.quarter AND all_grades.year = prof_and_course.year AND all_grades.grade = prof_and_course.grade
ORDER BY instructor_id, course_id, quarter, year, grade;

/* Decision Support Query */
SELECT *
FROM CPQG c
WHERE c.course_id = ? AND c.instructor_id = ? AND c.quarter = ? AND c.year = ?
ORDER BY grade;

/* CPG */
CREATE VIEW all_grades AS
(SELECT s.instructor_id, s.course_id, 'A' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'B' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'C' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'D' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'other' AS grade
FROM section s)
ORDER BY instructor_id, course_id, grade;

CREATE VIEW prof_and_course AS
(SELECT s.instructor_id, e.course_id, e.grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade = 'A' OR e.grade = 'B' OR e.grade = 'C' OR e.grade = 'D')
GROUP BY s.instructor_id, e.course_id, e.section_id, e.grade
UNION
SELECT s.instructor_id, e.course_id, 'other' AS grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade != 'A' AND e.grade != 'B' AND e.grade != 'C' AND e.grade != 'D')
GROUP BY s.instructor_id, e.course_id, e.section_id, e.grade)
ORDER BY instructor_id, course_id, grade;

CREATE VIEW counts AS
SELECT all_grades.instructor_id, all_grades.course_id, all_grades.grade, COALESCE(prof_and_course.count, 0) AS count
FROM all_grades
LEFT JOIN
prof_and_course
ON all_grades.instructor_id = prof_and_course.instructor_id AND all_grades.course_id = prof_and_course.course_id AND all_grades.grade = prof_and_course.grade
ORDER BY instructor_id, course_id, grade;

/* final CPG */
CREATE TABLE CPG AS
WITH all_grades AS
((SELECT s.instructor_id, s.course_id, 'A' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'B' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'C' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'D' AS grade
FROM section s
UNION
SELECT s.instructor_id, s.course_id, 'other' AS grade
FROM section s)
ORDER BY instructor_id, course_id, grade),
prof_and_course AS
((SELECT s.instructor_id, e.course_id, e.grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade = 'A' OR e.grade = 'B' OR e.grade = 'C' OR e.grade = 'D')
GROUP BY s.instructor_id, e.course_id, e.section_id, e.grade
UNION
SELECT s.instructor_id, e.course_id, 'other' AS grade, COUNT(*) AS count
FROM section s, enroll e
WHERE s.course_id = e.course_id AND s.class_title = e.class_title AND s.quarter = e.quarter AND s.year = e.year AND s.section_id = e.section_id
AND (e.grade != 'A' AND e.grade != 'B' AND e.grade != 'C' AND e.grade != 'D')
GROUP BY s.instructor_id, e.course_id, e.section_id, e.grade)
ORDER BY instructor_id, course_id, grade)
SELECT all_grades.instructor_id, all_grades.course_id, all_grades.grade, COALESCE(prof_and_course.count, 0) AS count
FROM all_grades
LEFT JOIN
prof_and_course
ON all_grades.instructor_id = prof_and_course.instructor_id AND all_grades.course_id = prof_and_course.course_id AND all_grades.grade = prof_and_course.grade
ORDER BY instructor_id, course_id, grade;

/* Decision Support Query */
SELECT *
FROM CPG c
WHERE c.course_id = ? AND c.instructor_id = ?
ORDER BY grade;

CREATE TRIGGER mv_enroll
BEFORE INSERT ON enroll
FOR EACH ROW
EXECUTE PROCEDURE add_enrollment();

CREATE OR REPLACE FUNCTION add_enrollment()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
  $$
  declare prof integer;
  BEGIN
	SELECT s.instructor_id into prof FROM section s WHERE s.course_id = new.course_id AND s.class_title = new.class_title AND s.section_id = new.section_id AND s.quarter = new.quarter AND s.year = new.year;
	IF new.grade != 'A' AND new.grade != 'B' AND new.grade != 'C' AND new.grade != 'D'
	THEN
		UPDATE CPQG SET count = count + 1 WHERE instructor_id = prof AND course_id = new.course_id AND quarter = new.quarter AND year = new.year AND grade = 'other';
		UPDATE CPG SET count = count + 1 WHERE instructor_id = prof AND course_id = new.course_id AND grade = 'other';
	ELSE 
		UPDATE CPQG SET count = count + 1 WHERE instructor_id = prof AND course_id = new.course_id AND quarter = new.quarter AND year = new.year AND grade = new.grade;
		UPDATE CPG SET count = count + 1 WHERE instructor_id = prof AND course_id = new.course_id AND grade = new.grade;
	END IF;
    RETURN NEW;
  END;
  $$;
  
insert into enroll VALUES ('222222222', 10, 'CSE008-2', 'FA', 2017, 'A00', NULL, 'letter', 'enroll', 'A');