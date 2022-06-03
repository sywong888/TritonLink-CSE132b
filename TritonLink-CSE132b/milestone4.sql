/** Trigger 1 **/
CREATE TRIGGER MEETING_CONFLICT
BEFORE INSERT ON MEETING
EXECUTE PROCEDURE add_meeting();

CREATE OR REPLACE FUNCTION add_meeting()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
  $$
  BEGIN
	IF (NOT EXISTS(
      SELECT *
      FROM MEETING m
      WHERE m.course_id = new.course_id AND m.class_title = new.class_title AND m.quarter = new.quarter AND m.year = new.year AND
            m.section_id = new.section_id AND m.day = new.day AND
            ((new.start_time > m.start_time AND new.start_time < m.end_time) OR
            (new.end_time > m.start_time AND new.end_time < m.end_time) OR
            (new.start_time <= m.start_time AND new.end_time >= m.end_time) OR
            (new.start_time >= m.start_time AND new.end_time <= m.end_time)))) 
    THEN
	  RETURN NEW;
	ELSE 
      RAISE EXCEPTION 'This meeting conflicts with another meeting that is already scheduled for the same section.';
    END IF;
  END;
  $$;

insert into meeting values(14, 'MATH132B-1', 'SP', 2022, 'A00', 'T', '15:00', '16:00', 'room15', 'discussion', 'n');

/** Trigger 2 **/ 
CREATE TRIGGER PROF_CONFLICT
BEFORE INSERT ON MEETING
EXECUTE PROCEDURE add_prof_meeting(new.course_id, new.class_title, new.quarter, new.year, new.section_id);

CREATE OR REPLACE FUNCTION add_prof_meeting()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
  $$
  DECLARE prof INT := (SELECT s.faculty_id FROM section s WHERE s.course_id = new.course_id AND s.class_title = new.class_title AND s.quarter = new.quarter AND s.year = new.year); 
  
  BEGIN
	EXECUTE 'CREATE OR REPLACE VIEW prof_meetings AS
	SELECT m.*
	FROM section s, meeting m
	WHERE s.faculty_id = prof AND s.course_id = ' || $1 || 'AND s.class_title = ' || $2 || 'AND s.quarter = ' || $3 || 'AND s.year = ' || $4 || 'AND s.section_id = ' || $5 || ';';
	
	IF (NOT EXISTS(
      SELECT *
      FROM section s, meeting m
      WHERE m.quarter = new.quarter AND m.year = new.year AND m.faculty_id = new.faculty_id AND m.day = new.day AND
            ((new.start_time > m.start_time AND new.start_time < m.end_time) OR
            (new.end_time > m.start_time AND new.end_time < m.end_time) OR
            (new.start_time <= m.start_time AND new.end_time >= m.end_time) OR
            (new.start_time >= m.start_time AND new.end_time <= m.end_time)))) 
    THEN
	  RETURN NEW;
	ELSE 
      RAISE EXCEPTION 'This meeting conflicts with another meeting from a different section that the professsor is also teaching.';
    END IF;
  END;
  $$;
  
insert into meeting values(2, 'CSE150A-1', 'SP', 2022, 'A00', 'T', '11:00', '12:00', 'room15', 'discussion', 'n');


















