#!/bin/bash
#$ -S /bin/bash
#$ -q all.q
#$ -hard
#$ -N execute_data_analysis
#$ -cwd
#$ -j Y
#$ -V
#$ -m bea
#$ -M E-MAIL_ADDRESS
#R CMD BATCH "--args $i $j" /home/USERNAME/TEST/single_run.R /exports/clinicalepi/FIRSTNAME/TEST/scenario${i}_${j}.Rout
R CMD BATCH /exports/clinicalepi/Linda/me_neo_motivatingexample/rcode/exe/execute_data_analysis.R /exports/clinicalepi/Linda/me_neo_motivatingexample/scripts/output/execute_data_analysis.Rout
