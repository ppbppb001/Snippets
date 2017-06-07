#=============================================
#  <caret-cv.r>:
#   Example code in the article "A Short 
#   Introduction to the caret Package" 
#   with file name as 'caret.pdf', using CV
#=============================================


library(caret)      # [ Classification and Regression Training ]
library(mlbench)    # [ Machine Learning Benchmark Problems ]
library(pls)        # [ Partial Least Squares and Principal Component Regression ]
library(gbm)        # [ Generalized Boosted Regression Models ]
library(plyr)       # [ Tools for Splitting, Applying and Combining Data ]
library(pROC)       # [ Display and Analyze ROC Curves ]

#---------------------------------
# Prepare the data set
#---------------------------------
data("Sonar")  # Test data set from package<mlbench>

inTrain <- createDataPartition(y = Sonar$Class,
                               p = 0.75,
                               list = FALSE)
str(inTrain)

training <- Sonar[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
nrow(training)

testing <- Sonar[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
nrow(testing)


#------------------------------
# Fit/Train
#------------------------------
set.seed(123)

# Train control ..............

# [ Cross-Validation ]
# Control = Cross-Validation
cvCtrl <- trainControl(
    method = "repeatedcv",   # repeated cross-validation
    number = 10,             # 10-fold
    repeats = 3,
    classProbs = TRUE,       # OPTIONAL: package-"pROC" is required
    # summaryFunction = defaultSummary  # Default
    summaryFunction = twoClassSummary # OPTIONAL: package-"pROC" is required
                                      # This option must be removed if metric="Accuracy" is wanted
)


# Train/Fit ..................

# [ Partial Least Squares and Principal Component Regression ]
# Train-pls: withou CV ...............
plsFit <- train(
    Class ~ .,
    data = training,
    method = "pls",
    tuneLength = 15,
    preProcess = c("center", "scale")
)
plsFit

# Train-pls-CV: resampling by 10-fold cross-validation  ...............
plsFitCV <- train(
    Class ~ .,
    data = training,
    method = "pls",
    tuneLength = 15,
    trControl = cvCtrl,
    metric = "ROC",     # OPTIONAL: package-"pROC" is required
                        # metric="Accuray" is applied by default when
                        # 'summaryFunction = twoClassSummary' removed while
                        # building the trainControl
    preProcess = c("center", "scale")
)
plsFitCV

# [ Generalized Boosted Regression Models ]
# Train-gbm-cv ...............
gbmFitCV <- train(
    Class ~ .,
    data = training,
    method = "gbm",
    trControl = cvCtrl,
    metric = "ROC",     # OPTIONAL: package-"pROC" is required
                        # metric="Accuray" is applied by default when
                        # 'summaryFunction = twoClassSummary' removed while
                        # building the trainControl
    verbose = FALSE
)
gbmFitCV


#------------------------------
# Predict
#------------------------------

# <plsFit>: without CV ...............
plsClasses <- predict(plsFit, 
                      newdata = testing)
str(plsClasses)
#
plsProbs <- predict(plsFit, 
                    newdata = testing, 
                    type = "prob")
head(plsProbs)
# the confusion matrix and associated statistics for the model fit:
cm.pls <- confusionMatrix(data = plsClasses, testing$Class, mode = "prec_recall")
cm.pls$byClass["Precision"]
cm.pls$byClass["Recall"]
cm.pls$overall["Accuracy"]


# <plsFitCV>: with CV ...............
plsClassesCV <- predict(plsFitCV, 
                        newdata = testing)
str(plsClassesCV)
#
plsProbsCV <- predict(plsFitCV, 
                      newdata = testing, 
                      type = "prob")
head(plsProbsCV)
# the confusion matrix and associated statistics for the model fit:
cm.plscv <- confusionMatrix(data = plsClassesCV, testing$Class, mode = "prec_recall")
cm.plscv$byClass["Precision"]
cm.plscv$byClass["Recall"]
cm.plscv$overall["Accuracy"]

# <gbmFitCV>: with CV ...............
gbmClassesCV <- predict(gbmFitCV, 
                        newdata = testing)
str(gbmClassesCV)
#
gbmProbsCV <- predict(gbmFitCV, 
                      newdata = testing, 
                      type = "prob")
head(gbmProbsCV)
# the confusion matrix and associated statistics for the model fit:
cm.gbmcv <- confusionMatrix(data = gbmClassesCV, testing$Class, mode = "prec_recall")
cm.gbmcv$byClass["Precision"]
cm.gbmcv$byClass["Recall"]
cm.gbmcv$overall["Accuracy"]


#------------------------------
# Comparison of models
#  (with same method)
#------------------------------
# resamps <- resamples(list(pls = plsFitCV, gbm = gbmFitCV))
# summary(resamps)
# 
# xyplot(resamps)  # ggplot2
# # xyplot(resamps, what = "BlandAltman") # ggplot2
# 
# diffs <- diff(resamps)
# summary(diffs)





