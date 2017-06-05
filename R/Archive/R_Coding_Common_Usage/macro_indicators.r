setwd("e:/cat/projects/r practice/DIBP")
rm(list=ls())

library(ggplot2)
library(caret)
library(reshape2)

df0 <- read.csv('macro_indicators.csv', header=T, na.strings = c(""))
df <- df0[1:18, c(1,7:10)]

# preOBJ <- preProcess(df[, -1], method=c("center", "scale"))
# df_new <- predict(preOBJ, df[, -1])
# df_new$X <- df$X
# 
# dat_m <- melt(df_new, id.var='X')
# p1 <- ggplot(dat_m)
# p1 + geom_line(aes(X, value, color=variable))

plot(100*df[1:17,5], df[2:18,3]/1000)  #exchange rate
# plot(1000*df[1:17,2], df[2:18,3]/1000) #unemployed
# plot(df[1:17,4]/100, df[2:18,3]/1000) #import export



