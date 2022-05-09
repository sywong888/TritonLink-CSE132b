CREATE TABLE department (dno int PRIMARY KEY, dname varchar(255));
CREATE TABLE student (ssn char(9) NOT NULL, first_name varchar(255), middle_name varchar(255), last_name varchar(255), student_id char(9), student_type varchar(255), resident_type varchar(255), dno int, enrolled char(1), PRIMARY KEY (ssn), FOREIGN KEY (dno) REFERENCES department);
CREATE TABLE undergraduate (ssn char(9) NOT NULL, major varchar(255), minor varchar(255), college varchar(255), PRIMARY KEY (ssn), FOREIGN KEY (ssn) REFERENCES student);
CREATE TABLE graduate (ssn char(9) NOT NULL, PRIMARY KEY (ssn));
CREATE TABLE masters (ssn char(9) NOT NULL, PRIMARY KEY (ssn), FOREIGN KEY (ssn) REFERENCES student);
CREATE TABLE phd (ssn char(9) NOT NULL, candidate_type varchar(255), advisor varchar(255), PRIMARY KEY (ssn), FOREIGN KEY (ssn) REFERENCES student);
CREATE TABLE bsms (ssn char(9) NOT NULL, PRIMARY KEY (ssn), FOREIGN KEY (ssn) REFERENCES student);
CREATE TABLE periods_of_enrollment (ssn char(9) NOT NULL, period_start varchar(255) NOT NULL, period_end varchar(255) NOT NULL, PRIMARY KEY (ssn, period_start, period_end), FOREIGN KEY (ssn) REFERENCES student);
CREATE TABLE probation_reason (reason varchar(255) NOT NULL, PRIMARY KEY (reason));
CREATE TABLE on_probation (ssn char(9) NOT NULL, reason varchar(255), date varchar(255), PRIMARY KEY (ssn, reason), FOREIGN KEY (ssn) REFERENCES student, FOREIGN KEY (reason) REFERENCES probation_reason);
CREATE TABLE prev_degree (ssn char(9) NOT NULL, university varchar (255), type varchar(255), graduation_date varchar(255), PRIMARY KEY (ssn), FOREIGN KEY (ssn) REFERENCES student); 
CREATE TABLE ucsd_degree (degree_type varchar(255) not null, dno integer not null, concentration varchar(255) not null, total_units integer, PRIMARY KEY (degree_type, dno, concentration), FOREIGN KEY (dno) REFERENCES department (dno));
CREATE TABLE degree_requirement (category varchar(255), degree_type varchar(255), dno integer, concentration varchar(255), number_units integer, required_average float, PRIMARY KEY (category, degree_type, dno, concentration), FOREIGN KEY (degree_type, dno, concentration) REFERENCES ucsd_degree (degree_type, dno, concentration));
create table courses (course_id integer not null, dno integer, current_number varchar(255), old_number varchar(255), grading_method varchar(255), possible_units varchar(255), PRIMARY KEY (course_id), FOREIGN KEY (dno) REFERENCES department (dno));
CREATE TABLE concentration (name varchar(255), course_id integer, PRIMARY KEY (name, course_id), FOREIGN KEY (course_id) REFERENCES courses (course_id));
CREATE TABLE prerequisites (course_id integer not null, prereq_id integer not null, PRIMARY KEY (course_id, prereq_id), FOREIGN KEY (course_id) REFERENCES courses(course_id), FOREIGN KEY (prereq_id) REFERENCES courses(course_id));
CREATE TABLE faculty (faculty_id integer NOT NULL, first_name varchar(255), middle_name varchar(255), last_name varchar(255), title varchar(255), PRIMARY KEY (faculty_id));
CREATE TABLE classes (course_id integer not null, class_id varchar(255) not null, instructor_id integer, quarter varchar(255), year integer, enrollment_limit integer, title varchar(255), PRIMARY KEY (course_id, class_id, quarter, year), FOREIGN KEY (instructor_id) REFERENCES faculty (faculty_id), FOREIGN KEY (course_id) REFERENCES courses (course_id));
CREATE TABLE meeting (course_id integer not null, class_id varchar(255) not null, quarter varchar(255), year integer, day varchar(255), time varchar(255), room varchar(255), type varchar(255), mandatory char(1), PRIMARY KEY (course_id, class_id, quarter, year, day, time, room, type), FOREIGN KEY (course_id, class_id, quarter, year) REFERENCES classes(course_id, class_id, quarter, year));
CREATE TABLE review_session (course_id int NOT NULL, class_id varchar(255) NOT NULL, quarter varchar(255), year int, date varchar(255), time varchar(255), PRIMARY KEY (course_id, class_id, quarter, year, date, time), FOREIGN KEY (course_id, class_id, quarter, year) REFERENCES classes(course_id, class_id, quarter, year));
CREATE TABLE enroll (ssn char(9) NOT NULL, course_id int NOT NULL, class_id varchar(255) NOT NULL, quarter varchar(255) NOT NULL, year int NOT NULL, units_taken int, status varchar(255), grade varchar(255), PRIMARY KEY (ssn, course_id, class_id, quarter, year), FOREIGN KEY (ssn) REFERENCES student(ssn), FOREIGN KEY (course_id, class_id, quarter, year) REFERENCES classes(course_id, class_id, quarter, year));
CREATE TABLE thesis_committee (ssn char(9), faculty_id integer, type varchar(255), PRIMARY KEY (ssn, faculty_id), FOREIGN KEY (ssn) REFERENCES student (ssn), FOREIGN KEY (faculty_id) REFERENCES faculty (faculty_id));
CREATE TABLE student_organization (org_id integer, name varchar(255), yearly_budget integer, PRIMARY KEY (org_id));
CREATE TABLE student_organization_participation (org_id integer, ssn char(9), position varchar(255), PRIMARY KEY (org_id, ssn, position), FOREIGN KEY (ssn) REFERENCES student(ssn), FOREIGN KEY (org_id) REFERENCES student_organization(org_id));
CREATE TABLE company (name varchar(255), org_id integer, PRIMARY KEY (name, org_id), FOREIGN KEY (org_id) REFERENCES student_organization (org_id));
CREATE TABLE event (org_id integer, title varchar(255), date varchar(255), time varchar(255), location varchar(255), PRIMARY KEY (org_id, title, date), FOREIGN KEY (org_id) REFERENCES student_organization (org_id));
