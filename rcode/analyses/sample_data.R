#############################################################
## Internal validation sampling strategies for exposure 
## measurement error correction
## Motivating example
##
## Sample data
## lindanab4@gmail.com - 20200408
#############################################################

sample_data <- function(data, seed){
  set.seed(seed)
  select_rows <- sample(1:NROW(data),
                        size = NROW(data),
                        replace = TRUE)
  new_data <- data[select_rows,]
  new_data
}