# <ggplot2-mytools-lib.r> ----------------------
#
#   Chart plotting tools for specified purposes
#
#   [2017-06-16] - Initialized
#   [2017-06-20] - multiPlot() added
#-----------------------------------------------



# <Function>: Plot multiple lines ----------------------------------
# input: title = character, title of this plot
#        x.name, y.name = character, string of x/y axis
#        x.values, y.values = list(numeric), list of values of x/y coordinate
#        x.range, y.range = 2-elements numeric vector, range of x/y axis
#        index.text = multi-elements character vector, strings of multi-lines comments
#        index.text = 1..4, 1:up-left, 2:lower-left, 3:upper-right, 4:lower-right
plotLines <- function(title = NULL,
                      x.name="X", y.name="Y",
                      x.values=NULL, y.values=NULL,
                      x.range=c(0,1), y.range=c(0,1),
                      index.text = NULL, index.pos = 4, index.x = 0.75) {
    
    # Check input values:
    pcnt <- length(x.values)
    pcnt.y <- length(y.values)
    if (pcnt==0 || pcnt.y==0 || pcnt!=pcnt.y)
        return(NULL)
    
    # check index.text
    tlen <- length(index.text)
    if (tlen < pcnt) {
        for (i in (tlen+1):pcnt) {
            index.text <- c(index.text, sprintf("#%2d",i))
        }
    }
    # padding index.text
    n <- max(nchar(index.text))
    index.text <- ifelse(nchar(index.text) < n, 
                         paste0(index.text, strrep(" ", (n - nchar(index.text)))),
                         index.text)

    # basic plot
    ggp <- ggplot(data.frame(Group=index.text)) +
            labs(x = x.name, y = y.name, title = title) +
            xlim(x.range[1], x.range[2]) + 
            ylim(y.range[1], y.range[2])
    
    for (xi in 1:pcnt) {
        # data
        vx <- x.values[[xi]]
        vx[which(is.nan(vx))] <- mean(vx, na.rm = TRUE)
        vy <- y.values[[xi]]
        vy[which(is.nan(vy))] <- mean(vy, na.rm = TRUE)
        # line
        gl <- geom_line(
                data = data.frame(
                    Index = index.text[xi],
                    X = vx,
                    Y = vy
                ),
                aes(x = X, y = Y, color = Index),
                size = 1,
                alpha = 0.5)
        ggp <- ggp + gl
    }
    
    # Change color manually:
    # cloffset <- 400
    # ggp <- ggp +
    #         scale_color_manual(values=colors()[(1+cloffset) : (pcnt+cloffset)])
    
    # Text?
    if (tlen > 0) {
        if (bitwAnd(index.pos-1, 0x02) == 0) {
            t.x1 <- x.range[1]
        } else {
            # t.x1 <- x.range[2]
            t.x1 <- (x.range[2] - x.range[1])*index.x
        }
        if (bitwAnd(index.pos-1, 0x01) == 0) {
            t.y1 <- y.range[2] 
            t.y2 <- (y.range[2] - y.range[1])*0.6
        } else {
            t.y1 <- (y.range[2] - y.range[1])*0.4
            t.y2 <- y.range[1] 
        }
        df.index <- data.frame(
                        Index = index.text[1:tlen],
                        X = t.x1,
                        Y = seq(from=t.y1, to=t.y2, length.out = tlen)
                    )
        ggp <- ggp +
            geom_text(
                data = df.index,
                aes(x = X, y = Y, label = Index, color = Index),
                hjust = "left"
                # family = "mono", fontface = "bold"
            )
    }
    
    # Remove legend:
    ggp <- ggp +
            theme(legend.position="none")
    
    return(ggp)
}


# <Function>: Plot multiple points ---------------------------
# input: x.values, y.values = list(vector)
plotPoints <- function(title = NULL,
                       x.name="X", y.name="Y",
                       x.values=NULL, y.values=NULL,
                       x.range=c(0,1), y.range=c(0,1),
                       smooth = FALSE) {
    
    pcnt <- length(x.values)
    pcnt.y <- length(y.values)
    if (pcnt==0 || pcnt.y==0 || pcnt!=pcnt.y)
        return(NULL)
    
    # Prepare data
    vx <- unlist(x.values)
    vx[which(is.nan(vx))] <- mean(vx, na.rm = TRUE)
    vy <- unlist(y.values)
    vy[which(is.nan(vy))] <- mean(vy, na.rm = TRUE)
    
    # base plotting
    ggp <- ggplot(
                data = data.frame(
                    X = vx,
                    Y = vy
                ),
                aes(x = X, y = Y)
            ) + 
            labs(x = x.name, y = y.name, title = title) +
            xlim(x.range[1], x.range[2]) +
            ylim(y.range[1], y.range[2])
    
    # points:
    ggp <- ggp +
            geom_point(
                size = 4, 
                color = "steelblue",
                alpha = 0.8)
    
    # smooth:
    if (smooth) {
        ggp <- ggp + 
                geom_smooth(
                    # method = "lm",
                    # span = 1,
                    color = "pink",
                    alpha = 0.2)
    }
    return(ggp)    
}




# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
    library(grid)
    
    # Make a list from the ... arguments and plotlist
    plots <- c(list(...), plotlist)
    
    numPlots = length(plots)
    
    # If layout is NULL, then use 'cols' to determine layout
    if (is.null(layout)) {
        # Make the panel
        # ncol: Number of columns of plots
        # nrow: Number of rows needed, calculated from # of cols
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                         ncol = cols, nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots==1) {
        print(plots[[1]])
        
    } else {
        # Set up the page
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        
        # Make each plot, in the correct location
        for (i in 1:numPlots) {
            # Get the i,j matrix positions of the regions that contain this subplot
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                            layout.pos.col = matchidx$col))
        }
    }
}


