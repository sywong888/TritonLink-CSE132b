# Triton Link #

## How to run the entry forms:  ##
1. ensure the postgresql jar file is inside the src --> main --> webapp --> WEB-INF --> lib directory
2. to open home page from eclipse, right click on the TritonLink-CSE132b project folder --> Run As --> Run on Server --> check that Tomcat v9.0 Server at localhost is selected --> click Finish (this will only work if the dynamic web project was set up with Apache Tomcat v9.0 as the target runtime)
3. your browser should direct you to the [home page](http://localhost:8080/TritonLink-CSE132b/)

The home page contains links to all of our forms.

## JSP Files ##
- `classes.jsp` works with the classes and meeting entities. It also deletes from the review_session entity to avoid foreign key violations.
- `course_enrollment.jsp` works with the enroll entity.
- `courses.jsp` works with the course and prerequisite entities.
- `degree_requirements.jsp` works with the ucsd_degree and degree_requirement entities.
- `department.jsp` works with the department entity.
- `faculty.jsp` works with the faculty entity.
- `past_classes.jsp` works with the enroll entity.
- `probation.jsp` works with the probation_reasons and on_probation entities.
- `review_session.jsp` works with the review_session entity.
- `student.jsp` works with the student, undergraduate, graduate, masters, phd, bsms, periods_of_enrollment, prev_degree entities. It also deletes from the on_probation entity to avoid foreign key violations.
- `thesis_committee.jsp` works with the thesis_committee entity. It also runs some queries on the student entity.