# install packages and data for stwur
# address: http://tinyurl.com/STWUR-setup
install.packages(c("ggplot2", "dplyr"), repos = "https://cloud.r-project.org/")
download.file(url = "https://raw.githubusercontent.com/STWUR/eRementarz/master/data/mieszkania_wroclaw_ceny.csv", 
              destfile = "mieszkania_wroclaw_ceny.csv")
dat <- read.csv("mieszkania_wroclaw_ceny.csv")
