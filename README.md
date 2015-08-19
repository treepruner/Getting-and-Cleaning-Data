# Getting-and-Cleaning-Data
##Course Project

###Original file:
- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
- 


###General plan
- comment run_analysis.R as you go
- read in intitial files with original names + 0
- increment suffix by 1 for each major change
- name new files as explicitly as possible
- keep original field names as intact as possible 
- write out with a "|" so that anyone with a text editor can tell the fields apart


###Code to read in table:  
-temp <-read.table("tidy_narrow.txt", sep = "|")
