# The me_neo_motivatingexample repository

## Version 0.1.0
This repository contains the code and simulation output of the motivating example accompanying the manuscript 'Internal validation data sampling strategies for exposure measurement error correction:  a study of visceral adipose tissue measurements replaced by waist circumference measurements' by Linda Nab et al.

## Usage
The raw data is saved in the directory [./data/raw](./data/raw). The raw data is processed and saved in [./data/processed](./data/processed). The data is processed using the script [./rcode/dataconfig/process_data.R](./rcode/dataconfig/process_data.R). These data sets are not available on the public repository, but instead, a fake processed data set is created and can be found in: [./data/processed/ldrp_fake.Rds](./data/processed/ldrp_fake.Rds).


All end scripts can be found in [./rcode/exe](./rcode/exe).
* The script [./rcode/exe/execute_initial_data_analysis.R](./rcode/exe/execute_initial_data_analysis.R) estimates the association between visceral adipose tissue/waist circumference and insulin resistance in the Leiderdorp-VAT cohort. The results of this analysis are saved in [./results/summaries/summary_init_analysis.Rds](./results/summaries/summary_init_analysis.Rds).
* The script [./rcode/exe/execute_data_analysis.R](./rcode/exe/execute_data_analysis.R) runs the resampling study and creates 4 directories in [./results/output](./results/output): method_complete_case; method_efficient_reg_cal; method_inadm_reg_cal; method_reg_cal. Subsequently, in all these directories, 3 .Rds files are saved: extremes.Rds; random.Rds; uniform.Rds. Then, these .Rds files are summarised and are saved in [./results/summaries/summary.Rds](./results/summaries/summary.Rds).
* The script [./rcode/exe/extract_dgms_for_simstudy.R](./rcode/exe/extract_dgms_for_simstudy.R) extracts the data generating mechanisms from the NEO data, used as input for the simulation study (see www.github.com/LindaNab/me_neo).
* The script [./rcode/exe/cleanup_datadir.R](./rcode/exe/cleanup_datadir.R) can be used if you were to rerun the resampling study and like to remove the .Rds files and directories in [./results/output](./results/output).

## Tables
To recreate Table 1 from the manuscript, run the code in [./rcode/tabular/create_tables.R](./rcode/tabular/create_tables.R). The script saves a LaTeX compatible table in [./results/tables/table1.txt](./results/tables/table1.txt). 

## Figures
To recreate Figure 2 from the manuscript (the scatter histograms), run the code in [./rcode/visualisation/create_scatterhist.R](./rcode/visualisation/create_scatterhist.R). Subsequently, the script saves 3 .png files in [./results/figures](./results/figures).

## Instructions
Download the repository by using:
```console
git clone https://github.com/LindaNab/me_neo_motivatingexample
```

This script is tested on:
platform: x86_64-apple-darwin17.0, version: R version 4.0.0 (2020-04-24)

With attached packages:
taRifx_1.0.6.2, xtable_1.8-4, data.table_1.12.9