library(maptools)
library(rgeos)
library(ggplot2)
library(ggmap)
library(mapdata)
library(rgdal)
library(grid)

shp1 <- readOGR("demografia_wroclawia_2014_wg_rejonow_brec_2011/demografia_wroclawia_2014_wg_rejonow_brec_2011.shp")

png(filename = "./img/banner.png", width = 4600, height = 2700, res = 500)
ggplot() +
  geom_polygon(data=shp1, aes(x=long, y=lat, group=id), fill = "#9ebcda") +
  theme_nothing() +
  annotate("text", x = 17, y = 51.14, label = "STWUR", fontface = 1, family="Courier",
           size = 33, color = "white") +
  annotate("text", x = 17, y = 51.120, label = "Stowarzyszenie Wrocławskich Użytkowników R", 
           fontface = 2, family="Courier", size = 6.5, color = "white")
dev.off()
