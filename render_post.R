library(knitr)
library(dplyr)

opts_chunk$set(fig.path = "./blog/beeswarm/figure/")

knit(input = "./rmd_posts/2017-02-20-beeswarm.Rmd", 
     output = "./_posts/blog/2017-02-20-beeswarm.md")

readLines("./_posts/blog/2017-02-20-beeswarm.md") %>% 
  gsub("./blog/beeswarm/", "./", x = ., fixed = TRUE) %>% 
  cat(file = "./_posts/blog/2017-02-20-beeswarm.md", sep = "\n")
