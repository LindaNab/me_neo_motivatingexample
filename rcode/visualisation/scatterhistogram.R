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

############################## 
# 1 - Workhorse scatterplots
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
       ylim = c(-4, 4)
  )
  axis(1,
       at = c(-2, 0, 2, 4,  6),
       labels = c(expression(-2), expression(0), expression(2), expression(4), expression(6))
  )
  mtext(expression(paste("Standardized Visceral Adipose Tissue, ", cm^2)),
        side = 1,
        line = 3,
  )
  axis(2, 
       at = c(-4, -2, 0, 2, 4),
       labels = c(expression(-4), expression(-2), expression(0), expression(2), expression(4)),
       las = 1
  )
  mtext("Standardized Waist Circumference, cm", 
        side = 2, 
        line = 3)
  di <- dev.size("in")
  x <- grconvertX(c(0, di[1]), from="in", to="user")
  y <- grconvertY(c(0, di[2]), from="in", to="user")
  fig <- par("fig")
  x <- x[1] + (x[2] - x[1]) * fig[1:2]
  y <- y[1] + (y[2] - y[1]) * fig[3:4]
  x <- x[1] + strwidth(txt)
  y <- y[2] - strheight(txt) * 1.5
  text(x, y, txt)
  with (data[data$in_valdata == 0, ], 
        points(z_MVAT, z_middelomtrek, 
               col = "lightgrey", 
               pch = 1))
  with (data[data$in_valdata == 1, ], 
        points(z_MVAT, z_middelomtrek,
               pch = 1))
}
pdf("./results/figures/scatterplot_samplingstrats.pdf", width = 3, height = 9,
    pointsize = 8)
par(mar = c(4, 5, 2, 1),
    xpd = NA,
    mfrow = c(3, 1),
    pty = "s")
create_scatterplot(data_random,
                   "A)")
create_scatterplot(data_uniform,
                   "B)")
create_scatterplot(data_extremes,
                   "C)")
dev.off()
# 
# zones <- matrix(c(2, 0, 1, 3), ncol = 2, byrow = TRUE)
# layout(zones, widths = c(4/5, 1/5), heights = c(1/5, 4/5))

# xhist <- with (data[data$in_valdata == 1,],
#                hist(z_MVAT, plot = FALSE))
# yhist <- with (data[data$in_valdata == 1,],
#                hist(
#                  z_middelomtrek,
#                  breaks = c(bins$lower_bound, bins$upper_bound[10]),
#                  plot = FALSE
#                ))
# top = max(c(xhist$counts, yhist$counts))
# par(mar = c(0, 3, 1, 1))
# barplot(xhist$counts,
#         axes = FALSE,
#         ylim = c(0, top),
#         space = 0)
# par(mar = c(3, 0, 1, 1))
# if (uniform == T) {
#   barplot(
#     bins$n_valdata_bin,
#     axes = FALSE,
#     xlim = c(0, top),
#     space = 0,
#     horiz = T
#   )
# } else
#   barplot(
#     yhist$count,
#     axes = FALSE,
#     xlim = c(0, top),
#     space = 0,
#     horiz = T
#   )
