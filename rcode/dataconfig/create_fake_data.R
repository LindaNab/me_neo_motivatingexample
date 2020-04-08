#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating example
##
## Create fake data
## lindanab4@gmail.com - 20200408
#############################################################

##############################
# 0 - Load librairies
##############################
library(fakeR)
# needs the processed file "ldrp.Rds" in ./data/processed/

############################## 
# 1 - Create fake dataset
##############################
data <- readRDS(file = "./data/processed/ldrp.Rds")
fake_data <- simulate_dataset(data)
saveRDS(fake_data, file = file = "./data/processed/ldrp_fake.Rds")