#Author: mhb777us
#Date: 12/15/2015
Document: The script (run_analysis.R) for assignment of course Getting and Cleaning Data. 

library(dplyr)  #load the dplyr 

## Read activity and features details
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

## Read train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

## rename the columns of activity_labels to meaningful names
## V1 = activity_id , V2 = activity_name
names(activity_labels) <- c ("activity_id" , "activity_name")

## rename the columns of y_train, y_test meaningful names
## V1 = activity_id which will be used for merging the dataframess with activity_labels
names(y_train) <-  "activity_id" 
names(y_test)  <-  "activity_id" 

## Join tables y_train with activity_labes using activity_id
## give a descriptive label for this table.
y_train_activity <- merge(activity_labels, y_train)  ## JOIN BASED ON KEY x

## Join tables y_test with activity_labes using activity_id
## give a descriptive label for this table.
y_test_activity <- merge(activity_labels, y_test)  ## JOIN BASED ON KEY x

## Join tables y_train with activity_labes using activity_id
## give a descriptive label for this table.
y_train_activity <- merge(activity_labels, y_train)  ## JOIN BASED ON KEY 

## Join tables y_test with activity_labes using activity_id
## give a descriptive label for this table.
y_test_activity <- merge(activity_labels, y_test)  ## JOIN BASED ON KEY 

## Rename the column name of subject_test and subject_train as subject_id
## so that the the V1 has a meaningful name which identifies the subject
names(subject_train) <- "subject_id"
names(subject_test) <- "subject_id"

## convert the dataframe into a vector so that 
## you could rename the X_test & X_train column names to be descriptive

fvector <- features[, "V2"] ## captures all measurement column names into a vector
names(X_test) <- fvector ## creates descriptive column names using fvector
names(X_train) <- fvector ## creates descriptive column names using fvector

## combine X_train,subject_train, and y_train_activity dataframes so that each row can 
## be identified by descriptive name such Walking and for a given subject
label_train_activity <- cbind(y_train_activity,subject_train, X_train)

## combine X_test,subject_test, and y_test_activity dataframes so that each row can 
## be identified by descriptive name such Walking and for a given subject
label_test_activity <- cbind(y_test_activity, subject_test, X_test)

## combine test and train data from dataframes label_train_activity, label_test_activity
all_activity <- rbind(label_train_activity, label_test_activity )

# create subset for mean only mesurement data and store in mymean
mymean <-  all_activity[, grep("mean", fvector) ]

# create subset for standard dev only mesurement data and store in mystd
mystd <-  all_activity[, grep("std", fvector) ]

# Combine mean and std mesurement data into one dataframe: my_mean_std
my_mean_std <- cbind(mymean, mystd)

# Write the output file with mean and sd measurements only. The file name is mean_std_only.txt
write.table(my_mean_std , "UCI HAR Dataset/mean_std_only.txt", row.name=FALSE )

# Create a group function using by_package. It can be used in summerize_each function
by_activity_subject <- group_by(my_mean_std, activity_name, subject_id) 

# Create the actual dataset for the group defined in by_activity_subject

mean_by_activity_subject <-summarise_each(by_activity_subject,funs(mean))

# Write the output file with mean and sd measurements only. The file name is mean_by_activity_subject.txt
write.table(mean_by_activity_subject , "UCI HAR Dataset/mean_by_activity_subject.txt", row.name=FALSE )
