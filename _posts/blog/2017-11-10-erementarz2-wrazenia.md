---
layout: post
title: "Materiały ze spotkania eRementarz #2: wizualizacja danych w pakiecie ggplot2"
modified:
author: michal
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-11-10
output:
  md_document:
    variant: markdown_github
---

Jak zawsze publikujemy materiały z ostatniego spotkania STWURa, które poprowadził Bartosz Kolasa - data scientist z firmy PiLab, a zorganizował Mateusz Staniak.

### Materiały

Data Visualisation cheatsheet

<https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf>

Github

<https://github.com/STWUR/eRementarz2>


Eseje o sztuce prezentowania danych
<http://www.biecek.pl/Eseje/>

Pakiety:
- ggplot2
- dplyr

### Cele wizualizacji

- zrozumienie danych 
- prezentacja zjawiska
- przekonanie odbiorcy do określonej tezy

### Gramatyka wykresów

<img src="img/grammtics.png" width="800px"/>

### Gramatyka wykresów


```r
library(ggplot2)
ggplot(mpg, aes(hwy, cty)) +
  geom_point(aes(color=cyl)) + geom_smooth(method="lm") +
  coord_cartesian() + scale_color_gradient() + theme_bw()
```

<img src="./figure/unnamed-chunk-1-1.png" title="plot of chunk unnamed-chunk-1" alt="plot of chunk unnamed-chunk-1" style="display: block; margin: auto;" />


### Najprostszy przykład


```r
library(ggplot2)
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny.csv")
ggplot(mieszkania, aes(x=dzielnica)) + geom_bar()
```

<img src="./figure/unnamed-chunk-2-1.png" title="plot of chunk unnamed-chunk-2" alt="plot of chunk unnamed-chunk-2" style="display: block; margin: auto;" />


### Zmienna ciągła


```r
library(ggplot2)
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny.csv")
ggplot(mieszkania, aes(x=metraz)) + geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="./figure/unnamed-chunk-3-1.png" title="plot of chunk unnamed-chunk-3" alt="plot of chunk unnamed-chunk-3" style="display: block; margin: auto;" />


### Ograniczenie danych


```r
library(dplyr)
filter(mieszkania, metraz<150) -> mieszkania
ggplot(mieszkania, aes(x=metraz)) + geom_histogram()
```

```
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="./figure/unnamed-chunk-4-1.png" title="plot of chunk unnamed-chunk-4" alt="plot of chunk unnamed-chunk-4" style="display: block; margin: auto;" />

### Kolejny wymiar


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny.csv")
ggplot(mieszkania, aes(x=dzielnica, fill=as.factor(n_pokoj))) + geom_bar()
```

<img src="./figure/unnamed-chunk-5-1.png" title="plot of chunk unnamed-chunk-5" alt="plot of chunk unnamed-chunk-5" style="display: block; margin: auto;" />

### Rozsądniejsze kolory


```r
library(RColorBrewer)
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny.csv")
ggplot(mieszkania, aes(x=dzielnica, fill=as.factor(n_pokoj))) + geom_bar() + scale_fill_brewer(palette="Reds") 
```

<img src="./figure/unnamed-chunk-6-1.png" title="plot of chunk unnamed-chunk-6" alt="plot of chunk unnamed-chunk-6" style="display: block; margin: auto;" />

### Porównywanie wartości


```r
library(RColorBrewer)
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny.csv")
ggplot(mieszkania, aes(x=dzielnica, fill=as.factor(n_pokoj))) + geom_bar(position="fill") + scale_fill_brewer(name="Liczba pokoi", palette="Reds")
```

<img src="./figure/unnamed-chunk-7-1.png" title="plot of chunk unnamed-chunk-7" alt="plot of chunk unnamed-chunk-7" style="display: block; margin: auto;" />


### Etykietki


```r
library(RColorBrewer)
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny.csv")
ggplot(mieszkania, aes(x=dzielnica, fill=as.factor(n_pokoj))) + geom_bar(position="fill") +
  scale_fill_brewer(name="Liczba pokoi", palette="Reds") + geom_text(aes(label=..count..), stat="count", position="fill", vjust="bottom")
```

<img src="./figure/unnamed-chunk-8-1.png" title="plot of chunk unnamed-chunk-8" alt="plot of chunk unnamed-chunk-8" style="display: block; margin: auto;" />

### Ostatnie szlify


```r
mutate(mieszkania, n_pokoj=if_else(n_pokoj>4, "więcej niż 4", as.character(n_pokoj))) -> mieszkania
ggplot(mieszkania, aes(x=dzielnica, fill=as.factor(n_pokoj))) + geom_bar(position="fill") +
  scale_fill_brewer(name="Liczba pokoi", palette="Reds") + geom_text(aes(label=..count..), stat="count", position="fill", vjust="bottom")
```

<img src="./figure/unnamed-chunk-9-1.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" style="display: block; margin: auto;" />

### Zadania

Do użycia nowy zbiór z pliku "data/mieszkania_wroclaw_ceny_rozbudowana.csv"
- Narysuj wykres słupkowy liczby mieszkań w wybranych kategoriach cenowych.
- Zbadaj jak rozkłada się to w zależności od dzielnic.
- Zbadaj odwrotną relację tzn. liczbę mieszkań w określonych kategoriach cenowych w wybranych dzielnicach

### Rozkład kategorii cenowych


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=kat_cenowa)) + geom_bar() 
```

<img src="./figure/unnamed-chunk-10-1.png" title="plot of chunk unnamed-chunk-10" alt="plot of chunk unnamed-chunk-10" style="display: block; margin: auto;" />

### Rozkład kategorii cenowych wg dzielnic


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=kat_cenowa, fill=dzielnica)) +  geom_bar(position="fill") 
```

<img src="./figure/unnamed-chunk-11-1.png" title="plot of chunk unnamed-chunk-11" alt="plot of chunk unnamed-chunk-11" style="display: block; margin: auto;" />


### Rozkład dzielnic wg kategorii


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, fill=kat_cenowa)) +  geom_bar(position="fill") 
```

<img src="./figure/unnamed-chunk-12-1.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" style="display: block; margin: auto;" />

### Dwa wymiary


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=cena)) +  geom_boxplot() 
```

<img src="./figure/unnamed-chunk-13-1.png" title="plot of chunk unnamed-chunk-13" alt="plot of chunk unnamed-chunk-13" style="display: block; margin: auto;" />

### Skala logarytmiczna


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=cena)) +  geom_boxplot()+ scale_y_log10()
```

<img src="./figure/unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" style="display: block; margin: auto;" />

### Z etykietką


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=cena)) + geom_boxplot(stat="boxplot") +scale_y_log10() +
  geom_text(data=aggregate(cena ~ dzielnica,mieszkania, median), aes(label=cena, x=dzielnica, y=cena), vjust=-0.75)
```

<img src="./figure/unnamed-chunk-15-1.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" style="display: block; margin: auto;" />


### Bez outlierów


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
filter(mieszkania, cena < 1000000) -> mieszkania
ggplot(mieszkania, aes(x=dzielnica, y=cena)) + geom_boxplot(stat="boxplot") +scale_y_log10() +
  geom_text(data=aggregate(cena ~ dzielnica,mieszkania, median), aes(label=cena, x=dzielnica, y=cena), vjust=-0.75)
```

<img src="./figure/unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" style="display: block; margin: auto;" />

### Bez outlierów


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=cena)) + geom_boxplot(stat="boxplot") +scale_y_log10() +
  geom_text(data=aggregate(cena ~ dzielnica,mieszkania, median), aes(label=cena, x=dzielnica, y=cena), vjust=-0.75) + ylim(1e5, 1e6)
```

```
## Scale for 'y' is already present. Adding another scale for 'y', which
## will replace the existing scale.
```

```
## Warning: Removed 97 rows containing non-finite values (stat_boxplot).
```

<img src="./figure/unnamed-chunk-17-1.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" style="display: block; margin: auto;" />


### Zadania

- Pokaż na wykresie pudełkowym zależność metrażu mieszkań w zależności od dzielnicy
- Zaznacz kolorem kategorie cenowe
- Jaką tendencję można wyciągnąć z tego wykresu?
- Jakie są wartości liczbowe median metrażu?


### Metraż wg dzielnic


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=metraz)) +  geom_boxplot() 
```

<img src="./figure/unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" style="display: block; margin: auto;" />

### Metraż wg dzielnic i kategorii cenowych


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=metraz, fill=kat_cenowa)) +  geom_boxplot() 
```

<img src="./figure/unnamed-chunk-19-1.png" title="plot of chunk unnamed-chunk-19" alt="plot of chunk unnamed-chunk-19" style="display: block; margin: auto;" />

### Mediany


```r
aggregate(metraz ~ kat_cenowa + dzielnica, mieszkania, median)
```

```
##          kat_cenowa    dzielnica metraz
## 1   1. bardzo tanie    Fabryczna  64.00
## 2          2. tanie    Fabryczna  56.43
## 3         3. drogie    Fabryczna  53.60
## 4  4. bardzo drogie    Fabryczna  48.00
## 5   1. bardzo tanie       Krzyki  70.00
## 6          2. tanie       Krzyki  64.25
## 7         3. drogie       Krzyki  56.00
## 8  4. bardzo drogie       Krzyki  49.00
## 9   1. bardzo tanie    Psie Pole  65.40
## 10         2. tanie    Psie Pole  55.25
## 11        3. drogie    Psie Pole  49.69
## 12 4. bardzo drogie    Psie Pole  53.13
## 13  1. bardzo tanie  Srodmiescie  70.00
## 14         2. tanie  Srodmiescie  63.00
## 15        3. drogie  Srodmiescie  52.60
## 16 4. bardzo drogie  Srodmiescie  64.00
## 17  1. bardzo tanie Stare Miasto  72.00
## 18         2. tanie Stare Miasto  56.75
## 19        3. drogie Stare Miasto  50.55
## 20 4. bardzo drogie Stare Miasto  54.00
```


### Wykres punktowy


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=metraz, y=cena_m2)) + geom_point()
```

<img src="./figure/unnamed-chunk-21-1.png" title="plot of chunk unnamed-chunk-21" alt="plot of chunk unnamed-chunk-21" style="display: block; margin: auto;" />


### Wykres punktowy z podziałami


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=metraz, y=cena_m2)) + geom_point() + facet_wrap(~dzielnica)
```

<img src="./figure/unnamed-chunk-22-1.png" title="plot of chunk unnamed-chunk-22" alt="plot of chunk unnamed-chunk-22" style="display: block; margin: auto;" />


### Wykres z rozrzutem


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=metraz, y=cena_m2)) + geom_jitter(size=0.1) +facet_wrap(~dzielnica) 
```

<img src="./figure/unnamed-chunk-23-1.png" title="plot of chunk unnamed-chunk-23" alt="plot of chunk unnamed-chunk-23" style="display: block; margin: auto;" />

### Wykres z pomocnikiem...


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=metraz, y=cena_m2)) + geom_jitter(size=0.1) + geom_smooth(method="loess") + facet_wrap(~dzielnica) 
```

<img src="./figure/unnamed-chunk-24-1.png" title="plot of chunk unnamed-chunk-24" alt="plot of chunk unnamed-chunk-24" style="display: block; margin: auto;" />

... i poprawioną skalą


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
filter(mieszkania, metraz<150) -> mieszkania
ggplot(mieszkania, aes(x=metraz, y=cena_m2)) + geom_jitter(size=0.1) + geom_smooth(method="loess") + facet_wrap(~dzielnica)
```

<img src="./figure/unnamed-chunk-25-1.png" title="plot of chunk unnamed-chunk-25" alt="plot of chunk unnamed-chunk-25" style="display: block; margin: auto;" />

... i bez Starego Miasta


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
filter(mieszkania, metraz<150, dzielnica != "Stare Miasto") -> mieszkania
ggplot(mieszkania, aes(x=metraz, y=cena_m2)) + geom_jitter(size=0.1) + geom_smooth(method="loess") + facet_wrap(~dzielnica)
```

<img src="./figure/unnamed-chunk-26-1.png" title="plot of chunk unnamed-chunk-26" alt="plot of chunk unnamed-chunk-26" style="display: block; margin: auto;" />


### Zadanie

- Stwórz wersję wykresu metrażu w zależności od dzielnic z użyciem podziałów
- Czy ta wizualizacja jest lepsza czy gorsza od wersji z kolorami?


### Metraż wg dzielnic i kategorii cenowych


```r
mieszkania <- read.csv("data/mieszkania_wroclaw_ceny_rozbudowana.csv")
ggplot(mieszkania, aes(x=dzielnica, y=metraz)) +  geom_boxplot() + facet_wrap(~kat_cenowa)
```

<img src="./figure/unnamed-chunk-27-1.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" style="display: block; margin: auto;" />


## Link do repotyzorium

https://github.com/STWUR/eRementarz2 - kody i dane do spotkania.

Dziękujemy firmie Kruk SA (jedzenie i napoje) za wspieranie spotkań STWURa.

<img src='https://stwur.github.io/STWUR//images/kruk_logo.jpg' id="logo" height="35%" width="35%"/>
