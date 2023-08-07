
# load the library
library(mlbench)
library(caret)

library(doParallel)
library(foreach)

# load the data
data(PimaIndiansDiabetes)
# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# control <- rfeControl(functions=rfFuncs, method="cv", number=5)



# Original ########################################################################
# run the RFE algorithm
set.seed(7) # ensure the results are repeatable
tk1 <- as.numeric(Sys.time()) * 1000
results <- rfe(PimaIndiansDiabetes[,1:8], PimaIndiansDiabetes[,9], sizes=c(1:8), rfeControl=control)
tkx1 <- as.numeric(Sys.time()) * 1000 - tk1

# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
plot(results, type=c("g", "o"))




# DFX8 #########################################################

# Prepare data set: dfx8
dfx8 <- PimaIndiansDiabetes



# run RFE in single thread ..............................
tk1 <- as.numeric(Sys.time()) * 1000
set.seed(7) # ensure the results are repeatable
resx8 <- rfe(dfx8[,1:8], dfx8[,9], sizes=c(1:8), rfeControl=control)
tkx8 <- as.numeric(Sys.time()) * 1000 - tk1
# summarize the results
print(resx8)
# list the chosen features
predictors(resx8)
# plot the results
plot(resx8, type=c("g", "o"))


# run RFE in parallel ...................................
ncores <- 8  # cores to be utilized
c1 <- makeCluster(ncores)
registerDoParallel(c1)
lssize <- list()

lssize[[1]] <- c(1)
lssize[[2]] <- c(2)
lssize[[3]] <- c(3)
lssize[[4]] <- c(4)
lssize[[5]] <- c(5)
lssize[[6]] <- c(6)
lssize[[7]] <- c(7)
lssize[[8]] <- c(8) # the last core MUST be allocated with ONE task doing the MAX!


# MAP
lsres <-list()
tk1 <- as.numeric(Sys.time()) * 1000
lsres <- foreach(i=1:ncores) %dopar% {
    set.seed(7) # ensure the results are repeatable
    caret::rfe(dfx8[,1:8], dfx8[,9], sizes=lssize[[i]], rfeControl=control)
}
tkp8 <- as.numeric(Sys.time()) * 1000 - tk1
stopCluster(c1)

#print(lsres)
# resp8 <- lsres[[1]]
# resp8$results <- lsres[[1]]$results[1,]
# for (i in c(2:ncores)){
#     resp8$results <- rbind(resp8$results, lsres[[i]]$results[1,])
# }
# print (resp8)

# REDUCE (in general)
resp8 <- lsres[[1]]
resp8$results <- lsres[[1]]$results[-nrow(lsres[[1]]$results),]
for (i in c(2:(ncores-1))){
    resp8$results <- rbind(resp8$results, lsres[[i]]$results[-nrow(lsres[[i]]$results),])
}
resp8$results <- rbind(resp8$results, lsres[[ncores]]$results[1,])
print (resp8)

# summarize the results
print(resp8)
# list the chosen features
predictors(resp8)
# plot the results
plot(resp8, type=c("g", "o"))





# DFX16 #########################################################

# Define control of random forest
control <- rfeControl(functions=rfFuncs, method="cv", number=10)

# Prepare pseudo data set: dfx16
dfx16 <- PimaIndiansDiabetes[,1:8]
for (i in seq(8)) {
    dfx16[i+8] <- dfx16[i] * dfx16[i]
}
dfx16$tags <- PimaIndiansDiabetes$diabetes

# run RFE in single thread ....................................
tk1 <- as.numeric(Sys.time()) * 1000
set.seed(7) # ensure the results are repeatable
resx16 <- rfe(dfx16[,1:16], dfx16[,17], sizes=c(1:16), rfeControl=control)
tkx16 <- as.numeric(Sys.time()) * 1000 - tk1

# summarize the results
print(resx16)
# list the chosen features
predictors(resx16)
# plot the results
plot(resx16, type=c("g", "o"))




# run RFE in parallel ........................................

# Allocate computing resource
available_cores <- detectCores(logical = F)

ncores <- 8  # cores to be utilized
c1 <- makeCluster(ncores)
registerDoParallel(c1)

lssize <- list()
lssize[[1]] <- c(1:3)
lssize[[2]] <- c(4:6)
lssize[[3]] <- c(7:8)
lssize[[4]] <- c(9:10)
lssize[[5]] <- c(11:12)
lssize[[6]] <- c(13:14)
lssize[[7]] <- c(15)
lssize[[8]] <- c(16)   # the last core MUST be allocated with ONE task doing the MAX!

# MAP
lsres <-list()

tk1 <- as.numeric(Sys.time()) * 1000
set.seed(7) # ensure the results are repeatable
lsres <- foreach(i=1:ncores) %dopar% {
    caret::rfe(dfx16[,1:16], dfx16[,17], sizes=lssize[[i]], rfeControl=control)
}
tkp16 <- as.numeric(Sys.time()) * 1000 - tk1
stopCluster(c1)
#print(lsres)

# REDUCE
resp16 <- lsres[[1]]
resp16$results <- lsres[[1]]$results[-nrow(lsres[[1]]$results),]
for (i in c(2:(ncores-1))){
    resp16$results <- rbind(resp16$results, lsres[[i]]$results[-nrow(lsres[[i]]$results),])
}
resp16$results <- rbind(resp16$results, lsres[[ncores]]$results[1,])

# summarize the results
print(resp16)
# list the chosen features
predictors(resp16)
# plot the results
plot(resp16, type=c("g", "o"))





