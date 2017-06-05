library(randomForest)


#--------------------------------------------------
# Examples-1
#   examples from 'r-package-randomforest.pdf'
#--------------------------------------------------
data("iris")
data("ChickWeight")

set.seed(123)


# Classification:
rfIris <- randomForest(Species~., iris, keep.forest=TRUE)
rfIris
rfIris$type
rfIris$ntree
plot(margin(rfIris))

rfIris100 <- randomForest(Species~., iris, ntree = 100, keep.forest=TRUE)
rfIris100$ntree
plot(margin(rfIris100))


# Regression:
rfChick <- randomForest(Time~., ChickWeight, keep.forest=TRUE)
rfChick
rfChick$type
rfChick$ntree

