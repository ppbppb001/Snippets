# <lm-expand-example.r> -------------
#
#  Example to test 'lm-expand-lib' modules
#  
# [2016-01-09] - r1
# [2016-01-12] - r2: ouput glm.pred
#------------------------------------------

source("lm-expand-lib.r")



# ****************************************************
#
#   Make pseudo data sets for testing
#
# ****************************************************
test.rows <- 5000
test.classSplit <- 0.1    # 10% of '1', 90% of '0'
test.n1 <- test.rows * test.classSplit
test.n0 <- test.rows - test.n1
test.date.start <- 2005
test.date.end <- 2015

# Make date and key columns: .................
set.seed(proc.time()[3])
# dates:
years <- sample(test.date.start:test.date.end,
                test.rows, 
                replace = TRUE)
months <- sample(1:12, test.rows, replace = TRUE)
days <- sample(1:28, test.rows, replace = TRUE)
dates <- sprintf("%4.4d-%2.2d-%2.2d", years, months, days)
# keys:
keys <- sample(test.rows) + 100000
keys <- sprintf('%6.6d', keys)

# class:
classes <- c(rep(0, test.n0), rep(1, test.n1))

# values:
v1 <- c(runif(test.n0, min = 7.5, max = 12.5),
        runif(test.n1, min = 10.5, max = 15.5))
v2 <- c(runif(test.n0, min = 7.5, max = 12.5),
        runif(test.n1, min = 10.5, max = 15.5))
v3 <- c(runif(test.n0, min = 7.5, max = 12.5),
        runif(test.n1, min = 10.5, max = 15.5))


# Make pseudo data sets:................
nshare <- as.integer(test.rows * 0.95)  #
# Base:
ix <- sample(test.rows)[1:nshare]
df.base <- data.frame(Date = dates,
                      Key = keys,
                      V1 = v1,
                      Class =  classes)
df.base <- df.base[ix,]
rownames(df.base) <- 1:nrow(df.base)
# Extra:
ix <- sample(test.rows)[1:nshare]
df.ext <- data.frame(Key = keys,
                     V2 = v2,
                     V3 = v3)
df.ext <- df.ext[ix,]
rownames(df.ext) <- 1:nrow(df.ext)



# ****************************************************
#
#   Call calculation function
#
# ****************************************************
measures <- glmComparison(data.base = df.base,
                          data.ext = df.ext,
                          name.date = "Date",
                          name.key = "Key",
                          name.class = "Class",
                          names.ext = c("V2", "V3"),
                          date.train = c("2006-01-01", "2013-12-31"),
                          date.test = c("2014-01-01", "2015-12-31"),
                          iteration = 5,
                          balance = 1,
                          mode = 1
                          )
# measures



# ****************************************************
#
#   Plot performance measures
#
# ****************************************************

plotGlmMeasures(measures, "ROC")
plotGlmMeasures(measures, "Recall")
plotGlmMeasures(measures, "Accuracy")



# ****************************************************
#
#   Retrieve performance measures
#
# ****************************************************

# 'pred' - prediction :
pred.base <- retrieveGlmMeasures(measures, "base", "pred")
pred.base
pred.ext <- retrieveGlmMeasures(measures, "extend", "pred")
pred.ext

# 'cm' - confusion matrix :
cm.base <- retrieveGlmMeasures(measures, "base", "cm")
cm.base
cm.ext <- retrieveGlmMeasures(measures, "extend", "cm")
cm.ext

# 'table' :
table.base <- retrieveGlmMeasures(measures, "base", "table")
table.base
table.ext <- retrieveGlmMeasures(measures, "extend", "table")
table.ext

# 'auc':
auc.base <- retrieveGlmMeasures(measures, "base", "auc")
auc.base
auc.ext <- retrieveGlmMeasures(measures, "extend", "auc")
auc.ext

# 'roc'/'tprfpr':
roc.base <- retrieveGlmMeasures(measures, "base", "roc")
roc.base
roc.ext <- retrieveGlmMeasures(measures, "extend", "roc")
roc.ext

# 'recall':
recall.base <- retrieveGlmMeasures(measures, "base", "recall")
recall.base
recall.ext <- retrieveGlmMeasures(measures, "extend", "recall")
recall.ext

# 'accuracy'/'accerr':
accuracy.base <- retrieveGlmMeasures(measures, "base", "accuracy")
accuracy.base
accuracy.ext <- retrieveGlmMeasures(measures, "extend", "accuracy")
accuracy.ext

