#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating example
##
## Run analysis
## lindanab4@gmail.com - 20200408
#############################################################

##############################
# Some notes on where the results of the analysis will be saved
##############################
# The output of each run (beta, var_beta, seed) will be saved as 
# follows: for each method (cc, eff_reg_cal, inadm_reg_cal, naive, reg_cal) a 
# directory is created in ./data/output. This results in 5 different 
# output folders. In each folder, 3 RDS files will be saved: the 3 sampling 
# strategies. In total there will be 5 directories, each including 3 files. The 
# .Rds files within those directories contain 500 rows.
# The structure is displayed here:
# ./data/output
# ├── method_complete_case
# │ └── random.Rds, uniform.Rds, extremes.Rds
# ├── method_naive
# │ └── random.Rds, uniform.Rds, extremes.Rds
# ...
# └── method_inadm_reg_cal 
#   └── random.Rds, uniform.Rds, extremes.Rds

##############################
# 0 - Load librairies + source code 
##############################
source(file = "./rcode/analyses/analysis_scen.R")
source(file = "./rcode/analyses/analyse_data.R")
source(file = "./rcode/analyses/sample_data.R")
source(file = "./rcode/tools/create_data_dirs.R")
source(file = "./rcode/tools/file_handling.R")

############################## 
# 1 - Helper Functions ----
##############################
# save the output in dir_name/file_name
save_result <- function(result){
  beta <- as.numeric(result['beta'])
  var_beta <- as.numeric(result['var_beta'])
  n_valdata <- as.numeric(result['n_valdata'])
  seed <- as.numeric(result['seed'])
  dir_name <- result[['dir_name']]
  file_name <- result[['file_name']]
  file <- paste0(dir_name, "/", file_name) 
  # append new result to old results if file exists
  if (file.exists(file)){
    con <- file(file)
    while (isOpen(con)){
      Sys.sleep(2)
    }
    open(con)
    results_in_file <- readRDS(file)
    new_results <- rbind(results_in_file, 
                         c(beta, var_beta, n_valdata, seed))
    rownames(new_results) <- NULL
    saveRDS(new_results, file = file)
    close(con)
  } else{ #create new file
    saveRDS(c(beta, var_beta, n_valdata, seed), file = file)}
  message <- paste0(file, " saved!")
  print(message)
}

##############################
# 2 - Seed ---
##############################

get_seeds <- function(rep){
  set.seed(20200408)
  n_seed <- rep 
  seed <- sample(1:1e8, 
                 size = n_seed, 
                 replace = FALSE)
}

############################## 
# 3 - Analysis in steps
##############################
# Perform one run, i.e.: for one resampled data set, perform the 5x3 different 
# analyses (see analysis_scenarios())
perform_one_run <- function(data, 
                            seed,
                            use_analysis_scenarios,
                            output_dir){
  # generate data
  new_data <- sample_data(data, seed)
  # analyse the data using use_analysis_scenarios
  results <- apply(use_analysis_scenarios, 
                   1, 
                   FUN = analyse_data, 
                   data = new_data,
                   seed = seed)
  results <- as.data.frame(t(rbind(results, 
                                   seed,
                                   apply(use_analysis_scenarios, 
                                         1, 
                                         FUN = get_dir_name,
                                         data_dir = output_dir),
                                   apply(use_analysis_scenarios, 
                                         1, 
                                         FUN = get_file_name)
  )))
  colnames(results) <- c("beta", 
                         "var_beta",
                         "n_valdata",
                         "seed", 
                         "dir_name", # directory were results will be saved
                         "file_name") # name of the .Rds file
  apply(results, 1, save_result)
}
# Workhorse of the simulation study. For each of the datagen_scenarios(), rep 
# data sets will be generated, and analysed using analysis_scenarios(). The 
# default will generate 20 * 150 files each including 5000 rows. 
run_analysis <- function(rep = 500,
                         data,
                         use_analysis_scenarios = analysis_scenarios(),
                         seeds = get_seeds(rep),
                         output_dir = "./results/output") {
  # levels of data_dirs (see the described structure above)
  levels <- list(
    "method" = 
      unique(use_analysis_scenarios[['method']])
  )
  create_data_dirs(levels = levels)
  for(i in 1:rep){
    perform_one_run(data = data,
                    seed = seeds[i],
                    use_analysis_scenarios = use_analysis_scenarios,
                    output_dir = output_dir)
    print(i)
  }
}
