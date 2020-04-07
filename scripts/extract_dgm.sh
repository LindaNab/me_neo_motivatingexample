#!/bin/bash
#$ -S /bin/bash
#$ -q all.q
#$ -hard
#$ -N extract_dgm
#$ -cwd
#$ -j Y
#$ -V
#$ -m bea
#$ -M E-MAIL_ADDRESS
#R CMD BATCH "--args $i $j" /home/USERNAME/TEST/single_run.R /exports/clinicalepi/FIRSTNAME/TEST/scenario${i}_${j}.Rout
R CMD BATCH /exports/clinicalepi/Linda/me_neo_motivatingexample/rcode/exe/extract_dgms_for_simstudy.R /exports/clinicalepi/Linda/me_neo_motivatingexample/scripts/output/extract_dgm.Rout
