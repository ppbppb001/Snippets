# 2019-05-06

library(ggplot2)

x <- rep(seq(from=100,to=104),6)  # Compand's id number
y <- rnorm(5*6)*5+15              # values
z <- c(rep(2001,5), rep(2002,5), rep(2003,5), rep(2004,5), rep(2005,5), rep(2006,5))  # years
z <- as.character(z)              # convert 'years' from int to string
df <- data.frame(Company=x, Value=y, Year=z)   # compose a data frame

p <- ggplot(df, aes(x=Company, y=Value, fill=Year)) +               # colored ribon for each year
     geom_area() +                                                  # area fill (ribon)
     labs(x="X=COMPANY", y="Y=VALUE", title="TITLE") +              # x/y labels and title
     theme(plot.title = element_text(hjust=0.5))                    # center the title

p                                              # draw the plot using default palette(hue)

p + scale_fill_brewer(palette = "Set1")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Set2")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Set3")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Pastel1")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Pastel2")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Accent")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Dark2")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Paired")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Spectral")        # draw the plot using color brewer palette 

p + scale_fill_brewer(palette = "Greens")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Blues")        # draw the plot using color brewer palette 
p + scale_fill_brewer(palette = "Oranges")        # draw the plot using color brewer palette 

