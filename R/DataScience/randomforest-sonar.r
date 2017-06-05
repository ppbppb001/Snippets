library(mlbench)
library(randomForest)

data("Sonar")
lt <- length(Sonar[,1])
lt
pt <- trunc(0.9*lt)  # partition coefficient
pt


# Classification ................
sonar.Class.rf <- randomForest(Class~., Sonar[1:pt,])
sonar.Class.rf
sonar.Class.rf$type

sonar.Class.pred <- predict(sonar.Class.rf, Sonar[(pt+1):lt,])
sonar.Class.pred


# Regression ...................
sonar.V60.rf <- randomForest(formula=(V60)~., data=Sonar[,1:60], subset=1:pt)
str(sonar.V60.rf)
sonar.V60.rf$type
plot(sonar.V60.rf)

sonar.V60.pred <- predict(sonar.V60.rf, Sonar[(pt+1):lt,])
sonar.V60.pred

ev <- mean(abs(Sonar$V60[(pt+1):lt] - sonar.V60.pred))
ev
mv <- mean(abs(Sonar$V60[(pt+1):lt]))
mv
ev/mv

