# This file is my course project for "Getting and Cleaning Data" on Coursera.


# Constants

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

DATA_FILE <- "UCI_HAR_Dataset.zip"
UCI_DIR <- "UCI HAR Dataset/"

OUT_FILE_1 <- "tidy_data_1.txt"
OUT_FILE_2 <- "tidy_data_2.txt"


# Download raw data and extract them

if (!file.exists(DATA_FILE)) {
    ret <- download.file(URL, DATA_FILE, method = "curl")
    if (ret != 0) {
        stop("failed to download raw data")
    }
}
if (!file.exists(UCI_DIR)) {
    unzip(DATA_FILE)
}


# Load raw data

features <- read.table(paste0(UCI_DIR, "features.txt"))
stopifnot(identical(features$V1, 1:nrow(features)))

activity_labels <- read.table(paste0(UCI_DIR, "activity_labels.txt"))
stopifnot(identical(activity_labels$V1, 1:nrow(activity_labels)))

train <- read.table(paste0(UCI_DIR, "train/X_train.txt"))
train_labels <- as.integer(readLines(paste0(UCI_DIR, "train/subject_train.txt")))
train_activities <- as.integer(readLines(paste0(UCI_DIR, "train/y_train.txt")))

test <- read.table(paste0(UCI_DIR, "test/X_test.txt"))
test_labels <- as.integer(readLines(paste0(UCI_DIR, "test/subject_test.txt")))
test_activities <- as.integer(readLines(paste0(UCI_DIR, "test/y_test.txt")))


# 1. Merges the training and the test sets to create one data set.

tidy_data <- rbind(cbind(train = TRUE, subject = train_labels,
                         activity = train_activities, train),
                   cbind(train = FALSE, subject = test_labels,
                         activity = test_activities, test))


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

feature_index <- grep("(mean|std)\\(\\)", features$V2)
tidy_data <- tidy_data[, c(1:3, 3 + feature_index)]


# 3. Uses descriptive activity names to name the activities in the data set

activities <- factor(activity_labels$V2, levels = activity_labels$V2)
tidy_data$activity <- activities[tidy_data$activity]


# 4. Appropriately labels the data set with descriptive variable names.

colnames(tidy_data)[-(1:3)] <- gsub("mean", "Mean",
                                    gsub("std", "Std",
                                         gsub("-", "",
                                              gsub("\\(\\)", "",
                                                   as.character(features$V2[feature_index])))))


# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_data_2 <- aggregate(tidy_data[, -(1:3)], by = tidy_data[, 2:3], mean)


# Write tidy data

write.table(tidy_data, file = OUT_FILE_1, row.names = FALSE, quote = FALSE, sep = "\t")
write.table(tidy_data_2, file = OUT_FILE_2, row.names = FALSE, quote = FALSE, sep = "\t")
