setwd('../projects/r practice/r_coding_common_usage')
rm(list=ls())

# call Python from R

# construct a data frame
x1 <- c(1,2,3,4)
x2 <- c(5,6,7,8)
dfx <- data.frame(x1, x2)

write.csv(dfx, file='input.csv', row.names=FALSE)

system('python python_func.py')

dfz<-read.csv('output.csv')
# print.data.frame(dfz)


x1 <- c(1,2,3,4)
x2 <- c(5,6,7,8)
df <- cbind(x1, x2)

system('python python_func.py')
