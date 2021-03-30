#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction 
## Motivating example
##
## Scatter histogram
## lindanab4@gmail.com - 202005012
#############################################################

##############################
# 0 - Load librairies
##############################
library(extrafont)
# see fonts() for available fonts
library(data.table)
source("./rcode/analyses/sample_valdata.R") 

############################## 
# 1 - Prepare data for visualisation
##############################
data_path <- "./data/processed" 
data <- readRDS(file = paste0(data_path, "/ldrp_fake.Rds"))
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

############################## 
# 2 - Function to create scatterplot
##############################
create_scatterplot <- function(data,
                               txt){
  plot(0,
       type = "n",
       xaxt = "n",
       xaxs = "i",
       yaxt = "n",
       yaxs = "i",
       frame.plot = F,
       ann = F,
       xlim = c(-2, 6),
       ylim = c(-4, 4),
       asp = 1
  )
  axis(1,
       at = c(-2, 0, 2, 4,  6),
       labels = c(expression(-2), expression(0), expression(2), expression(4), expression(6))
  )
  mtext(expression(paste("Visceral Adipose Tissue, ", cm^2)),
        side = 1,
        line = 3,
        cex = 0.66
  )
  axis(2, 
       at = c(-4, -2, 0, 2, 4),
       labels = c(expression(-4), expression(-2), expression(0), expression(2), expression(4)),
       las = 1
  )
  mtext("Waist Circumference, cm", 
        side = 2, 
        line = 3, 
        cex = 0.66)
  di <- dev.size("in")
  x <- grconvertX(c(0, di[1]), from="in", to="user")
  y <- grconvertY(c(0, di[2]), from="in", to="user")
  fig <- par("fig")
  x <- x[1] + (x[2] - x[1]) * fig[1:2]
  y <- y[1] + (y[2] - y[1]) * fig[3:4]
  x <- x[1] + strwidth(txt)
  y <- y[2] - strheight(txt) * 1.5
  text(x, y, txt, cex = 1)
  with (data[data$in_valdata == 0, ], 
        points(z_MVAT, z_middelomtrek, 
               col = "lightgrey", 
               pch = 1,
               asp = 1))
  with (data[data$in_valdata == 1, ], 
        points(z_MVAT, z_middelomtrek,
               pch = 1, 
               asp = 1))
}

pdf("./results/figures/scatterplot_samplingstrats.pdf",
    width = 2.5, 
    height = 7.5,
    pointsize = 8 / 0.66)
layout(matrix(c(1, 2, 3), nrow = 3, ncol = 1))
par(mar = c(4, 5, 2, 1),
    xpd = NA)
create_scatterplot(data_random,
                   "A)")
create_scatterplot(data_uniform,
                   "B)")
create_scatterplot(data_extremes,
                   "C)")
dev.off()
