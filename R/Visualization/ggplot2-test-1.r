library(ggplot2)
library(mlbench)


# c1 <- as.factor(as.character(1:10))
c1 <- as.character(seq(10))
print(c1)
# c2 <- as.factor(abs(rnorm(10)*100))
c2 <- abs(rnorm(10)*100)
print(c2)

df <- data.frame(C1=c1, C2=c2)
print(head(df))

data(Sonar)
df <- Sonar

data("iris")
df <- iris

ggplot(data = df, 
       mapping = aes(x=Species,y=Sepal.Length ,color=Species)
       ) + 
       geom_bar(stat='identity')
