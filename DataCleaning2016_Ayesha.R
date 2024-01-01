#read in libraries
library(tidyverse)

#read in datasets
path <- '/Users/adarekar/Documents/College/Senior/ST 495/Project/'
device_data <- read_delim(paste(path, 'DEVICE2016.txt', sep = ""), delim = '|', col_names = TRUE)
patient_data <- read_csv(paste(path, 'patient2016.csv', sep = ""))
mdr_data <- read_csv(paste(path, 'mdr2016.csv', sep = ""))
patient_problem <- read_delim(paste(path, 'patientproblemcode.txt', sep =""), delim = '|', col_names = TRUE)
foi_dev_problem <- read_delim(paste(path, 'foidevproblem.txt', sep = ""), delim = '|', col_names = c('MDR_REPORT_KEY', 'DEVICE_PROBLEM_CODE'))
device_prob_code <- read_csv(paste(path, 'deviceproblemcodes.csv', sep = ""), col_names = c('DEVICE_PROBLEM_CODE', 'PROBLEM_DESCRIPTION'))
patient_prob_code <- read_csv(paste(path, 'patientproblemcodes.csv', sep = ""), col_names = c('PATIENT_PROBLEM_CODE', 'PROBLEM_DESCRIPTION'))


#convert mdr report key variable in patient problem code to integer
patient_problem$MDR_REPORT_KEY <- as.numeric(patient_problem$MDR_REPORT_KEY)

#only keep variables of interest
device_data <- select(device_data, MDR_REPORT_KEY, MANUFACTURER_D_NAME,DEVICE_REPORT_PRODUCT_CODE, 
                      COMBINATION_PRODUCT_FLAG, BRAND_NAME)
patient_data <- select(patient_data, MDR_REPORT_KEY, DATE_RECEIVED)
mdr_data <- select(mdr_data, MDR_REPORT_KEY, REPORT_SOURCE_CODE, DATE_RECEIVED, DATE_OF_EVENT, REPORTER_OCCUPATION_CODE, 
                   EVENT_TYPE, MANUFACTURER_NAME, REPORTER_COUNTRY_CODE, PMA_PMN_NUM)
patient_problem <- select(patient_problem, MDR_REPORT_KEY, PROBLEM_CODE)



#merge datasets using mdr report key and date_received variable
merge_data <- merge(mdr_data, patient_data, by = c("MDR_REPORT_KEY", "DATE_RECEIVED"))
merge_data <- merge(merge_data, device_data, by = c("MDR_REPORT_KEY"))
merge_data <- merge(merge_data, foi_dev_problem,  by = c("MDR_REPORT_KEY"))
merge_data <- merge(merge_data, patient_problem, by = c("MDR_REPORT_KEY"))


#drop MANUFACTURER_NAME
merge_data <- select(merge_data, -MANUFACTURER_NAME)

#match patient and device codes with their description 
p_prob_descrip <- rep(NA, length(merge_data$PROBLEM_CODE))
d_prob_descrip <- rep(NA, length(merge_data$DEVICE_PROBLEM_CODE))
p_code <- merge_data$PROBLEM_CODE
d_code <- merge_data$DEVICE_PROBLEM_CODE

for (i in 1:length(p_code)) {
  index_d <- which(device_prob_code$DEVICE_PROBLEM_CODE == d_code[i])
  d_prob_descrip[i] <- device_prob_code$PROBLEM_DESCRIPTION[index_d]
  
  index_p <- which(patient_prob_code$PATIENT_PROBLEM_CODE == p_code[i])
  p_prob_descrip[i] <- patient_prob_code$PROBLEM_DESCRIPTION[index_p]
}

#append descriptions to merge_data
merge_data$PATIENT_PROBLEM_DESCRIPTION <- p_prob_descrip
merge_data$DEVICE_PROBLEM_DESCRIPTION <- d_prob_descrip

write.csv(merge_data, paste(path, 'cleandata2016.csv', sep = ""), row.names = FALSE)




