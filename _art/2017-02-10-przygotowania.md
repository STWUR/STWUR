---
layout: post
title: "Jak się przygotować?"
excerpt: "Wszystko co warto zrobić przed spotkaniem STWURa"
---

Podczas każdego ze spotkań aktywnie używamy **R**, dlatego przyda się własny laptop. Przed spotkaniem dobrze jest:

* zainstalować [najnowszą wersję **R**](https://cran.r-project.org/) i [RStudio](https://www.rstudio.com/products/rstudio/download/).

* zainstalować niezbędne pakiety i ściągnąć dane za pomocą poniższego skryptu:

{% highlight R %}
install.packages(c("ggplot2", "dplyr"), repos = "https://cloud.r-project.org/")
download.file(url = "https://github.com/michbur/Diagnoza_dane/archive/master.zip", 
              destfile = "diagnoza.zip")
unzip("diagnoza.zip", exdir = getwd())
file.remove("diagnoza.zip")
load("./Diagnoza_dane-master/osoby.RData")
load("./Diagnoza_dane-master/osobyDict.RData")
{% endhighlight %}
