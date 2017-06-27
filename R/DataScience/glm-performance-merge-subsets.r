library(caret)
library(ROCR)   
library(ggplot2)

# Define const -----------------------------
test.dlen <- 100
test.split <- 0.7    # 70% as training data set


# [Subset 1]: ------------------------
# Prepare data frame:
set.seed(1000)
c1 <- sample(test.dlen)
c2 <- sample(0:1,test.dlen,replace = TRUE)
df <- data.frame(Value=c1, Class=c2)

# Partition data set:
inTrain = 1:(test.dlen * test.split)  
training.s1 <- df[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
testing.s1 <- df[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
glm.fit.s1 <- glm(formula = "Class~.",
                  data = training.s1,
                  method = "glm.fit",
                  family = binomial(link="logit"),
                  control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
)

# Predict
glm.pred.s1 <- predict(object = glm.fit.s1,
                       newdata = testing.s1,
                       type = "response"
)


# [Subset 2]: ------------------------
# Prepare data frame:
set.seed(2000)
c1 <- sample(test.dlen)
c2 <- sample(0:1,test.dlen,replace = TRUE)
df <- data.frame(Value=c1, Class=c2)

# Partition data set:
inTrain = 1:(test.dlen * test.split)  
training.s2 <- df[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
testing.s2 <- df[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
glm.fit.s2 <- glm(formula = "Class~.",
                  data = training.s2,
                  method = "glm.fit",
                  family = binomial(link="logit"),
                  control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
)

# Predict
glm.pred.s2 <- predict(object = glm.fit.s2,
                       newdata = testing.s2,
                       type = "response"
)


# [Subset 3]: ------------------------
# Prepare data frame:
set.seed(3000)
c1 <- sample(test.dlen)
c2 <- sample(0:1,test.dlen,replace = TRUE)
df <- data.frame(Value=c1, Class=c2)

# Partition data set:
inTrain = 1:(test.dlen * test.split)  
training.s3 <- df[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
testing.s3 <- df[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
glm.fit.s3 <- glm(formula = "Class~.",
                  data = training.s3,
                  method = "glm.fit",
                  family = binomial(link="logit"),
                  control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
)

# Predict
glm.pred.s3 <- predict(object = glm.fit.s3,
                       newdata = testing.s3,
                       type = "response"
)


# [Merge] ----------------------------------------
pred.all <- c(glm.pred.s1, 
              glm.pred.s2,
              glm.pred.s3)         # merge prediction subsets
ref.all <- c(testing.s1$Class,
             testing.s2$Class,
             testing.s3$Class)     # merge testing data subsets


# [ROCR Performance] ------------------------------
# Get ROCR prediction object:
rocr.pred <- prediction(as.numeric(pred.all), 
                        as.numeric(ref.all))          

# tpr/fpr: ROC
rocr.perf.tprfpr <- performance(rocr.pred, 
                                measure = "tpr", 
                                x.measure = "fpr")
# AUC:
rocr.perf.auc <- performance(rocr.pred, 
                             measure = "auc")
# recall:
rocr.perf.recall <- performance(rocr.pred, 
                                measure = "prec", 
                                x.measure = "rec")
# acc/err:
rocr.perf.accerr <- performance(rocr.pred, 
                                measure = "acc", 
                                x.measure = "err")
# Plot ROC/AUC:
plot(rocr.perf.tprfpr)
text(x=0.6, y=0.2,
     sprintf("AUC = %f", rocr.perf.auc@y.values))


# [Table] --------------------------------
pred.all.t <- ifelse(pred.all > 0.5, 1, 0)  # if pred > 0.5 then 1 else 0
# prediction data to factor:
pred.all.t <- c(0, 1, pred.all.t)                # Add preamble (0,1)
pred.all.t <- as.factor(pred.all.t)              # Convert to factor
pred.all.t <- pred.all.t[-c(1,2)]                # Remove preamble
# reference data to factor:
ref.all.t <- c(0, 1, ref.all)                        # Add preamble (0,1)
ref.all.t <- as.factor(ref.all.t)                      # Convert to factor
ref.all.t <- ref.all.t[-c(1,2)]                        # Remove preamble
table.all <- table(ref.all.t, pred.all.t)
table.all




