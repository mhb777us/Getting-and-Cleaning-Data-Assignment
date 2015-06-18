#Author: mhb777us
#Date: 12/15/2015
##Document: The script (run_analysis.R) for assignment of course Getting and Cleaning Data. 
library(dplyr)  #load the dplyr 

## Download data from the web
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl1,destfile="./Dataset.zip",method="curl")
unzdir <- getwd() 

## Unzip the data into directory:UCI HAR Dataset
unzip("Dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = unzdir, unzip = "internal",
      setTimes = FALSE)

## Load activity and features details
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Load test data and load into dataframes
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

## Load train data and load into dataframes
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

## Rename the columns of activity_labels to meaningful names
## V1 = activity_id , V2 = activity_name
names(activity_labels) <- c ("activity_id" , "activity_name")

## rename the columns of y_train, y_test meaningful names
## V1 = activity_id which will be used for merging the dataframess with activity_labels
names(y_train) <-  "activity_id" 
names(y_test)  <-  "activity_id" 

## Rename the column name of subject_test and subject_train as subject_id
## so that the the V1 has a meaningful name which identifies the subject
names(subject_train) <- "subject_id"
names(subject_test) <- "subject_id"

## convert the dataframe into a vector so that 
## you could rename the X_test & X_train column names to be descriptive
fvector <- as.vector(features[, "V2"]) ## captures all measurement column names into a vector

## Clean up the data labels: 
## Remove "-", "(",  ")" , "," replace with "_" (underscore)
fvector <- gsub("-","_", fvector) ## replace -  with _
fvector <- gsub(",","_", fvector) ## replace ,  with _
fvector <- gsub("\\(","_",fvector) ## replace (  with _
fvector <- gsub("\\)","",fvector) ## replace )  with nothing
fvector <- gsub("__","_",fvector)  ## replace __ with _
fvector <- gsub("_$","",fvector)  ## replace _  with nothing (at the end)

## Apply the clensed data labels to raw data's columns
names(X_train) <- fvector ## creates descriptive column names using fvector
names(X_test) <- fvector ## creates descriptive column names using fvector

## Join tables y_train with activity_labes using activity_id
## give a descriptive label for this table.
y_train_activity <- merge(activity_labels, y_train)  ## JOIN BASED ON KEY activity_id

## Join tables y_test with activity_labes using activity_id
## give a descriptive label for this table.
y_test_activity <- merge(activity_labels, y_test)  ## JOIN BASED ON KEY activity_id

## Combine columnwize Train Activity, Subjects to the measurement dataframes so that  
## each measurement row can be identified by Activity and Subject
label_train_activity <- cbind(y_train_activity,subject_train, X_train)

## Combine columnwize Test Activity, Subjects to the measurement dataframes so that  
## each measurement row can be identified by Activity and Subject
label_test_activity <- cbind(y_test_activity, subject_test, X_test)

## Combine row-wize Test and Train data from dataframes label_train_activity, label_test_activity
all_activity <- rbind(label_train_activity, label_test_activity )

# Create Key only subset dataframe with : activity_id, activity_name and subject_id. It is
# required to identify the data for mean and std measurements.
mykeys <- all_activity [, 1:3]

# Create subset for mean only mesurement data and store in mymean
mymean <-  all_activity[, grep("mean", fvector, value = TRUE) ]

# Create subset for standard dev only mesurement data and store in mystd
mystd <-  all_activity[, grep("std", fvector, value = TRUE) ]

# Combine columnwize with keys, mean, and std into one dataframe: my_mean_std. 
# It will have activity id, subject id and the mean and std only measurements
my_mean_std <- cbind(mykeys, mymean, mystd)

# Create a group function using by_package. It can be used in summerize_each function
by_activity_subject <- group_by(my_mean_std, activity_name, subject_id) 

# Create the actual dataset for the group defined in by_activity_subject
mean_by_activity_subject <-summarise_each(by_activity_subject,funs(mean))

# Write the output file with mean and sd measurements group by activity name and subject id.
# The file name is mean_by_activity_subject.txt
file2 <- paste0 (unzdir, "/mean_by_activity_subject.txt")
write.table(mean_by_activity_subject , file2, row.name=FALSE )
