# install packages and data for stwur
# address: http://tinyurl.com/STWUR-setup-01-2018
install.packages(c("ggplot2", "dplyr", "mlr", "randomForest", "glmnet", "nnet"),
                 repos = "https://cloud.r-project.org/")
download.file(url = "https://raw.githubusercontent.com/STWUR/eRementarz/master/data/mieszkania_wroclaw_ceny.csv",
              destfile = "mieszkania_wroclaw_ceny.csv")
mieszkania <- read.csv("mieszkania_wroclaw_ceny.csv")
