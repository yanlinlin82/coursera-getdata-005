URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DATA_DIR <- "./data/"
DATA_FILE <- paste0(DATA_DIR, "getdata_projectfiles_UCI_HAR_Dataset.zip")

if (!file.exists(DATA_DIR)) {
    if (!dir.create(DATA_DIR)) {
        stop("failed to create directory")
    }
}
if (!file.exists(DATA_FILE)) {
    ret <- download.file(URL, DATA_FILE, method = "curl")
    if (ret != 0) {
        stop("failed to download raw data")
    }
}
if (!file.exists("./UCI HAR Dataset/")) {
    unzip(DATA_FILE)
}
