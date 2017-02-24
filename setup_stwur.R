# install packages and data for stwur
install.packages(c("ggplot2", "dplyr"), repos = "https://cloud.r-project.org/")
download.file(url = "https://github.com/michbur/Diagnoza_dane/archive/master.zip", 
              destfile = "diagnoza.zip")
unzip("diagnoza.zip", exdir = getwd())
file.remove("diagnoza.zip")
