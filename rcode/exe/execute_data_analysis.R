#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating Example
##
## Executive script to run the analysis
## lindanab4@gmail.com - 20200408
#############################################################

##############################
# 0 - Load librairies + source code 
##############################
source(file = "./rcode/analyses/run_analysis.R")
source(file = "./rcode/dataconfig/summarise_analysis_output.R")
data <- readRDS(file = "./data/processed/ldrp_fake.Rds")

# Select datagen_scenarios and analysis_scenarios to be used
use_analysis_scenarios <- analysis_scenarios()

##############################
# 1 - Run analysis
##############################
run_analysis(rep = 5,
             data = data,
             use_analysis_scenarios = use_analysis_scenarios)

##############################
# 2 - Summarise output files
##############################
summarise_analysis(use_analysis_scenarios = use_analysis_scenarios)
