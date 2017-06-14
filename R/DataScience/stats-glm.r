#=================================
#  <stats-glm.r>
#   Using standard functions in
#   package {stats}
#=================================

library(caret)

# [Data Set 1]:
# Prepare data set  .......................
dlen <- 10000

c1 <- sample(dlen)
c1
c2 <- sample(0:1,dlen,replace = TRUE)
c2
df <- data.frame(Value=c1, Class=c2)
df

df[100,1] <- NA
df[200,2] <- NA


# Partition data set:
inTrain = 1:(dlen*0.7)
inTrain

training <- df[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
nrow(training)

testing <- df[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
nrow(testing)

my.formula <- "Class~."

# Prepare refrence data:
cm.ref <- testing$Class

# Train/Fit ...........................................
set.seed(666)

my.glmfit <- glm(formula = my.formula,
                 data = training,
                 method = "glm.fit",
                 family = binomial(link="logit"),
                 control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
                )
print(my.glmfit)


# Predict ............................................
my.glmpred <- predict(object = my.glmfit,
                      newdata = testing,
                      type = "response"
                      )
print(my.glmpred)


# confusion maxtrix: ...................................
# Prepare prediction data for confusion matrix:
cm.pred <- ifelse(my.glmpred > 0.5, 1, 0)  # if pred > 0.5 then 1 else 0

# prediction data to factor:
cm.pred <- c(0, 1, cm.pred)                # Add preamble (0,1)
cm.pred <- as.factor(cm.pred)              # Convert to factor
cm.pred <- cm.pred[-c(1,2)]                # Remove preamble
print(head(cm.pred)) 

# reference data to factor:
cm.ref <- c(0, 1, cm.ref)                  # Add preamble (0,1)
cm.ref <- as.factor(cm.ref)                # Convert to factor
cm.ref <- cm.ref[-c(1,2)]                  # Remove preamble
print(head(cm.ref))

my.cm <- confusionMatrix(data = cm.pred,
                         reference = cm.ref,
                         mode = "prec_recall"
                        )
print(my.cm)     # output of confusion matrix

my.table <- table(cm.ref, cm.pred)
print (my.table)


