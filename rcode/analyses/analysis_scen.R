#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating example
##
## Analysis strategies used
## lindanab4@gmail.com - 20200407
#############################################################

##############################
# 0 - Load librairies ----
##############################

##############################
# 1 - Analysis scenarios ----
##############################
analysis_scenarios <- function(){
  sampling_strat <- c("random", 
                      "uniform", 
                      "extremes")
  method <- c("complete_case",
              "naive",
              "reg_cal",
              "efficient_reg_cal",
              "inadm_reg_cal")
  analyse_scenarios <- expand.grid(sampling_strat,
                                   method)
  colnames(analyse_scenarios) <- c("sampling_strat",
                                   "method")
  return(analyse_scenarios)}