#libraries
library(tidyverse)
library(rstudioapi)

#change working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#read in datasets
path <- '../data/processed_data/'
data2016 <- read_csv(paste(path, 'cleandata2016.csv', sep = ""))
data2017 <- read_csv(paste(path, 'cleandata2017.csv', sep = ""))
data2018 <- read_csv(paste(path, 'cleandata2018.csv', sep = ""))
data2019 <- read_csv(paste(path, 'cleandata2019.csv', sep = ""))


#rename variables
data2016 <- rename(data2016, PATIENT_PROBLEM_CODE = PROBLEM_CODE)
data2019 <- rename(data2019, PATIENT_PROBLEM_DESCRIPTION = PATIENT_PROBLEM,
                   DEVICE_PROBLEM_DESCRIPTION = DEVICE_PROBLEM)
data2017 <- rename(data2017, PATIENT_PROBLEM_CODE = PROBLEM_CODE)
data2018 <- rename(data2018, PATIENT_PROBLEM_CODE = PROBLEM_CODE)

#get rid of first variable in data2018 
data2018 <- data2018[,-c(1)]

#more data cleaning 
data2017$DATE_OF_EVENT <- format(as.Date(as.character(data2017$DATE_OF_EVENT)), format = "%m/%d/%Y")
data2017$DATE_RECEIVED <- format(as.Date(as.character(data2017$DATE_RECEIVED)), format = "%m/%d/%Y")

data2019$DATE_OF_EVENT <- format(as.Date(as.character(data2019$DATE_OF_EVENT)), format = "%m/%d/%Y")
data2019$DATE_RECEIVED <- format(as.Date(as.character(data2019$DATE_RECEIVED)), format = "%m/%d/%Y")


#vertical merge 
cleandata <- rbind(data2016, data2017, data2018, data2019)


#write to csv file
write.csv(cleandata, paste(path, 'cleandata.csv', sep = ""), row.names = FALSE)


                      
            
      

               
  


