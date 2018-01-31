---
layout: post
title: "Materiały ze spotkania eRementarz #4: uczenie maszynowe z pakietem mlr"
modified:
author: michal
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-01-31
output:
  md_document:
    variant: markdown_github
---


Pierwsze tegoroczne spotkanie STWUR-a poprowadził Mateusz Staniak, a zorganizował Jarosław Chilimoniuk. Zachęcamy do zapoznania się z materiałami.

Materiały
---------

[https://github.com/STWUR/eRementarz3](Pełna%20prezentacja%20na%20Githubie)

### Work flow

-   Przygotowanie danych (preprocessing)
-   Zadanie (task)
-   Wybór modelu (benchmark)
-   Strojenie parametrów (tuning)
-   Ocena modelu

### Dane

``` r
library(mlr)
library(dplyr)
library(ggplot2)

mieszkania  <- read.csv("mieszkania_wroclaw_ceny.csv")

head(mieszkania)
```

    ##   n_pokoj metraz cena_m2  rok pietro pietro_maks   dzielnica
    ## 1       3  89.00    5270 2007      2           2      Krzyki
    ## 2       4 163.00    6687 2002      2           2   Psie Pole
    ## 3       3  52.00    6731 1930      1           2 Srodmiescie
    ## 4       4  95.03    5525 2016      1           2      Krzyki
    ## 5       4  88.00    5216 1930      3           4 Srodmiescie
    ## 6       2  50.00    5600 1915      3           4      Krzyki

### Przygotowanie danych

Typowe zadania:

-   standaryzacja danych - `normalizeFeatures`
-   łączenie mało licznych poziomów zmiennych jakościowych - `mergeSmallFactorLevels`
-   wybranie części obserewacji - `subsetTask`
-   imputacja danych brakujących - `impute`
-   i inne...

### Zadania (task)

-   Obsługiwane klasy problemów

``` r
makeClassifTask()
makeRegrTask()
makeClusterTask()
makeCostSensTask()
makeMultilabelTask()
makeSurvTask()
```

### Nasz problem

``` r
m2_task <- makeRegrTask(id = "mieszkanie",
                        data = mieszkania,
                        target = "cena_m2")
```

-   Alternatywnie

``` r
m2_task_ndz <- makeRegrTask(id = "mieszkanie_ndz",
                            data = select(mieszkania, -dzielnica),
                            target = "cena_m2")
```

#### Uwaga

-   `fixup.data = "warn"`: czyszczenie danych (aktualnie tylko usuwanie pustych poziomów)
-   `check.data = TRUE`: sprawdzanie poprawności danych (aktualnie: NA i puste poziomy zmiennej odpowiedzi)

### Metody uczenia (learner)

-   Ogromna liczba dostępnych metod

``` r
listLearners(obj = "regr")[1:6, c(1, 3:4)]
```

    ##              class  short.name package
    ## 1     regr.cforest     cforest   party
    ## 2       regr.ctree       ctree   party
    ## 3    regr.cvglmnet    cvglmnet  glmnet
    ## 4 regr.featureless featureless     mlr
    ## 5     regr.gausspr     gausspr kernlab
    ## 6         regr.glm         glm   stats

-   Jak radzi sobie zwykła regresja liniowa?

``` r
reg_lm <- makeLearner("regr.lm")
```

-   A jak inne popularne metody?

``` r
reg_rf <- makeLearner("regr.randomForest")
reg_nnet <- makeLearner("regr.nnet")
```

-   Inaczej:

``` r
lrns <- makeLearners(c("lm", "randomForest", "nnet"),
                    type = "regr")
```

-   takie wywołania tworzą obiekty typu `Learner`
-   metody są zaimplementowane w odpowiednich pakietach - `mlr` jest nakładką
-   różne metody - różne wsparcie dla brakujących wartości, wag itd

-   Uwaga: w ten sposób wszystkie hiperparametry mają ustawione wartości domyślne

#### Informacje o metodzie

``` r
getLearnerProperties(reg_rf)
```

    ## [1] "numerics" "factors"  "ordered"  "se"       "oobpreds" "featimp"

``` r
getLearnerParamSet(reg_rf)
```

    ##                      Type  len       Def                 Constr Req
    ## ntree             integer    -       500               1 to Inf   -
    ## se.ntree          integer    -       100               1 to Inf   Y
    ## se.method        discrete    - jackknife bootstrap,jackknife,sd   Y
    ## se.boot           integer    -        50               1 to Inf   -
    ## mtry              integer    -         -               1 to Inf   -
    ## replace           logical    -      TRUE                      -   -
    ## strata            untyped    -         -                      -   -
    ## sampsize    integervector <NA>         -               1 to Inf   -
    ## nodesize          integer    -         5               1 to Inf   -
    ## maxnodes          integer    -         -               1 to Inf   -
    ## importance        logical    -     FALSE                      -   -
    ## localImp          logical    -     FALSE                      -   -
    ## nPerm             integer    -         1            -Inf to Inf   -
    ## proximity         logical    -     FALSE                      -   -
    ## oob.prox          logical    -         -                      -   Y
    ## do.trace          logical    -     FALSE                      -   -
    ## keep.forest       logical    -      TRUE                      -   -
    ## keep.inbag        logical    -     FALSE                      -   -
    ##             Tunable Trafo
    ## ntree          TRUE     -
    ## se.ntree       TRUE     -
    ## se.method      TRUE     -
    ## se.boot        TRUE     -
    ## mtry           TRUE     -
    ## replace        TRUE     -
    ## strata        FALSE     -
    ## sampsize       TRUE     -
    ## nodesize       TRUE     -
    ## maxnodes       TRUE     -
    ## importance     TRUE     -
    ## localImp       TRUE     -
    ## nPerm          TRUE     -
    ## proximity     FALSE     -
    ## oob.prox      FALSE     -
    ## do.trace      FALSE     -
    ## keep.forest   FALSE     -
    ## keep.inbag    FALSE     -

### Ustawianie hiperparametrów

-   przy tworzeniu learnera:

``` r
reg_rf2 <- makeLearner("regr.randomForest",
                       par.vals = list(ntree = 1000))
```

-   po utworzeniu learnera:

``` r
reg_rf2 <- setHyperPars(reg_rf, ntree = 1000)
```

``` r
getHyperPars(reg_rf2)
```

    ## $ntree
    ## [1] 1000

### Porównywanie modeli

``` r
porownanie <- benchmark(learners = list(reg_lm, reg_rf, reg_nnet),
                        tasks = list(m2_task, m2_task_ndz),
                        resampling = cv5)
save(porownanie, file = "porownanie.rda")
```

``` r
load("porownanie.rda")
porownanie
```

    ##          task.id        learner.id mse.test.mean
    ## 1     mieszkanie           regr.lm       2084932
    ## 2     mieszkanie regr.randomForest       1119241
    ## 3     mieszkanie         regr.nnet       2674150
    ## 4 mieszkanie_ndz           regr.lm       2481207
    ## 5 mieszkanie_ndz regr.randomForest       1748378
    ## 6 mieszkanie_ndz         regr.nnet       2672237

#### Wyniki porównania

``` r
# getBMRAggrPerformances(porownanie)
# getBMRPerformances(porownanie)
plotBMRBoxplots(porownanie)
```

![](2018-01-31-eRementarz4_files/figure-markdown_github/wynikpor-1.png)

#### Różne kryteria

``` r
listMeasures(obj = "regr")
```

    ##  [1] "rsq"         "rae"         "rmsle"       "mse"         "rrse"       
    ##  [6] "medse"       "mae"         "timeboth"    "timepredict" "medae"      
    ## [11] "featperc"    "mape"        "rmse"        "kendalltau"  "sse"        
    ## [16] "arsq"        "expvar"      "msle"        "sae"         "timetrain"  
    ## [21] "spearmanrho"

### Wytrenowanie pojedynczego modelu

-   podstawowe wywołanie:

``` r
m2_rf <- train(reg_rf2, m2_task)
```

-   uwaga: można samodzielnie zdefiniować zbiór uczący

``` r
uczacy <- sample(1:nrow(mieszkania), floor(0.7*nrow(mieszkania)))
testowy <- setdiff(1:nrow(mieszkania), uczacy)
```

``` r
m2_rf_czesc <- train(reg_rf2, m2_task, subset = uczacy)
```

-   przewidywane wartości:

``` r
pred <- predict(m2_rf, task = m2_task)
head(getPredictionResponse(pred))
```

    ## [1] 5353.419 6598.072 6426.211 5378.307 5241.464 5547.251

``` r
pred2 <- predict(m2_rf_czesc, newdata = mieszkania[testowy, ])
head(getPredictionResponse(pred2))
```

    ## [1] 6561.364 7179.609 4940.466 7324.085 5975.484 5270.767

### Strojenie parametrów

``` r
all_params <- makeParamSet(
  makeDiscreteParam("mtry", values = 2:5),
  makeDiscreteParam("nodesize", values = seq(5, 45, by = 10))
)
```

``` r
m2_params <- tuneParams(reg_rf2, task = m2_task,
                        resampling = cv3,
                        par.set = all_params,
                        control =  makeTuneControlGrid())
```

#### Wynik

``` r
m2_params
```

    ## Tune result:
    ## Op. pars: mtry=3; nodesize=5
    ## mse.test.mean=1.15e+06

``` r
par_data <- generateHyperParsEffectData(m2_params)
plotHyperParsEffect(par_data, x = "mtry", y = "nodesize", z = "mse.test.mean", plot.type = "heatmap")
```

![](2018-01-31-eRementarz4_files/figure-markdown_github/wyswietlpar-1.png)

``` r
reg_rf2 <- setHyperPars(reg_rf2, mtry = 3)
```

``` r
m2_rf2 <- train(reg_rf2, m2_task)
```

#### Inne kontrolki

``` r
makeTuneControlCMAES()
makeTuneControlIrace()
makeTuneControlRandom()
```

### Cena mieszkania

``` r
moje <- data.frame(n_pokoj = 3L,
                   metraz = 60.00,
                   rok = 2010L,
                   pietro = 3L,
                   pietro_maks = 5L,
                   dzielnica = "Srodmiescie")
moje$dzielnica <- factor(moje$dzielnica,
                         levels = levels(mieszkania$dzielnica))
predict(m2_rf2, newdata = moje)
```

    ## Prediction: 1 observations
    ## predict.type: response
    ## threshold: 
    ## time: 0.09
    ##   response
    ## 1 7503.985

### Wizualizacja modelu

``` r
pdp <- generatePartialDependenceData(m2_rf2,
                                     m2_task,
                                     features = colnames(mieszkania)[-c(3, 7)])
```

``` r
plotPartialDependence(pdp)
```

![](2018-01-31-eRementarz4_files/figure-markdown_github/plotpdp-1.png)

### Podsumowanie

-   Tworzenie zadania: `makeRegrTask`, `makeClassifTask` itd
-   Metoda uczenia: `makeLearner`, `makeLearners`
-   Porównanie kilku modeli: `benchmark`
-   Ustawianie hiperparametrów: `setHyperPars`
-   Wytrenowanie pojedynczego modelu: `train`
-   Strojenie parametrów: `tuneParams`

### Podziękowanie

Dziękujemy firmie Kruk i Wydziałowi Biotechnologii UWr.
