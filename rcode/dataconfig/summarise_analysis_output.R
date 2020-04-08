#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating Example
##
## Summarize output
## lindanab4@gmail.com - 20200408
#############################################################

##############################
# Some notes on the format of the *summarised* data from .data/output
##############################
# The content of the summary table include:
# sampling_strat   method
# random           complete_case
# uniform          complete_case
# extremes         complete_case
# ...
# extremes         inadm_reg_cal
# with the following columns (information):
# beta, var_beta, n_valdata

##############################
# 0 - Load librairies ----
##############################
library(data.table)
source(file = "./rcode/tools/file_handling.R")

##############################
# 1 - Evaluation params of sim study
##############################
# The simulation evaluation parameters not obtained from the rsimsum package 
# (but by user defined functions in fill_one_row_with_eval_param())
eval_param <- function(){
  eval_param <- c("beta",
                  "mod_var_beta",
                  "emp_var_beta",
                  "n_valdata", 
                  "effect_est",
                  "ci_lower",
                  "ci_upper")
  eval_param
}
##############################
# 2 - Helper functions to init, fill and save summary
##############################
# creates data.table that will be filled later on
init_summary <- function(use_analysis_scenarios){
  size <- NROW(use_analysis_scenarios)
  out_datatable <- data.table(use_analysis_scenarios)
  out_datatable[, (eval_param()) := numeric(size)]
  out_datatable[]
}
# fill the summary data.table for the used analysis_scenarios and 
# datagen_scenarios, of which the processed output can be found in processed_dir
fill_summary <- function(summary,
                         use_analysis_scenarios,
                         output_dir){
  for (j in 1:NROW(use_analysis_scenarios)) {
    fill_one_row_of_summary(
      summary,
      analysis_scenario = use_analysis_scenarios[j, ],
      output_dir
    )
  }
}
# Fills one row of the data.table summary of a specific analysis_scenario and
# datagen_scenario
fill_one_row_of_summary <- function(summary,
                                    analysis_scenario,
                                    output_dir){
  file <- seek_file(analysis_scenario,  
                    data_dir = output_dir)
  output <- readRDS(file = file)
  # process output 
  output <- as.data.frame(output)
  colnames(output) <- c("beta", "var_beta", "n_valdata", "seed")
  # get row_number of this sim_scen in summary
  row_num <- summary[analysis_scenario, 
                     on = colnames(analysis_scenario), 
                     which = TRUE]
  # Fill the row with the params in eval_param()
  fill_row_with_eval_param(row_num, summary, output)
  print(paste0(file, " summarized!"))
  summary[]
}
# A function for each of the params in eval_param() to fill the subsequent cell
fill_row_with_eval_param <- function(row_num, summary, output){
  summary[row_num, beta := mean(output$beta)]
  summary[row_num, mod_var_beta := mean(output$var_beta)]
  summary[row_num, emp_var_beta := var(output$beta)]
  summary[row_num, n_valdata := mean(output$n_valdata)]
  beta_lower <- mean(output$beta) - 
    qnorm(0.05 / 2, lower.tail = F) * sqrt(var(output$beta))
  beta_upper <- mean(output$beta) + 
    qnorm(0.05 / 2, lower.tail = F) * sqrt(var(output$beta)) 
  effect_est_par <- (exp(mean(output$beta)) - 1) * 100
  ci_lower_par <- (exp(beta_lower) - 1) * 100
  ci_upper_par <- (exp(beta_upper) - 1) * 100
  summary[row_num, effect_est := effect_est_par]
  summary[row_num, ci_lower := ci_lower_par]
  summary[row_num, ci_upper := ci_upper_par]
}
save_summary <- function(summary, summarised_dir){
  output_file <- paste0(summarised_dir, "/summary.Rds")
  saveRDS(summary, file = output_file)
}

##############################
# 3 - Work horse ----
##############################
summarise_analysis <- function(use_analysis_scenarios = analysis_scenarios(),
                               output_dir = "./results/output",
                               summarised_dir = "./results/summaries"){
  # summary will inculde all different analysis_scenarios times the different 
  # datagen_scenarios
  # init data.table for summary
  summary <- init_summary(use_analysis_scenarios)
  # fill summary
  fill_summary(summary,
               use_analysis_scenarios = use_analysis_scenarios,
               output_dir = output_dir)
  # save summary
  save_summary(summary, summarised_dir)
}