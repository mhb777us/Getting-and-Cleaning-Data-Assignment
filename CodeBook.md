
Author: mhb777us
Date: 12/15/2015
Document: Code book about assignment for course Getting and Cleaning Data.

# Load all data from the sources.

R object			Source					Description
activity_labels		activity_labels.txt		Load Activity data 
features			features.txt			Load features data 
subject_test		subject_test.txt		Load subject test data 
X_test 				X_test.txt				Load subject X_test data 
y_test 				y_test.txt				Load subject y_test data 
subject_train		subject_train.txt		Load subject train data 
X_train 			X_train.txt				Load subject X_train data 
y_train				y_train.txt				Load subject y_train data 


# Rename the default key names with appropriate meaningful labels

R object			Source					Description
activity_labels		activity_labels			Renamed: V1 = activity_id, V2 = activity_name
y_train				y_train					Renamed: V1 = activity_id 
y_test				y_test					Renamed: V1 = activity_id 
fvector				features				Captures all descriptive column labels. These 
											labels would be applied to X_train, X_tests
X_test				fvector					These labels captured from prior step are  
											applied to X_tests
X_train				fvector					These labels captured from prior step are  
											applied to X_train
subject_train		N/A						Renamed column: V1 = subject_id 
subject_test		N/A						Renamed column: V1 = subject_id 


# Combine all data: measurements with activity and subjects

R object			  Source					Description
y_train_activity	  activity_labels			Join dataframes on activity_id to provide  
					  y_train					descriptive activity names
y_test_activity		  activity_labels			Join dataframes on activity_id to provide  
					  y_test					descriptive activity names
					
label_train_activity  y_train_activity			Join train measures to activity & subjects.
					  subject_train				This step provides who does what
					  X_train
label_test_activity   y_test_activity			Join test measures to activity & subjects.
					  subject_test				This step provides who does what
					  X_test

all_activity 	      label_train_activity      Merge test and train data into one.
					  label_test_activity		This step provides the complete measures
					   							for test and train data together


## Create subset only for mean and standard deviation measurements. Ignore other columns
## Write the file from this data set that satisfy the first requirement

R object		  	Source					Description
mymean	  			all_activity			Subset columns who's labels are mean 
mystd	  			all_activity			Subset columns who's labels are standard dev 
my_mean_std 		mymean					Combine mean and std measure columns
					mystd
mean_std_only.txt	my_mean_std				Write output for Step 4


## Using the previous data set, create a new summary data set for mean grouped by 
## activity names and subject id. 
## Write the file from this data set that satisfy the second requirement

R object		  		      Source				    Description
by_activity_subject			  my_mean_std  			    group by activity name and subject
mean_by_activity_subject	  by_activity_subject	    create a mean data by above group
mean_by_activity_subject.txt  mean_by_activity_subject  Write output for Step 5


