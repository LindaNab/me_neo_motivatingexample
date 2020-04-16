#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction 
##
## Data generating mechanisms for simulation study
## lindanab4@gmail.com - 20200407
#############################################################

##############################
# 0 - Load librairies
##############################

############################## 
# 1 - Prepare data for analysis
##############################
data_path <- "./data/processed" 
data <- readRDS(file = paste0(data_path, "/ldrp_fake.Rds"))

############################## 
# 2 - Generating mechanisms
##############################
# Distribution of sex
prop.table(table(data$sexe)) # sexe ~ binom(1, 0.53)

# Distribution of age
mean(data$leeftijd) # leeftijd ~ uniform(min = 45, max = 66)
quantile(data$leeftijd)
png(file = "./scripts/output/histogram_age.png",
    width = 600, height = 350)
hist(data$leeftijd)
dev.off()

# Distribution of TBF_z|leeftijd, sexe (TBF = vetpercentage)
tbf_lm <- lm(z_vetpercentage ~ sexe + leeftijd, 
             data = data)
summary(tbf_lm)
summary(tbf_lm)$sigma^2

# Distribution of VAT_z|sexe, leeftijd, TBF_z
vat_lm <- lm(z_MVAT ~ sexe + leeftijd + z_vetpercentage,
	     data = data)
summary(vat_lm)
summary(vat_lm)$sigma^2
# Gamma regression to obtain shape of MVAT|sexe, leeftijd, TBF_z
vat_gamma <- glm(MVAT ~ sexe + leeftijd + z_vetpercentage, 
                 family = Gamma(link = "log"),
                 data = data)
MASS::gamma.shape(vat_gamma)$alpha #6 
png(file = "./scripts/output/residuals_vat_lm.png",
    width = 600, height = 350)
plot(density(vat_lm$residuals))
dev.off()

# Distribution of WC_z|VAT_z 
wc_lm <- lm(z_middelomtrek ~ z_MVAT, 
            data = data)
summary(wc_lm)
summary(wc_lm)$sigma^2
png(file = './scripts/output/wc_vat.png',
    with = 600, height = 350)
plot(data$z_MVAT, data$z_middelomtrek)
dev.off()

# Distribution of ln_IR|VAT_z, sexe, leeftijd, TBF_z
ir_lm <- lm(ln_homa1IR ~ z_MVAT + sexe + leeftijd + z_vetpercentage, 
            data = data)
summary(ir_lm)
summary(ir_lm)$sigma^2