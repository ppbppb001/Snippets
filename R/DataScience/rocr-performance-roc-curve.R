library(caret)
library(ROCR)   
library(ggplot2)

# Define const -----------------------------
test.count <- 20
test.dlen <- 1000
test.split <- 0.7    # 70% as training data set
test.output <- list(ref = NULL,
                    glm.pred = NULL,
                    cm = NULL,
                    table = NULL,
                    rocr.pred = NULL,
                    perf.auc = NULL,
                    perf.recall = NULL,
                    perf.accerr = NULL,
                    perf.tprfpr = NULL
                    )


# Testing loop ----
#   1. prepare random data set
#   2. train/fit
#   3. predict
#   4. measure: confusion matrix / table / rocr performance
for (i in 1:test.count) {

    # (1) Prepare data set  ------------------------------
    set.seed(i*100+i)
    
    c1 <- sample(test.dlen)
    c1
    c2 <- sample(0:1,test.dlen,replace = TRUE)
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
    set.seed(666)
    
    me.glm.fit <- glm(formula = me.formula,
                     data = training,
                     method = "glm.fit",
                     family = binomial(link="logit"),
                     # control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
                     control = glm.control(maxit = 20, trace = FALSE)
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




# <Function>: Plot multiple points ---------------------------
plotPoints <- function(x.name="X", y.name="Y",
                      x.values=NULL, y.values=NULL,
                      x.range=c(0,1), y.range=c(0,1)) {
    
    pcnt <- length(x.values)
    pcnt.y <- length(y.values)
    if (pcnt==0 || pcnt.y==0 || pcnt!=pcnt.y)
        return(NULL)
    
    vx <- unlist(x.values)
    vx[which(is.nan(vx))] <- mean(vx, na.rm = TRUE)
    vy <- unlist(y.values)
    vy[which(is.nan(vy))] <- mean(vy, na.rm = TRUE)
    print(vy)
    
    ggp <- ggplot(
                data = data.frame(
                    CX = vx,
                    CY = vy
                ),
                aes(x = CX, y = CY)
            ) + 
            xlab(x.name) + ylab(y.name) +
            xlim(x.range[1], x.range[2]) +
            ylim(y.range[1], y.range[2])

    ggp <- ggp +
        geom_point(
            size = 4, 
            color = "steelblue",
            alpha = 0.8) +
        geom_smooth(
            color = "pink",
            alpha = 0.2)
        
    return(ggp)    
}


# <Function>: Plot multiple lines ----------------------------------
plotLines <- function(x.name="X", y.name="Y",
                      x.values=NULL, y.values=NULL,
                      x.range=c(0,1), y.range=c(0,1)) {
    
    pcnt <- length(x.values)
    pcnt.y <- length(y.values)
    if (pcnt==0 || pcnt.y==0 || pcnt!=pcnt.y)
        return(NULL)
    
    ggp <- ggplot() + 
            xlab(x.name) + ylab(y.name) +
            xlim(x.range[1], x.range[2]) + 
            ylim(y.range[1], y.range[2])
    
    for (xi in 1:pcnt) {
        vx <- x.values[[xi]]
        vx[which(is.nan(vx))] <- mean(vx, na.rm = TRUE)
        vy <- y.values[[xi]]
        vy[which(is.nan(vy))] <- mean(vy, na.rm = TRUE)
        
        ggp <- ggp +
            geom_line(
                data = data.frame(
                    CX = vx,
                    CY = vy
                ),
                aes(x = CX, y = CY),
                color = xi,
                size = 1,
                alpha = 0.5
            )
    }
    
    return(ggp)
}


# plot AUC ----
xname <- "Test"
yname <- test.output$perf.auc[[1]]@y.name 
xvalues <- 1:test.count
yvalues <- sapply(test.output$perf.auc, function(v) v@y.values)
xrange <- range(unlist(xvalues), na.rm = TRUE)
# yrange <- range(unlist(yvalues), na.rm = TRUE)
yrange = c(0,1)
ggp.auc <- plotPoints(x.name = xname, y.name = yname,
                      x.values = xvalues, y.values = yvalues,
                      x.range = xrange, y.range = yrange)
print(ggp.auc)


# Plot ROC (Tpr/Fpr) ----
xname <- test.output$perf.tprfpr[[1]]@x.name
yname <- test.output$perf.tprfpr[[1]]@y.name 
xvalues <- sapply(test.output$perf.tprfpr, function(v) v@x.values)
yvalues <- sapply(test.output$perf.tprfpr, function(v) v@y.values)
xrange <- range(unlist(xvalues), na.rm = TRUE)
yrange <- range(unlist(yvalues), na.rm = TRUE)
ggp.tprfpr <- plotLines(x.name = xname, y.name = yname,
                        x.values = xvalues, y.values = yvalues,
                        x.range = xrange, y.range = yrange)
print(ggp.tprfpr)

# Plot Recall (prec/rec) ----
xname <- test.output$perf.recall[[1]]@x.name
yname <- test.output$perf.recall[[1]]@y.name 
xvalues <- sapply(test.output$perf.recall, function(v) v@x.values)
yvalues <- sapply(test.output$perf.recall, function(v) v@y.values)
xrange <- range(unlist(xvalues), na.rm = TRUE)
yrange <- range(unlist(yvalues), na.rm = TRUE)
ggp.recall <- plotLines(x.name = xname, y.name = yname,
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
