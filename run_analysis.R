
# Getting and Cleaning Data Course Project

# cleaning workspace
rm(list=ls())

# 1. Merges the training and the test sets to create one data set.

setwd("C:\\Users\\niandry\\Documents\\niandry\\Data science\\gettingandcleandata\\UCI HAR Dataset")

# read train data
trainsubject<-read.table("./train/subject_train.txt",header=FALSE)
trainset<-read.table("./train/X_train.txt",header=FALSE)
trainlabel<-read.table("./train/Y_train.txt",header=FALSE)
# binding all datasets
traindata <- cbind(trainsubject, trainlabel, trainset)

#read test data
testsubject<-read.table("./test/subject_test.txt",header=FALSE)
testset<-read.table("./test/X_test.txt",header=FALSE)
testlabel<-read.table("./test/Y_test.txt",header=FALSE)
# binding all datasets
testdata <- cbind(testsubject, testlabel, testset)

# combining train and test
alldata <- rbind(traindata, testdata)

#adding columns names
features<- read.table('./features.txt',header=FALSE)
cnames<-c("subjectid","label",as.character(features[,2]))
colnames(alldata)<-cnames


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#creating a vector with name of the columns that need to be included into the dataset
featuresrequiredindex <- grep(".*mean\\(\\).*|.*std.*", as.character(features[,2]))
featuresrequired <- as.character(features[featuresrequiredindex,2])

# subset the dataset with a particular selection of columns
alldata<- subset(alldata, select=c("subjectid","label",featuresrequired))


# 3. Uses descriptive activity names to name the activities in the data set
#reading activiy labels
activitylabel<- read.table('./activity_labels.txt',header=FALSE)
colnames(activitylabel)<-c("label","activity")

#mergen data sets with the activity labels
alldata<-merge(activitylabel,alldata)
alldata<- subset(alldata, select=c("subjectid","activity",featuresrequired))

# 4. Appropriately labels the data set with descriptive variable names.
cnames<-colnames(alldata)

for (i in 1:length(cnames)) 
{
  cnames[i] = gsub("^t","Time",cnames[i])
  cnames[i] = gsub("^f","Frequency",cnames[i])
  cnames[i] = gsub("BodyBody","Body",cnames[i])
  cnames[i] = gsub("Acc","Acceleration",cnames[i])
  cnames[i] = gsub("Mag","Magnitude",cnames[i])
  cnames[i] = gsub("\\(\\)","",cnames[i])
}

colnames(alldata)<-cnames


#5.From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject. 

finaldata <-aggregate(alldata[, !(colnames(alldata) %in% c("subjectid","activity"))], by=list(activity=alldata$activity,subjectid=alldata$subjectid), mean, na.rm=TRUE)
write.table(finaldata, '../tidy_dataset.txt',row.names=FALSE,sep='\t')

