---
layout: post
title: "Materiały ze spotkania eRementarz #3: eksploracyjna analiza danych"
modified:
author: michal
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-12-06
output:
  md_document:
    variant: markdown_github
---

Ostatnie spotkanie STWURa w tym roku poprowadził Bartosz Kolasa - data scientist z firmy PiLab, a zorganizował Jarosław Chilimoniuk. Zachęcamy do zapoznania się z materiałami.

## Materiały

<https://github.com/STWUR/eRementarz3>

## Co robi Data Scientist?

![](img/tasks-time.PNG)

## Czego nie lubi Data Scientist?

![](img/tasks-enjoy.PNG)

## Wielokrotna iteracja

![](img/data3.png)

## Ekspolaracyjna analiza danych (EDA)

"Procedures for analyzing data, techniques for interpreting the results of such procedures, ways of planning the gathering of data to make its analysis easier, more precise or more accurate, and all the machinery and results of (mathematical) statistics which apply to analyzing data."

John Tukey

## Brudne dane

![](img/bad-data-is.png)



## Dane niepełne


```r
library(titanic)
```

```
## Error in library(titanic): there is no package called 'titanic'
```

```r
library(dplyr)
titanic_train %>% filter(is.na(Age)) %>% head
```

```
## Error in eval(lhs, parent, parent): object 'titanic_train' not found
```

## Dane niepoprawne

- dane spoza oczekiwanego zakresu
- niepoprawne kombinacje danych

![](img/australia.png)

## Dane niespójne

![](img/duplicates.jpg)

## Dane niezintegrowane

![](img/sources.png)

## Typy danych


```r
str(titanic_train)
```

```
## Error in str(titanic_train): object 'titanic_train' not found
```


## Uwaga na zmienne czynnikowe


```r
read.csv("myfile.csv", stringsAsFactors = FALSE)
```

## Macierz odpowiedniości

```r
table(titanic_train$Survived)
```

```
## Error in table(titanic_train$Survived): object 'titanic_train' not found
```

## Macierz odpowiedności


```r
table(titanic_train$Sex, titanic_train$Survived)
```

```
## Error in table(titanic_train$Sex, titanic_train$Survived): object 'titanic_train' not found
```

## Procentowo


```r
prop.table(table(titanic_train$Sex, titanic_train$Survived))
```

```
## Error in table(titanic_train$Sex, titanic_train$Survived): object 'titanic_train' not found
```

```r
# table(titanic_train$Sex, titanic_train$Survived) %>% prop.table
prop.table(table(titanic_train$Sex, titanic_train$Survived), margin=1)
```

```
## Error in table(titanic_train$Sex, titanic_train$Survived): object 'titanic_train' not found
```

## Czy zmienne są zależne?

```r
chisq.test(titanic_train$Survived, titanic_train$Sex) -> chsq
```

```
## Error in is.data.frame(x): object 'titanic_train' not found
```

```r
chsq$observed
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

```r
chsq$expected
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

## Która kombinacja zaburza najbardziej?

```r
chsq$residuals
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

```r
chsq$p.value
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

## Mniej widoczne

```r
titanic_emb <- dplyr::filter(titanic_train, Embarked != "")
```

```
## Error in dplyr::filter(titanic_train, Embarked != ""): object 'titanic_train' not found
```

```r
chisq.test(titanic_emb$Survived, titanic_emb$Embarked) -> chsq
```

```
## Error in is.data.frame(x): object 'titanic_emb' not found
```

```r
chsq$observed
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

```r
chsq$residuals
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

```r
chsq$p.value
```

```
## Error in eval(expr, envir, enclos): object 'chsq' not found
```

## Więcej wymiarów

```r
with(titanic_train, ftable(Survived, Sex, Embarked))
```

```
## Error in with(titanic_train, ftable(Survived, Sex, Embarked)): object 'titanic_train' not found
```

## Pakiet DescTools


```r
library(DescTools)
```

```
## Error in library(DescTools): there is no package called 'DescTools'
```

```r
Desc(titanic_train$Survived, plotit=FALSE)
```

```
## Error in Desc(titanic_train$Survived, plotit = FALSE): could not find function "Desc"
```

## Wykresy

```r
Desc(titanic_train$Survived, plotit=FALSE) -> d
```

```
## Error in Desc(titanic_train$Survived, plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```


## Więcej kategorii


```r
Desc(titanic_train$Embarked, plotit=FALSE)
```

```
## Error in Desc(titanic_train$Embarked, plotit = FALSE): could not find function "Desc"
```

## Wykresy

```r
Desc(titanic_train$Embarked, plotit=FALSE) -> d
```

```
## Error in Desc(titanic_train$Embarked, plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```

## Zmienna ciągła


```r
Desc(titanic_train$Age, plotit=FALSE)
```

```
## Error in Desc(titanic_train$Age, plotit = FALSE): could not find function "Desc"
```

## Wykresy

```r
Desc(titanic_train$Age, plotit=FALSE) -> d
```

```
## Error in Desc(titanic_train$Age, plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```

## Formuły


```r
Desc(titanic_train$Survived ~ titanic_train$Age, plotit=FALSE)
```

```
## Error in Desc(titanic_train$Survived ~ titanic_train$Age, plotit = FALSE): could not find function "Desc"
```

## Formuły

```r
Desc(titanic_train$Survived ~ titanic_train$Age, plotit=FALSE) ->d
```

```
## Error in Desc(titanic_train$Survived ~ titanic_train$Age, plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```

## Formuły


```r
Desc(titanic_train$Age ~ titanic_train$Survived, plotit=FALSE)
```

```
## Error in Desc(titanic_train$Age ~ titanic_train$Survived, plotit = FALSE): could not find function "Desc"
```

## Formuły

```r
Desc(titanic_train$Age ~ titanic_train$Survived, plotit=FALSE) ->d
```

```
## Error in Desc(titanic_train$Age ~ titanic_train$Survived, plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```

## Rozkład długoogonowy


```r
Desc(log10(titanic_train$Fare), plotit=FALSE)
```

```
## Error in Desc(log10(titanic_train$Fare), plotit = FALSE): could not find function "Desc"
```

## Rozkład długoogonowy

```r
Desc(log10(titanic_train$Fare), plotit=FALSE) ->d
```

```
## Error in Desc(log10(titanic_train$Fare), plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```

## Rozkład długoogonowy


```r
library(dplyr)
titanic_nozero <- mutate(titanic_train, Fare=na_if(Fare,0))
```

```
## Error in mutate(titanic_train, Fare = na_if(Fare, 0)): object 'titanic_train' not found
```

```r
Desc(log10(titanic_nozero$Fare), plotit=FALSE)
```

```
## Error in Desc(log10(titanic_nozero$Fare), plotit = FALSE): could not find function "Desc"
```

## Rozkład długoogonowy

```r
Desc(log10(titanic_nozero$Fare), plotit=FALSE) ->d
```

```
## Error in Desc(log10(titanic_nozero$Fare), plotit = FALSE): could not find function "Desc"
```

```r
plot(d)
```

```
## Error in plot(d): object 'd' not found
```

## Szybki sposób na outliery

```r
library(outliers)
titanic_train %>%
  filter(!is.na(Age)) %>% 
  mutate(score=scores(Age, type="iqr")) %>%
  select(Name,Age,score) %>% arrange(desc(score)) %>% head
```

```
## Error in eval(lhs, parent, parent): object 'titanic_train' not found
```


## Podziękowania

Dziękujemy firmie Kruk SA i Wydziałowi Biotechnologii UWr za wspieranie spotkań STWURa.

<img src="img/kruk_logo.jpg" width="50%" />
