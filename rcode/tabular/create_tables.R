#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating Example
##
## Tabularise summaries
## lindanab4@gmail.com - 20200303
#############################################################

##############################
# 0 - Load librairies + source code 
##############################
library(xtable)
library(taRifx)
source(file = "./rcode/analyses/analysis_scen.R")
sum_analysis <- 
  readRDS(file = "./results/summaries/summary.Rds")
sum_init_analysis <-
  readRDS(file = "./results/summaries/summary_init_analysis.Rds")

##############################
# 1 - Helper functions 
##############################
# Function that creates a string of effect_est% (ci_lower%-ci_upper%)
effect_est_and_ci <- function(row_of_summary){
  effect_est <- round(as.numeric(row_of_summary[["effect_est"]]), 0)
  ci_lower <- round(as.numeric(row_of_summary[["ci_lower"]]), 0)
  ci_upper <- round(as.numeric(row_of_summary[["ci_upper"]]), 0)
  paste0(effect_est, "%", " (", ci_lower, "%-", ci_upper, "%)")
}

##############################
# 2 - Create table 1
##############################
# Select values needed from summary object
table1 <-
  sum_init_analysis[, c("method",
                        "effect_est",
                        "ci_lower",
                        "ci_upper")]
# Format estimates from analysis
table1 <- cbind(table1[, c("method")],
                c("", ""),
                apply(table1,
                      1,
                      FUN = effect_est_and_ci),
                c("", ""))
table1 <- as.data.frame(table1, stringsAsFactors = F)
# Change columnames 
colnames(table1) <- c("Method","", "Effect size (CI)", "")
table1$Method <- c("Reference",
                   "Naive")

##############################
# 3 - Create table 2
##############################
# Select values needed from summary object
table2 <-
  sum_analysis[, c("method",
                   "sampling_strat",
                   "effect_est",
                   "ci_lower",
                   "ci_upper")]
# Format estimates from analysis
table2 <- cbind(table2[, c("method", "sampling_strat")],
                apply(table2,
                      1,
                      FUN = effect_est_and_ci))
# Format table2 to long format
table2 <- reshape(table2,
                  idvar = "method",
                  timevar = "sampling_strat",
                  direction = "wide")
table2 <- unfactor.data.frame(table2)
# Change columnames 
colnames(table2) <- c("Method","", "Effect size (CI)", "")
table2 <- rbind(c("", "Random", "Uniform", "Extremes"), 
                table2)
# Change rownames
table2$Method <- c("", 
                   "Complete case", 
                   "Regression calibration", 
                   "Efficient regression calibration",
                   "Inadmissible regression calibration")

# Create TeX table combining table1 and table2
caption <- "Estimated association between visceral adipose tissue (VAT) and insulin resistance using different methods to deal with the induced measurement error if VAT measures are replaced by WC measures"
table <- rbind(table1, table2)
table_xtable <- print(xtable(table,
                             caption = caption), 
                      include.rownames = FALSE)
file_con <- file("./results/tables/table1.txt")
writeLines(table_xtable, file_con)
close(file_con)
