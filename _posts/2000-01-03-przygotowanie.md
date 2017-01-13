---
title: "Przygotowanie do zajęć"
bg: white
color: black
fa-icon: plug
---

Przed zajęciami warto:

* zainstalować najnowszą wersję **R** i RStudio

* założyć konto na GitHubie i skonfigurować je dodając klucz prywatny

* pobrać pakiet Diagnoza (uwaga, plik powyżej 100 MB):

```R
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("pbiecek/Diagnoza")
```
