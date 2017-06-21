# <ggplot2-test-glm-performance.r> -------------
#
# [2017-06-16]:
#   1) test metric funtions applicable to glm,
#      such as confusionmatrix(), table(), rocr 
#      performance()
#   2) test multi-layers chart plotting functions
#      in 'ggplot2-mytools-lib.r'
# [2017-06-21]:
#   1) Output 2 set of metrics: base and improved  
#
#-----------------------------------------------


library(caret)
library(ROCR)   
library(ggplot2)

source("ggplot2-mytools-lib.r")  # load code module: ggplot2-mytools-lib.r
                                 # locate in folder of 'Visualization'


#*************************************************
#
#   Functions
#
#*************************************************

#<predAndEval>: Predict and Evaluate ----
glmPredAndEval <- function(data.train = NULL,       # data frame as training set
                           data.test = NULL,        # data frame as testing set
                           name.ref = NULL) {       # name of reference/label column
    
    # Prepare output result:
    output <- list(cm = list(),
                   table = list(),
                   perf.tprfpr = list(),
                   perf.recall = list(),
                   perf.auc = list(),
                   perf.accerr = list()
    )
    
    formula <- paste0(name.ref, "~.")       # Set formula
    
    ref <- data.test[, name.ref]            # Set refrence data
    
    # [Train/Fit] -----------------------------------
    glm.fit <- glm(formula = formula,
                   data = data.train,
                   method = "glm.fit",
                   family = binomial(link="logit"),
                   control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
    )
    
    # [Predict] ------------------------------------------
    glm.pred <- predict(object = glm.fit,
                        newdata = data.test,
                        type = "response")
    
    # [Evaluate] -----------------------------------------
    # (1) confusion maxtrix:
    # Prepare prediction data for confusion matrix:
    cm.pred <- ifelse(glm.pred > 0.5, 1, 0)  # if pred > 0.5 then 1 else 0
    # prediction data to factor:
    cm.pred <- c(0, 1, cm.pred)                # Add preamble (0,1)
    cm.pred <- as.factor(cm.pred)              # Convert to factor
    cm.pred <- cm.pred[-c(1,2)]                # Remove preamble
    # reference data to factor:
    ref <- c(0, 1, ref)                        # Add preamble (0,1)
    ref <- as.factor(ref)                      # Convert to factor
    ref <- ref[-c(1,2)]                        # Remove preamble
    # Confusion Matrix
    cm <- confusionMatrix(data = cm.pred,
                          reference = ref,
                          mode = "prec_recall"
    )
    output$cm <- c(output$cm, list(cm))  # push to output list
    
    # (2) table:
    table <- table(ref, cm.pred)
    output$table <- c(output$table, list(table))  # push to output list
    
    
    # (3) ROCR Performance:
    rocr.pred <- prediction(as.numeric(glm.pred), 
                            as.numeric(ref))   # prediction=me.pred, reference=me.ref
    # tpr/fpr (ROC):
    rocr.perf.tprfpr <- performance(rocr.pred, 
                                    measure = "tpr", 
                                    x.measure = "fpr")
    output$perf.tprfpr <- c(output$perf.tprfpr, rocr.perf.tprfpr) # push to output list
    # recall:
    rocr.perf.recall <- performance(rocr.pred, 
                                    measure = "prec", 
                                    x.measure = "rec")
    output$perf.recall <- c(output$perf.recall, rocr.perf.recall) # push to output list
    # AUC:
    rocr.perf.auc <- performance(rocr.pred, 
                                 measure = "auc")
    output$perf.auc <- c(output$perf.auc, rocr.perf.auc) # push to output list
    # acc/err:
    rocr.perf.accerr <- performance(rocr.pred, 
                                    measure = "acc", 
                                    x.measure = "err")
    output$perf.accerr <- c(output$perf.accerr, rocr.perf.accerr) # push to output list
    
    return(output)
}

#<subsetByFeatures>: subset a data frame by names of selected features ----
subsetByFeatures <- function(data = NULL, feature.names = NULL) {
    if (is.null(data)) return(NULL)
    if (is.null(feature.names)) return(NULL)
    
    data.names <- names(data)
    feature.ix <- sapply(feature.names, function(x) which(data.names==x))
    return(subset(data, select = feature.ix))
}


#<pushMetrics>: Push metrics to the output list ----
pushMetrics <- function(output, input) {
    
    output$cm <- c(output$cm, input$cm)
    output$table <- c(output$table, input$table)
    output$perf.tprfpr <- c(output$perf.tprfpr, input$perf.tprfpr) # push to output list
    output$perf.recall <- c(output$perf.recall, input$perf.recall)  # push to output list
    output$perf.auc <- c(output$perf.auc, input$perf.auc)           # push to output list
    output$perf.accerr <- c(output$perf.accerr, input$perf.accerr)  # push to output list
    
    return(output)
}

# <pseudoDataSetBase>: make a pseudo data set as the base ----
pseudoDataSetBase <- function(rows){
    c1 <- sample(rows)                      # col-1 of pseudo data set
    c2 <- sample(rows)
    c3 <- sample(rows)
    label <- sample(0:1, rows, replace = TRUE)   # col-2 of pseudo data set
    
    df <- data.frame(B1 = c1,
                     B2 = c2,
                     B3 = c3,
                     Label = label)
    return(df)
}

# <pseudoDataSetExtra>: make a pseudo data set as extra source ----
pseudoDataSetExtra <- function(rows){
    c1 <- sample(rows)                      # col-1 of pseudo data set
    c2 <- sample(rows)
    c3 <- sample(rows)
    c4 <- sample(rows)
    c5 <- sample(rows)
    c6 <- sample(rows)
    c7 <- sample(rows)
    c8 <- sample(rows)
    c9 <- sample(rows)
    c10 <- sample(rows)
    df <- data.frame(P1 = c1,
                     P2 = c2,
                     P3 = c3,
                     P4 = c4,
                     P5 = c5,
                     P6 = c6,
                     P7 = c7,
                     P8 = c8,
                     P9 = c9,
                     P10 = c10
                    )
    return(df)
}

# <plotPerformance>: Plot performance curves ----
plotPerformance <- function(perfm = NULL, title = NULL, text = NULL) {
    xname <- perfm[[1]]@x.name                          # name of x axis
    yname <- perfm[[1]]@y.name                          # name of y axis
    xvalues <- sapply(perfm, function(v) v@x.values)    # list of values for x
    yvalues <- sapply(perfm, function(v) v@y.values)    # list of values for y
    xrange <- range(unlist(xvalues), na.rm = TRUE)      # range of x axis
    yrange <- range(unlist(yvalues), na.rm = TRUE)      # range of y axis  
    
    ggp <- plotLines(title = title,
                     x.name = xname, y.name = yname,
                     x.values = xvalues, y.values = yvalues,
                     x.range = xrange, y.range = yrange,
                     index.text = text, index.pos = 4,
                     index.x = 0.65)  
    
    return(ggp)
}




#***********************************
#
#   Main: Testing
#
#***********************************

# Initializations ----------------------------------------------------------

# Define varibles to store metrics:  
metrics.template <- list(ref = list(),            # list of reference data sets
                         glm.pred = list(),       # list of glm predictions
                         cm = list(),             # list of confusion matrix
                         table = list(),          # list of tables
                         rocr.pred = list(),      # list of rocr predictioin objects
                         perf.tprfpr = list(),    # list of rocr performance objects for ROC
                         perf.auc = list(),       # list of rocr performance objects for AUC
                         perf.recall = list(),    # list of rocr performance objects for Recall
                         perf.accerr = list()     # list of rocr performance objects for Acc/Err
)                      
metrics.base <- metrics.template         # list of metrics for base data set 
metrics.improve <- metrics.template      # list of metrics for improved data set

# Define key params for testing data set:
test.count <- 10     # number of testing runs
test.dlen <- 1000    # length of testing data set
test.split <- 0.7    # 70% as training data set

# Define a set of selected features in 'df.extra' to be appened to 'df.base'
# for the sake of performance
features.select <- c("P3",
                     "P5",
                     "P7")   # selected feature to be append to 'df.base'

# Make base/extra/imrpove data set:
set.seed(777)
df.base <- pseudoDataSetBase(test.dlen)     # make pseudo base data set
df.extra <- pseudoDataSetExtra(test.dlen)   # make pseudo extra data set
df.extra.select <- subset(df.extra, 
                          select = features.select)  # get a subset of df.extra by features.select
df.improve <- cbind(df.base, df.extra.select)  # df.improve = df.base + df.extra.select


# Testing loops --------------------------------------------------

#   1. partition data est
#   2. train(fit)/predict/measure
for (i in 1:test.count) {
    
    # (1) Partition pseudo data set
    set.seed(i*100+i)
    
    xi <- sample(test.dlen)                   # random indices for partitioning      
    inTrain = xi[1:(test.dlen * test.split)]  # indices for training data set

    training.base <- df.base[inTrain, ]       # training data set of 'df.base'
    testing.base <- df.base[-inTrain, ]       # testing data set of 'df.base'

    training.improve <- df.improve[inTrain, ] # training data set of 'df.improve'
    testing.improve <- df.improve[-inTrain, ] # testing data set of 'df.improve'
    
    # (2) predict and evaluate:
    # for 'df.base'
    result <- glmPredAndEval(data.train = training.base,
                             data.test = testing.base,
                             name.ref = "Label")
    metrics.base <- pushMetrics(metrics.base, result)   # save metrics to output list
    
    # for 'df.improve'
    result <- glmPredAndEval(data.train = training.improve,
                             data.test = testing.improve,
                             name.ref = "Label")
    metrics.improve <- pushMetrics(metrics.improve, result)  # save metrics to output list
    
}
cat("$ Count of testing is (",i,")\n")



#***********************************
#
#   Main: Output
#
#***********************************

# Generate metrics plots ------------------------------

# Generate ROC (Tpr/Fpr) plot:
# Base:
aucs <- sapply(metrics.base$perf.auc, function(v) v@y.values)      # get auc values
text <- sapply(aucs, function(x) sprintf("AUC = %f",x))            # make AUC labels
# text <- c(text, " ", " ", " ", " ")                              # padding text with empty lines
ggp.roc.base <- plotPerformance(perfm = metrics.base$perf.tprfpr,
                                title = "ROC Curves (Base)",
                                text = text)
# Improved:
aucs <- sapply(metrics.improve$perf.auc, function(v) v@y.values)   # get auc values
text <- sapply(aucs, function(x) sprintf("AUC = %f",x))            # make AUC labels
# text <- c(text, " ", " ", " ", " ")                              # padding text with empty lines
ggp.roc.improve <- plotPerformance(perfm = metrics.improve$perf.tprfpr,
                                   title = "ROC Curves (Improved)",
                                   text = text)

# Generate Recall (prec/rec) plot ----
# Base:
ggp.recall.base <- plotPerformance(perfm = metrics.base$perf.recall,
                                   title = "Recall Curves (Base)")
# Improved:
ggp.recall.improve <- plotPerformance(perfm = metrics.improve$perf.recall,
                                      title = "Recall Curves (Improved)")

# Generate Acc/Err plot ----
# Base:
ggp.accerr.base <- plotPerformance(perfm = metrics.base$perf.accerr,
                                   title = "Accuracy/Error (Base)")
# Improved:
ggp.accerr.improve <- plotPerformance(perfm = metrics.improve$perf.accerr,
                                      title = "Accuracy/Error (Improved)")


# Display metrics plots ------------------------------

# Dispaly single plot:
print(ggp.roc.base)           # Display plot of ROC/base 
print(ggp.roc.improve)        # Display plot of ROC/improved

print(ggp.recall.base)        # Display plot of Recall/base 
print(ggp.recall.improve)     # Display plot of Recall/improved

print(ggp.accerr.base)        # Display plot of AccErr/base 
print(ggp.accerr.improve)     # Display plot of AccErr/improved

# Display 2 plots combined into one graph:
# ROC/base and ROC/improve
multiplot(ggp.roc.base, 
          ggp.roc.improve, 
          cols = 2)

# Recall/base and Recall/improve
# multiplot(ggp.recall.base, 
#           ggp.recall.improve, 
#           cols = 2)

# AccErr/base and AccErr/improve
# multiplot(ggp.accerr.base,
#           ggp.accerr.improve,
#           cols = 2)



