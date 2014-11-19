GettingAndCleaningDataProject
=============================

The key file in this repository is run_analysis.R, which was authored by Ben Sanders on November 5th, 2014.
 
This script acts on the Human Activity Recognition Using Smartphones Data Set. information about the data set may be found here: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


the data set may be downloaded here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
 
This script creates two files containing activity data which has been prepared for analysis.
The file cleaned_data.txt contains a subset of the merged Activity Recognition Using Smartphones Data Set,
which has then been labeled for clarity. The file averaged_data.txt contains the averages for each activity
and subject, taken from the cleaned_data.text file, using the same units of measure.
 
In order for this script to function the source data must be downloaded and extracted to the working directory.
Expected files include:

UCI HAR Dataset\
-features.txt
-test\
--subject_test.txt
--x_test.txt
--y_test.txt
-train\
--subject_train.txt
--x_train.txt
--y_train.txt
 
There are no functions to call, just run the script in its entirety and the data will be merged and summarized.
 
This script operates through the following steps:

1) Load the files into memory

2) merge the data sets using rbind and cbind.

3) Label the dataset with descriptive names.

4) Remove undesired columns

5) Add descriptive activity names.

6) Create a second dataset with averages information.

7) Store the data in files.

8) Test the data for consistency with my original data.
