# Getting and Cleaning Data Course Project
# getdata-031

# load likely packages
library(tidyr)
library(dplyr)
library(stringr)


### set dir, download and unzip
rm(list = ls())
if (!file.exists("./data")) { dir.create("data")} 
setwd("./data")
fileURL = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "projectFiles.zip", method = "auto")
unzip(zipfile = "projectFiles.zip")

#### what do we have?
dir()
setwd("./UCI HAR Dataset")
fileListing <- list.files();fileListing 

##########################################################################
### Step 0 - read in data  
# 
#### initial read is given a suffix of 0
#### suffix is incremented by 1 for each transformation 
##
#### From the original README.txt 
####
##### Forr each record it is provided:
##### Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
##### Triaxial Angular velocity from the gyroscope. 
##### A 561-feature vector with time and frequency domain variables. 
##### Its activity label. 
##### An identifier of the subject who carried out the experiment.

#### From the original features_info.txt
#####               
##### t prefix denotes time domain signals, except for these that are averages
#####      tBodyAccMean
#####      tBodyAccJerkMean
#####      tBodyGyroMean
#####      tBodyGyroJerkMean
##### f prefix denotes frequency domain signals
##### anything else was estimated from signal

##########################################################################

####activity_labels 
activity_labels0 <- read.csv("activity_labels.txt"
                            , sep = " ", header = FALSE
                            , col.names = c("activity_cd", "activity"))


####features
features0 <- read.csv("features.txt"
                     , sep = " ", header = FALSE
                     , col.names = c("feature_cd", "feature"))


#####fix invalid column characters with stringr
#####convert "-"  and "," to "_"
#####remove trailing "()"
#####make unique by adding suffix of left padded row numbers

features1 <- features0  %>%  
        mutate(feature = str_replace_all(feature,  "[-,]", "_")) %>% 
        mutate(feature = str_replace_all(feature,  "[()]", "")) %>% 
        mutate(feature_cnt = rownames(features0)) %>%
        mutate(feature_cnt = str_pad(feature_cnt, 3, pad = "0" )) %>%
        mutate(feature_unq = paste(feature, feature_cnt, sep = "_"))

#### read in testing data, check rows, add existing labels
####       initial file read in with suffix of 0 and all lower case
####       each alteration increments the suffix

x_test0 <- read.table("./test/X_test.txt") 
y_test0 <- read.table("./test/y_test.txt")
subject_test0 <- read.table("./test/subject_test.txt")

# update column names
colnames(x_test0) <- features1$feature_unq
colnames(subject_test0) <- "subject"
colnames(y_test0) <- "activity_cd"


# add subject and test activity columns to left side
x_test1 <- cbind(y_test0, x_test0)
x_test2 <- cbind(subject_test0, x_test1)
dim(x_test2) # [1] 2947  563



####       read in training data, add existing labels
x_train0 <- read.table("./train/X_train.txt") 
y_train0 <- read.table("./train/y_train.txt")
subject_train0 <- read.table("./train/subject_train.txt")

# update column names
colnames(x_train0) <- features1$feature_unq
colnames(subject_train0) <- "subject"
colnames(y_train0) <- "activity_cd"


# add subject and test activity columns to left side
x_train1 <- cbind(y_train0, x_train0)
x_train2 <- cbind(subject_train0, x_train1)
dim(x_train2) # [1] 7352  563




##########################################################################
### Step 1 - Merge training and test sets                         #
##########################################################################

####combine rows
####new file starts again with suffix of 0
x0 <- rbind(x_test2, x_train2) # 10299 rows

####save 
save(x0, file = "x0.Rda")
# load ("x0.Rda")


# clean up environment
rm(features0, features1
   , x_test0, x_test1, x_test2, subject_test0, y_test0
   , x_train0,x_train1, x_train2, subject_train0, y_train0)


##########################################################################
### Step 2 - Extract only the measurements on the mean and standard deviation     #
#                             for each measurement.                      #
# mean, std
##########################################################################

# err on the side of including too many variables
# unable to combine in a single step... matches seemed to override exclusions

# take any fields containing any case of "mean" or "std"
mean_std0  <- select( x0, subject, activity_cd
                      , matches("mean|std")) 

# remove columns related to the angle variable
mean_std1  <- select( mean_std0 
                      , -angletBodyAccJerkMean_gravityMean_556 
                      , -angletBodyAccMean_gravity_555
                      , -angletBodyGyroJerkMean_gravityMean_558
                      , -angletBodyGyroMean_gravityMean_557
                      , -angleX_gravityMean_559
                      , -angleY_gravityMean_560
                      , -angleZ_gravityMean_561
) 

# remove columns related to the meanFreq
mean_std2  <- select( mean_std1 
                     ,-contains("meanFreq")
) 

# clean up environment
rm(x0)

##########################################################################
### Step 3 - Use descriptive activity names on activities in the data set         #
##########################################################################

# show common names
intersect(names(mean_std1), names(activity_labels0))

# add activity label to left side
# leaving in the activity_cd on purpose
mean_std3 <- merge(activity_labels0, mean_std2,  by.x = "activity_cd", by.y = "activity_cd", all = TRUE)

# clean up environment
rm(mean_std0, mean_std1, mean_std2)

##########################################################################
### Step 4 - Label the data set with descriptive variable names                   #
##########################################################################

# save current column names
mean_std3_colNames0 <- as.data.frame(colnames(mean_std3))
colnames(mean_std3_colNames0) = "activity"

# remove the _### required for uniqueness
# this should be done in one step using regex...
mean_std3_colNames1 <- mean_std3_colNames0  %>%
        mutate(activity = str_sub(activity, end = -5  )) 

# fix the 3 without _#### that got wrecked...
mean_std3_colNames1[1,1] = "activity_cd"
mean_std3_colNames1[2,1] = "activity"
mean_std3_colNames1[3,1] = "subject"

# replace the column names
colnames(mean_std3) <-  mean_std3_colNames1$activity

# check column names are still unique
count(names(mean_std3))


####save so you can start over...
setwd("..")
save(mean_std3, file = "mean_std3.Rda")
#load (mean_std3.Rda")

# clean up environment
rm(mean_std3_colNames0,  mean_std3_colNames1, activity_labels0, mean_std2)


##########################################################################
### Step 5 -  create an independent tidy data set with the                         #
### average of each variable for each activity and each subject.           #
##########################################################################


#### create relatively narrow and long dataset
#### note that summarize_each did NOT run. I had to use the 'S' spelling
tidy <- mean_std3  %>%
        arrange(subject, activity) %>%
        group_by(subject, activity) %>%
        summarise_each( funs(mean))



# save out with a "|" for the delimiter
# to perserve the ability to ID one field from another in a text editor
setwd("..")
write.table(tidy, file = "tidy.txt", sep = "|", row.name = FALSE)



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


### get stats for codebook
dim(tidy) # [1] 180  69

#### Get the structure
#### mystery on why this always stores null                  
tidy_str <- str(tidy)
str(tidy)

#### Get the summary
tidy_summary <- as.data.frame(summary(tidy))
write.table(tidy_summary, file = "tidy_summary.txt", sep = "|")

##### edit tidy_summary.txt in notepad++
##### search and replace with regex
##### remove garbage at beginning of each line with  ^[0-9]+[\|\|] 
##### add a pipe at the end of each line by searching for $  and replace with \






