Course project for Getting and Cleaning Data 
========================================================

## Creating complete data set

Downloaded all data files and moved to new folder, "CleaningData".

Set working directory to UCI HAR Dataset, and created run_analysis.R and CodeBook.md files.  Loaded data.table and reshape2 packages.

First, read files into R - used fread() on small files (y_train.txt, subject_train.txt, y_test.txt, subject_test.txt, features.txt, and activity_labels.txt) and read.table on large files (X_test.txt and X_train.txt).  Called as.data.table() on large files.

Merged activity labels independently with test and train labels (y_train.txt and y_test.txt data), using key feature from data.table package.  

Used cbind() to fuse test data sets and train data sets (activity labels, subject numbers, and calculated data), independently.

Used rbind() to combine test and train data into complete data set.

Named columns of fused data sets with "Activity", "Subject", and list from features.txt using setnames function from data.table package.

Removed all but complete data set from memory.

## Extracting mean and std measurements

Used grep() to place column names containing "mean" (but not "meanFreq") and "std" into vector("col_meanstd").  Created subset ("meanstd_data") of complete data frame on this vector and re-attached "Activity" and "Subject" columns.  It was necessary to specify the names of the re-attached columns, again, using the setnames function.

## Creating data set of averages for mean and std data

Set "Activity" and "Subject" as my data table's keys, and then computed the means for all present variables, based on those keys, producing data table "aveDT".  Used reshape function from the reshape2 package to position data in long format for improved readability (aveDT_long).  Finally, captured print out of entire table in text file.
