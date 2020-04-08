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
# 2 - Process simulation output 
##############################
# not run
# process_sim_output()
process_sim_output(use_datagen_scenarios = use_datagen_scenarios,
                   use_analysis_scenarios = use_analysis_scenarios)

##############################
# 3 - Summarize processed simulation output 
##############################
# not run
# summarize_sim()
summarize_sim(use_datagen_scenarios = use_datagen_scenarios,
              use_analysis_scenarios = use_analysis_scenarios)