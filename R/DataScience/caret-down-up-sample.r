#---------------------------------------------
# <carte-down-up-sample.r>
#  Showing how to use down/up sample
#  function in caret package
#---------------------------------------------


library(caret)


dlen <- 100       # length of test data
offset <- 70      # len(sample(0:1)) = dlen-offset, len(1)=offset

# Build values
tmp <- sample(0:1, size=(dlen-offset), replace = TRUE)
values <- c(tmp, rep(1,offset))

# Build classes
classes <- ifelse(values==0, "C", "A")   # 0=C=Cancel, 1=A=Approve
classes


# Make target data.frame
df.target <- data.frame(Values = values,
                        Classes = classes,
                        stringsAsFactors = F)
head(df.target)

# Down-Sample
df.down <- downSample(df.target[, 'Values'], 
                      as.factor(df.target[,'Classes']))
nrow(df.down)

# Up-Sample
df.up <- upSample(df.target[, 'Values'], 
                  as.factor(df.target[,'Classes']))
nrow(df.up) 


# Check integrity of output:
classes.cntA <- length(which(classes=="A"))
classes.cntA                                 # count of class-A (Approved)
classes.cntC <- length(which(classes=="C"))
classes.cntC                                 # count of class-C (Cancelled)
nrow(df.down) == min(classes.cntA, classes.cntC)*2  # check size of down-sample output
nrow(df.up) == max(classes.cntA, classes.cntC)*2    # check size of up-sample output



