library(maptools)
library(rgeos)
library(ggplot2)
library(ggmap)
library(mapdata)
library(rgdal)
library(grid)

shp1 <- readOGR("demografia_wroclawia_2014_wg_rejonow_brec_2011/demografia_wroclawia_2014_wg_rejonow_brec_2011.shp")

png(filename = "./img/banner.png", width = 4600/2, height = 2700/3.5, res = 200)
ggplot() +
  geom_polygon(data=shp1, aes(x=long, y=lat, group=id), fill = "#9ebcda") +
  theme_nothing() +
  annotate("text", x = 17, y = 51.14, label = "STWUR", fontface = 1, family="Courier",
           size = 28, color = "white") +
  annotate("text", x = 17, y = 51.106, label = "Stowarzyszenie Wrocławskich\nUżytkowników R", 
           fontface = 2, family="Courier", size = 7.5, color = "white") +
  scale_x_continuous(limits = c(16.7, 17.3))
dev.off()
