#=============================================
#  <c50-cv.r>: 
#   Classification by Decision Trees
#   <1> Example code in chapter-10 of the book 
#       "Machine Learning with R" 
#       (using CV)
#   <2> Example code in article "Classification 
#       Using C5.0" by Max Kuhn
#       (not using CV)
#=============================================


library(caret)      # [ Classification and Regression Training ]
library(C50)        # [ C5.0 Decision Trees and Rule-Based Models ]
library(lpSolve)    # [ Solve Linear/Integer Programs ] required by package<irr>
library(irr)        # [ Various Coefficients of Interrater Reliability and Agreement ]
library(AppliedPredictiveModeling)  # [ Functions and Data Sets for Book 'Applied Predictive Modeling' ]


#---------------------------------
# Example-1
#   Book "Machine Learning with R"
#   Using CV
#---------------------------------
credit <- read.csv("credit.csv")   # test data provied by PACKT publishing

# folds <- createFolds(credit$default, k=10) # Original code failed by lacking of factor in 'default'
folds <- createFolds(credit$housing, k=10)   # 'housing' has factor/level which is a MUST to use C5.0
str(folds)

set.seed(123)

# Loop through the folds to apply CV method
cv_results <- lapply(folds, function(x) {
    credit_train <- credit[-x, ]  # data set for training
    credit_test <- credit[x, ]    # data set for testing
    credit_model <- C5.0(housing~., 
                         data = credit_train)  # OneTree predictive model
    credit_pred <- predict(credit_model, credit_test)  # predict
    credit_actual <- credit_test$housing
    dfk <- data.frame(credit_actual, credit_pred)
    kappa <- kappa2(dfk)$value   # measuring
    return (kappa)
})
str(cv_results)
mean(unlist(cv_results))




#---------------------------------
# Example-2
#   "Classification Using C5.0"
#    Not using CV
#---------------------------------
# load data set
data("schedulingData")   # data set in package<AppliedPredictiveModeling>
str(schedulingData)

set.seed(733)

# prepare data set
schInTrain <- createDataPartition(schedulingData$Class, 
                                  p = 0.75, 
                                  list = FALSE)
schTraining <- schedulingData[schInTrain,]
schTesting <- schedulingData[-schInTrain,]

# [ (1) Single Tree ] ..........................
# Make predictive model:
schOneTree <- C5.0(Class~., 
                   data = schTraining)
schOneTree
# summary(schOneTree)

# Predict:
schOneTreePred <- predict(schOneTree, schTesting)
# schOneTreeProbs <- predict(schOneTree, 
#                            schTesting, 
#                            type = "prob")
schOneTreeRes <- postResample(schOneTreePred, schTesting$Class)
schOneTreeRes


# [ (2) Single Ruleset ] ........................
# Make predictive model
schRules <- C5.0(Class~., 
                 data = schTraining,
                 rules = TRUE)
schRules
# summary(schRules)

# Predict:
schRulesPred <- predict(schRules, schTesting)
schRulesRes <- postResample(schRulesPred, schTesting$Class)
schRulesRes


# [ (3) Boosted Tree ] ........................
# Make predictive model
schBstTree <- C5.0(Class~., 
                   data = schTraining,
                   trials = 10)
schBstTree
# summary(schRules)

# Predict
schBstTreePred <- predict(schBstTree, schTesting)
schBstTreeRes <- postResample(schBstTreePred, schTesting$Class)
schBstTreeRes

