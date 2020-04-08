#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
##
## 2 - naive analysis
## lindanab4@gmail.com - 20200303
#############################################################
naive <- function(data){
  # using WC io VAT
  fit <- lm(
    formula = ln_homa1IR ~
      z_middelomtrek +
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
      z_vetpercentage,
    data = data
  )
  beta <- fit$coefficients
  vcov_beta <- vcov(fit)
  out <- list(beta = beta, vcov = vcov_beta)
}