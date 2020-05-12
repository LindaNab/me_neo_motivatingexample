#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction 
## Motivating example
##
## Perform original data analysis on the Leiderdorp-VAT subcohort
## lindanab4@gmail.com - 20200407
#############################################################

##############################
# 0 - Load librairies
##############################
library(data.table)

############################## 
# 1 - Prepare data for analysis
##############################
data_path <- "./data/processed" 
data <- readRDS(file = paste0(data_path, "/ldrp.Rds"))
# use data for analysis

############################## 
# 2 - Characteristics of the data that is used for this analysis
#     (the numbers after // indicate the values in the original paper 
#     (= analysis in whole NEO cohort))
##############################
# EXPOSURE: MVAT // mean 89 and sd 55
mean(data$MVAT)
sd(data$MVAT)
# EXPOSURE: Waist Circumference // mean 91 and sd 13
mean(data$middelomtrek)
sd(data$middelomtrek)
# OUTCOME: HOMA-IR // median 1.85 (25th, 75th percentiles) 1.19, 2.82 
quantile(data$homa1IR, quantiles = c(0.25, 0.5, 0,75))
# CONFOUNDER: AGE // mean 56 and sd 6
mean(data$leeftijd)
sd(data$leeftijd)
# CONFOUNDER: SEX // 1190 men and 1063 women
sum(apply(cbind(data$sexe == "man"), 1, prod))
sum(apply(cbind(data$sexe == "vrouw"), 1, prod))
# CONFOUNDER: ETHNICITY // 96 % white
prop.table(table(data$etnwhite))
# CONFOUNDER: EDUCATION // 47 % high
prop.table(table(data$eduh))
# CONFOUNDER: TOBACCO SMOKING // 14 % current, 45 % former
prop.table(table(data$smoking))
# CONFOUNDER: ALCOHOL CONSUMPTION // mean 14.7 and sd 15.9
mean(data$alc_g)
sd(data$alc_g)
# CONFOUNDER: PHYSICAL ACTIVITY // mean 38.3 and sd 33.3
mean(data$leismeth)
sd(data$leismeth)
# CONFOUNDER: MENOPAUSAL STATE // 19 %
data_f <- subset(data, sexe == "vrouw")
prop.table(table(data_f$menopause3))
# CONFOUNDER: USE OF ESTROGENS // 12 % (hrt hormone replacement therapy, 
# contraceptives)
prop.table(table(data_f$hormone3))
# CONFOUNDER: TOTAL BODYFAT // mean 31 sd 8
mean(data$vetpercentage)
sd(data$vetpercentage)

############################## 
# 3 - Linear regressions
#     (the numbers after // indicate the values in the original paper 
#     (= analysis in whole NEO cohort))
##############################
# UNADJUSTED MODEL ln_homa1IR ON wzmiddelomtrek // 45(39-51) 
crude_wc_lm <- lm(formula = ln_homa1IR ~ z_middelomtrek, data = data)
(exp(coef(crude_wc_lm)[2]) - 1) * 100
se_crude_wc <- summary(crude_wc_lm)$coef[2,2]
crude_wc_lower <- coef(crude_wc_lm)[2] - qt(0.05 / 2, 2251, lower.tail = F) * 
  se_crude_wc
(exp(crude_wc_lower) - 1) * 100 
crude_wc_upper <- coef(crude_wc_lm)[2] + qt(0.05 / 2, 2251, lower.tail = F) * 
  se_crude_wc
(exp(crude_wc_upper) - 1) * 100 
# UNADJUSTED MODEL ln_homa1IR on wzMVAT // 46(41-52)
crude_vat_lm <- glm(formula = ln_homa1IR ~ z_MVAT, data = data)
(exp(coef(crude_vat_lm)[2]) - 1) * 100
se_cude_vat <- summary(crude_vat_lm)$coef[2,2]
crude_vat_lower <- coef(crude_vat_lm)[2] - qt(0.05 / 2, 2251, lower.tail = F) * 
  se_cude_vat
(exp(crude_vat_lower) - 1) * 100 
crude_vat_upper <- coef(crude_vat_lm)[2] + qt(0.05 / 2, 2251, lower.tail = F) * 
  se_cude_vat
(exp(crude_vat_upper) - 1) * 100 
# REGRESSING ln_homa1IR ON z_middelomtrek, ADJUSTING FOR leeftijd, sexe, 
# etnwhite, eduh, smoking, alc_g, leismeth, z_vetpercentage and in women 
# additionally for menopausal state and use of estrogens
wc_lm <- lm(formula = ln_homa1IR ~ z_middelomtrek + 
                                   leeftijd + 
                                   sexe +
                                   etnwhite + 
                                   eduh +
                                   cursmk +
                                   formsmk +
                                   alc_g + 
                                   leismeth + 
                                   sexhormone +
                                   perimenopausal +
                                   premenopausal +
                                   z_vetpercentage, data = data)
summary(wc_lm)
(exp(coef(wc_lm)[2]) - 1) * 100
se_wc <- summary(wc_lm)$coef[2,2]
wc_lower <- coef(wc_lm)[2] - qnorm(0.05 / 2, lower.tail = F) * se_wc
(exp(wc_lower) - 1) * 100 
wc_upper <- coef(wc_lm)[2] + qnorm(0.05 / 2, lower.tail = F) * se_wc
(exp(wc_upper) - 1) * 100 

## REGRESSING ln_homa1IR ON z_MVAT, ADJUSTING FOR leeftijd, sexe, etnwhite, eduh 
## smoking, alc_g, leismeth, vetpercentage and in women additionally for 
## menopausal state and use of estrogens
vat_lm <- lm(formula = ln_homa1IR ~ z_MVAT + 
                                    leeftijd + 
                                    sexe +
                                    etnwhite + 
                                    eduh +
                                    cursmk +
                                    formsmk +
                                    alc_g + 
                                    leismeth + 
                                    sexhormone +
                                    perimenopausal +
                                    premenopausal +
                                    z_vetpercentage, data = data)
summary(vat_lm)
(exp(coef(vat_lm)[2]) - 1) * 100
se_vat <- summary(vat_lm)$coef[2,2]
vat_lower <- coef(vat_lm)[2] - qnorm(0.05 / 2, lower.tail = F) * se_vat
(exp(vat_lower) - 1) * 100 
vat_upper <- coef(vat_lm)[2] + qnorm(0.05 / 2, lower.tail = F) * se_vat
(exp(vat_upper) - 1) * 100 

## Is there perhaps a relation between ln_homa1IR and z_middelomtrek, given
## all other covariates?
vat_lm <- lm(formula = ln_homa1IR ~ z_MVAT + 
               leeftijd + 
               sexe +
               etnwhite + 
               eduh +
               cursmk +
               formsmk +
               alc_g + 
               leismeth + 
               sexhormone +
               perimenopausal +
               premenopausal +
               z_vetpercentage +
               z_middelomtrek, data = data)

## Create summary of results
# init summary object
summary <- data.table(method = c("reference", "naive"),
                      beta = numeric(2),
                      var_beta = numeric(2),
                      effect_est = numeric(2),
                      ci_lower = numeric(2),
                      ci_upper = numeric(2))
# fill summary object for reference analysis (1st row)
summary[1, beta := coef(vat_lm)[2]]
summary[1, var_beta := se_vat^2]
summary[1, effect_est :=  (exp(coef(vat_lm)[2]) - 1) * 100]
summary[1, ci_lower := (exp(vat_lower) - 1) * 100 ]
summary[1, ci_upper := (exp(vat_upper) - 1) * 100 ]
# fill summary object for naive analysis (2nd row)
summary[2, beta := coef(wc_lm)[2]]
summary[2, var_beta := se_wc^2]
summary[2, effect_est :=  (exp(coef(wc_lm)[2]) - 1) * 100]
summary[2, ci_lower := (exp(wc_lower) - 1) * 100 ]
summary[2, ci_upper := (exp(wc_upper) - 1) * 100 ]
# save summary in RDS file in ./results/summaries
saveRDS(summary, "./results/summaries/summary_init_analysis.Rds")
