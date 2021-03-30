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
data <- readRDS(file = paste0(data_path, "/ldrp_fake.Rds"))
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
# make bins for uniform plot
# total number of subjects in data
n <- NROW(data)
# desired  number of subjects in valdata
n_valdata <- ceiling(n * 0.4)
n_bins <- 10
n_each_bin <- round(n_valdata / n_bins) # possibly less people included in
# validation sample due to rounding
bins <-
  create_bins(n_bins, 
              n_each_bin, 
              data, 
              use_variable = "z_middelomtrek", 
              n_valdata)

##############################
# 2 - Create and save scatterhistograms
##############################
png(paste0("./results/figures", "/scatterhist_random.png"),
    width = 6, height = 4, units = 'in', res = 250)
pdf(file = "new.pdf",
    family = "Arial",
    pointsize = 10)
create_scatterhist(data_random, bins = bins)
dev.off()
png(paste0("./results/figures", "/scatterhist_uniform.png"),
    width = 6, height = 4, units = 'in', res = 250)
create_scatterhist(data_uniform, uniform = T, bins = bins)
dev.off()
png(paste0("./results/figures", "/scatterhist_extremes.png"),
    width = 6, height = 4, units = 'in', res = 250)
create_scatterhist(data_extremes, bins = bins)
dev.off()