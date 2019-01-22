# <ggplot2-multiple-plots.r> ----------------------
#
#   Overlapped plotting
#
#   [2018-06-21] - startup
#   [2019-01-22] = Scatter points plotting added
#-----------------------------------------------


library(ggplot2)

# Data
d1 <- data.frame( x=rnorm(20000, 10, 1.9), y=rnorm(20000, 10, 1.2) )
d2 <- data.frame( x=rnorm(20000, 11.5, 1.9), y=rnorm(20000, 11.5, 1.2) )
d3 <- data.frame( x=rnorm(2000, 9.5, 1.9), y=rnorm(2000, 15.5, 1.9) )

# Define the range/limitation of the plots
x.min <- min(min(d1["x"]), min(d2["x"]), min(d3["x"])) - 1
x.min
x.max <- max(max(d1["x"]), max(d2["x"]), max(d3["x"])) + 1
x.max
y.min <- min(min(d1["y"]), min(d2["y"]), min(d3["y"])) - 1
y.min
y.max <- max(max(d1["y"]), max(d2["y"]), max(d3["y"])) + 1
y.max

# Make a dumb data set for ggplot basic call
dumb <- data.frame(DUMB=0)

# Display all pre-defined color paletter
# RColorBrewer::display.brewer.all()
# myPalette <- 'Set2'

# Define private color picks
# Color picked from 'http://colorbrewer2.org'
# Classes = 5, Nature = qualitative
myColor1 <- "#66c2a5"
myColor2 <- "#fc8d62"
myColor3 <- "#8da0cb"
myColor4 <- "#e78ac3"
myColor5 <- "#a6d854"

alpha.contour <- 0.4
alpha.point <- 0.05


# Plot 'd1' only
g1 <- ggplot(data=dumb, aes(x=x, y=y)) +
        stat_density2d(data=d1, aes(fill="Data-1", alpha=..density..), geom='raster', contour=FALSE) +
        stat_density2d(data=d1, color=myColor1, alpha = alpha.contour, contour=TRUE) +
        xlim(x.min, x.max) + 
        ylim(y.min, y.max) +
        scale_fill_manual(values = myColor1)
g1

# Plot 'd2' only
g2 <- ggplot(data=dumb, aes(x=x, y=y)) +
        stat_density2d(data=d2, aes(fill="Data-2", alpha=..density..), geom='raster', contour=FALSE) +
        stat_density2d(data=d2, color=myColor2, alpha = alpha.contour, contour=TRUE) +
        xlim(x.min, x.max) + 
        ylim(y.min, y.max) +
        scale_fill_manual(values = myColor2)
g2

# Plot 'd3' only
g3 <- ggplot(data=dumb, aes(x=x, y=y)) +
        stat_density2d(data=d3, aes(fill="Data-3", alpha=..density..), geom='raster', contour=FALSE) +
        stat_density2d(data=d3, color=myColor3, alpha = alpha.contour, contour=TRUE) +
        xlim(x.min, x.max) + 
        ylim(y.min, y.max) +
        scale_fill_manual(values = myColor3)
g3


# Plot 'd1' on top of 'd2'
g12 <- ggplot(data=dumb, aes(x=x, y=y)) +
        stat_density2d(data=d2, aes(alpha=..density.., fill="Data-2"), geom='raster', contour=FALSE) +
        stat_density2d(data=d2, color=myColor2, alpha = alpha.contour, contour=TRUE) +
        stat_density2d(data=d1, aes(alpha=..density.., fill="Data-1"), geom='raster', contour=FALSE) +
        stat_density2d(data=d1, color=myColor1, alpha = alpha.contour, contour=TRUE) +
        xlim(x.min, x.max) + 
        ylim(y.min, y.max) +
        scale_fill_manual(values = c(myColor1, myColor2))
g12

# Plot 'd2' on top of 'd1'
g21 <- ggplot(data=dumb, aes(x=x, y=y)) +
        stat_density2d(data=d1, aes(alpha=..density.., fill="Data-1"), geom='raster', contour=FALSE) +
        stat_density2d(data=d1, color=myColor1, alpha = alpha.contour, contour=TRUE) +
        stat_density2d(data=d2, aes(alpha=..density.., fill="Data-2"), geom='raster', contour=FALSE) +
        stat_density2d(data=d2, color=myColor2, alpha = alpha.contour, contour=TRUE) +
        xlim(x.min, x.max) + 
        ylim(y.min, y.max) +
        scale_fill_manual(values = c(myColor1, myColor2))
g21


# Plot 'd1' on top of 'd2' and 'd2' on top of 'd3'
g123 <- ggplot(data=dumb, aes(x=x, y=y)) +
        stat_density2d(data=d3, aes(alpha=..density.., fill="Data-3"), geom='raster', contour=FALSE) +
        stat_density2d(data=d3, color=myColor3, alpha = alpha.contour, contour=TRUE) +
        stat_density2d(data=d2, aes(alpha=..density.., fill="Data-2"), geom='raster', contour=FALSE) +
        stat_density2d(data=d2, color=myColor2, alpha = alpha.contour, contour=TRUE) +
        stat_density2d(data=d1, aes(alpha=..density.., fill="Data-1"), geom='raster', contour=FALSE) +
        stat_density2d(data=d1, color=myColor1, alpha = alpha.contour, contour=TRUE) +
        xlim(x.min, x.max) + 
        ylim(y.min, y.max) +
        guides(fill = guide_legend(title = "Set")) +
        guides(alpha = guide_legend(title = "Scale", keyheight = 3))+
        # labs(fill="Set", alpha="Scale") +
        scale_fill_manual(values = c(myColor1, myColor2, myColor3))
g123


# Plot points:  Plot 'd1' on top of 'd2' and 'd2' on top of 'd3'
# With legends
g123.2 <- ggplot(data=dumb, aes(x=x, y=y)) +
        geom_point(data = d1, aes(color = "Data-1"), alpha = 0.05, size = 1) +
        geom_point(data = d2, aes(color = "Data-2"), alpha = 0.05, size = 1) +
        geom_point(data = d3, aes(color = "Data-3"), alpha = 0.05, size = 1) +
        xlim(x.min, x.max) +
        ylim(y.min, y.max) +
        guides(color = guide_legend(title = "Data Set")) +
        annotate("text", x=x.max-3, y=y.max, label="Data-1", color=myColor1) +
        annotate("text", x=x.max-3, y=y.max-1, label="Data-2", color=myColor2) +
        annotate("text", x=x.max-3, y=y.max-2, label="Data-3", color=myColor3) +
        scale_color_manual(values = c(myColor1, myColor2, myColor3))
g123.2
# Without legends
g123.3 <- ggplot(data=dumb, aes(x=x, y=y)) +
    geom_point(data = d1, color = myColor1, alpha = 0.05, size = 1) +
    geom_point(data = d2, color = myColor2, alpha = 0.05, size = 1) +
    geom_point(data = d3, color = myColor3, alpha = 0.2, size = 3) +
    xlim(x.min, x.max) +
    ylim(y.min, y.max) +
    annotate("text", x=x.max-3, y=y.max, label="Data-1", color=myColor1) +
    annotate("text", x=x.max-3, y=y.max-1, label="Data-2", color=myColor2) +
    annotate("text", x=x.max-3, y=y.max-2, label="Data-3", color=myColor3)
g123.3

