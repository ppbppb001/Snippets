
setwd('e:/cat/projects/r practice/DIBP')
rm(list=ls())

df0 <- read.csv('aus-economics-features.csv', header=T)
df <- df0[264:nrow(df0),]

bulk.k3 <- unique(df[,'Bulk.K3'])
barplot(bulk.k3)

bulk.k2 <- unique(df[,'Bulk.K2'])
barplot(bulk.k2)

bulk.k1 <- unique(df[,'Bulk.K1'])
barplot(bulk.k1)

plot(seq(1:nrow(df)), df[,'Unemployment.Rate'])
plot(seq(1:nrow(df)), df[,'Unemployment.Rate.Annual'])
plot(seq(1:nrow(df)), df[,'Unemployment.K1'])
plot(seq(1:nrow(df)), df[,'Unemployment.K2'])
plot(seq(1:nrow(df)), df[,'Unemployment.K3'])

plot(seq(1:nrow(df)), df[,'AUDUSD'])
plot(seq(1:nrow(df)), df[,'AUDUSD.Annual'])
plot(seq(1:nrow(df)), df[,'AUDUSD.K1'])
plot(seq(1:nrow(df)), df[,'AUDUSD.K2'])
plot(seq(1:nrow(df)), df[,'AUDUSD.K3'])

plot(seq(1:nrow(df)), df[,'Bulk.USD'])
plot(seq(1:nrow(df)), df[,'Bulk.Annual'])
plot(seq(1:nrow(df)), df[,'Bulk.K1'])
plot(seq(1:nrow(df)), df[,'Bulk.K2'])
plot(seq(1:nrow(df)), df[,'Bulk.K3'])

