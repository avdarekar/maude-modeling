# maude-modeling

## Description
As a part of our statistical learning course, my team and I trained and tested a random forest model in combination with latent semantic analysis to predict the type of adverse event that occurs due to a medical device error using MAUDE (Manufacturer and User Facility Device Experience) data. We achieved a 2.51% misclassification error.

Note: This repo only contains my contributions towards this project.

## File Descriptions
- FinalReport.pdf: report that contains our methodology and findings

### data
#### processed_data 
- cleandata.csv: cleaned dataset containing data from 2016-2019
- cleandata2016.csv: cleaned dataset containing data from 2016
- cleandata2017.csv: cleaned dataset containing data from 2017
- cleandata2018.csv: cleaned dataset containing data from 2018
- cleandata2019.csv: cleaned dataset containing data from 2019
- cleaned-maude-2016-2019.csv: cleaned dataset used for modeling

#### raw_data 
These are all raw datasets that came from the [FDA MAUDE database](https://www.fda.gov/medical-devices/mandatory-reporting-requirements-manufacturers-importers-and-device-user-facilities/about-manufacturer-and-user-facility-device-experience-maude). 

### scripts 
- data_cleaning_2016_Ayesha.R: data cleaning for MAUDE records in 2016 
- clean_data_Ayesha.R: merged MAUDE dataset containing records for 2016-2019
- random_forest_LSA.R: random forest modeling using cleaned dataset and latent semantic analysis results 

## Obtaining Data 
The data was obtained from the [FDA MAUDE database](https://www.fda.gov/medical-devices/mandatory-reporting-requirements-manufacturers-importers-and-device-user-facilities/about-manufacturer-and-user-facility-device-experience-maude).  
