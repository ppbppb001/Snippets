setwd('../projects/r practice/r_coding_common_usage')
rm(list=ls())

# common data manipulations
library(MASS)

#split a vector into groups
split(Cars93$MPG.city, Cars93$Origin) #method 1
unstack(data.frame(Cars93$MPG.city, Cars93$Origin)) #method 2

#apply a function to each list element, lapply & sapply
S1 <- c(89, 85, 85, 86, 88, 89, 86, 82, 96, 85, 93, 91, 98, 87, 94, 77, 87, 98, 85, 89, 95, 
        85, 93, 93, 97, 71, 97, 93, 75, 68, 98, 95, 79, 94, 98, 95)
S2 <- c(60, 98, 94, 95, 99, 97, 100, 73, 93, 91, 98, 86, 66, 83, 77, 97, 91, 93, 71, 91, 95, 
        100, 72, 96, 91, 76, 100, 97, 99, 95, 97, 77, 94, 99, 88, 100, 94, 93, 86)
S3 <- c(95, 86, 90, 90, 75, 83, 96, 85, 83, 84, 81, 98, 77, 94, 84, 89, 93, 99, 91, 77,
        95, 90, 91, 87, 85, 76, 99, 99, 97, 97, 97, 77, 93, 96, 90, 87, 97, 88)
S4 <- c(67, 93, 63, 83, 87, 97, 96, 92, 93, 96, 87, 90, 94, 90, 82, 91, 85, 93, 83, 90,
        87, 99, 94, 88, 90, 72, 81, 93, 93, 94, 97, 89, 96, 95, 82, 97)
scores <- list(S1=S1, S2=S2, S3=S3, S4=S4)
lapply(scores, length)
sapply(scores, length)
sapply(scores, sd)

#apply a function to every row, apply
row1 <- c(-1.8501520, -1.406571, -1.0104817, -3.7170704, -0.2804896)
row2 <- c(0.9496313, 1.346517, -0.1580926, 1.6272786, 2.4483321)
row3 <- c(-0.5407272, -1.708678, -0.3480616, -0.2757667, -1.2177024)
long <- rbind(row1, row2, row3)
colnames(long) <- c('trial1', 'trial2', 'trial3', 'trial4', 'trial5')
rownames(long) <- c('Moe', 'Larry', 'Curly')

apply(long, 1, mean) #argument "1" indicates row by row

#string operations
nchar('Moe') #length of a string
paste('Everybody', 'loves', 'stats.', sep='-') #concatenate strings
substr('Statistics', 1, 4) #substring

s <- "Curly is the smart one. Curly is funny, too." #replace substring
sub("Curly", "Moe", s)

