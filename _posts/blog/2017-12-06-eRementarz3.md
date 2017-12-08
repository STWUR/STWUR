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
library(dplyr)
titanic_train %>% filter(is.na(Age)) %>% head
```

```
##   PassengerId Survived Pclass                          Name    Sex Age
## 1           6        0      3              Moran, Mr. James   male  NA
## 2          18        1      2  Williams, Mr. Charles Eugene   male  NA
## 3          20        1      3       Masselmani, Mrs. Fatima female  NA
## 4          27        0      3       Emir, Mr. Farred Chehab   male  NA
## 5          29        1      3 O'Dwyer, Miss. Ellen "Nellie" female  NA
## 6          30        0      3           Todoroff, Mr. Lalio   male  NA
##   SibSp Parch Ticket    Fare Cabin Embarked
## 1     0     0 330877  8.4583              Q
## 2     0     0 244373 13.0000              S
## 3     0     0   2649  7.2250              C
## 4     0     0   2631  7.2250              C
## 5     0     0 330959  7.8792              Q
## 6     0     0 349216  7.8958              S
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
## 'data.frame':	891 obs. of  12 variables:
##  $ PassengerId: int  1 2 3 4 5 6 7 8 9 10 ...
##  $ Survived   : int  0 1 1 1 0 0 0 0 1 1 ...
##  $ Pclass     : int  3 1 3 1 3 3 1 3 3 2 ...
##  $ Name       : chr  "Braund, Mr. Owen Harris" "Cumings, Mrs. John Bradley (Florence Briggs Thayer)" "Heikkinen, Miss. Laina" "Futrelle, Mrs. Jacques Heath (Lily May Peel)" ...
##  $ Sex        : chr  "male" "female" "female" "female" ...
##  $ Age        : num  22 38 26 35 35 NA 54 2 27 14 ...
##  $ SibSp      : int  1 1 0 1 0 0 0 3 0 1 ...
##  $ Parch      : int  0 0 0 0 0 0 0 1 2 0 ...
##  $ Ticket     : chr  "A/5 21171" "PC 17599" "STON/O2. 3101282" "113803" ...
##  $ Fare       : num  7.25 71.28 7.92 53.1 8.05 ...
##  $ Cabin      : chr  "" "C85" "" "C123" ...
##  $ Embarked   : chr  "S" "C" "S" "S" ...
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
## 
##   0   1 
## 549 342
```

## Macierz odpowiedności


```r
table(titanic_train$Sex, titanic_train$Survived)
```

```
##         
##            0   1
##   female  81 233
##   male   468 109
```

## Procentowo


```r
prop.table(table(titanic_train$Sex, titanic_train$Survived))
```

```
##         
##                   0          1
##   female 0.09090909 0.26150393
##   male   0.52525253 0.12233446
```

```r
# table(titanic_train$Sex, titanic_train$Survived) %>% prop.table
prop.table(table(titanic_train$Sex, titanic_train$Survived), margin=1)
```

```
##         
##                  0         1
##   female 0.2579618 0.7420382
##   male   0.8110919 0.1889081
```

## Czy zmienne są zależne?

```r
chisq.test(titanic_train$Survived, titanic_train$Sex) -> chsq
chsq$observed
```

```
##                       titanic_train$Sex
## titanic_train$Survived female male
##                      0     81  468
##                      1    233  109
```

```r
chsq$expected
```

```
##                       titanic_train$Sex
## titanic_train$Survived   female     male
##                      0 193.4747 355.5253
##                      1 120.5253 221.4747
```

## Która kombinacja zaburza najbardziej?

```r
chsq$residuals
```

```
##                       titanic_train$Sex
## titanic_train$Survived    female      male
##                      0 -8.086170  5.965128
##                      1 10.245095 -7.557757
```

```r
chsq$p.value
```

```
## [1] 1.197357e-58
```

## Mniej widoczne

```r
titanic_emb <- dplyr::filter(titanic_train, Embarked != "")
chisq.test(titanic_emb$Survived, titanic_emb$Embarked) -> chsq
chsq$observed
```

```
##                     titanic_emb$Embarked
## titanic_emb$Survived   C   Q   S
##                    0  75  47 427
##                    1  93  30 217
```

```r
chsq$residuals
```

```
##                     titanic_emb$Embarked
## titanic_emb$Survived           C           Q           S
##                    0 -2.82239750 -0.07993071  1.46918919
##                    1  3.58645093  0.10156881 -1.86691454
```

```r
chsq$p.value
```

```
## [1] 1.769922e-06
```

## Więcej wymiarów

```r
with(titanic_train, ftable(Survived, Sex, Embarked))
```

```
##                 Embarked       C   Q   S
## Survived Sex                            
## 0        female            0   9   9  63
##          male              0  66  38 364
## 1        female            2  64  27 140
##          male              0  29   3  77
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
##                                   Name  Age    score
## 1 Barkworth, Mr. Algernon Henry Wilson 80.0 2.349650
## 2                  Svensson, Mr. Johan 74.0 2.013986
## 3            Goldschmidt, Mr. George B 71.0 1.846154
## 4              Artagaveytia, Mr. Ramon 71.0 1.846154
## 5                 Connors, Mr. Patrick 70.5 1.818182
## 6          Mitchell, Mr. Henry Michael 70.0 1.790210
```


## Podziękowania

Dziękujemy firmie Kruk SA i Wydziałowi Biotechnologii UWr za wspieranie spotkań STWURa.

<img src="img/kruk_logo.jpg" width="50%" />
