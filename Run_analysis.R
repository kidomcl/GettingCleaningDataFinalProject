

setwd("C:/Users/mclelld2/Documents/DataCleaningWeek4Data/UCI HAR Dataset")

# Read Testing table:
x_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
subject_test <- read.table("./test/subject_test.txt")

# Read training tables:
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")
subject_train <- read.table("./train/subject_train.txt")


# Read Feature Table
features <- read.table("./features.txt")

# Read Activity labels
activity_labels <- read.table("./activity_labels.txt")

#Assigning Column Names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activity_labels) <-c("activityId", "activityType")

# Merging the dataset

merge_train <- cbind(subject_train,x_train,y_train)
merge_test <- cbind(subject_test,x_test,y_test)
setAllInOne <- rbind(merge_train,merge_test)

namesz=colnames(setAllInOne)
namesz=gsub("[()]","",namesz)
namesz=gsub("^t","Time",namesz)
namesz=gsub("^f","Frequency",namesz)
colnames(setAllInOne)=namesz


mean_and_std <- (grepl("activityId" , namesz) | 
                         grepl("subjectId" , namesz) | 
                         grepl("mean.." , namesz) | 
                         grepl("std.." , namesz) 
)
MeanAndStd <- setAllInOne[ , mean_and_std == TRUE]
ActivityNames <- merge(MeanAndStd, activity_labels,by = 'activityId',all.x=TRUE)

TidySet <- aggregate(. ~subjectId + activityId, ActivityNames,mean)
#secTidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

write.csv(TidySet, "TidySet.csv")