run_analysis <- function() {
     ## this script requires the dplyr package
     ## it is assumed that the working directory contains the unzipped
     ## UCI HAR Dataset, and no file or sub-directory names have been changed
     ## output (to working directory) is a tidy data set: "tidy_data.txt"
# Read Data ---------------------------------------------------------------
     ## list of files from test sub-dir. 2947 lines per file
     test_files <- list.files(path="UCI HAR Dataset/test/", pattern=".txt",
                              full.names = TRUE, include.dirs=FALSE)
     ##list of files from train sub-dir. 7352 lines per file
     train_files <- list.files(path="UCI HAR Dataset/train/", pattern=".txt",
                               full.names = TRUE, include.dirs=FALSE)

     ## read test/train files into a list of data frames
     test_frames <- llply( test_files, read.table, stringsAsFactors = FALSE )
     train_frames <- llply( train_files, read.table, stringsAsFactors = FALSE )

# Set Column Names --------------------------------------------------------
     ## set column names for each data frame in each list
     ## 1. get names of variables
     features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
     ## convert to a vector of variable names
     features <- features[,2]
     col_names <- list( "Subject", features, "Activity")
          for ( this_file in 1:length(test_files) ) {
               colnames(test_frames[[this_file]]) <- col_names[[this_file]]
               colnames(train_frames[[this_file]]) <- col_names[[this_file]]
          }

# Extract Mean and Std Data -----------------------------------------------
     non_mean_indices <- grep("-mean()", features, fixed=TRUE, invert=TRUE)
     non_std_indices <- grep("-std()", features, fixed=TRUE, invert=TRUE)
     both <- intersect(non_mean_indices, non_std_indices)
     test_frames[[2]] <- test_frames[[2]][,-both]
     train_frames[[2]] <- train_frames[[2]][,-both]

# Distinguish Between Test and Train Data ---------------------------------

     ## prefix Data column names
     colnames(test_frames[[2]]) <- paste( "Test", colnames(test_frames[[2]]), sep="_" )
     colnames(train_frames[[2]]) <- paste( "Train", colnames(train_frames[[2]]), sep="_" )
# Merge Test and Training Data --------------------------------------------------------------
     all.data <- merge( test_frames, train_frames, by=c("Subject", "Activity"),
                        all=TRUE, sort=FALSE, suffixes="")

     ## replace numbers in activity columns with respective activity names
     activities <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
     colnames(activities) <- c("Num", "Type")
     for ( index in 1:nrow(activities) ) {
          all.data$Activity[all.data$Activity %in% activities$Num[index]] <- activities$Type[index]
     }
# Average Data -----------------------------------------------
     subjs <- sort( unique(all.data$Subject) )
     avgs_by_subj <- data.frame()

     for( s in 1:length(subjs) ) {
          for( row in 1:length(activities$Type) ) {
               for( col in 3:ncol(all.data) )     ##skip Subject & Activity columns
                    sub_frame <- subset(all.data, Subject==subjs[s] & Activity==activities$Type[row],
                                        select = -(c(Subject,Activity)) )
                 avgs_by_subj <- rbind(avgs_by_subj, apply( sub_frame, 2, mean, na.rm = TRUE) )
          }
     }
     ## identify which subject & activity each average applies to
     colnames(avgs_by_subj) <- colnames(all.data[,-(1:2)])
     Subject <- rep(subjs, each=length(activities$Type))
     Activity <- rep(activities$Type, length(subjs))
     avgs_by_subj <- cbind(Activity, avgs_by_subj)
     avgs_by_subj <- cbind(Subject, avgs_by_subj)
     write.table(avgs_by_subj, file = "tidy_data.txt", row.names = FALSE)
}