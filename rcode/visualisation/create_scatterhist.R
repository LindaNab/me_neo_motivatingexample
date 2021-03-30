#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction 
## Motivating example
##
## Create scatterhistograms to illustrate sampling strategies
## lindanab4@gmail.com - 20200508
#############################################################

##############################
# 0 - Load librairies
##############################
library(data.table)
source("./rcode/analyses/sample_valdata.R") # needed for bins uniform sampling
source("./rcode/visualisation/scatterhistogram.R") # code of scatterhistogram

############################## 
# 1 - Prepare data for visualisation
##############################
data_path <- "./data/processed" 
data <- readRDS(file = paste0(data_path, "/ldrp.Rds"))
# use data for analysis

data_random <- select_valdata(
  data = data,
  use_variable = NA,
  size_valdata = 0.4,
  sampling_strat = "random",
  seed = 20200508
)
data_uniform <- select_valdata(
  data = data,
  use_variable = "z_middelomtrek",
  size_valdata = 0.4,
  sampling_strat = "uniform",
  seed = 20200508
)
data_extremes <- select_valdata(
  data = data,
  use_variable = "z_middelomtrek",
  size_valdata = 0.4,
  sampling_strat = "extremes",
  seed = 20200508
)