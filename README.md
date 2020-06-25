# The me_neo_motivatingexample repository

## Version 0.1.0
This repository contains the code and simulation output of the motivating example accompanying the manuscript 'Internal validation data sampling strategies for exposure measurement error correction:  a study of visceral adipose tissue measurements replaced by waist circumference measurements' by Linda Nab et al.

## Usage
All end scripts can be found in ./rcode/exe. 
* The script ./rcode/exe/execute_initial_data_analysis.R estimates the association between visceral adipose tissue/waist circumference and insulin resistance in the Leiderdorp-VAT cohort. The results of this analysis are saved in ./results/summaries/summary_init_analysis.Rds.
* The script ./rcode/exe/execute_data_analysis.R runs the resampling study and creates 4 directories in ./results/output: method_complete_case; method_efficient_reg_cal; method_inadm_reg_cal; method_reg_cal. Subsequently, in all these directories, 3 .Rds files are saved: extremes.Rds; random.Rds; uniform.Rds. Then, these .Rds files are summarised and are saved in ./results/summaries/summary.Rds.
* The script ./rcode/exe/extract_dgms_for_simstudy.R extracts the data generating mechanisms from the NEO data, used as input for the simulation study (see www.github.com/LindaNab/me_neo).
* The script ./rcode/exe/cleanup_datadir.R can be used if you were to rerun the resampling study and like to remove the .Rds files and directories in ./results/output/

## Tables
To recreate Table 1 from the manuscript, run the code in ./rcode/tabular/create_tables.R. The script saves the text file 'table1.txt' in ./results/tables. 

## Figures
To recreate Figure 2 from the manuscript (the scatter histograms), run the code in ./rcode/visualisation/create_scatterhist.R. Subsequently, the script saves the 3 .png files in ./results/figures.

## Instructions
Download the repository by using:
```console
git clone https://github.com/LindaNab/me_neo_motivatingexample
```

This script is tested on:
platform       x86_64-apple-darwin17.0     
arch           x86_64                      
os             darwin17.0                  
system         x86_64, darwin17.0          
status                                     
major          4                           
minor          0.0                         
year           2020                        
month          04                          
day            24                          
svn rev        78286                       
language       R                           
version.string R version 4.0.0 (2020-04-24)
nickname       Arbor Day  

With attached packages:
attached base packages:
stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
taRifx_1.0.6.2    xtable_1.8-4      data.table_1.12.9