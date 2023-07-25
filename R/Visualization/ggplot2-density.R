library(ggplot2)

set.seed(2222)

df <- data.frame(
    group=factor(rep(c("group1", "group2", "group3"), each=500)),
    value=round(c(rnorm(500, mean=95, sd=7),
                  rnorm(500, mean=115, sd=5),
                  rnorm(500, mean=135, sd=9))
                )
    )


# Line
plt <- ggplot(df, aes(x=value, color=group)) +
        geom_density(alpha=0.3)
plt

# Line + Fill
plt <- ggplot(df, aes(x=value, color=group, fill=group)) +
        geom_density(alpha=0.3)
plt

# Histogram
plt <- ggplot(df, aes(x=value, color=group, fill=group)) +
    geom_histogram(aes(y=..density..), binwidth = 1, alpha = 0.3)
plt

# Histogram + line + fill
plt <- ggplot(df, aes(x=value, color=group, fill=group)) +
    geom_histogram(aes(y=..density..),binwidth = 1, alpha = 0.3, position = 'identity') +
    geom_density(alpha=0.3)
plt

