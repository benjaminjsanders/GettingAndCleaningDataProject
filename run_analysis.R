# run_analysis.R
# Authored by Ben Sanders on November 5th, 2014.
# This script acts on the Human Activity Recognition Using Smartphones Data Set
# information about the data set may be found here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
# the data set may be downloaded here: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# This script creates two files containing activity data which has been prepared for analysis.
# The file cleaned_data.txt contains a subset of the merged Activity Recognition Using Smartphones Data Set,
# which has then been labled for clarity. The file averaged_data.txt contains the averages for each activity
# and subject, taken from the cleaned_data.text file.

# In order for this script to function the source data must be downloaded and extracted to the working directory.
# Expected files include:
# UCI HAR Dataset
# |__>features.txt
# |__>test
# |   |__>subject_test.txt
# |   |__>x_test.txt
# |   |__>y_test.txt
# |__>train
#     |__>subject_train.txt
#     |__>x_train.txt
#     |__>y_train.txt


### LOAD DATA
features <- read.table("./UCI HAR Dataset/features.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

### MERGE DATASETS
test_data <- cbind(subject_test, x_test)
test_data <- cbind(y_test, test_data)
train_data <- cbind(subject_train, x_train)
train_data <- cbind(y_train, train_data)
merged_data <- rbind(test_data, train_data)
merged_data <- cbind(rep_len(" ", length.out=length(merged_data[,1])), merged_data)

### LABEL THE DATASET WITH DESCRIPTIVE VARIABLE NAMES
names(merged_data) <- c("Activity_Name","Activity_ID","Subject",as.character(features[,2]))

### FREE UP MEMORY / GARBAGE COLLECTION
rm(list=ls()[ls()!="merged_data"])

### REMOVE UNDESIRED COLUMNS
desired_data <- merged_data[,1:3]
desired_data <- cbind(desired_data, merged_data[,grepl("-mean()",names(merged_data)) | grepl("-std()",names(merged_data))])

### FREE UP MEMORY / GARBAGE COLLECTION
rm(merged_data)

### ADD DESCRIPTIVE ACTIVITY NAMES
# Convert factor columns to character columns
desired_data[sapply(desired_data, is.factor)] <- lapply(desired_data[sapply(desired_data, is.factor)], as.character)
desired_data[desired_data[,2] == 1,1] <- "WALKING"
desired_data[desired_data[,2] == 2,1] <- "WALKING_UPSTAIRS"
desired_data[desired_data[,2] == 3,1] <- "WALKING_DOWNSTAIRS"
desired_data[desired_data[,2] == 4,1] <- "SITTING"
desired_data[desired_data[,2] == 5,1] <- "STANDING"
desired_data[desired_data[,2] == 6,1] <- "LAYING"

### CREATE AVERAGE DATASET
desired_data[,2:3] <- lapply(desired_data[2:3], as.integer)
# average_data <- lapply(split(desired_data,interaction(desired_data[,2],desired_data[,3], drop=TRUE)), function(x) lapply(x, max))
average_data <- data.frame()
for(i in 1:6) {
    for (j in 1:30) {
        row <- c(" ", i, j, colMeans(desired_data[desired_data[,2]==i & desired_data[,3]==j,4:82]))
        names(row) <- names(desired_data)
        average_data <- rbind(average_data, row)
        if(i==1 & j==1) {
            average_data[,] <- lapply(average_data[,], as.character)
            names(average_data) <- names(desired_data)
        }
    }
}

average_data[,1] <- as.character(average_data[,1])
average_data[,2:82] <- lapply(average_data[2:82], as.numeric)

average_data[average_data[,2] == 1,1] <- "WALKING"
average_data[average_data[,2] == 2,1] <- "WALKING_UPSTAIRS"
average_data[average_data[,2] == 3,1] <- "WALKING_DOWNSTAIRS"
average_data[average_data[,2] == 4,1] <- "SITTING"
average_data[average_data[,2] == 5,1] <- "STANDING"
average_data[average_data[,2] == 6,1] <- "LAYING"

### STORE DATASETS
write.table(desired_data, file="cleaned_data.txt", row.name=FALSE)
write.table(average_data, file="averaged_data.txt", row.name=FALSE)

if (length(average_data[,1]) == 180 &
      isTRUE(all.equal(sum(average_data[,4]),49.37449, tolerance=0.0001)) &
      isTRUE(all.equal(sum(average_data[,5]),-3.217594, tolerance=0.0001))) {
  print("Operation completed successfully.")
} else {
  print("Checksum failed. You may have received a different version of the dataset. Please check your source data.")
}
