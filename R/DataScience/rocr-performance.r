#=============================================
#  <rocr-performance.r>:
#
#=============================================


library(caret)      # [ Classification and Regression Training ]
library(mlbench)    # [ Machine Learning Benchmark Problems ]
library(ROCR)       # [ Visualizing the Performance of Scoring Classifiers ]
library(gbm)        # [ Generalized Boosted Regression Models ]
library(pls)        # [ Partial Least Squares and Principal Component Regression ]
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
# [ Generalized Boosted Regression Models ]
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
confusionMatrix(data = gbmClassesCV, testing$Class)




#------------------------------
# Performance:
#------------------------------

# As ROCR supports only binary classification in current version, 
# The testing and predicted data MUST be converted to binary format before
# checking the performance by ROCR

# Convert the format of $Class(2 classes: M,R) to binary ..................
# Class: "R"=1, else=0
bTest <- ifelse(testing$Class=="R",1,0)  # testing data set -> binary format
bTest

bGbmClasses <- ifelse(gbmClassesCV=="R",1,0) # gbmCV prediction -> binary format
bGbmClasses


# Get prediction object for the performance checking .............
predGbmClasses <- prediction(bGbmClasses, bTest)   # prediction=Classes, label=bTest
predGbmProbsM <- prediction(gbmProbsCV$M, bTest)   # prediction=Probs$M, label=bTest
predGbmProbsR <- prediction(gbmProbsCV$R, bTest)   # prediction=Probs$R, label=bTest


# Get performace object / Check performance: ...........................
# Precision/recall graphs: measure="prec", x.measure="rec":
perfGbmClasses <- performance(predGbmClasses, "prec", "rec")
perfGbmClasses

perfGbmProbsM <- performance(predGbmProbsM, "prec", "rec")
perfGbmProbsM

perfGbmProbsR <- performance(predGbmProbsR, "prec", "rec")
perfGbmProbsR

#ROC curves: measure="tpr", x.measure="fpr":
perfGbmClasses2 <- performance(predGbmClasses, "tpr", "fpr")
perfGbmClasses2

perfGbmProbsM2 <- performance(predGbmProbsM, "tpr", "fpr")
perfGbmProbsM2

perfGbmProbsR2 <- performance(predGbmProbsR, "tpr", "fpr")
perfGbmProbsR2

#Accuracy and Errors: measure="acc", x.measure="err":
perfGbmClasses3 <- performance(predGbmClasses, "acc", "err")
perfGbmClasses3

perfGbmProbsM3 <- performance(predGbmProbsM, "acc", "err")
perfGbmProbsM3

perfGbmProbsR3 <- performance(predGbmProbsR, "acc", "err")
perfGbmProbsR3


# How to retrieve the name/value from the performance object: ................
perfGbmProbsR3@x.name         # vector: name of slot-"x"
perfGbmProbsR3@x.values[[1]]  # vector: value of slot-"x
perfGbmProbsR3@y.name         # vector: name of slot-"y"
perfGbmProbsR3@y.values[[1]]  # vector: value of slot-"y"
perfGbmProbsR3@alpha.name         # vector: name of slot-"alpha"
perfGbmProbsR3@alpha.values[[1]]  # vector: value of slot-"alpha"


# Plot ....................
plot(perfGbmProbsR, colorize=TRUE)
plot(perfGbmProbsM, colorize=TRUE)
plot(perfGbmProbsR2, colorize=TRUE)
plot(perfGbmProbsM2, colorize=TRUE)

