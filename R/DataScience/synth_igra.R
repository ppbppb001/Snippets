# test with synthetic data using igraph

library(igraph)
source("lm-expand-lib.r")

test.rows <- 1000
test.rows.h <- test.rows/2
test.date.start <- 2005
test.date.end <- 2015

set.seed(proc.time()[3])

#Date:
years <- sample(test.date.start:test.date.end,
                test.rows, 
                replace = TRUE)
months <- sample(1:12, test.rows, replace = TRUE)
days <- sample(1:28, test.rows, replace = TRUE)
dates <- sprintf("%4.4d-%2.2d-%2.2d", years, months, days)

#Keys
keys <- sample(1:test.rows, test.rows, replace=F) + test.rows

#Values
c1_1 <- runif(test.rows.h, min=7.5, max=12.5)
c1_2 <- runif(test.rows.h, min=8.5, max = 13.5)
c2_1 <- runif(test.rows.h, min=6.5, max=12.5)
c2_2 <- runif(test.rows.h, min=5, max=11)

#Class
class_1 <- rep(0, test.rows.h)
class_2 <- rep(1, test.rows.h)

c1 <- c(c1_1, c1_2)
c2 <- c(c2_1, c2_2)
class_all <- c(class_1, class_2)
df.base <- data.frame(Date=dates, 
                      Key=keys,
                      Value1 = c1, 
                      Value2=c2, 
                      Class=class_all)

#Date separate train and test
date.sep <- "2013-01-01"


# ****************************************************
#
#   Call calculation function
#
# ****************************************************
measures <- glmComparison(data.base = df.base,
                          name.date = "Date",
                          name.key = "Key",
                          name.class = "Class",
                          date.train = c("2005-01-01", as.character(as.Date(date.sep)-1)),
                          date.test = c(date.sep, "2015-12-31"),
                          # date.train = c("2005-01-01", "2012-12-31"),
                          # date.test = c("2013-01-01", "2015-12-31"),
                          iteration = 5,
                          balance = 1,
                          mode = 2
)

plotGlmMeasures(measures, "ROC")




# ****************************************************
#
#   Retrieve performance measures
#
# ****************************************************

#retrieve pred scores from train and test
ind <- which(as.character(df.base$Date)<date.sep)
train.base <- df.base[ind,]
test.retr <- retrieveGlmMeasures(measures, "base", "test")
test.base <- test.retr[[1]]

ls.score <- c(train.base$Class, test.base$Pred)

#synthetic adjacency matrix

# #fixed no of degrees of each node
# lstmp <- sample_degseq(rep(3, test.rows), method='vl')

#power law degree distribution
degs <- sample(2:8, test.rows, replace=TRUE, prob=(2:8)^-2)
if (sum(degs) %% 2 != 0) { degs[1] <- degs[1] + 1 }
lstmp <- sample_degseq(degs, method='vl')


mat.tmp  <- as_adjacency_matrix(lstmp)

#calculate degree-1 score sum of neighbor nodes
ls.sum1 <- NULL
for (i in 1:nrow(mat.tmp)){
  ind <- which(mat.tmp[i,] == 1)
  ls.sum1[i] <- sum(ls.score[ind])
}

# #calculate degree-2 score sum of neighbor nodes
# ls.sum2 <- NULL
# for (i in 1:nrow(mat.tmp)){
#   ind <- which(mat.tmp[i,] == 1)
#   ls.sum2[i] <- sum(ls.sum1[ind])
# }


#calculate degree-2 score sum of neighbor nodes
ls.sum2 <- NULL
for (i in 1:nrow(mat.tmp)){
  ind <- which(mat.tmp[i,]==1)
  ls.sum2[i] <- sum(ls.score[ind])
  for (j in 1:length(ind)){
    ind2 <- which(mat.tmp[j]==1)
    ind2 <- ind2[!ind2==i]
    ls.sum2[i] <- ls.sum2[i] + sum(ls.score[ind2])
    
  }
  
}



df.base$Score <- ls.sum2

measures <- glmComparison(data.base = df.base,
                          name.date = "Date",
                          name.key = "Key",
                          name.class = "Class",
                          date.train = c("2005-01-01", as.character(as.Date(date.sep)-1)),
                          date.test = c(date.sep, "2015-12-31"),
                          # date.train = c("2005-01-01", "2012-12-31"),
                          # date.test = c("2013-01-01", "2015-12-31"),
                          iteration = 5,
                          balance = 1,
                          mode = 2
)







# ****************************************************
#
#   Plot performance measures
#
# ****************************************************

plotGlmMeasures(measures, "ROC")

