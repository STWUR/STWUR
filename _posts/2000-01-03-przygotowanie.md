---
title: "Przed spotkaniem"
bg: '#63BD2F'
color: black
fa-icon: plug
---

Przed zajęciami warto:

* zainstalować [najnowszą wersję **R**](https://cran.r-project.org/) i [RStudio](https://www.rstudio.com/products/rstudio/download/).

* zainstalować niezbędne pakiety *ggplot2* oraz *dplyr* i ściągnąć dane za pomocą poniższego skryptu:

{% highlight text linenos=table %}
install.packages(c("ggplot2", "dplyr"), repos = "https://cloud.r-project.org/")
download.file("https://github.com/michbur/Diagnoza_dane/archive/master.zip")
{% endhighlight %}
