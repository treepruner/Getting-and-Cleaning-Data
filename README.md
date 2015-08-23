##Course Project

Original file:
- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

###General plan
- read comments in  run_analysis.R as you go
- intitial files read in with with original names + 0
- files names suffix incremented by 1 for each major change
- new files named as explicitly as possible
- original field names kept as intact as possible 
- final file wrote out with a "|" so that anyone with a text editor can tell the fields apart

###Codebook
- extracts from original data's README, features_info.txt plus my comments

###Code to read in table:  
#### code to read it back in & set column classes
temp <-read.table("tidy.txt"
       , sep = "|"
       , header = TRUE
       , colClasses = c("integer", "factor", "numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric" )
)  
