library(ggplot2)


dumb <- data.frame(X = 0)     # dummy data

stdseq <- 1:20

d1 <- sample(stdseq, 1000, replace = TRUE)
data1 <- data.frame(X = d1)                       # pseudo source data frame 1
df1 <- data.frame(X = data1[,"X"], SET = "R112")     # df1 = data frame composed for plotting

d2 <- sample(stdseq, 10000, replace = TRUE)
data2 <- data.frame(X = d2)                       # data2 = pseudo source data frame 2 
df2 <- data.frame(X = data2[,"X"], SET = "V231")    # df2 = data frame composed for plotting

g1 <- ggplot(data = dumb, aes(x=X, fill = SET)) +
        geom_density(data = df1, alpha = 0.7) +
        geom_density(data = df2, alpha =  0.7) +
        scale_fill_manual(values = c("blue", "green")) +          # color choices of SET
        labs(x = "X-Label", y = "Y-Label", title = "TITLE") +     # text of x/y/title
        theme(plot.title = element_text(hjust = 0.5))             # center aligned title
g1

