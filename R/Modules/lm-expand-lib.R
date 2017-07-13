# <lm-expand-lib.r> -------------------------------
#
#  functions for expandable lm comparison
#  
# [2016-01-09] - r1: Initial 
# [2016-01-12] - r2: ouput glm.pred
# [2016-01-13] - r3: ouput data.train and data.test
#--------------------------------------------------

library(caret)
library(ROCR)
library(ggplot2)


# <glmComparison>: main entry -----------------------------------------
glmComparison <- function(
    data.base = NULL,       # base data frame
    data.ext = NULL,        # extra data frame
    name.date = "Date",     # name of date column
    name.key = "Key",       # name of key column
    name.class = "Class",   # name of class column
    names.ext = NULL,       # name of columns of extra data frame
    date.train = NULL,      # c(start,end), start/end is char as "yyyy-mm-dd"
    date.test = NULL,       # c(start,end), start/end is char as "yyyy-mm-dd", when mode==2
    mode = 1,               # 1=train calc, 2=pred calc
    iteration = 5,          # number of iterations
    balance = 1             # balance of classification tags
){
    
    # (1) Initializations -------------------------------
    # Check input params
    if (is.null(data.base)) return(NULL)
    if (is.null(name.date)) return(NULL)
    if (is.null(name.key)) return(NULL)
    if (is.null(name.class)) return(NULL)
    if (is.null(date.train)) return(NULL)
    if (mode == 2){
        if (is.null(date.test)) return(NULL)
    }
    
    # Define varibles to store measures:  
    measures.template <- list(
        data.train = list(),     # list of data frame for training
        data.test = list(),      # list of data frame for testing
        # ref = list(),            # list of reference data sets
        glm.pred = list(),       # list of glm predictions
        cm = list(),             # list of confusion matrix
        table = list(),          # list of tables
        # rocr.pred = list(),      # list of rocr predictioin objects
        perf.tprfpr = list(),    # list of rocr performance objects for ROC
        perf.auc = list(),       # list of rocr performance objects for AUC
        perf.recall = list(),    # list of rocr performance objects for Recall
        perf.accerr = list()     # list of rocr performance objects for Acc/Err
    )                      
    measures.b <- measures.template     # list of metrics for base data set 
    measures.e <- measures.template      # list of metrics for extended data set
    
    
    # (2) Prepare data set -----------------------------
    df.e <- NULL
    df.e.train <- NULL
    df.b.test <- NULL
    df.e.test <- NULL
    
    # data.base[, name.key] <- as.character(data.base[, name.key]) # remove factors
    
    # Merge base and ext:
    if (!is.null(data.ext)) {
        # data.ext[, name.key] <- as.character(data.ext[, name.key]) # remove factors
        
        # subset of data.ext by the given columns:
        df.ext <- subsetByColumns(data = data.ext,
                                  colnames = c(name.key, names.ext))
        
        # merge data.base and data.base by key column:
        ix.s1 <- data.base[, name.key] %in% df.ext[, name.key] 
        df.base.sub <- data.base[ix.s1, ]
        
        ix.s2 <- df.ext[, name.key] %in% data.base[, name.key]
        df.ext.sub <- df.ext[ix.s2, ]
        
        df.e <- merge(df.base.sub, 
                      df.ext.sub, 
                      by.x = name.key,
                      sort = FALSE)
    }
    
    # Select by range of date:
    df.b.train <- subsetByDateRange(data = data.base,
                                    colname = name.date,
                                    dates = date.train)
    if (!is.null(df.e)) {
        df.e.train <- subsetByDateRange(data = df.e,
                                        colname = name.date,
                                        dates = date.train)
    }
    if (mode == 2) {
        df.b.test <- subsetByDateRange(data = data.base,
                                       colname = name.date,
                                       dates = date.test)
        if (!is.null(df.e)) {
            df.e.test <- subsetByDateRange(data = df.e,
                                           colname = name.date,
                                           dates = date.test)
        }
    }
    
    # Remove unused columnus = c(date, key):
    # if (!is.null(df.b.train)) {
    #     df.b.train <- df.b.train[, !(names(df.b.train) %in% c(name.date, name.key))]
    # }
    # if (!is.null(df.e.train)) {
    #     df.e.train <- df.e.train[, !(names(df.e.train) %in% c(name.date, name.key))]
    # }
    # if (!is.null(df.b.test)) {
    #     df.b.test <- df.b.test[, !(names(df.b.test) %in% c(name.date, name.key))]
    # }
    # if (!is.null(df.e.test)) {
    #     df.e.test <- df.e.test[, !(names(df.e.test) %in% c(name.date, name.key))]
    # }
    
    
    # (3) Train/Test looping ------------------------------
    split <- 0.7                 # split of training vs testing
    for (i in 1:iteration) {
        set.seed(i*100 + i)
        
        # (i) partitioning data set ----
        # for base data set:
        len.b <- nrow(df.b.train)
        xi.b <- sample(len.b)
        inTrain.b <- xi.b[1:(len.b * split)]
        training.b <- df.b.train[inTrain.b, ]
        if (mode == 1) {
            testing.b <- df.b.train[-inTrain.b, ]
        } else {
            testing.b <- df.b.test
        }
        
        # for extended data set:
        if (!is.null(df.e)) {
            len.e <- nrow(df.e.train)
            ix.e <- sample(len.e)
            inTrain.e <- ix.e[1:(len.e * split)]
            training.e <- df.e.train[inTrain.e, ]
            if (mode == 1) {
                testing.e <- df.e.train[-inTrain.e, ]
            } else {
                testing.e <- df.e.test
            }
        } else {
            training.e <- NULL
            testing.e <- NULL
        }
        
        # (ii) predict and evaluate ----
        # for base data set:
        result <- glmPredAndEval(data.train = training.b,
                                 data.test = testing.b,
                                 name.ref = name.class,
                                 names.remove = c(name.date, name.key),
                                 balance = balance)
        measures.b <- pushMetrics(measures.b, result)   # save metrics to output list
        
        # for extended data set:
        if (!is.null(training.e) && !is.null(testing.e)) {
            result <- glmPredAndEval(data.train = training.e,
                                     data.test = testing.e,
                                     name.ref = name.class,
                                     names.remove = c(name.date, name.key),
                                     balance = balance)
            measures.e <- pushMetrics(measures.e, result)   # save metrics to output list
        }
        
    }
    
    
    # (4) Return the metrics ------------------------------
    measures <- c(list(measures.b), list(measures.e))
    names(measures) <- c("base", "extend")
    return(measures)
}


#<predAndEval>: Predict and Evaluate ----
glmPredAndEval <- function(data.train = NULL,       # data frame as training set
                           data.test = NULL,        # data frame as testing set
                           name.ref = NULL,         # name of reference/label column
                           names.remove = NULL,     # names of column to be removed before calculating
                           balance = NULL           # balance of class/ref
) {       
    
    # Prepare output result:
    output <- list(
                   data.train = list(),
                   data.test = list(),
                   glm.pred = list(), 
                   cm = list(),
                   table = list(),
                   perf.tprfpr = list(),
                   perf.recall = list(),
                   perf.auc = list(),
                   perf.accerr = list()
                  )
    
    # Remove unused columnus = c(date, key):
    df.train <- data.train[, !(names(data.train) %in% names.remove)]
    df.test <- data.test[, !(names(data.test) %in% names.remove)]

    formula <- paste0(name.ref, "~.")     # Set formula
    ref <- df.test[, name.ref]            # Set reference data
    
    # [Balance train data] --------------------------
    if (!is.null(balance)) {
        df.train <- binaryBalance(data = df.train,
                                  name.class = name.ref,
                                  balance = balance)
    }
    
    # [Train/Fit] -----------------------------------
    glm.fit <- glm(formula = formula,
                   data = df.train,
                   method = "glm.fit",
                   family = binomial(link="logit"),
                   control = glm.control(epsilon = 1e08, maxit = 10, trace = FALSE)
    )
    output$data.train <- list(data.train)  # r3: save training data to ouput
    
    # [Predict] ------------------------------------------
    glm.pred <- predict(object = glm.fit,
                        newdata = df.test,
                        type = "response")
    output$glm.pred <- list(glm.pred)      # r2: save pred to output list
    output$data.test <- list(data.frame(data.test, Pred = glm.pred))  # r3: save data.test to output list
    
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
    # Generate Confusion Matrix:
    # cm <- confusionMatrix(data = cm.pred,
    #                       reference = ref,
    #                       mode = "prec_recall"
    # )
    # output$cm <- list(cm)  
    
    # (2) table:
    table <- table(ref, cm.pred)
    # output$table <- c(output$table, list(table))  # push to output list
    output$table <- list(table)            
    
    
    # (3) ROCR Performance:
    rocr.pred <- prediction(as.numeric(glm.pred), 
                            as.numeric(ref))   # prediction=me.pred, reference=me.ref
    
    # tpr/fpr (ROC):
    rocr.perf.tprfpr <- performance(rocr.pred, 
                                    measure = "tpr", 
                                    x.measure = "fpr")
    output$perf.tprfpr <- rocr.perf.tprfpr     
    
    # recall:
    rocr.perf.recall <- performance(rocr.pred, 
                                    measure = "prec", 
                                    x.measure = "rec")
    output$perf.recall <- rocr.perf.recall     
    
    # AUC:
    rocr.perf.auc <- performance(rocr.pred, 
                                 measure = "auc")
    output$perf.auc <- rocr.perf.auc           
    
    # acc/err:
    rocr.perf.accerr <- performance(rocr.pred, 
                                    measure = "acc", 
                                    x.measure = "err")
    output$perf.accerr <- rocr.perf.accerr     
    
    return(output)
}


#<subsetByColumns>: subset a data frame by names of selected features(columns) ----
subsetByColumns <- function(data = NULL, colnames = NULL) {
    if (is.null(data)) return(NULL)
    if (is.null(colnames)) return(NULL)
    
    data.names <- names(data)
    feature.ix <- sapply(colnames, function(x) which(data.names==x))
    return(subset(data, select = feature.ix))
}


#<subsetByDateRange>: subset a data frame by range of date ----
# dates = c(start, end), format="yyyy-mm-dd"
subsetByDateRange <- function(data = NULL, colname = "Date", dates = NULL) {
    if (is.null(data)) return(NULL)
    if (is.null(dates)) return(NULL)
    if (length(dates) < 2) return(NULL)
    
    data.date <- as.character(data[,colname])
    ixs <- which(data.date>=dates[1] & data.date<=dates[2] )
    
    return(data[ixs,])
}


#<pushMetrics>: Push metrics to the output list ----
pushMetrics <- function(output, input) {
    
    output$data.train <- c(output$data.train, input$data.train)
    output$data.test <- c(output$data.test, input$data.test)
    output$glm.pred <- c(output$glm.pred, input$glm.pred)
    output$cm <- c(output$cm, input$cm)
    output$table <- c(output$table, input$table)
    output$perf.tprfpr <- c(output$perf.tprfpr, input$perf.tprfpr)  
    output$perf.recall <- c(output$perf.recall, input$perf.recall)  
    output$perf.auc <- c(output$perf.auc, input$perf.auc)       
    output$perf.accerr <- c(output$perf.accerr, input$perf.accerr)
    
    return(output)
}


# <binaryBalance>: Balance data frame classified by binary tags ----
binaryBalance <- function(data = NULL, 
                          name.class = "Class", 
                          balance = 1) {
    if (is.null(data)) {
        return(NULL)
    }
    
    ix <- which(data[,name.class] == 1)
    len.one <- length(ix)
    if (len.one == 0) {
        return(data)
    }
    
    len.all <- nrow(data)
    x <- as.double(len.one) / as.double(len.all)
    k <- ((1-x)/x) * balance
    k <- round(k) - 1
    if (k<=0) {
        return(data)
    }
    
    ixe <- rep(ix, k)
    dfx <- rbind(data,data[ixe,])
    rownames(dfx) <- 1:nrow(dfx)
    return(dfx)
}


# <Function>: Plot multiple lines ----------------------------------
# input: title = character, title of this plot
#        x.name, y.name = character, string of x/y axis
#        x.values, y.values = list(numeric), list of values of x/y coordinate
#        x.range, y.range = 2-elements numeric vector, range of x/y axis
#        index.text = multi-elements character vector, strings of multi-lines comments
#        index.text = 1..4, 1:up-left, 2:lower-left, 3:upper-right, 4:lower-right
plotLines <- function(title = NULL,
                      x.name="X", y.name="Y",
                      x.values=NULL, y.values=NULL,
                      x.range=c(0,1), y.range=c(0,1),
                      index.text = NULL, index.pos = 4, index.x = 0.75) {
    
    # Check input values:
    pcnt <- length(x.values)
    pcnt.y <- length(y.values)
    if (pcnt==0 || pcnt.y==0 || pcnt!=pcnt.y)
        return(NULL)
    
    # check index.text
    tlen <- length(index.text)
    if (tlen < pcnt) {
        for (i in (tlen+1):pcnt) {
            index.text <- c(index.text, sprintf("#%2d",i))
        }
    }
    # padding index.text
    n <- max(nchar(index.text))
    index.text <- ifelse(nchar(index.text) < n, 
                         paste0(index.text, strrep(" ", (n - nchar(index.text)))),
                         index.text)
    index.color <- sprintf("Color-%d",1:length(index.text))
    
    # basic plot
    ggp <- ggplot(data.frame(Group=index.text)) +
        labs(x = x.name, y = y.name, title = title) +
        xlim(x.range[1], x.range[2]) + 
        ylim(y.range[1], y.range[2])
    
    for (xi in 1:pcnt) {
        # data
        vx <- x.values[[xi]]
        vx[which(is.nan(vx))] <- mean(vx, na.rm = TRUE)
        vy <- y.values[[xi]]
        vy[which(is.nan(vy))] <- mean(vy, na.rm = TRUE)
        
        # line
        gl <- geom_line(
            data = data.frame(
                Index = index.text[xi],
                IndexColor = index.color[xi],
                X = vx,
                Y = vy
            ),
            aes(x = X, y = Y, color = IndexColor),
            size = 1,
            alpha = 0.5)
        ggp <- ggp + gl
    }
    
    # Change color manually:
    # cloffset <- 400
    # ggp <- ggp +
    #         scale_color_manual(values=colors()[(1+cloffset) : (pcnt+cloffset)])
    
    # Text?
    if (tlen > 0) {
        if (bitwAnd(index.pos-1, 0x02) == 0) {
            t.x1 <- x.range[1]
        } else {
            # t.x1 <- x.range[2]
            t.x1 <- (x.range[2] - x.range[1])*index.x
        }
        if (bitwAnd(index.pos-1, 0x01) == 0) {
            t.y1 <- y.range[2] 
            t.y2 <- (y.range[2] - y.range[1])*0.6
        } else {
            t.y1 <- (y.range[2] - y.range[1])*0.4
            t.y2 <- y.range[1] 
        }
        
        df.index <- data.frame(
            Index = index.text[1:tlen],
            IndexColor = index.color,
            X = t.x1,
            Y = seq(from=t.y1, to=t.y2, length.out = tlen)
        )
        
        ggp <- ggp +
            geom_text(
                data = df.index,
                aes(x = X, y = Y, label = Index, color = IndexColor),
                hjust = "left"
                # family = "mono", fontface = "bold"
            )
    }
    
    # Remove legend:
    ggp <- ggp +
        theme(legend.position="none")
    
    return(ggp)
}


# <Function>: multiPlot ----------------------------------
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain this subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                            layout.pos.col = matchidx$col))
        }
    }
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


# <plotGlmMeasures>: Plot measures output by <glmComparison>  ----
plotGlmMeasures <- function(measures = NULL, 
                            name = NULL) {
    
    if (is.null(measures)) return(NULL)
    if (is.null(name)) return(NULL)
    
    # ROC curve (tpr/fpr): ...................................
    if (tolower(name[1]) == "roc") {
        # Base:
        aucs <- sapply(measures$base$perf.auc, function(v) v@y.values)      # get auc values
        text <- sapply(aucs, function(x) sprintf("AUC = %f",x))            # make AUC labels
        # text <- c(text, " ", " ", " ", " ")                              # padding text with empty lines
        ggp.roc.b <- plotPerformance(perfm = measures$base$perf.tprfpr,
                                     title = "ROC Curves (Base)",
                                     text = text)
        # Extended:
        if (length(measures$extend$table) > 0) {
            aucs <- sapply(measures$extend$perf.auc, function(v) v@y.values)   # get auc values
            text <- sapply(aucs, function(x) sprintf("AUC = %f",x))            # make AUC labels
            # text <- c(text, " ", " ", " ", " ")                              # padding text with empty lines
            ggp.roc.e <- plotPerformance(perfm = measures$extend$perf.tprfpr,
                                         title = "ROC Curves (Expand)",
                                         text = text)
        } else {
            ggp.roc.e <- NULL
        }
        
        # Plot:
        if (is.null(ggp.roc.e)) {
            print(ggp.roc.b)
        } else {
            multiplot(ggp.roc.b, 
                      ggp.roc.e, 
                      cols = 2)
        }
        
        return(NULL)
    }
    
    # Recall (prec/rec) ......................................
    if (tolower(name[1]) == "recall") {
        # Base:
        ggp.recall.b <- plotPerformance(perfm = measures$base$perf.recall,
                                        title = "Recall Curves (Base)")
        # Extended:
        if (length(measures$extend$table) > 0) {
            ggp.recall.e <- plotPerformance(perfm = measures$extend$perf.recall,
                                            title = "Recall Curves (Expand)")
        } else {
            ggp.recall.e <- NULL
        }
        
        # Plot:
        if (is.null(ggp.recall.e)) {
            print(ggp.recall.b)
        } else {
            multiplot(ggp.recall.b, 
                      ggp.recall.e, 
                      cols = 2)
        }
        
        return(NULL)
    }
    
    # Acc/Err ......................................
    if (tolower(name[1]) == "accuracy") {
        # Base:
        ggp.accerr.b <- plotPerformance(perfm = measures$base$perf.accerr,
                                        title = "Accuracy/Error (Base)")
        # Extended:
        if (length(measures$extend$table) > 0) {
            ggp.accerr.e <- plotPerformance(perfm = measures$extend$perf.accerr,
                                            title = "Accuracy/Error (Expand)")
        } else {
            ggp.accerr.e <- NULL
        }
        
        # Plot:
        if (is.null(ggp.accerr.e)) {
            print(ggp.accerr.b)
        } else {
            multiplot(ggp.accerr.b, 
                      ggp.accerr.e, 
                      cols = 2)
        }
        
        return(NULL)
    }
    
    return(NULL)
} 


# <retrieveGlmMeasures>: retrieve measures output by <glmComparison>  ----
# return: list of measure
retrieveGlmMeasures <- function(measures = NULL, 
                                set = "base",
                                name = NULL) {
    
    if (is.null(measures)) return(NULL)
    if (is.null(set)) return(NULL)
    if (is.null(name)) return(NULL)
    
    set <- tolower(set[1])
    
    # data.train .............................
    if (tolower(name[1]) == "train") {
        return(measures[[set]][["data.train"]])
    }
    
    # data.test .............................
    if (tolower(name[1]) == "test") {
        return(measures[[set]][["data.test"]])
    }
    
    # glm.prediction .............................
    if (tolower(name[1]) == "pred") {
        return(measures[[set]][["glm.pred"]])
    }
    
    # CM/ConfusionMatrix .............................
    if (tolower(name[1]) == "cm") {
        return(measures[[set]][["cm"]])
    }
    
    # Tabel .............................
    if (tolower(name[1]) == "table") {
        return(measures[[set]][["table"]])
    }
    
    # AUC ...............................
    if (tolower(name[1]) == "auc") {
        x <- sapply(measures[[set]][["perf.auc"]], function(x) x@y.values)
        return(x)
    }
    
    # ROC ...............................
    if (tolower(name[1]) == "roc") {
        return(measures[[set]][["perf.tprfpr"]])
    }
    
    # Recall ...............................
    if (tolower(name[1]) == "recall") {
        return(measures[[set]][["perf.recall"]])
    }
    
    # Accuracy ...............................
    if (tolower(name[1]) == "accuracy") {
        return(measures[[set]][["perf.accerr"]])
    }
    
    
    return(NULL)
}

