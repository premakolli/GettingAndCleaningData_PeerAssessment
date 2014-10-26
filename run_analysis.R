#Reading the column names from features text file
column_names<-read.table("features.txt")
#Filtering columns to consider only mean and standard deviation measurements
column_indexes<-grep("mean|std", column_names[,2])

#Reading the activity labels text file
activity_labels<-read.table("activity_labels.txt")

#Reading the training and testing subject files
subject_test<-read.table("test/subject_test.txt")
subject_train<-read.table("train/subject_train.txt")
#Set labels for subject datasets
names(subject_test)<-c("subjectnumber")
names(subject_train)<-c("subjectnumber")

#Reading the training and testing x files
x_test<-read.table("test/X_test.txt")
x_train<-read.table("train/X_train.txt")
#Getting columns with mean and standard deviation measurements
x_test<-x_test[,column_indexes]
x_train<-x_train[,column_indexes]
#Setting labels for x datasets
names(x_test)<-column_names[column_indexes,2]
names(x_train)<-column_names[column_indexes,2]

#Reading the training and testing y files
y_test<-read.table("test/y_test.txt")
y_train<-read.table("train/y_train.txt")

#Merging the training and testing y datasets with activity labels
y_test<-merge(activity_labels, y_test)
y_train<-merge(activity_labels, y_train)

#Setting labels for y datasets
names(y_test)<-c("activitycode", "activitydescription")
names(y_train)<-c("activitycode", "activitydescription")

#Creating data frame from the testing and training data
test_df<-data.frame(subject_test, y_test, x_test)
train_df<-data.frame(subject_train, y_train, x_train)

#Combining the testing and training data frame
dataset<-rbind(test_df, train_df)

#Splitting the dataset by subject and acvitity
splitdatasets<-split(dataset, list(dataset$subjectnumber, dataset$activitycode), drop=TRUE)

#Calculating column means and transpose
colmeans<-data.frame(t(sapply(splitdatasets, function(x) colMeans(x[, 4:82], na.rm=TRUE))))
#Get row.names
subject.activity<-row.names(colmeans)
#Delete row.names column
row.names(colmeans)<-NULL
#Create new subject.activity column
colmeans<-cbind(subject.activity, colmeans)

#Save the two tidy datasets
write.csv(dataset, file="dataset1.csv")
write.csv(colmeans, file="dataset2.csv")
write.table(colmeans, file="dataset2.txt", row.name=FALSE)