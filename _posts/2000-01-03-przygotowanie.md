---
title: "Przed spotkaniem"
bg: '#7fcdbb'
color: '#edf8b1'
fa-icon: check-square-o
---

Przed zajęciami warto:

* zainstalować [najnowszą wersję **R**](https://cran.r-project.org/) i [RStudio](https://www.rstudio.com/products/rstudio/download/).

* zainstalować niezbędne pakiety i ściągnąć dane za pomocą poniższego skryptu:

{% highlight R %}
install.packages(c("ggplot2", "dplyr"), repos = "https://cloud.r-project.org/")
download.file(url = "https://github.com/michbur/Diagnoza_dane/archive/master.zip", 
              destfile = "diagnoza.zip")
unzip("diagnoza.zip", exdir = getwd())
load("./Diagnoza_dane-master/osoby.RData")
load("./Diagnoza_dane-master/osobyDict.RData")
{% endhighlight %}
