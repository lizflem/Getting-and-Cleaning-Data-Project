##Course project for Getting and Cleaning Data

## Creating complete data set

## Set wd to "./R/CleaningData/UCI HAR Dataset"

library(data.table)
library(reshape2)

test_subject <- fread("./test/subject_test.txt")
test_label <- fread("./test/y_test.txt")

test_dataset <- read.table("./test/x_test.txt", sep="", header=FALSE, strip.white=TRUE)
test_dataset <- as.data.table(test_dataset)

train_subject <- fread("./train/subject_train.txt")
train_label <- fread("./train/y_train.txt")

train_dataset <- read.table("./train/x_train.txt", sep="", header=FALSE, strip.white=TRUE)
train_dataset <- as.data.table(train_dataset)

feature <- fread("./features.txt")
Activity <- fread("./activity_labels.txt")

setkey(Activity, V1)
test_data <- Activity[test_label]
test_data <- cbind(test_data$V2, test_subject, test_dataset)

train_data <- Activity[train_label]
train_data <- cbind(train_data$V2, train_subject, train_dataset)

Sphone_data <- rbind(train_data, test_data)
setnames(Sphone_data,1:2,c("Activity","Subject"))
setnames(Sphone_data,3:563,feature$V2)

rm(Activity, test_dataset, test_label, test_subject, train_dataset, train_label, train_subject, train_data, test_data)

## Extracting mean and std measurements

colmeans <- names(Sphone_data)[grep("mean",names(Sphone_data))]
colmeans <- colmeans[-grep("meanFreq",colmeans)]

colstds <- names(Sphone_data)[grep("std",names(Sphone_data))]
col_meanstd <- c(colmeans, colstds) 

meanstd_data <- Sphone_data[,col_meanstd,with=FALSE]
meanstd_data <- cbind(Sphone_data$Activity, Sphone_data$Subject, meanstd_data)
setnames(meanstd_data,1:2,c("Activity","Subject"))

## Creating data set of averages for mean and std data

setkey(meanstd_data, Activity, Subject)
aveDT <- meanstd_data[,lapply(.SD,mean),by=list(Activity,Subject)]

aveDT_long <- melt(aveDT, id.vars=c("Activity","Subject"),
                   variable.name="Calculation",
                   value.name="Measurement")

options(max.print=1000000)
capture.output( print(aveDT_long, print.gap=3, nrow=11880, row.names=FALSE), file="tidydata.txt")