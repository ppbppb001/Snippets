library(reshape)
library(ggplot2)

# Data 
set.seed(8)
m <- matrix(round(rnorm(20000), 2), 50, 50)
colnames(m) <- paste("Col", 1:50)
rownames(m) <- paste("Row", 1:50)

# Transform the matrix in long format
df <- melt(m)
colnames(df) <- c("x", "y", "value")

#df <- data.frame(x=c(1,2,3),y=c(10,20,30))

plt <- ggplot(df, aes(x = x, y = y, fill = value)) +
        geom_tile()
plt

plt <- ggplot(df, aes(x, y)) +
        geom_raster(aes(fill = value))
plt

# Color schemes
# R base color palettes
plt + scale_fill_gradientn(colors = rainbow(100))
plt + scale_fill_gradientn(colors = heat.colors(100))
plt + scale_fill_gradientn(colors = terrain.colors(100))
plt + scale_fill_gradientn(colors = topo.colors(100))
plt + scale_fill_gradientn(colors = cm.colors(100))
# Colorspace
plt + scale_fill_gradientn(colors = colorspace::heat_hcl(100))
plt + scale_fill_gradientn(colors = colorspace::diverge_hcl(100))
plt + scale_fill_gradientn(colors = colorspace::rainbow_hcl(10))
# distiller
plt + scale_fill_distiller()
plt + scale_fill_distiller(palette = "RdPu")
plt + scale_fill_distiller(palette = "YlOrBr")
plt + scale_fill_distiller(palette = "Tableau")
