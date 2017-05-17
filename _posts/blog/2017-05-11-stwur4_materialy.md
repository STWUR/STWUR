---
layout: post
title: "STWUR #4 za nami"
modified:
author: michal
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-05-17
output:
  md_document:
    variant: markdown_github
---

Jak zawsze publikujemy materiały z ostatniego spotkania STWURa.



## Wstęp

Materiały są dostępne w repozytorium: http://tinyurl.com/stwur4

Pobierz materiały z **R** poleceniem:


```r
download.file(url = "https://github.com/STWUR/STWUR-2017-05-17/archive/master.zip", 
              destfile = "tmp.zip")
unzip("tmp.zip", exdir = getwd())
file.remove("tmp.zip")
```

## Dane

Dane z Diagnozy społecznej, 23 130 respondentów.

Pytania:

- Czy czuje się Pan/i samotny/a?
- Czy używa Pan/i internetu w pracy?
- Ile godzin spędził/a Pan/i w internecie w ostatnim tygodniu?

## Wczytanie danych


```r
dat <- read.csv("internet_samotnosc_aggregated.csv")
```

```
## Warning in file(file, "rt"): cannot open file
## 'internet_samotnosc_aggregated.csv': No such file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
head(dat)
```

```
## Error in head(dat): object 'dat' not found
```

## Liczba respondentów 


```r
ggplot(dat, aes(x = plec, y = n_resp, fill = samotnosc)) + 
  geom_col(position = "dodge") +
  facet_wrap( ~ internet_zawodowo, labeller = label_both) +
  scale_x_discrete("Płeć") +
  scale_y_continuous("Liczba respondentów") +
  scale_fill_manual("Uczucie osamotnienia", 
                    values = c("cadetblue3", "coral2")) +
  theme_bw() +
  theme(legend.position = "bottom")
```

## Liczba respondentów 


```
## Error in ggplot(dat, aes(x = plec, y = n_resp, fill = samotnosc)): object 'dat' not found
```

*geom_col*: odpowiednik geom_bar(stat = "identity")

## Przedziały ufności


```r
conf_int <- group_by(dat, internet_zawodowo) %>% 
  mutate(total = sum(n_resp)) %>% 
  bind_cols(binom.confint(.[["n_resp"]], .[["total"]], 
                          method = "asymptotic")) %>% 
  select(-method, -x, -n, -mean)
```

```
## Error in group_by_(.data, .dots = lazyeval::lazy_dots(...), add = add): object 'dat' not found
```

```r
conf_int[1L:3, -c(1L:4)]
```

```
## Error in eval(expr, envir, enclos): object 'conf_int' not found
```

*binom.confint* - przedziały ufności dla zmiennych dwumianowych (9 dostępnych metod).

*bind_cols* - *cbind* dla tibble.


## Przedziały ufności

```r
ggplot(conf_int, aes(x = plec, y = n_resp, fill = samotnosc)) + 
  geom_col(position = "dodge") +
  facet_wrap( ~ internet_zawodowo, labeller = label_both) +
  scale_x_discrete("Płeć") +
  scale_y_continuous("Liczba respondentów") +
  scale_fill_manual("Uczucie osamotnienia", 
                    values = c("cadetblue3", "coral2")) +
  theme_bw() +
  theme(legend.position = "bottom") +
  geom_errorbar(aes(ymin = lower*total, ymax = upper*total), 
                position = "dodge")
```


## Przedziały ufności

```
## Error in ggplot(conf_int, aes(x = plec, y = n_resp, fill = samotnosc)): object 'conf_int' not found
```

## Przedziały ufności

Coverage probability: prawdopodobieństwo, że wartość zmiennej znajduje się w określonym przedziale ufności.

![plot of chunk unnamed-chunk-8](./figure/unnamed-chunk-8-1.png)


## Przedziały ufności


```
##       method      p     n  coverage
## 1 asymptotic 0.0567 10587 0.9488404
## ----
##  -4 rows ommited
```

```
##   method      p     n  coverage
## 1 wilson 0.0567 10587 0.9493279
## ----
##  -4 rows ommited
```

## Liczba respondentów 


```
## Error in ggplot(conf_int, aes(x = plec, y = n_resp, fill = samotnosc)): object 'conf_int' not found
```

## Liczba godzin w internecie a samotność


```r
ggplot(dat, aes(x = plec, y = internet_h, fill = samotnosc)) +
  geom_col(position = "dodge") +
  facet_wrap( ~ internet_zawodowo, labeller = label_both) +
  scale_x_discrete("Płeć") +
  scale_y_continuous("Użycie internetu w ostatnim tygodniu [h]") +
  scale_fill_manual("Uczucie osamotnienia", values = c("cadetblue3", "coral2")) +
  theme_bw() +
  theme(legend.position = "bottom")
```

## Liczba godzin w internecie a samotność


```
## Error in ggplot(dat, aes(x = plec, y = internet_h, fill = samotnosc)): object 'dat' not found
```

## Liczba godzin w internecie a samotność


```r
full_dat <- read.csv("internet_samotnosc_full.csv")

wilcox.test(filter(full_dat, samotnosc == "TAK")[["internet_h"]],
            filter(full_dat, samotnosc != "TAK")[["internet_h"]],
            alternative = "greater")
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  filter(full_dat, samotnosc == "TAK")[["internet_h"]] and filter(full_dat, samotnosc != "TAK")[["internet_h"]]
## W = 40072000, p-value = 0.0004915
## alternative hypothesis: true location shift is greater than 0
```


## Liczba godzin w internecie a samotność

Czy osoby samotne nieużywające internetu w pracy, spędzają w internecie więcej czasu niż ich mniej samotni koledzy?


```r
wilcox.test(filter(full_dat, samotnosc == "TAK", 
                   internet_zawodowo != "TAK")[["internet_h"]],
            filter(full_dat, samotnosc != "TAK", 
                   internet_zawodowo != "TAK")[["internet_h"]],
            alternative = "greater")
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  filter(full_dat, samotnosc == "TAK", internet_zawodowo != "TAK")[["internet_h"]] and filter(full_dat, samotnosc != "TAK", internet_zawodowo != "TAK")[["internet_h"]]
## W = 11058000, p-value = 0.4745
## alternative hypothesis: true location shift is greater than 0
```

## Liczba godzin w internecie a samotność

Czy osoby samotne używające internetu w pracy, spędzają w internecie więcej czasu niż ich mniej samotni koledzy?


```r
wilcox.test(filter(full_dat, samotnosc == "TAK", 
                   internet_zawodowo == "TAK")[["internet_h"]],
            filter(full_dat, samotnosc != "TAK", 
                   internet_zawodowo == "TAK")[["internet_h"]],
            alternative = "greater")
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  filter(full_dat, samotnosc == "TAK", internet_zawodowo == "TAK")[["internet_h"]] and filter(full_dat, samotnosc != "TAK", internet_zawodowo == "TAK")[["internet_h"]]
## W = 8897900, p-value = 5.457e-05
## alternative hypothesis: true location shift is greater than 0
```


## Liczba godzin w internecie a samotność

Czy osoby samotne używające internetu w pracy, spędzają w internecie więcej czasu niż ich mniej samotni koledzy?


```r
wilcox.test(filter(full_dat, samotnosc == "TAK", 
                   internet_zawodowo == "TAK")[["internet_h"]],
            filter(full_dat, samotnosc != "TAK", 
                   internet_zawodowo == "TAK")[["internet_h"]],
            alternative = "greater")
```

```
## 
## 	Wilcoxon rank sum test with continuity correction
## 
## data:  filter(full_dat, samotnosc == "TAK", internet_zawodowo == "TAK")[["internet_h"]] and filter(full_dat, samotnosc != "TAK", internet_zawodowo == "TAK")[["internet_h"]]
## W = 8897900, p-value = 5.457e-05
## alternative hypothesis: true location shift is greater than 0
```

Czy naprawdę? Nie, na następnym spotkaniu wspólnie zrobimy to jeszcze raz - tym razem prawidłowo uwzględniając wagi!

## Trzy triki na factory

Zmiana kolejnosci poziomów

```r
fct_dat <- data.frame(imie = c("Janek", "Franek", "Stefanek", "Havranek"),
                      wzrost = c(188, 168, 210, 199))

levels(fct_dat[["imie"]])
```

```
## [1] "Franek"   "Havranek" "Janek"    "Stefanek"
```

```r
fct_dat2 <- mutate(fct_dat, 
                   imie = factor(imie, levels = imie[order(wzrost)]))
levels(fct_dat2[["imie"]])
```

```
## [1] "Franek"   "Janek"    "Havranek" "Stefanek"
```


## Trzy triki na factory

Zmiana nazw poziomów

```r
fct_dat2 <- mutate(fct_dat, 
                   imie = factor(imie, labels = toupper(levels(imie))))
levels(fct_dat2[["imie"]])
```

```
## [1] "FRANEK"   "HAVRANEK" "JANEK"    "STEFANEK"
```

## Trzy triki na factory

Łączenie poziomow

```r
fct_dat2 <- fct_dat
levels(fct_dat2[["imie"]]) <- c("Franek", "Janek", "Janek", "Stefanek")

levels(fct_dat2[["imie"]])
```

```
## [1] "Franek"   "Janek"    "Stefanek"
```


## Dane (raz jeszcze)

- plec: płeć
- waga: ważność obserwacji, istotne przy wyciąganiu średnich
- woj: województwo
- region66: region NUTS3. 
- internet_zawodowo: czy używa Pan/i internetu w pracy?
- samotnosc: Czy czuje się Pan/i samotny/a?
- internet_h: Ile godzin spędził/a Pan/i w internecie w ostatnim tygodniu?
- rok: rok sondażu.
