setwd('../projects/r practice/r_coding_common_usage')
rm(list=ls())

# common ways of plot
library(ggplot2)
library(ggrepel)
library(scales)
library(reshape2)
library(hexbin)

housing <- read.csv('landdata-states.csv')
dat <- read.csv('EconomistData.csv')
custdata <- read.csv('custdata.csv', header=TRUE)

# line plot
dat_sub <- subset(dat, select=c('X', 'HDI', 'CPI'))
dat_m <- melt(dat_sub, id.var='X')
p1 <- ggplot(dat_m)
p1 + geom_line(aes(X, value, color=variable))

#histogram - ggplot 0
ggplot(housing, aes(x=Home.Value)) + 
  geom_histogram(data=subset(housing, Home.Value<200000), fill='red', alpha=0.3, bins=40) +
  geom_histogram(data=subset(housing, Home.Value>=200000), fill='green', alpha=0.3, bins=40)

#histogram - ggplot 1
ggplot(housing, aes(x=Home.Value)) + 
  geom_histogram(bins=40)

#histogram - ggplot 2
ggplot(housing, aes(x=Home.Value)) + 
  geom_histogram(stat='bin', binwidth=10000)

#density & scale_x_continuous
ggplot(custdata) +
  geom_density(aes(x=income)) +
  scale_x_continuous(labels=dollar)

#bar plot - ggplot 1
house.sum <- aggregate(housing['Home.Value'], housing['State'], FUN=mean)
ggplot(house.sum, aes(x=State, y=Home.Value)) +
  geom_bar(stat='identity')

#bar plot - ggplot 2
ggplot(custdata) +
  geom_bar(aes(x=marital.stat, fill=health.ins), position='fill')

#bar plot - coord_flip
ggplot(custdata) +
  geom_bar(aes(x=state.of.res)) + 
  coord_flip() +
  theme(axis.text.y=element_text(size=rel(0.8)))

#scatter plot - plot
plot(Home.Value ~ Date, data=subset(housing, State=='MA'))
points(Home.Value ~ Date, data=subset(housing, State=='TX'), 
       col='blue')
legend(19750, 400000, c('MA', 'TX'), pch=c(1,1))

#scatter plot - ggplot
ggplot(subset(housing, State %in% c('MA', 'TX')), 
       aes(x=Date, y=Home.Value, color=State)) + 
  geom_point()

#hexagon binning (heatmap)
custdata2 <- subset(custdata, (custdata$age>0 & custdata$age<100 & custdata$income>0))
ggplot(custdata2, aes(x=age, y=income)) + 
  geom_hex(binwidth=c(5, 10000)) + 
  ylim(0, 200000)


#plot of fitted points
data1 <- subset(housing, Date==20011)
p1 <- ggplot(data1, 
             aes(x=Land.Value, y=Structure.Cost)) +
  geom_point(aes(color=Home.Value))
predval <- predict(lm(Structure.Cost ~ Land.Value, data1))
p1 + geom_line(aes(y=predval)) + geom_smooth()
p1 + geom_line(aes(y=predval)) + geom_smooth() + 
  geom_text_repel(aes(label=State), size=4)

#ggplot with theme
p3 <- ggplot(housing, aes(x=State, y=Home.Price.Index)) + 
  theme(legend.position='top', axis.text=element_text(size=6))
p3 + geom_point(aes(color=Date), alpha=0.5, size=1.5, 
                position=position_jitter(width=0.25, height=0))

#ggplot with facet_wrap
p1 <- ggplot(housing, aes(x=Date, y=Home.Value))
p1 + geom_line() + facet_wrap(~State, ncol=10) + theme_light()

