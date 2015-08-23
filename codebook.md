# GCD Course Project Codebook
treepruner  
August 19, 2015  

# Project Description
Getting and Cleaning Data course project takes files from
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
and produces a tidy data by subject and activity of any original measurement fields 
with "mean" or "std" in their name.


##Project design and data processing
I first read the README and features_info.txt to get an overview of the data. Next I looked at the files in a text editor. The text editor wasn't helpful since you can't tell where one field stops and another starts.

Here are the row counts for the test data sets:

| file                |contents                            | rows count| column count|
|---------------------|------------------------------------|-----------|-------------|
| X_test.txt          | Test set data                      |  2947     |561|
| y_test.txt          | Test set column labels             |  2947     | 1 |
| subject_test.txt    | Test set subjects                  |  2947     | 1 |
| features.txt        | Test and Train column descriptions |  561      | 2 |
| activity_labels.txt | Activity codes and labels          |  6        | 2 |
| X_train.txt         | Train set data                     |  7352     |561|
| y_train.tt          | Train set column labels            |  2947     | 1 |
| subject_train.txt   | Train set subjects                 |  7352     | 1 |


The files are broken apart very strangely. 

The number of columns in X_test.txt matches the # rows in features.txt. I was able to confirm that features.txt contains the column headings for X_test.txt.

The number of rows in subject_test.txt and y_test.txt match the # of rows in X_test.txt. I was able to confirm that these files have the subject and activity test information for each row in x_test.txt

The codes in x_test.txt are match the codes in activity_labels.txt

The training data sets work in a similar fashion.


##Manipulation of the study data

### Step 0 - Download, Unzip and Read in files
- files downloaded from "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
- initial read is given a suffix of 0
- suffix is incremented by 1 for each transformation 



#### read in activity, features 
- activity_labels.txt imported as as activity_cd and activity
- features.txt imported as feature_cd and feature

##### clean features using stringr package
Features contains the column labels for the test and training datasets, but there are non-alphanumeric symbols and duplicate entries. 

- convert "-"  and "," to "_"
- remove  "("  and ")"
- make unique by adding suffix of left 0 padded row numbers, e.g., _001, _002 and so on. These were stripped out later.

####  read in testing data, check rows, add existing labels
- initial file read in with suffix of 0 and all lower case
- each alteration increments the suffix
- update column names
- add subject and test columns to left side


####  read in training data, add existing labels
- initial file read in with suffix of 0 and all lower case
- each alteration increments the suffix
- update column names
- add subject and test columns to left side


### Step 1 - Merge training and test sets 
- combine testing and training rows into new data frame.


### Step 2 - Extract only the measurements on the mean and standard deviation 

#### err on the side of including too many variables
I was unable to combine in a single step... matches seemed to override exclusions, so these were done on multiple steps
- take any fields containing any case of "mean" or "std"
- remove columns related to the angle variable
- remove columns related to the meanFreq, which is a summary measure


### Step 3 - Use descriptive activity names on activities in the data set 
- add activity label to left side
- leave in the activity_cd on purpose


### Step 4 -  Label the data set with descriptive variable names                  
- save current column names
- alter to remove the _### required for uniqueness by position
- fix the 3 without _### that got wrecked
- replace the column names
- check column names are still unique

### Step - 5 create an independent tidy data set with average of each variable for each activity and each subject
- use dplyr's "arrange" and "group_by" with "summarise_each" create a dataset with one row per subject and activity. Note that the US spelling of summarize_each failed to run.
- save out with a "|" for the delimiter so the fields can be told apart in a text editor


#### Code to read it back in & set column classes
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


## Notes on the original (study) data 
There were duplicate rows in the feature.txt file. It appears the original file was missing an X, Y or Z suffix on some entries. To preserve the original naming convention as much as possible and avoid guessing, I worked around the bad entries by adding "_ + row number" to make them unique. The  "_ + row number" was later stripped out.

Here are the non-unique entries in features.txt and the number of occurances:


|       original entry           | x freq  |
|--------------------------------|---------|
| fBodyAcc-bandsEnergy()-1,16|   3   |   
| fBodyAcc-bandsEnergy()-1,24|   3   |   
| fBodyAcc-bandsEnergy()-1,8|   3   |   
| fBodyAcc-bandsEnergy()-17,24|   3   |   
| fBodyAcc-bandsEnergy()-17,32|   3   |   
| fBodyAcc-bandsEnergy()-25,32|   3   |   
| fBodyAcc-bandsEnergy()-25,48|   3   |   
| fBodyAcc-bandsEnergy()-33,40|   3   |   
| fBodyAcc-bandsEnergy()-33,48|   3   |   
| fBodyAcc-bandsEnergy()-41,48|   3   |   
| fBodyAcc-bandsEnergy()-49,56|   3   |   
| fBodyAcc-bandsEnergy()-49,64|   3   |   
| fBodyAcc-bandsEnergy()-57,64|   3   |   
| fBodyAcc-bandsEnergy()-9,16|   3   |   
| fBodyAccJerk-bandsEnergy()-1,16|   3   |   
| fBodyAccJerk-bandsEnergy()-1,24|   3   |   
| fBodyAccJerk-bandsEnergy()-1,8|   3   |   
| fBodyAccJerk-bandsEnergy()-17,24|   3   |   
| fBodyAccJerk-bandsEnergy()-17,32|   3   |   
| fBodyAccJerk-bandsEnergy()-25,32|   3   |   
| fBodyAccJerk-bandsEnergy()-25,48|   3   |   
| fBodyAccJerk-bandsEnergy()-33,40|   3   |   
| fBodyAccJerk-bandsEnergy()-33,48|   3   |   
| fBodyAccJerk-bandsEnergy()-41,48|   3   |   
| fBodyAccJerk-bandsEnergy()-49,56|   3   |   
| fBodyAccJerk-bandsEnergy()-49,64|   3   |   
| fBodyAccJerk-bandsEnergy()-57,64|   3   |   
| fBodyAccJerk-bandsEnergy()-9,16|   3   |   
| fBodyGyro-bandsEnergy()-1,16|   3   |   
| fBodyGyro-bandsEnergy()-1,24|   3   |   
| fBodyGyro-bandsEnergy()-1,8|   3   |   
| fBodyGyro-bandsEnergy()-17,24|   3   |   
| fBodyGyro-bandsEnergy()-17,32|   3   |   
| fBodyGyro-bandsEnergy()-25,32|   3   |   
| fBodyGyro-bandsEnergy()-25,48|   3   |   
| fBodyGyro-bandsEnergy()-33,40|   3   |   
| fBodyGyro-bandsEnergy()-33,48|   3   |   
| fBodyGyro-bandsEnergy()-41,48|   3   |   
| fBodyGyro-bandsEnergy()-49,56|   3   |   
| fBodyGyro-bandsEnergy()-49,64|   3   |   
| fBodyGyro-bandsEnergy()-57,64|   3   |   
| fBodyGyro-bandsEnergy()-9,16|   3   |   




##Summary statistics of the tidy.txt file
|field          |summary stats    |
|---------------|-----------------|
|tBodyAcc_mean_X|Min.   :0.2216   |
|tBodyAcc_mean_X|1st Qu.:0.2712   |
|tBodyAcc_mean_X|Median :0.2770   |
|tBodyAcc_mean_X|Mean   :0.2743   |
|tBodyAcc_mean_X|3rd Qu.:0.2800   |
|tBodyAcc_mean_X|Max.   :0.3015   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAcc_mean_Y|Min.   :-0.040514  | 
|tBodyAcc_mean_Y|1st Qu.:-0.020022   |
|tBodyAcc_mean_Y|Median :-0.017262   |
|tBodyAcc_mean_Y|Mean   :-0.017876   |
|tBodyAcc_mean_Y|3rd Qu.:-0.014936   |
|tBodyAcc_mean_Y|Max.   :-0.001308   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAcc_mean_Z|Min.   :-0.15251   |
|tBodyAcc_mean_Z|1st Qu.:-0.11207   |
|tBodyAcc_mean_Z|Median :-0.10819   |
|tBodyAcc_mean_Z|Mean   :-0.10916   |
|tBodyAcc_mean_Z|3rd Qu.:-0.10443   |
|tBodyAcc_mean_Z|Max.   :-0.07538   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAcc_std_X|Min.   :-0.9961   |
|tBodyAcc_std_X|1st Qu.:-0.9799   |
|tBodyAcc_std_X|Median :-0.7526   |
|tBodyAcc_std_X|Mean   :-0.5577   |
|tBodyAcc_std_X|3rd Qu.:-0.1984   |
|tBodyAcc_std_X|Max.   : 0.6269   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAcc_std_Y|Min.   :-0.99024   |
|tBodyAcc_std_Y|1st Qu.:-0.94205   |
|tBodyAcc_std_Y|Median :-0.50897   |
|tBodyAcc_std_Y|Mean   :-0.46046   |
|tBodyAcc_std_Y|3rd Qu.:-0.03077   |
|tBodyAcc_std_Y|Max.   : 0.61694   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAcc_std_Z|Min.   :-0.9877   |
|tBodyAcc_std_Z|1st Qu.:-0.9498   |
|tBodyAcc_std_Z|Median :-0.6518   |
|tBodyAcc_std_Z|Mean   :-0.5756   |
|tBodyAcc_std_Z|3rd Qu.:-0.2306   |
|tBodyAcc_std_Z|Max.   : 0.6090   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAcc_mean_X|Min.   :-0.6800 |  
|tGravityAcc_mean_X|1st Qu.: 0.8376   |
|tGravityAcc_mean_X|Median : 0.9208   |
|tGravityAcc_mean_X|Mean   : 0.6975   |
|tGravityAcc_mean_X|3rd Qu.: 0.9425   |
|tGravityAcc_mean_X|Max.   : 0.9745   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAcc_mean_Y|Min.   :-0.47989   |
|tGravityAcc_mean_Y|1st Qu.:-0.23319   |
|tGravityAcc_mean_Y|Median :-0.12782   |
|tGravityAcc_mean_Y|Mean   :-0.01621   |
|tGravityAcc_mean_Y|3rd Qu.: 0.08773   |
|tGravityAcc_mean_Y|Max.   : 0.95659   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAcc_mean_Z|Min.   :-0.49509   |
|tGravityAcc_mean_Z|1st Qu.:-0.11726   |
|tGravityAcc_mean_Z|Median : 0.02384   |
|tGravityAcc_mean_Z|Mean   : 0.07413   |
|tGravityAcc_mean_Z|3rd Qu.: 0.14946   |
|tGravityAcc_mean_Z|Max.   : 0.95787   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAcc_std_X|Min.   :-0.9968   |
|tGravityAcc_std_X|1st Qu.:-0.9825   |
|tGravityAcc_std_X|Median :-0.9695   |
|tGravityAcc_std_X|Mean   :-0.9638   |
|tGravityAcc_std_X|3rd Qu.:-0.9509   |
|tGravityAcc_std_X|Max.   :-0.8296   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAcc_std_Y|Min.   :-0.9942   |
|tGravityAcc_std_Y|1st Qu.:-0.9711   |
|tGravityAcc_std_Y|Median :-0.9590   |
|tGravityAcc_std_Y|Mean   :-0.9524   |
|tGravityAcc_std_Y|3rd Qu.:-0.9370   |
|tGravityAcc_std_Y|Max.   :-0.6436   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAcc_std_Z|Min.   :-0.9910   |
|tGravityAcc_std_Z|1st Qu.:-0.9605   |
|tGravityAcc_std_Z|Median :-0.9450   |
|tGravityAcc_std_Z|Mean   :-0.9364   |
|tGravityAcc_std_Z|3rd Qu.:-0.9180   |
|tGravityAcc_std_Z|Max.   :-0.6102   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerk_mean_X|Min.   :0.04269   |
|tBodyAccJerk_mean_X|1st Qu.:0.07396   |
|tBodyAccJerk_mean_X|Median :0.07640   |
|tBodyAccJerk_mean_X|Mean   :0.07947   |
|tBodyAccJerk_mean_X|3rd Qu.:0.08330   |
|tBodyAccJerk_mean_X|Max.   :0.13019   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerk_mean_Y|Min.   :-0.0386872  | 
|tBodyAccJerk_mean_Y|1st Qu.: 0.0004664   |
|tBodyAccJerk_mean_Y|Median : 0.0094698   |
|tBodyAccJerk_mean_Y|Mean   : 0.0075652   |
|tBodyAccJerk_mean_Y|3rd Qu.: 0.0134008   |
|tBodyAccJerk_mean_Y|Max.   : 0.0568186   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerk_mean_Z|Min.   :-0.067458   |
|tBodyAccJerk_mean_Z|1st Qu.:-0.010601   |
|tBodyAccJerk_mean_Z|Median :-0.003861   |
|tBodyAccJerk_mean_Z|Mean   :-0.004953   |
|tBodyAccJerk_mean_Z|3rd Qu.: 0.001958   |
|tBodyAccJerk_mean_Z|Max.   : 0.038053   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerk_std_X|Min.   :-0.9946   |
|tBodyAccJerk_std_X|1st Qu.:-0.9832   | 
|tBodyAccJerk_std_X|Median :-0.8104   |
|tBodyAccJerk_std_X|Mean   :-0.5949   |
|tBodyAccJerk_std_X|3rd Qu.:-0.2233   |
|tBodyAccJerk_std_X|Max.   : 0.5443   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerk_std_Y|Min.   :-0.9895   |
|tBodyAccJerk_std_Y|1st Qu.:-0.9724   |
|tBodyAccJerk_std_Y|Median :-0.7756   | 
|tBodyAccJerk_std_Y|Mean   :-0.5654   |
|tBodyAccJerk_std_Y|3rd Qu.:-0.1483   |
|tBodyAccJerk_std_Y|Max.   : 0.3553   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerk_std_Z|Min.   :-0.99329   |
|tBodyAccJerk_std_Z|1st Qu.:-0.98266   |
|tBodyAccJerk_std_Z|Median :-0.88366   |
|tBodyAccJerk_std_Z|Mean   :-0.73596   |
|tBodyAccJerk_std_Z|3rd Qu.:-0.51212   |
|tBodyAccJerk_std_Z|Max.   : 0.03102   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyro_mean_X|Min.   :-0.20578   |
|tBodyGyro_mean_X|1st Qu.:-0.04712   |
|tBodyGyro_mean_X|Median :-0.02871   |
|tBodyGyro_mean_X|Mean   :-0.03244   |
|tBodyGyro_mean_X|3rd Qu.:-0.01676   |
|tBodyGyro_mean_X|Max.   : 0.19270   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyro_mean_Y|Min.   :-0.20421   |
|tBodyGyro_mean_Y|1st Qu.:-0.08955   |
|tBodyGyro_mean_Y|Median :-0.07318   |
|tBodyGyro_mean_Y|Mean   :-0.07426   |
|tBodyGyro_mean_Y|3rd Qu.:-0.06113   |
|tBodyGyro_mean_Y|Max.   : 0.02747   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyro_mean_Z|Min.   :-0.07245   |
|tBodyGyro_mean_Z|1st Qu.: 0.07475   |
|tBodyGyro_mean_Z|Median : 0.08512   |
|tBodyGyro_mean_Z|Mean   : 0.08744   |
|tBodyGyro_mean_Z|3rd Qu.: 0.10177   |
|tBodyGyro_mean_Z|Max.   : 0.17910   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyro_std_X|Min.   :-0.9943   |
|tBodyGyro_std_X|1st Qu.:-0.9735   |
|tBodyGyro_std_X|Median :-0.7890   |
|tBodyGyro_std_X|Mean   :-0.6916   |
|tBodyGyro_std_X|3rd Qu.:-0.4414   |
|tBodyGyro_std_X|Max.   : 0.2677   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyro_std_Y|Min.   :-0.9942   |
|tBodyGyro_std_Y|1st Qu.:-0.9629   |
|tBodyGyro_std_Y|Median :-0.8017   |
|tBodyGyro_std_Y|Mean   :-0.6533   |
|tBodyGyro_std_Y|3rd Qu.:-0.4196   |
|tBodyGyro_std_Y|Max.   : 0.4765   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyro_std_Z|Min.   :-0.9855   |
|tBodyGyro_std_Z|1st Qu.:-0.9609   |
|tBodyGyro_std_Z|Median :-0.8010   | 
|tBodyGyro_std_Z|Mean   :-0.6164   |
|tBodyGyro_std_Z|3rd Qu.:-0.3106   |
|tBodyGyro_std_Z|Max.   : 0.5649   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerk_mean_X|Min.   :-0.15721   |
|tBodyGyroJerk_mean_X|1st Qu.:-0.10322   |
|tBodyGyroJerk_mean_X|Median :-0.09868   |
|tBodyGyroJerk_mean_X|Mean   :-0.09606   |
|tBodyGyroJerk_mean_X|3rd Qu.:-0.09110   |
|tBodyGyroJerk_mean_X|Max.   :-0.02209   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerk_mean_Y|Min.   :-0.07681   |
|tBodyGyroJerk_mean_Y|1st Qu.:-0.04552   |
|tBodyGyroJerk_mean_Y|Median :-0.04112   |
|tBodyGyroJerk_mean_Y|Mean   :-0.04269   |
|tBodyGyroJerk_mean_Y|3rd Qu.:-0.03842   |
|tBodyGyroJerk_mean_Y|Max.   :-0.01320   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerk_mean_Z|Min.   :-0.092500   |
|tBodyGyroJerk_mean_Z|1st Qu.:-0.061725   |
|tBodyGyroJerk_mean_Z|Median :-0.053430   |
|tBodyGyroJerk_mean_Z|Mean   :-0.054802   |
|tBodyGyroJerk_mean_Z|3rd Qu.:-0.048985   |
|tBodyGyroJerk_mean_Z|Max.   :-0.006941   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerk_std_X|Min.   :-0.9965   |
|tBodyGyroJerk_std_X|1st Qu.:-0.9800   |
|tBodyGyroJerk_std_X|Median :-0.8396   |
|tBodyGyroJerk_std_X|Mean   :-0.7036   |
|tBodyGyroJerk_std_X|3rd Qu.:-0.4629   |
|tBodyGyroJerk_std_X|Max.   : 0.1791   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerk_std_Y|Min.   :-0.9971   |
|tBodyGyroJerk_std_Y|1st Qu.:-0.9832   |
|tBodyGyroJerk_std_Y|Median :-0.8942   |
|tBodyGyroJerk_std_Y|Mean   :-0.7636   |
|tBodyGyroJerk_std_Y|3rd Qu.:-0.5861   |
|tBodyGyroJerk_std_Y|Max.   : 0.2959   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerk_std_Z|Min.   :-0.9954   |
|tBodyGyroJerk_std_Z|1st Qu.:-0.9848   |
|tBodyGyroJerk_std_Z|Median :-0.8610   |
|tBodyGyroJerk_std_Z|Mean   :-0.7096   |
|tBodyGyroJerk_std_Z|3rd Qu.:-0.4741   |
|tBodyGyroJerk_std_Z|Max.   : 0.1932   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccMag_mean|Min.   :-0.9865   |
|tBodyAccMag_mean|1st Qu.:-0.9573   |
|tBodyAccMag_mean|Median :-0.4829   |
|tBodyAccMag_mean|Mean   :-0.4973   |
|tBodyAccMag_mean|3rd Qu.:-0.0919   |
|tBodyAccMag_mean|Max.   : 0.6446   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccMag_std|Min.   :-0.9865   |
|tBodyAccMag_std|1st Qu.:-0.9430   |
|tBodyAccMag_std|Median :-0.6074   |
|tBodyAccMag_std|Mean   :-0.5439   |
|tBodyAccMag_std|3rd Qu.:-0.2090   |
|tBodyAccMag_std|Max.   : 0.4284   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAccMag_mean|Min.   :-0.9865 |  
|tGravityAccMag_mean|1st Qu.:-0.9573   |
|tGravityAccMag_mean|Median :-0.4829   |
|tGravityAccMag_mean|Mean   :-0.4973   |
|tGravityAccMag_mean|3rd Qu.:-0.0919   |
|tGravityAccMag_mean|Max.   : 0.6446   |

|field     |summary stats|
|---------------|-----------------|
|tGravityAccMag_std|Min.   :-0.9865   |
|tGravityAccMag_std|1st Qu.:-0.9430   |
|tGravityAccMag_std|Median :-0.6074   |
|tGravityAccMag_std|Mean   :-0.5439   |
|tGravityAccMag_std|3rd Qu.:-0.2090   |
|tGravityAccMag_std|Max.   : 0.4284   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerkMag_mean|Min.   :-0.9928   |
|tBodyAccJerkMag_mean|1st Qu.:-0.9807   |
|tBodyAccJerkMag_mean|Median :-0.8168   |
|tBodyAccJerkMag_mean|Mean   :-0.6079   |
|tBodyAccJerkMag_mean|3rd Qu.:-0.2456   |
|tBodyAccJerkMag_mean|Max.   : 0.4345   |

|field     |summary stats|
|---------------|-----------------|
|tBodyAccJerkMag_std|Min.   :-0.9946   |
|tBodyAccJerkMag_std|1st Qu.:-0.9765   |
|tBodyAccJerkMag_std|Median :-0.8014   |
|tBodyAccJerkMag_std|Mean   :-0.5842   |
|tBodyAccJerkMag_std|3rd Qu.:-0.2173   |
|tBodyAccJerkMag_std|Max.   : 0.4506   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroMag_mean|Min.   :-0.9807   |
|tBodyGyroMag_mean|1st Qu.:-0.9461   |
|tBodyGyroMag_mean|Median :-0.6551   |
|tBodyGyroMag_mean|Mean   :-0.5652   |
|tBodyGyroMag_mean|3rd Qu.:-0.2159   |
|tBodyGyroMag_mean|Max.   : 0.4180   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroMag_std|Min.   :-0.9814   |
|tBodyGyroMag_std|1st Qu.:-0.9476   |
|tBodyGyroMag_std|Median :-0.7420   |
|tBodyGyroMag_std|Mean   :-0.6304   |
|tBodyGyroMag_std|3rd Qu.:-0.3602   |
|tBodyGyroMag_std|Max.   : 0.3000   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerkMag_mean|Min.   :-0.99732   |
|tBodyGyroJerkMag_mean|1st Qu.:-0.98515   |
|tBodyGyroJerkMag_mean|Median :-0.86479   |
|tBodyGyroJerkMag_mean|Mean   :-0.73637   |
|tBodyGyroJerkMag_mean|3rd Qu.:-0.51186   |
|tBodyGyroJerkMag_mean|Max.   : 0.08758   |

|field     |summary stats|
|---------------|-----------------|
|tBodyGyroJerkMag_std|Min.   :-0.9977   |
|tBodyGyroJerkMag_std|1st Qu.:-0.9805   |
|tBodyGyroJerkMag_std|Median :-0.8809   |
|tBodyGyroJerkMag_std|Mean   :-0.7550   |
|tBodyGyroJerkMag_std|3rd Qu.:-0.5767   |
|tBodyGyroJerkMag_std|Max.   : 0.2502   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAcc_mean_X|Min.   :-0.9952   |
|fBodyAcc_mean_X|1st Qu.:-0.9787   |
|fBodyAcc_mean_X|Median :-0.7691   |
|fBodyAcc_mean_X|Mean   :-0.5758   |
|fBodyAcc_mean_X|3rd Qu.:-0.2174   |
|fBodyAcc_mean_X|Max.   : 0.5370   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAcc_mean_Y|Min.   :-0.98903   |
|fBodyAcc_mean_Y|1st Qu.:-0.95361   |
|fBodyAcc_mean_Y|Median :-0.59498   |
|fBodyAcc_mean_Y|Mean   :-0.48873   |
|fBodyAcc_mean_Y|3rd Qu.:-0.06341   |
|fBodyAcc_mean_Y|Max.   : 0.52419   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAcc_mean_Z|Min.   :-0.9895   |
|fBodyAcc_mean_Z|1st Qu.:-0.9619   |
|fBodyAcc_mean_Z|Median :-0.7236   |
|fBodyAcc_mean_Z|Mean   :-0.6297   |
|fBodyAcc_mean_Z|3rd Qu.:-0.3183   |
|fBodyAcc_mean_Z|Max.   : 0.2807   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAcc_std_X|Min.   :-0.9966   |
|fBodyAcc_std_X|1st Qu.:-0.9820   |
|fBodyAcc_std_X|Median :-0.7470   |
|fBodyAcc_std_X|Mean   :-0.5522   |
|fBodyAcc_std_X|3rd Qu.:-0.1966   |
|fBodyAcc_std_X|Max.   : 0.6585   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAcc_std_Y|Min.   :-0.99068   |
|fBodyAcc_std_Y|1st Qu.:-0.94042   |
|fBodyAcc_std_Y|Median :-0.51338   |
|fBodyAcc_std_Y|Mean   :-0.48148   |
|fBodyAcc_std_Y|3rd Qu.:-0.07913   |
|fBodyAcc_std_Y|Max.   : 0.56019   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAcc_std_Z|Min.   :-0.9872   |
|fBodyAcc_std_Z|1st Qu.:-0.9459   |
|fBodyAcc_std_Z|Median :-0.6441   |
|fBodyAcc_std_Z|Mean   :-0.5824   |
|fBodyAcc_std_Z|3rd Qu.:-0.2655   |
|fBodyAcc_std_Z|Max.   : 0.6871   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccJerk_mean_X|Min.   :-0.9946   |
|fBodyAccJerk_mean_X|1st Qu.:-0.9828   |
|fBodyAccJerk_mean_X|Median :-0.8126   |
|fBodyAccJerk_mean_X|Mean   :-0.6139   |
|fBodyAccJerk_mean_X|3rd Qu.:-0.2820   |
|fBodyAccJerk_mean_X|Max.   : 0.4743   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccJerk_mean_Y|Min.   :-0.9894   |
|fBodyAccJerk_mean_Y|1st Qu.:-0.9725   |
|fBodyAccJerk_mean_Y|Median :-0.7817   |
|fBodyAccJerk_mean_Y|Mean   :-0.5882   |
|fBodyAccJerk_mean_Y|3rd Qu.:-0.1963   |
|fBodyAccJerk_mean_Y|Max.   : 0.2767   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccJerk_mean_Z|Min.   :-0.9920   |
|fBodyAccJerk_mean_Z|1st Qu.:-0.9796   |
|fBodyAccJerk_mean_Z|Median :-0.8707   |
|fBodyAccJerk_mean_Z|Mean   :-0.7144   |
|fBodyAccJerk_mean_Z|3rd Qu.:-0.4697   |
|fBodyAccJerk_mean_Z|Max.   : 0.1578   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccJerk_std_X|Min.   :-0.9951   |
|fBodyAccJerk_std_X|1st Qu.:-0.9847   |
|fBodyAccJerk_std_X|Median :-0.8254   |
|fBodyAccJerk_std_X|Mean   :-0.6121   |
|fBodyAccJerk_std_X|3rd Qu.:-0.2475   |
|fBodyAccJerk_std_X|Max.   : 0.4768   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccJerk_std_Y|Min.   :-0.9905   |
|fBodyAccJerk_std_Y|1st Qu.:-0.9737   |
|fBodyAccJerk_std_Y|Median :-0.7852   |
|fBodyAccJerk_std_Y|Mean   :-0.5707   |
|fBodyAccJerk_std_Y|3rd Qu.:-0.1685   |
|fBodyAccJerk_std_Y|Max.   : 0.3498   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccJerk_std_Z|Min.   :-0.993108   |
|fBodyAccJerk_std_Z|1st Qu.:-0.983747   |
|fBodyAccJerk_std_Z|Median :-0.895121   |
|fBodyAccJerk_std_Z|Mean   :-0.756489   |
|fBodyAccJerk_std_Z|3rd Qu.:-0.543787   |
|fBodyAccJerk_std_Z|Max.   :-0.006236   |

|field     |summary stats|
|---------------|-----------------|
|fBodyGyro_mean_X|Min.   :-0.9931   |
|fBodyGyro_mean_X|1st Qu.:-0.9697   |
|fBodyGyro_mean_X|Median :-0.7300   |
|fBodyGyro_mean_X|Mean   :-0.6367   |
|fBodyGyro_mean_X|3rd Qu.:-0.3387   |
|fBodyGyro_mean_X|Max.   : 0.4750   |

|field     |summary stats|
|---------------|-----------------|
|fBodyGyro_mean_Y|Min.   :-0.9940   |
|fBodyGyro_mean_Y|1st Qu.:-0.9700   |
|fBodyGyro_mean_Y|Median :-0.8141   |
|fBodyGyro_mean_Y|Mean   :-0.6767   |
|fBodyGyro_mean_Y|3rd Qu.:-0.4458   |
|fBodyGyro_mean_Y|Max.   : 0.3288   |

|field     |summary stats|
|---------------|-----------------|
|fBodyGyro_mean_Z|Min.   :-0.9860   |
|fBodyGyro_mean_Z|1st Qu.:-0.9624   |
|fBodyGyro_mean_Z|Median :-0.7909   |
|fBodyGyro_mean_Z|Mean   :-0.6044   |
|fBodyGyro_mean_Z|3rd Qu.:-0.2635   |
|fBodyGyro_mean_Z|Max.   : 0.4924   |

|field     |summary stats|
|---------------|-----------------|
|fBodyGyro_std_X|Min.   :-0.9947   |
|fBodyGyro_std_X|1st Qu.:-0.9750   |
|fBodyGyro_std_X|Median :-0.8086   |
|fBodyGyro_std_X|Mean   :-0.7110   |
|fBodyGyro_std_X|3rd Qu.:-0.4813   |
|fBodyGyro_std_X|Max.   : 0.1966   |

|field     |summary stats|
|---------------|-----------------|
|fBodyGyro_std_Y|Min.   :-0.9944   |
|fBodyGyro_std_Y|1st Qu.:-0.9602   |
|fBodyGyro_std_Y|Median :-0.7964   |
|fBodyGyro_std_Y|Mean   :-0.6454   |
|fBodyGyro_std_Y|3rd Qu.:-0.4154   |
|fBodyGyro_std_Y|Max.   : 0.6462   |

|field     |summary stats|
|---------------|-----------------|
|fBodyGyro_std_Z|Min.   :-0.9867   |
|fBodyGyro_std_Z|1st Qu.:-0.9643   |
|fBodyGyro_std_Z|Median :-0.8224   |
|fBodyGyro_std_Z|Mean   :-0.6577   |
|fBodyGyro_std_Z|3rd Qu.:-0.3916   |
|fBodyGyro_std_Z|Max.   : 0.5225   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccMag_mean|Min.   :-0.9868   |
|fBodyAccMag_mean|1st Qu.:-0.9560   |
|fBodyAccMag_mean|Median :-0.6703   |
|fBodyAccMag_mean|Mean   :-0.5365   |
|fBodyAccMag_mean|3rd Qu.:-0.1622   |
|fBodyAccMag_mean|Max.   : 0.5866   |

|field     |summary stats|
|---------------|-----------------|
|fBodyAccMag_std|Min.   :-0.9876   |
|fBodyAccMag_std|1st Qu.:-0.9452   |
|fBodyAccMag_std|Median :-0.6513   |
|fBodyAccMag_std|Mean   :-0.6210   |
|fBodyAccMag_std|3rd Qu.:-0.3654   |
|fBodyAccMag_std|Max.   : 0.1787   |

|field     |summary stats|
|---------------|-----------------|
|fBodyBodyAccJerkMag_mean|Min.   :-0.9940   |
|fBodyBodyAccJerkMag_mean|1st Qu.:-0.9770   |
|fBodyBodyAccJerkMag_mean|Median :-0.7940   |
|fBodyBodyAccJerkMag_mean|Mean   :-0.5756   |
|fBodyBodyAccJerkMag_mean|3rd Qu.:-0.1872   |
|fBodyBodyAccJerkMag_mean|Max.   : 0.5384   |

|field     |summary stats|
|---------------|-----------------|
|fBodyBodyAccJerkMag_std|Min.   :-0.9944   |
|fBodyBodyAccJerkMag_std|1st Qu.:-0.9752   |
|fBodyBodyAccJerkMag_std|Median :-0.8126   |
|fBodyBodyAccJerkMag_std|Mean   :-0.5992   |
|fBodyBodyAccJerkMag_std|3rd Qu.:-0.2668   |
|fBodyBodyAccJerkMag_std|Max.   : 0.3163   |

|field     |summary stats|
|---------------|-----------------|
|fBodyBodyGyroMag_mean|Min.   :-0.9865   |
|fBodyBodyGyroMag_mean|1st Qu.:-0.9616   |
|fBodyBodyGyroMag_mean|Median :-0.7657   |
|fBodyBodyGyroMag_mean|Mean   :-0.6671   |
|fBodyBodyGyroMag_mean|3rd Qu.:-0.4087   |
|fBodyBodyGyroMag_mean|Max.   : 0.2040   |

|field     |summary stats|
|---------------|-----------------|
|fBodyBodyGyroMag_std|Min.   :-0.9815   |
|fBodyBodyGyroMag_std|1st Qu.:-0.9488   |
|fBodyBodyGyroMag_std|Median :-0.7727   |
|fBodyBodyGyroMag_std|Mean   :-0.6723   |
|fBodyBodyGyroMag_std|3rd Qu.:-0.4277   |
|fBodyBodyGyroMag_std|Max.   : 0.2367   |

|field     |summary stats|
|---------------|-----------------|
|fBodyBodyGyroJerkMag_mean|Min.   :-0.9976   |
|fBodyBodyGyroJerkMag_mean|1st Qu.:-0.9813   |
|fBodyBodyGyroJerkMag_mean|Median :-0.8779   |
|fBodyBodyGyroJerkMag_mean|Mean   :-0.7564   |
|fBodyBodyGyroJerkMag_mean|3rd Qu.:-0.5831   |
|fBodyBodyGyroJerkMag_mean|Max.   : 0.1466   |

|field     |summary stats|
|---------------|-----------------|
|fBodyBodyGyroJerkMag_std|Min.   :-0.9976   |
|fBodyBodyGyroJerkMag_std|1st Qu.:-0.9802   |
|fBodyBodyGyroJerkMag_std|Median :-0.8941   |
|fBodyBodyGyroJerkMag_std|Mean   :-0.7715   |
|fBodyBodyGyroJerkMag_std|3rd Qu.:-0.6081   |
|fBodyBodyGyroJerkMag_std|Max.   : 0.2878   |



##Description of the variables in the tidy.txt file

#### Original README.txt excerpts

######  Each record provides:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.


####  Original Features file excerpts:
- t prefix denotes time domain signals, except for these that are averages listed below:
- - tBodyAccMean
- - tBodyAccJerkMean
- - tBodyGyroMean
- - tBodyGyroJerkMean

- f prefix denotes frequency domain signals

- anything else was estimated from signal




The final tidy file is 180 rows and 69 columns. Here are the results of running str() on it:

 
| column                     |type| valyes|
|----------------------------|----|---------|
| $ subject                  | : int|  1 1 1 1 1 1 2 2 2 2 ...|
| $ activity                 | : Factor w/ 6 levels| "LAYING","SITTING",..| : 1 2 3 4 5 6 1 2 3 4 ...|
| $ activity_cd              | : num|  6 4 5 1 3 2 6 4 5 1 ...|
| $ tBodyAcc_mean_X          | : num|  0.222 0.261 0.279 0.277 0.289 ...|
| $ tBodyAcc_mean_Y          | : num| -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...|
| $ tBodyAcc_mean_Z          | : num|  -0.113 -0.105 -0.111 -0.111 -0.108 ...|
| $ tBodyAcc_std_X           | : num|  -0.928 -0.977 -0.996 -0.284 0.03 ...|
| $ tBodyAcc_std_Y           | : num|  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...|
| $ tBodyAcc_std_Z           | : num|  -0.826 -0.94 -0.98 -0.26 -0.23 ...|
| $ tGravityAcc_mean_X       | : num|  -0.249 0.832 0.943 0.935 0.932 ...|
| $ tGravityAcc_mean_Y       | : num|  0.706 0.204 -0.273 -0.282 -0.267 ...|
| $ tGravityAcc_mean_Z       | : num|  0.4458 0.332 0.0135 -0.0681 -0.0621 ...|
| $ tGravityAcc_std_X        | : num|  -0.897 -0.968 -0.994 -0.977 -0.951 ...|
| $ tGravityAcc_std_Y        | : num|  -0.908 -0.936 -0.981 -0.971 -0.937 ...|
| $ tGravityAcc_std_Z        | : num|  -0.852 -0.949 -0.976 -0.948 -0.896 ...|
| $ tBodyAccJerk_mean_X      | : num|  0.0811 0.0775 0.0754 0.074 0.0542 ...|
| $ tBodyAccJerk_mean_Y      | : num|  0.003838 -0.000619 0.007976 0.028272 0.02965 ...|
| $ tBodyAccJerk_mean_Z      | : num|  0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...|
| $ tBodyAccJerk_std_X       | : num|  -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...|
| $ tBodyAccJerk_std_Y       | : num|  -0.924 -0.981 -0.986 0.067 -0.102 ...|
| $ tBodyAccJerk_std_Z       | : num|  -0.955 -0.988 -0.992 -0.503 -0.346 ...|
| $ tBodyGyro_mean_X         | : num|  -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...|
| $ tBodyGyro_mean_Y         | : num|  -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...|
| $ tBodyGyro_mean_Z         | : num|  0.1487 0.0629 0.0748 0.0849 0.0901 ...|
| $ tBodyGyro_std_X          | : num|  -0.874 -0.977 -0.987 -0.474 -0.458 ...|
| $ tBodyGyro_std_Y          | : num|  -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...|
| $ tBodyGyro_std_Z          | : num|  -0.908 -0.941 -0.981 -0.344 -0.125 ...|
| $ tBodyGyroJerk_mean_X     | : num|  -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...|
| $ tBodyGyroJerk_mean_Y     | : num|  -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...|
| $ tBodyGyroJerk_mean_Z     | : num|  -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...|
| $ tBodyGyroJerk_std_X      | : num|  -0.919 -0.992 -0.993 -0.207 -0.487 ...|
| $ tBodyGyroJerk_std_Y      | : num|  -0.968 -0.99 -0.995 -0.304 -0.239 ...|
| $ tBodyGyroJerk_std_Z      | : num|  -0.958 -0.988 -0.992 -0.404 -0.269 ...|
| $ tBodyAccMag_mean         | : num|  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...|
| $ tBodyAccMag_std          | : num|  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...|
| $ tGravityAccMag_mean      | : num|  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...|
| $ tGravityAccMag_std       | : num|  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...|
| $ tBodyAccJerkMag_mean     | : num|  -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...|
| $ tBodyAccJerkMag_std      | : num|  -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...|
| $ tBodyGyroMag_mean        | : num|  -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...|
| $ tBodyGyroMag_std         | : num|  -0.819 -0.935 -0.979 -0.187 -0.226 ...|
| $ tBodyGyroJerkMag_mean    | : num|  -0.963 -0.992 -0.995 -0.299 -0.295 ...|
| $ tBodyGyroJerkMag_std     | : num|  -0.936 -0.988 -0.995 -0.325 -0.307 ...|
| $ fBodyAcc_mean_X          | : num|  -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...|
| $ fBodyAcc_mean_Y          | : num|  -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...|
| $ fBodyAcc_mean_Z          | : num|  -0.883 -0.959 -0.985 -0.332 -0.226 ...|
| $ fBodyAcc_std_X           | : num|  -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...|
| $ fBodyAcc_std_Y           | : num|  -0.834 -0.917 -0.972 0.056 -0.113 ...|
| $ fBodyAcc_std_Z           | : num|  -0.813 -0.934 -0.978 -0.28 -0.298 ...|
| $ fBodyAccJerk_mean_X      | : num|  -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...|
| $ fBodyAccJerk_mean_Y      | : num|  -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...|
| $ fBodyAccJerk_mean_Z      | : num|  -0.948 -0.986 -0.991 -0.469 -0.288 ...|
| $ fBodyAccJerk_std_X       | : num|  -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...|
| $ fBodyAccJerk_std_Y       | : num|  -0.932 -0.983 -0.987 0.107 -0.135 ...|
| $ fBodyAccJerk_std_Z       | : num|  -0.961 -0.988 -0.992 -0.535 -0.402 ...|
| $ fBodyGyro_mean_X         | : num|  -0.85 -0.976 -0.986 -0.339 -0.352 ...|
| $ fBodyGyro_mean_Y         | : num|  -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...|
| $ fBodyGyro_mean_Z         | : num|  -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...|
| $ fBodyGyro_std_X          | : num|  -0.882 -0.978 -0.987 -0.517 -0.495 ...|
| $ fBodyGyro_std_Y          | : num|  -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...|
| $ fBodyGyro_std_Z          | : num|  -0.917 -0.944 -0.982 -0.437 -0.238 ...|
| $ fBodyAccMag_mean         | : num|  -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...|
| $ fBodyAccMag_std          | : num|  -0.798 -0.928 -0.982 -0.398 -0.187 ...|
| $ fBodyBodyAccJerkMag_mean | : num|  -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...|
| $ fBodyBodyAccJerkMag_std  | : num|  -0.922 -0.982 -0.993 -0.103 -0.104 ...|
| $ fBodyBodyGyroMag_mean    | : num|  -0.862 -0.958 -0.985 -0.199 -0.186 ...|
| $ fBodyBodyGyroMag_std     | : num|  -0.824 -0.932 -0.978 -0.321 -0.398 ...|
| $ fBodyBodyGyroJerkMag_mean| : num|  -0.942 -0.99 -0.995 -0.319 -0.282 ...|
| $ fBodyBodyGyroJerkMag_std | : num|  -0.933 -0.987 -0.995 -0.382 -0.392 ...|



##Sources
- http://stackoverflow.com/questions/7963898/extracting-the-last-n-characters-from-a-string-in-r
- https://fishr.wordpress.com/2014/04/17/dplyr-example-1/
- https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
- https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf

