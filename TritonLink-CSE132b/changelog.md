# Milestone 3

Student:  
- options for student_type changed to bsc, ba, master's, phd  
- update command should only be used if a student goes from undergraduate -> master's (not from bs -> ba or vice versa)

Undergraduate:  
- added type attribute for bsc and ba

Enroll:  
- changed units_taken attribute to integer to allow sum in query

Meeting:  
- new start_time and end_time attributes  
- TODO: java code to make sure start is before end

Concentration:  
- TODO: change min_gpa to float

NEW Concentration_Requirements:  

Classes:  
- TODO: fix delete function