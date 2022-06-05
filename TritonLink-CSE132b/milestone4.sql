/** Trigger 1 **/
CREATE TRIGGER MEETING_CONFLICT
BEFORE INSERT ON MEETING
FOR EACH ROW
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
CREATE OR REPLACE FUNCTION add_enrollment() RETURNS TRIGGER LANGUAGE PLPGSQL AS
    $$
        BEGIN
--             CREATE OR REPLACE VIEW enrollment_section_limit AS SELECT count(*) AS e_limit from enroll e, section s where e.section_id = s.section_id and e.class_title = s.class_title and e.quarter = s.quarter
--                                                                                                     and e.section_id = NEW.section_id and e.class_title = NEW.class_title and e.quarter = NEW.quarter;
            CREATE OR REPLACE VIEW enrollment_section AS SELECT e.class_title, e.section_id, e.quarter, s.enrollment_limit, count(*) AS e_count from enroll e, section s where e.section_id = s.section_id and e.class_title = s.class_title and e.quarter = s.quarter
                                                                                                    and e.section_id = NEW.section_id and e.class_title = NEW.class_title and e.quarter = NEW.quarter
                                                                                                    group by e.class_title, e.section_id, e.quarter, s.enrollment_limit;
            IF (enrollment_section.e_count <= enrollment_section.enrollment_limit)
                THEN RETURN NEW;
            ELSE
                RAISE EXCEPTION 'Enrollment limit of the section has been reached. Cannot enroll.';
                END IF;
        END;
    $$;

CREATE TRIGGER ENROLLMENT_LIMIT_CONFLICT
    BEFORE INSERT ON enroll
    FOR EACH ROW
    EXECUTE PROCEDURE add_enrollment();

/** Trigger 3 **/ 
CREATE TRIGGER PROF_CONFLICT
BEFORE INSERT ON MEETING
FOR EACH ROW
EXECUTE PROCEDURE add_prof_meeting();

CREATE OR REPLACE FUNCTION add_prof_meeting()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL
  AS
  $$
  declare prof integer;
  BEGIN
	SELECT s.instructor_id into prof FROM section s WHERE s.course_id = new.course_id AND s.class_title = new.class_title AND s.section_id = new.section_id AND s.quarter = new.quarter AND s.year = new.year; 
	execute format('CREATE OR REPLACE VIEW prof_meetings AS SELECT m.* FROM section s, meeting m WHERE s.instructor_id = %L AND s.course_id = m.course_id AND s.class_title = m.class_title AND s.quarter = m.quarter AND s.year = m.year AND s.section_id = m.section_id;', prof);
	
	IF (NOT EXISTS(
      SELECT *
      FROM prof_meetings m
      WHERE m.quarter = new.quarter AND m.year = new.year AND m.day = new.day AND
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
  
insert into meeting values(2, 'CSE150A-1', 'SP', 2022, 'A00', 'R', '21:10', '21:50', 'room15', 'discussion', 'n');


















