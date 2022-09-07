#This is not the original file. I have edited this one. -Deva

rm(list = ls(all = TRUE)) 

setwd("~/")
#setwd("Z:/Experiments_of_Maria/20200505_strain_extra")

#Set path to this from where your 'cardiac' folder is. The .rda is inside the UKBB.. folder shown below
ukbbdata<-readRDS("Desktop/cardiac/UKBB_40616/Phenotypes/41354/my_ukb_data_41354.rda") 

############################################################################
#NOTE: This here (the data folder) does not exist. So lets ignore it for now
#I think from what I can gather this was a folder pointing to a set of images with 
#ID's that would link them with eid_18545 (must have been a group of 
#images that were linked to some expriemntal subgroup...)
##Code ignored

folderImagingDataPath <- c("cardiac/UKBB_New_Data/data") 

foldersNames <- list.dirs(folderImagingDataPath,
                          full.names = FALSE,
                          recursive = F)
############################################################################

#Chage path to your cardiac drive and the bridge file will be in the folder structure
ukbb_bridge <-data.frame(read.csv("Desktop/cardiac/UKBB_40616/Bridging file/Bridge40616_18545.csv"))

#NOTE: The folder here refed (foldersNames) does not exist. (see Note above.) 
#So lets just get all the IDs on the folder for now (or any subset that you think is relavent).
#Btw for anyone working on this in future the below code will
#return the indexes that matches eid_18545 with the folders

##p<-match(foldersNames,ukbb_bridge$eid_18545) #Original code ignored for now as no subset

p<-row.names(ukbb_bridge)#The edit

names<-ukbb_bridge[p,]
pdata<-match(names$eid_40616,ukbbdata$eid)
age<-ukbbdata$age_when_attended_assessment_centre_f21003_2_0[pdata]
sex<-ukbbdata$sex_f31_0_0[pdata]
library(plyr)

sex<-as.matrix(mapvalues(sex, from = c("Female", "Male"), to = c("0","1")))
sex<-as.numeric(as.character(sex))

bsa<-ukbbdata$body_surface_area_f22427_2_0[pdata]


mSBP<-cbind(rowMeans(cbind(ukbbdata$systolic_blood_pressure_manual_reading_f93_2_0[pdata],ukbbdata$systolic_blood_pressure_manual_reading_f93_2_1[pdata]), na.rm = TRUE, dims = 1),
            rowMeans(cbind(ukbbdata$systolic_blood_pressure_automated_reading_f4080_2_0[pdata], ukbbdata$systolic_blood_pressure_automated_reading_f4080_2_1[pdata]), na.rm = TRUE, dims = 1))
sbp<-rowMeans(mSBP, na.rm = TRUE, dims = 1)
mDBP<-cbind(rowMeans(cbind(ukbbdata$diastolic_blood_pressure_manual_reading_f94_2_0[pdata], ukbbdata$diastolic_blood_pressure_manual_reading_f94_2_1[pdata]), na.rm = TRUE, dims = 1),
            rowMeans(cbind(ukbbdata$diastolic_blood_pressure_automated_reading_f4079_2_0[pdata], ukbbdata$diastolic_blood_pressure_automated_reading_f4079_2_1[pdata]), na.rm = TRUE, dims = 1))
dbp<-rowMeans(mDBP, na.rm = TRUE, dims = 1)

ukb_datatble<-as.data.frame(cbind(names$eid_18545,age, sex, bsa,sbp,dbp))
colnames(ukb_datatble)<-c("Encoded_ID","Age","Sex","BSA","SBP","DBP")
#write.csv(ukb_datatble,"phenotype_ukbb_1800.csv", col.names = TRUE, row.names = FALSE) #Code ignored as writing a data table using csv is not the best

setwd("Desktop/cardiac/Deva/") #This should be your working folder in the cardiac drive. ie: ../cardiac/User01
write.table(ukb_datatble,"phenotype_ukbb_1800.csv", col.names = TRUE, row.names = FALSE, sep="\t")

# n<-which(is.na(ukb_datatble$Age))
