setwd('../projects/r practice/r_coding_common_usage')
rm(list=ls())

# typical machine learning usage
library(caret)
library(e1071)
library(rpart)
library(randomForest)
library(ROCR)
library(ggplot2)

#load spam data
load_spam <- function()
{
  spamD <- read.table('spamD.tsv', header=T, sep='\t')
  spamTrain <- subset(spamD, spamD$rgroup>=10)
  spamTest <- subset(spamD, spamD$rgroup<10)
  spamVars <- setdiff(colnames(spamD), list('rgroup', 'spam'))
  # spamFormula <- as.formula(paste('spam=="spam"',
  #                                 paste(spamVars, collapse='+'), sep='~'))
  spamFormula <- paste("spam", paste(spamVars, collapse='+'), sep='~')
  
  return (list('strain'=spamTrain, 'stest'=spamTest, 'sformula'=spamFormula, 
               'svars'=spamVars))
}

# split of data

set.seed(101) # Set Seed so that same sample can be reproduced in future also
# Now Selecting 75% of data as sample from total 'n' rows of the data  
sample <- sample.int(n = nrow(data), size = floor(.75*nrow(data)), replace = F)
train <- data[sample, ]
test  <- data[-sample, ]

#-------------------------------------------------------------------------
#preprocessing - standardize
data("iris")
preprocessparams <- preProcess(iris[,1:4], method=c('center', 'scale'))
transformed <- predict(preprocessparams, iris[,1:4])

#-------------------------------------------------------------------------
#linear regression
load('psub.RData')
dtrain <- subset(psub, ORIGRANDGROUP>=500)
dtest <- subset(psub, ORIGRANDGROUP<500)
model <- lm(log(PINCP, base=10) ~ AGEP+SEX+COW+SCHL, data=dtrain)
dtest$predLogPINCP <- predict(model, newdata=dtest)
dtrain$predLogPINCP <- predict(model, newdata=dtrain)

#-------------------------------------------------------------------------
#logistic regression, example 1
spamall <- load_spam()
spamTrain <- spamall$strain
spamTest <- spamall$stest
spamFormula <- spamall$sformula

spamModel <- glm(spamFormula, data=spamTrain, family=binomial(link='logit'))
spamTrain$pred <- predict(spamModel, newdata=spamTrain, type='response')
spamTest$pred <- predict(spamModel, newdata=spamTest, type='response')
print(with(spamTest, table(y=spam, glmPred=pred>0.5)))

#confusion matrix
cm <- table(truth=spamTest$spam, prediction=spamTest$pred>0.5)
print(cm)

#double density plot
ggplot(data=spamTest) +
  geom_density(aes(x=pred, color=spam, linetype=spam))

#roc curve
eval <- prediction(spamTest$pred, spamTest$spam)
plot(performance(eval, "tpr", "fpr"))
print(attributes(performance(eval, 'auc'))$y.values[[1]])

#-------------------------------------------------------------------------
#logistic regression, example 2
load("NatalRiskData.rData")
dtrain <- sdata[sdata$ORIGRANDGROUP<=5,]
dtest <- sdata[sdata$ORIGRANDGROUP>5,]

complications <- c('ULD_MECO', 'ULD_PRECIP', 'ULD_BREECH')
riskfactors <- c('URF_DIAB', 'URF_CHYPER', 'URF_PHYPER', 'URF_ECLAM')
y <- "atRisk"
x <- c('PWGT', 'UPREVIS', 'CIG_REC', 'GESTREC3', 'DPLURAL',
       complications, riskfactors)
fmla <- paste(y, paste(x, collapse='+'), sep='~')
model <- glm(fmla, data=dtrain, family=binomial(link='logit'))
dtrain$pred <- predict(model, newdata=dtrain, type='response')
dtest$pred <- predict(model, newdata=dtest, type='response')

#roc curve 
eval <- prediction(dtest$pred, dtest$atRisk)
plot(performance(eval, "tpr", "fpr"))
print(attributes(performance(eval, 'auc'))$y.values[[1]])




#-------------------------------------------------------------------------
#decision trees
spamall <- load_spam()
spamTrain <- spamall$strain
spamTest <- spamall$stest
spamFormula <- spamall$sformula

treemodel <- rpart(spamFormula, spamTrain)

#-------------------------------------------------------------------------
#randomforest
spamall <- load_spam()
spamTrain <- spamall$strain
spamTest <- spamall$stest
spamFormula <- spamall$sformula
spamVars <- spamall$svars

set.seed(5123512)
fmodel <- randomForest(x=spamTrain[, spamVars], y=spamTrain$spam,
                       ntree=100, )


#-------------------------------------------------------------------------
#practice...


