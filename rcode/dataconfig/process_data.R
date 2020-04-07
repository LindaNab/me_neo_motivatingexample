#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating example
##
## 0 - Load and clean NEO Leiderdorp data for analysis
## lindanab4@gmail.com - 20200407
#############################################################

##############################
# 0 - Load librairies
##############################
require(foreign)
require(dplyr)
require(mice)

############################## 
# 1 - Load data 
##############################
data_path <- "./data/raw" 
data_file <- "/NEO_analyse_PP140_samplingstrategies_Nab_2018-06-29.dta" 
org_data <- read.dta(paste0(data_path, data_file))

############################## 
# 2 - Select the subset within the NEO data that will be used for analysis 
#     and do some data cleaning 
##############################
# Select all individuals from the leiderdorp cohort
ldrp_data <- subset(org_data, as.integer(org_data$neolight) == 1) 
# nrow(ldrp_data) #1670
# Select all individuals of whom a VAT measure is taken
ldrp_vat_data <- subset(ldrp_data, as.integer(ldrp_data$Vetpresent) == 2)
# nrow(ldrp_vat_data) #668
# Exclude all individuals who use glucose lowering therapy
ldrp_vat_data <- subset(ldrp_vat_data, 
                       as.integer(ldrp_vat_data$medA10gluclow) == 1)
# nrow(ldrp_vat_data) #649
# Exclude all individuals who had a hypo during their first glucose measurement
ldrp_vat_data <- subset(ldrp_vat_data, is.na(ldrp_vat_data$glucose1) | 
                          ldrp_vat_data$glucose1 >= 3.6)
# nrow(ldrp_vat_data) #648
# Make a new variable that is 'male' if an indivduals sex is male and equals 
# menopause2 in any other case
ldrp_vat_data$menopause3 <- ifelse(ldrp_vat_data$sexe == "man", 4, 
                                  ldrp_vat_data$menopause2)
ldrp_vat_data$menopause3 <- factor(ldrp_vat_data$menopause3, 
                                  labels = 
                                    c(levels(ldrp_vat_data$menopause2), "male"))
# Make the one male that missing hormone2, "no, male" (level 4)
ldrp_vat_data$hormone3 <- ifelse(ldrp_vat_data$sexe == "man", 4, 
                                ldrp_vat_data$hormone2)
# Omit level 5 since no individuals belong to that level
ldrp_vat_data$hormone3 <- factor(ldrp_vat_data$hormone3, 
                                labels = levels(ldrp_vat_data$hormone2)[-5])

############################## 
# 3 - Initial checks 
##############################
# Is the BMI distribution of the Leiderdorp cohort comparible with the bmi 
# distribution of the Leiderdorp-VAT cohort?
# mean(ldrp_data$bmim) ; mean(ldrp_vat_data$bmim)
# sd(ldrp_data$bmim) ; sd(ldrp_vat_data$bmim)
# density
# plot(density(ldrp_data$bmim), col = 'red', ylim = c(0, 0.12), lty = 2) + 
#   lines(density(ldrp_vat_data$bmim), col = 'blue')
# cumulative distribution
# plot(ecdf(ldrp_data$bmim), col = 'red') + 
#   lines(ecdf(ldrp_vat_data$bmim), col = 'blue')
# Are there any missing values in the Leiderdorp-Vat cohort?
# sum(
#   sum(is.na(ldrp_vat_data$homa1IR)),       #5
#   sum(is.na(ldrp_vat_data$MVAT)),          #0
#   sum(is.na(ldrp_vat_data$middelomtrek)),  #0
#   sum(is.na(ldrp_vat_data$leeftijd)),      #0
#   sum(is.na(ldrp_vat_data$sexe)),          #0
#   sum(is.na(ldrp_vat_data$etnwhite)),      #1
#   sum(is.na(ldrp_vat_data$eduh)),          #3
#   sum(is.na(ldrp_vat_data$smoking)),       #1
#   sum(is.na(ldrp_vat_data$alc_g)),         #0
#   sum(is.na(ldrp_vat_data$leismeth)),     #11
#   sum(is.na(ldrp_vat_data$hormone3)),      #0   
#   sum(is.na(ldrp_vat_data$menopause3)),    #0
#   sum(is.na(ldrp_vat_data$vetpercentage)) #1
# )

############################## 
# 4 - Impute missing data 
##############################
# Narrow the data down so that it only contains the columns needed for analysis
ldrp_vat_data <- subset(ldrp_vat_data, select = c(homa1IR, MVAT, leeftijd, sexe,
                                                eduh, smoking, alc_g, leismeth, 
                                                hormone3, menopause3, 
                                                vetpercentage, etnwhite, 
                                                middelomtrek))
# ldrp_mvat$sexe <- factor(as.integer(ldrp_mvat$sexe)) 
# 1 = "man", 2 = "vrouw"
# ldrp_mvat$etnwhite <- factor(as.integer(ldrp_mvat$etnwhite)) 
# 1 = "other", 2 = "white"
# ldrp_mvat$eduh <- factor(as.integer(ldrp_mvat$eduh)) 
# 1 = "other", 2 = "high"
# ldrp_mvat$smoking <- factor(as.integer(ldrp_mvat$smoking)) 
# 1 = "never smk", 2 = "former smk", 3 = "current smk"
# ldrp_mvat$hormone2 <- factor(as.integer(ldrp_mvat$hormone2)) 
# 1 = "yes, now", 2 = "yes, in the past", 3 = "no, never", 
# 4 = "no, male", 5 = "no information on HRT and therefore missing"
# ldrp_mvat$menopause3 <- factor(as.integer(ldrp_mvat$menopause3)) 
# 1 = "postmenopausal", 2 = "premenopausal", 3 = "perimenopausal", 4 = "male"
# Impute missing values #
row.names(ldrp_vat_data) <- NULL
# Mice will produce an error if hormone3 and menopause3 are included in the
# data imputation, therefore a subset is created.
ldrpVatSub_data <- subset(ldrp_vat_data, select = c(homa1IR, MVAT, leeftijd, 
                                                   sexe, eduh, smoking, alc_g, 
                                                   leismeth, vetpercentage, 
                                                   etnwhite, middelomtrek))
set.seed(12092018)
imp <- mice(data = ldrpVatSub_data, m = 1, maxit = 5)
# imp$imp$homa1IR ; imp$imp$ethnwhite ; imp$imp$eduh ; 
# imp$imp$smoking ; imp$imp$leismeth ; imp$imp$vetpercentage
# Create new data set containing the imputed values
ldrp_vat_imp_data <- cbind(complete(imp), hormone3 = ldrp_vat_data$hormone3, 
                         menopause3 = ldrp_vat_data$menopause3)
# Create a data set with all complete cases for complete case analyses
ldrp_vat_data$filter <- ifelse(!is.na(ldrp_vat_data$homa1IR) & 
                                !is.na(ldrp_vat_data$etnwhite) &
                                !is.na(ldrp_vat_data$eduh) & 
                                !is.na(ldrp_vat_data$smoking) &
                                !is.na(ldrp_vat_data$leismeth) & 
                                !is.na(ldrp_vat_data$vetpercentage), 
                              1, 0)
ldrp_vat_cmplt_data <- subset(ldrp_vat_data, ldrp_vat_data$filter == 1)
# nrow(ldrp_vat_cmplt_data) #628
# fit <- with(ldrp_vat_cmplt_data, lm(middelomtrek ~ MVAT))
# plot(ldrp_vat_cmplt_data$MVAT, ldrp_vat_cmplt_data$middelomtrek)
# abline(a = fit$coef[1], b = fit$coef[2])

############################## 
# 5 - Divide the categorical variables smoking, menopause and hormonal use
#     into two categories + transform and standardize some vars
##############################
# Select data that will be used for the analysis
anal_data <- ldrp_vat_imp_data
# anal_data <- ldrp_vat_cmplt_data
# Dummy for smoking
# levels(anal_data$smoking)
anal_data$cursmk <- ifelse(anal_data$smoking == "current smk", 1, 0)
anal_data$formsmk <- ifelse(anal_data$smoking == "former smk", 1, 0)
anal_data$cursmk <- factor(anal_data$cursmk, labels = c("no", "yes"))
anal_data$formsmk <- factor(anal_data$formsmk, labels = c("no", "yes"))
# table(anal_data$smoking)
# table(anal_data$cursmk)
# table(anal_data$formsmk)
# Dummy for menopause
# levels(anal_data$menopause3)
anal_data$perimenopausal <- ifelse(anal_data$menopause3 == "perimenopausal", 
                                   1, 0)
anal_data$premenopausal <- ifelse(anal_data$menopause3 == "premenopausal", 
                                  1, 0)
anal_data$perimenopausal <- factor(anal_data$perimenopausal, 
                                   labels = c("no", "yes"))
anal_data$premenopausal <- factor(anal_data$premenopausal, 
                                  labels = c("no", "yes"))
# table(anal_data$menopause3)
# table(anal_data$perimenopausal)
# table(anal_data$premenopausal)
# Dummy for hormonal use 
# levels(anal_data$hormone3)
anal_data$sexhormone <- ifelse(anal_data$hormone3 == "yes, now", 1, 0)
anal_data$sexhormone <- factor(anal_data$sexhormone, labels = c("no", "yes"))
# table(anal_data$hormone3)
# table(anal_data$sexhormone)
# Transform IR
# hist(ldrp$homa1IR, breaks = 100)
anal_data$ln_homa1IR <- log(anal_data$homa1IR) #ln transformation
# hist(ldrp$ln_homa1IR, breaks = 100)
# Standardize VAT
# hist(anal_data$MVAT, breaks = 50)
mean_vat <- mean(anal_data$MVAT)
sd_vat <- sd(anal_data$MVAT)
anal_data$z_MVAT <- (anal_data$MVAT - mean_vat) / sd_vat
# mean(anal_data$z_MVAT)
# sd(anal_data$z_MVAT)
# Standardize WC
# hist(ldrp$middelomtrek, breaks  = 50)
mean_wc <- mean(anal_data$middelomtrek, na.rm = T)
sd_wc <- sd(anal_data$middelomtrek, na.rm = T)
anal_data$z_middelomtrek <- (anal_data$middelomtrek - mean_wc) / sd_wc
# Standardize TBF
# hist(anal_data$vetpercentage, breaks = 50)
mean_tbf <- mean(anal_data$vetpercentage)
sd_tbf <- sd(anal_data$vetpercentage)
anal_data$z_vetpercentage <- (anal_data$vetpercentage - mean_tbf) / sd_tbf
# mean(anal_data$z_vetpercentage)
# sd(anal_data$z_vetpercentage)

# Save the cleaned data set
saveRDS(anal_data, file = "./data/processed/ldrp.Rds")