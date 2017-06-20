# <ggplot2-test-glm-performance.r> -------------
#
#   1) test metric funtions applicable to glm,
#      such as confusionmatrix(), table(), rocr 
#      performance()
#   2) test multi-layers chart plotting functions
#      in 'ggplot2-mytools-lib.r'
#
#   [2017-06-16] - Initialized
#   [2017-06-20] - Combine 2 plots into one 
#                  by 'multiPlot'
#-----------------------------------------------


library(caret)
library(ROCR)   
library(ggplot2)

source("ggplot2-mytools-lib.r")  # load mytools code module


# Define const -----------------------------
test.count <- 10     # number of testing runs
test.dlen <- 1000    # length of testing data set
test.split <- 0.7    # 70% as training data set
# 'test.output' is a list of lists to save output results:  
test.output <- list(ref = list(),            # list of reference data sets
                    glm.pred = list(),       # list of glm predictions
                    cm = list(),             # list of confusion matrix
                    table = list(),          # list of tables
                    rocr.pred = list(),      # list of rocr predictioin objects
                    perf.tprfpr = list(),    # list of rocr performance objects for ROC
                    perf.auc = list(),       # list of rocr performance objects for AUC
                    perf.recall = list(),    # list of rocr performance objects for Recall
                    perf.accerr = list()     # list of rocr performance objects for Acc/Err
                    )                      


# Testing loop ----
#   1. prepare random data set
#   2. train/fit
#   3. predict
#   4. measure: confusion matrix / table / rocr performance
for (i in 1:test.count) {
    
    # (1) Fabricate pseudo data set  ------------------------------
    set.seed(i*100+i)
    
    c1 <- sample(test.dlen)                      # col-1 of pseudo data set
    c1
    c2 <- sample(0:1,test.dlen,replace = TRUE)   # col-2 of pseudo data set
    c2
    df <- data.frame(Value=c1, Class=c2)
    df
    
    # Partition data set:
    inTrain = 1:(test.dlen * test.split)  
    inTrain
    
    training <- df[inTrain, ]  # data 'inTrain' for training is part of 'Sonar'
    nrow(training)
    
    testing <- df[-inTrain, ]  # data with 'inTrain' removed from 'Sonar' is used as testing set
    nrow(testing)
    
    me.formula <- "Class~."
    
    # Set refrence data:
    me.ref <- testing$Class
    test.output$ref <- c(test.output$ref, list(me.ref))  # push to output list
    
    
    # (2) Train/Fit -----------------------------------
    # set.seed(666)
    
    me.glm.fit <- glm(formula = me.formula,
                      data = training,
                      method = "glm.fit",
                      family = binomial(link="logit"),
                      control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
    )
    
    
    # (3) Predict ------------------------------------------
    me.glm.pred <- predict(object = me.glm.fit,
                           newdata = testing,
                           type = "response"
    )
    test.output$glm.pred <- c(test.output$glm.pred, list(me.glm.pred)) # push to output list
    
    
    # (4.1) confusion maxtrix --------------------------------
    # Prepare prediction data for confusion matrix:
    me.cm.pred <- ifelse(me.glm.pred > 0.5, 1, 0)  # if pred > 0.5 then 1 else 0
    # prediction data to factor:
    me.cm.pred <- c(0, 1, me.cm.pred)                # Add preamble (0,1)
    me.cm.pred <- as.factor(me.cm.pred)              # Convert to factor
    me.cm.pred <- me.cm.pred[-c(1,2)]                # Remove preamble
    # reference data to factor:
    me.ref <- c(0, 1, me.ref)                        # Add preamble (0,1)
    me.ref <- as.factor(me.ref)                      # Convert to factor
    me.ref <- me.ref[-c(1,2)]                        # Remove preamble
    # Confusion Matrix
    me.cm <- confusionMatrix(data = me.cm.pred,
                             reference = me.ref,
                             mode = "prec_recall"
    )
    test.output$cm <- c(test.output$cm, list(me.cm))  # push to output list
    
    
    # (4.2) table --------------------------------------------
    me.table <- table(me.ref, me.cm.pred)
    test.output$table <- c(test.output$table, list(me.table))  # push to output list
    
    
    # (4.3) ROCR Performance ------------------------------------
    me.rocr.pred <- prediction(as.numeric(me.glm.pred), 
                               as.numeric(me.ref))   # prediction=me.pred, reference=me.ref
    test.output$rocr.pred <- c(test.output$rocr.pred, me.rocr.pred)  # push to output list
    # AUC:
    me.rocr.perf.auc <- performance(me.rocr.pred, 
                                    measure = "auc")
    test.output$perf.auc <- c(test.output$perf.auc, me.rocr.perf.auc) # push to output list
    # acc/err:
    me.rocr.perf.accerr <- performance(me.rocr.pred, 
                                       measure = "acc", 
                                       x.measure = "err")
    test.output$perf.accerr <- c(test.output$perf.accerr, me.rocr.perf.accerr) # push to output list
    # tpr/fpr:
    me.rocr.perf.tprfpr <- performance(me.rocr.pred, 
                                       measure = "tpr", 
                                       x.measure = "fpr")
    test.output$perf.tprfpr <- c(test.output$perf.tprfpr, me.rocr.perf.tprfpr) # push to output list
    # recall:
    me.rocr.perf.recall <- performance(me.rocr.pred, 
                                       measure = "prec", 
                                       x.measure = "rec")
    test.output$perf.recall <- c(test.output$perf.recall, me.rocr.perf.recall) # push to output list
    
    # cat("$ Test:",i,"\n")
}
cat("$ Count of testing is (",i,")\n")


# Plot ROC (Tpr/Fpr) ----
xname <- test.output$perf.tprfpr[[1]]@x.name                       # name of x axis
yname <- test.output$perf.tprfpr[[1]]@y.name                       # name of y axis
xvalues <- sapply(test.output$perf.tprfpr, function(v) v@x.values) # list of values for x
yvalues <- sapply(test.output$perf.tprfpr, function(v) v@y.values) # list of values for y
xrange <- range(unlist(xvalues), na.rm = TRUE)                     # range of x axis
yrange <- range(unlist(yvalues), na.rm = TRUE)                     # range of y axis
# Add AUC comments
aucs <- sapply(test.output$perf.auc, function(v) v@y.values)       # get auc values
text <- sapply(aucs, function(x) sprintf("AUC = %f",x))            # translate auc values to strings

ggp.roc <- plotLines(title = "ROC Curve",
                     x.name = xname, y.name = yname,
                     x.values = xvalues, y.values = yvalues,
                     x.range = xrange, y.range = yrange,
                     index.text = text, index.pos = 4,
                     index.x = 0.6)                               # Generate plot
print(ggp.roc)                                                     # Display plot


# Plot Recall (prec/rec) ----
xname <- test.output$perf.recall[[1]]@x.name
yname <- test.output$perf.recall[[1]]@y.name 
xvalues <- sapply(test.output$perf.recall, function(v) v@x.values)
yvalues <- sapply(test.output$perf.recall, function(v) v@y.values)
xrange <- range(unlist(xvalues), na.rm = TRUE)
yrange <- range(unlist(yvalues), na.rm = TRUE)

ggp.recall <- plotLines(title = "Recall",
                        x.name = xname, y.name = yname,
                        x.values = xvalues, y.values = yvalues,
                        x.range = xrange, y.range = yrange)
print(ggp.recall)


# Plot Acc/Err ----
xname <- test.output$perf.accerr[[1]]@x.name
yname <- test.output$perf.accerr[[1]]@y.name 
xvalues <- sapply(test.output$perf.accerr, function(v) v@x.values)
yvalues <- sapply(test.output$perf.accerr, function(v) v@y.values)
xrange <- range(unlist(xvalues), na.rm = TRUE)
yrange <- range(unlist(yvalues), na.rm = TRUE)

ggp.accerr <- plotLines(x.name = xname, y.name = yname,
                        x.values = xvalues, y.values = yvalues,
                        x.range = xrange, y.range = yrange)
print(ggp.accerr)


# plot AUC ----
xname <- "Test"
yname <- test.output$perf.auc[[1]]@y.name 
xvalues <- 1:test.count
yvalues <- sapply(test.output$perf.auc, function(v) v@y.values)
xrange <- range(unlist(xvalues), na.rm = TRUE)
# yrange <- range(unlist(yvalues), na.rm = TRUE)
yrange = c(0,1)

ggp.auc <- plotPoints(title = "AUCs",
                      x.name = xname, y.name = yname,
                      x.values = xvalues, y.values = yvalues,
                      x.range = xrange, y.range = yrange,
                      smooth = TRUE)
print(ggp.auc)


# Combine 2 plots into one graph -------------
multiplot(ggp.roc, ggp.recall, cols=2)


