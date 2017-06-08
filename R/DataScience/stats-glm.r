#=================================
#  <stats-glm.r>
#   Using standard functions in
#   package {stats}
#=================================


# [Data Set 1]:
# Prepare data set [Sonar] .......................
library(mlbench)    # [ Machine Learning Benchmark Problems ]
data(Sonar)

# Partition data set:
inTrain <- createDataPartition(y = Sonar$Class,
                               p = 0.75,
                               list = FALSE)
str(inTrain)

training <- Sonar[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
nrow(training)

testing <- Sonar[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
nrow(testing)

my.formula <- "Class~."

# Prepare refrence data:
cm.ref <- ifelse(testing$Class=="M", 1, 0)   # if class==M then 1 else 0
cm.ref <- as.factor(cm.ref)
if (levels(cm.ref)[1] == "0") {
    levels(cm.ref)[2] <- "1"
} else {
    levels(cm.ref)[2] <- "0"
}


# [Data Set 2]:
# Prepare data set [Iris] .......................
# data(iris)           # Fetch data set from the library(datsets)
# 
# iris.bak <- iris     # iris.bak as backup
# 
# iris <- iris[sample(1:dim(iris)[1]),]
# 
# iris$Species <- as.factor(ifelse(iris$Species=="setosa","1","0"))  # modify Col.Species
# 
# # inTrain <- createDataPartition(y = iris$Species,
# #                                p = 0.75,
# #                                list = FALSE)
# iris.len <- dim(iris)[1]
# inTrain <- 1:(iris.len * 0.75)
# str(inTrain)
# 
# training <- iris[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
# nrow(training)
# 
# testing <- iris[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
# nrow(testing)
# 
# my.formula <- "Species~."
# 
# # Prepare refrence data:
# cm.ref <- testing$Species


# Train/Fit ...........................................
set.seed(666)

my.glmfit <- glm(formula = my.formula,
                 data = training,
                 method = "glm.fit",
                 family = binomial(link="logit"),
                 control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
                )
my.glmfit


# Predict ............................................
my.glmpred <- predict(object = my.glmfit,
                      newdata = testing,
                      type = "response"
                      )
my.glmpred


# confusion maxtrix: ...................................
# Prepare prediction data for confusion matrix:
cm.pred <- ifelse(my.glmpred > 0.5, 1, 0)  # if pred > 0.5 then 1 else 0
cm.pred <- as.factor(cm.pred)
if (levels(cm.pred)[1] == "0") {
    levels(cm.pred)[2] <- "1"
} else {
    levels(cm.pred)[2] <- "0"
}
cm.pred   # Prediction

cm.ref    # Reference

my.cm <- confusionMatrix(data = cm.pred,
                         reference = cm.ref,
                         mode = "prec_recall"
                         )
my.cm     # output of confusion matrix


