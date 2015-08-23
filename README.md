---
title: "README"
author: "Heaven Hodges"
date: "August 23, 2015"
output: html_document
---

### This file explains the operation of the run_analysis script, which was used to generate the dataset in the file tidy_data.txt.

#### Note that the following is arranged into sections that correspond to the sections into which the script is divided.

* Read Data  
     + Training and test data are read in separately, via the function llply (hence, the dplyr package      must be loaded). The two lists of three data frames hold data from the three files in each of the train and test subdirectories.   
* Set Column Names  
     + The names of the data columns correspond to the variable names in the features.txt file.  
* Extract Mean and Std Data  
     + Data columns that do not correspond to mean and standard deviation estimates (the variables)            calculated directly from the smartphone signals were removed.  
* Distinguish Between Test and Train Data  
     + Data column names are prefixed with "Test" and "Train."  
* Merge Test and Training Data  
     + All six of the data frames are merged into a single data frame. The numerical values in the            Activity column are replaced with corresponding activity name according to the table in the             activity_labels.txt file.  
* Average Data  
     + A new data frame is created and written to text file. It consists of the mean of each of the            variables, calculated per subject, per each of the six activities.    