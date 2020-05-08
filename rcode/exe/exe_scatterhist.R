#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction 
## Motivating example
##
## Graphs to illustrate sampling strategies
## lindanab4@gmail.com - 20200508
#############################################################

##############################
# 0 - Load librairies
##############################
library(data.table)
source("./rcode/analyses/sample_valdata.R")

############################## 
# 1 - Prepare data for analysis
##############################
data_path <- "./data/processed" 
data <- readRDS(file = paste0(data_path, "/ldrp.Rds"))
# use data for analysis

data_random <- select_valdata(
  data = data,
  use_variable = NA,
  size_valdata = 0.4,
  sampling_strat = "random",
  seed = 20200508
)
data_uniform <- select_valdata(
  data = data,
  use_variable = "z_middelomtrek",
  size_valdata = 0.4,
  sampling_strat = "uniform",
  seed = 20200508
)
data_extremes <- select_valdata(
  data = data,
  use_variable = "z_middelomtrek",
  size_valdata = 0.4,
  sampling_strat = "extremes",
  seed = 20200508
)


create_scatterhist <- function(data, 
                               uniform = F){
  zones <- matrix(c(2, 0, 1, 3), ncol = 2, byrow = TRUE)
  layout(zones, widths = c(4/5, 1/5), heights = c(1/5, 4/5))
  par(mar = c(3, 3, 1, 1))
  plot(0,
       type = "n",
       xaxt = "n",
       yaxt = "n",
       frame.plot = F,
       ann = F,
       xlim = c(-1.5, 5.5),
       ylim = c(-3, 3.5)
  )
  axis(1,
       at = c(-1.5, 2, 5.5),
       tck = - 0.01,
       cex.axis = 0.75
  )
  mtext("Visceral adipose tissue",
        side = 1,
        line = 2,
        cex = 1
  )
  axis(2, 
       at = c(-3, 0.25, 3.5),
       tck = - 0.01,
       cex.axis = 0.75
  )
  mtext("Waist circumference", 
        side = 2, 
        line = 2)
  abline(h = c(bins$lower_bound, bins$upper_bound[10]),
         col = "lightgrey")
  with (data[data$in_valdata == 0, ], 
        points(z_MVAT, z_middelomtrek, 
               col = "lightgrey", 
               pch = 16))
  with (data[data$in_valdata == 1, ], 
        points(z_MVAT, z_middelomtrek,
               pch = 16))
  xhist <- with (data[data$in_valdata == 1, ],
                 hist(z_MVAT, plot = FALSE))
  yhist <- with (data[data$in_valdata == 1, ],
                 hist(z_middelomtrek, 
                      breaks = c(bins$lower_bound, bins$upper_bound[10]),
                      plot = FALSE))
  top = max(c(xhist$counts, yhist$counts))
  par(mar = c(0,3,1,1))
  barplot(xhist$counts, axes = FALSE, ylim = c(0, top), space = 0)
  par(mar=c(3,0,1,1))
  if (uniform == T){
    barplot(bins$n_valdata_bin, 
            axes = FALSE, 
            xlim = c(0, top),
            space = 0, horiz = T)
  } else
    barplot(yhist$count,
            axes = FALSE, 
            xlim = c(0, top),
            space = 0, horiz = T)
}

png(paste0("./results/figures", "/scatterhist_random.png"),
    width = 6, height = 4, units = 'in', res = 250)
create_scatterhist(data_random)
dev.off()
png(paste0("./results/figures", "/scatterhist_uniform.png"),
    width = 6, height = 4, units = 'in', res = 250)
create_scatterhist(data_uniform, uniform = T)
dev.off()
png(paste0("./results/figures", "/scatterhist_extremes.png"),
    width = 6, height = 4, units = 'in', res = 250)
create_scatterhist(data_extremes)
dev.off()
      