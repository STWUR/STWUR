---
layout: post
title: "Czy stać mnie na mieszkanie we Wrocławiu?"
---



Piąty STWUR odbył się 7.06.2017 - poniżej prezentacja ze spotkania.

## Link do repotyzorium

http://tinyurl.com/stwur5 - kody i dane do dzisiejszego spotkania.

Wygenerowanie tej prezentacji wymaga uruchomienia pliku **analysis.R**

## Uczenie maszynowe w R

Pakiety w **R** implementują większość ze znanych algorytmów uczenia maszynowego.


```r
## S3 method for class 'formula'
randomForest(formula, data=NULL, ..., subset, na.action = na.fail)

## S4 method for signature 'formula'
ksvm(x, data = NULL, ..., subset, na.action = na.omit, scaled = TRUE)
```

Ze względu na duże zróżnicowanie funkcji, uczenie maszynowe w **R** wymaga dużo zbędnego wysiłku.

## mlr

Pakiet **mlr** standaryzuje pracę z uczeniem maszynowym w *R* poprzez stworzenie wraperów wokół najpopularniejszych implementacji algorytmów uczenia maszynowego.


```r
listLearners()
```

```
## Warning in listLearners.character(obj = NA_character_, properties, quiet, : The following learners could not be constructed, probably because their packages are not installed:
## classif.ada,classif.bartMachine,classif.bdk,classif.blackboost,classif.boosting,classif.bst,classif.C50,classif.cforest,classif.clusterSVM,classif.ctree,classif.cvglmnet,classif.dbnDNN,classif.dcSVM,classif.earth,classif.evtree,classif.extraTrees,classif.fnn,classif.gamboost,classif.gaterSVM,classif.gbm,classif.geoDA,classif.glmboost,classif.glmnet,classif.h2o.deeplearning,classif.h2o.gbm,classif.h2o.glm,classif.h2o.randomForest,classif.hdrda,classif.IBk,classif.J48,classif.JRip,classif.kknn,classif.LiblineaRL1L2SVC,classif.LiblineaRL1LogReg,classif.LiblineaRL2L1SVC,classif.LiblineaRL2LogReg,classif.LiblineaRL2SVC,classif.LiblineaRMultiClassSVC,classif.linDA,classif.lqa,classif.mda,classif.mlp,classif.neuralnet,classif.nnTrain,classif.nodeHarvest,classif.OneR,classif.pamr,classif.PART,classif.penalized.fusedlasso,classif.penalized.lasso,classif.penalized.ridge,classif.plr,classif.plsdaCaret,classif.quaDA,classif.randomForestSRC,classif.rda,classif.rFerns,classif.rknn,classif.rotationForest,classif.RRF,classif.rrlda,classif.saeDNN,classif.sda,classif.sparseLDA,classif.xgboost,classif.xyf,cluster.cmeans,cluster.Cobweb,cluster.EM,cluster.FarthestFirst,cluster.kmeans,cluster.SimpleKMeans,cluster.XMeans,multilabel.cforest,multilabel.randomForestSRC,multilabel.rFerns,regr.bartMachine,regr.bcart,regr.bdk,regr.bgp,regr.bgpllm,regr.blackboost,regr.blm,regr.brnn,regr.bst,regr.btgp,regr.btgpllm,regr.btlm,regr.cforest,regr.crs,regr.ctree,regr.cubist,regr.cvglmnet,regr.earth,regr.elmNN,regr.evtree,regr.extraTrees,regr.fnn,regr.frbs,regr.gamboost,regr.gbm,regr.glmboost,regr.glmnet,regr.GPfit,regr.h2o.deeplearning,regr.h2o.gbm,regr.h2o.glm,regr.h2o.randomForest,regr.IBk,regr.kknn,regr.km,regr.laGP,regr.LiblineaRL2L1SVR,regr.LiblineaRL2L2SVR,regr.mars,regr.mob,regr.nodeHarvest,regr.pcr,regr.penalized.fusedlasso,regr.penalized.lasso,regr.penalized.ridge,regr.plsr,regr.randomForestSRC,regr.rknn,regr.RRF,regr.rsm,regr.slim,regr.xgboost,regr.xyf,surv.cforest,surv.CoxBoost,surv.cv.CoxBoost,surv.cvglmnet,surv.gamboost,surv.gbm,surv.glmboost,surv.glmnet,surv.penalized.fusedlasso,surv.penalized.lasso,surv.penalized.ridge,surv.randomForestSRC
## Check ?learners to see which packages you need or install mlr with all suggestions.
```

```
##                 class                         name  short.name package
## 1    classif.binomial          Binomial Regression    binomial   stats
## 2 classif.featureless       Featureless classifier featureless     mlr
## 3     classif.gausspr           Gaussian Processes     gausspr kernlab
## 4         classif.knn           k-Nearest Neighbor         knn   class
## 5        classif.ksvm      Support Vector Machines        ksvm kernlab
## 6         classif.lda Linear Discriminant Analysis         lda    MASS
##      type installed numerics factors ordered missings weights  prob
## 1 classif      TRUE     TRUE    TRUE   FALSE    FALSE    TRUE  TRUE
## 2 classif      TRUE     TRUE    TRUE    TRUE     TRUE   FALSE  TRUE
## 3 classif      TRUE     TRUE    TRUE   FALSE    FALSE   FALSE  TRUE
## 4 classif      TRUE     TRUE   FALSE   FALSE    FALSE   FALSE FALSE
## 5 classif      TRUE     TRUE    TRUE   FALSE    FALSE   FALSE  TRUE
## 6 classif      TRUE     TRUE    TRUE   FALSE    FALSE   FALSE  TRUE
##   oneclass twoclass multiclass class.weights featimp oobpreds    se lcens
## 1    FALSE     TRUE      FALSE         FALSE   FALSE    FALSE FALSE FALSE
## 2    FALSE     TRUE       TRUE         FALSE   FALSE    FALSE FALSE FALSE
## 3    FALSE     TRUE       TRUE         FALSE   FALSE    FALSE FALSE FALSE
## 4    FALSE     TRUE       TRUE         FALSE   FALSE    FALSE FALSE FALSE
## 5    FALSE     TRUE       TRUE          TRUE   FALSE    FALSE FALSE FALSE
## 6    FALSE     TRUE       TRUE         FALSE   FALSE    FALSE FALSE FALSE
##   rcens icens
## 1 FALSE FALSE
## 2 FALSE FALSE
## 3 FALSE FALSE
## 4 FALSE FALSE
## 5 FALSE FALSE
## 6 FALSE FALSE
## ... (34 rows, 22 cols)
```

## Zdefiniowanie learnera


```r
learnerRF <- makeLearner("regr.randomForest")
learnerNN <- makeLearner("regr.nnet")
learnerSVM <- makeLearner("regr.ksvm")

print(learnerNN)
```

```
## Learner regr.nnet from package nnet
## Type: regr
## Name: Neural Network; Short name: nnet
## Class: regr.nnet
## Properties: numerics,factors,weights
## Predict-Type: response
## Hyperparameters: size=3
```

```r
# alternatywnie:
# makeLearners(c("randomForest", "nnet", "ksvm"), type = "regr")
```

## Określenie zadania


```r
mieszkania <- na.omit(read.csv(file = "./data/mieszkania_dane.csv", encoding = "UTF-8"))

# zadania - kazde zadanie to inny zbior danych
predict_price <- makeRegrTask(id = "cenaMieszkan", data = mieszkania, target = "cena_m2")

predict_price2 <- makeRegrTask(id = "cenaMieszkanBezDzielnicy", 
                               data = select(mieszkania, -dzielnica), 
                               target = "cena_m2")

predict_price3 <- makeRegrTask(id = "cenaMieszkanBezMaksPieter", 
                               data = select(mieszkania, -pietro_maks), 
                               target = "cena_m2")
```

## Walidacja krzyżowa


```r
bench_cv <- crossval(learnerRF, predict_price)
#można też holdout, bootstrapOOB itp
```

Każdy z obiektów klasy **ResampleResult** można analizować za pomocą ujednoliconych metod.


```r
getRRPredictionList(bench_cv)
```

```
## $train
## NULL
## 
## $test
## $test$`1`
## Prediction: 586 observations
## predict.type: response
## threshold: 
## time: 0.34
##    id truth response
## 10 10  6878 6877.330
## 20 20  6154 5742.281
## 24 24  6870 6916.033
## 42 42  4621 4640.902
## 48 48  4796 5238.064
## 55 55  7600 7252.475
## ... (586 rows, 3 cols)
## 
## 
## $test$`2`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.20
##    id truth response
## 17 17  8111 7544.035
## 21 21  5882 6116.426
## 26 26  5363 5161.359
## 45 45  6364 6674.485
## 47 47  6294 5621.022
## 61 61  6628 5340.896
## ... (585 rows, 3 cols)
## 
## 
## $test$`3`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.19
##    id truth response
## 5   5  5216 5237.439
## 8   8  9761 9278.474
## 36 36  5232 5557.676
## 43 43  5875 5808.060
## 49 49  5806 5745.025
## 50 50  6976 6615.376
## ... (585 rows, 3 cols)
## 
## 
## $test$`4`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.20
##    id truth response
## 1   1  5270 5420.443
## 3   3  6731 6133.154
## 13 13  3586 5832.009
## 34 34  6909 6450.828
## 44 44  5160 6905.925
## 63 63  6765 5878.371
## ... (585 rows, 3 cols)
## 
## 
## $test$`5`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.19
##    id truth response
## 6   6  5600 5516.665
## 7   7  9146 7560.897
## 11 11  8684 4978.036
## 23 23  5972 6393.206
## 28 28  6675 5369.310
## 31 31  4671 5125.724
## ... (585 rows, 3 cols)
## 
## 
## $test$`6`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.20
##    id truth response
## 12 12  6327 7195.745
## 29 29  5303 5369.189
## 30 30  4277 5284.370
## 35 35  4897 5373.087
## 38 38  7341 6732.968
## 46 46  5780 6175.006
## ... (585 rows, 3 cols)
## 
## 
## $test$`7`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.07
##    id truth response
## 14 14  5369 5047.436
## 22 22  6968 5492.012
## 25 25  7358 6626.651
## 64 64  4894 5593.881
## 67 67  8754 7119.083
## 90 90  6643 6482.012
## ... (585 rows, 3 cols)
## 
## 
## $test$`8`
## Prediction: 586 observations
## predict.type: response
## threshold: 
## time: 0.20
##    id truth response
## 2   2  6687 6349.784
## 18 18  5716 6217.368
## 19 19  6340 6111.002
## 27 27  4591 5123.258
## 32 32  6064 5540.409
## 33 33  5000 5783.833
## ... (586 rows, 3 cols)
## 
## 
## $test$`9`
## Prediction: 585 observations
## predict.type: response
## threshold: 
## time: 0.19
##    id truth response
## 4   4  5525 5298.399
## 9   9  5209 5375.390
## 15 15  8100 7263.012
## 37 37  5937 6154.977
## 40 40  5322 5323.819
## 52 52  5436 6085.986
## ... (585 rows, 3 cols)
## 
## 
## $test$`10`
## Prediction: 586 observations
## predict.type: response
## threshold: 
## time: 0.19
##    id truth response
## 16 16  8409 7799.708
## 39 39  5781 5687.117
## 57 57  6918 6009.486
## 72 72  5895 6133.250
## 74 74  5306 5777.349
## 79 79  4916 5764.658
## ... (586 rows, 3 cols)
```

## Benchmark

Funkcja benchmark to rozszerzenie prostszych funkcji (takich jak **crossval**) na wiele zadań i wiele klasyfikatorów.


```r
bench_regr <- benchmark(learners = list(learnerRF,
                                        learnerNN,
                                        learnerSVM),
                        tasks = list(predict_price,
                                     predict_price2,
                                     predict_price3))
```

## Benchmark


```r
as.data.frame(bench_regr)
```

```
##                      task.id        learner.id iter       mse
## 1               cenaMieszkan regr.randomForest    1  839348.3
## 2               cenaMieszkan regr.randomForest    2  874275.2
## 3               cenaMieszkan regr.randomForest    3 1299829.0
## 4               cenaMieszkan regr.randomForest    4 1510080.1
## 5               cenaMieszkan regr.randomForest    5  784144.1
## 6               cenaMieszkan regr.randomForest    6 1067753.7
## 7               cenaMieszkan regr.randomForest    7 1000952.8
## 8               cenaMieszkan regr.randomForest    8 1013920.2
## 9               cenaMieszkan regr.randomForest    9 1297249.9
## 10              cenaMieszkan regr.randomForest   10 1297583.5
## 11              cenaMieszkan         regr.nnet    1 2104482.2
## 12              cenaMieszkan         regr.nnet    2 2381276.9
## 13              cenaMieszkan         regr.nnet    3 3447641.8
## 14              cenaMieszkan         regr.nnet    4 3568701.8
## 15              cenaMieszkan         regr.nnet    5 1822719.1
## 16              cenaMieszkan         regr.nnet    6 2588841.8
## 17              cenaMieszkan         regr.nnet    7 2533394.1
## 18              cenaMieszkan         regr.nnet    8 2469885.3
## 19              cenaMieszkan         regr.nnet    9 2702901.8
## 20              cenaMieszkan         regr.nnet   10 3112267.5
## 21              cenaMieszkan         regr.ksvm    1 1273267.3
## 22              cenaMieszkan         regr.ksvm    2 1563242.1
## 23              cenaMieszkan         regr.ksvm    3 2086075.1
## 24              cenaMieszkan         regr.ksvm    4 2279127.7
## 25              cenaMieszkan         regr.ksvm    5 1080269.3
## 26              cenaMieszkan         regr.ksvm    6 1612142.3
## 27              cenaMieszkan         regr.ksvm    7 1537292.4
## 28              cenaMieszkan         regr.ksvm    8 1476517.8
## 29              cenaMieszkan         regr.ksvm    9 1878614.2
## 30              cenaMieszkan         regr.ksvm   10 1929747.9
## 31  cenaMieszkanBezDzielnicy regr.randomForest    1 1503597.7
## 32  cenaMieszkanBezDzielnicy regr.randomForest    2 1730503.2
## 33  cenaMieszkanBezDzielnicy regr.randomForest    3 1739299.0
## 34  cenaMieszkanBezDzielnicy regr.randomForest    4 2229319.9
## 35  cenaMieszkanBezDzielnicy regr.randomForest    5 1752890.5
## 36  cenaMieszkanBezDzielnicy regr.randomForest    6 1979818.8
## 37  cenaMieszkanBezDzielnicy regr.randomForest    7 1383729.8
## 38  cenaMieszkanBezDzielnicy regr.randomForest    8 1173487.4
## 39  cenaMieszkanBezDzielnicy regr.randomForest    9 1827983.3
## 40  cenaMieszkanBezDzielnicy regr.randomForest   10 1926375.9
## 41  cenaMieszkanBezDzielnicy         regr.nnet    1 2263569.3
## 42  cenaMieszkanBezDzielnicy         regr.nnet    2 2484105.0
## 43  cenaMieszkanBezDzielnicy         regr.nnet    3 2885504.9
## 44  cenaMieszkanBezDzielnicy         regr.nnet    4 3368083.1
## 45  cenaMieszkanBezDzielnicy         regr.nnet    5 2763016.4
## 46  cenaMieszkanBezDzielnicy         regr.nnet    6 3050600.3
## 47  cenaMieszkanBezDzielnicy         regr.nnet    7 2043085.5
## 48  cenaMieszkanBezDzielnicy         regr.nnet    8 1953868.7
## 49  cenaMieszkanBezDzielnicy         regr.nnet    9 3074898.7
## 50  cenaMieszkanBezDzielnicy         regr.nnet   10 2844002.0
## 51  cenaMieszkanBezDzielnicy         regr.ksvm    1 1754017.1
## 52  cenaMieszkanBezDzielnicy         regr.ksvm    2 2142753.8
## 53  cenaMieszkanBezDzielnicy         regr.ksvm    3 2305377.0
## 54  cenaMieszkanBezDzielnicy         regr.ksvm    4 2925467.7
## 55  cenaMieszkanBezDzielnicy         regr.ksvm    5 2342743.4
## 56  cenaMieszkanBezDzielnicy         regr.ksvm    6 2657185.6
## 57  cenaMieszkanBezDzielnicy         regr.ksvm    7 1645302.7
## 58  cenaMieszkanBezDzielnicy         regr.ksvm    8 1467250.5
## 59  cenaMieszkanBezDzielnicy         regr.ksvm    9 2681122.0
## 60  cenaMieszkanBezDzielnicy         regr.ksvm   10 2243154.6
## 61 cenaMieszkanBezMaksPieter regr.randomForest    1 1093192.8
## 62 cenaMieszkanBezMaksPieter regr.randomForest    2 1204704.2
## 63 cenaMieszkanBezMaksPieter regr.randomForest    3 1709391.2
## 64 cenaMieszkanBezMaksPieter regr.randomForest    4 1295037.3
## 65 cenaMieszkanBezMaksPieter regr.randomForest    5 1527194.2
## 66 cenaMieszkanBezMaksPieter regr.randomForest    6 1462621.4
## 67 cenaMieszkanBezMaksPieter regr.randomForest    7 1294842.2
## 68 cenaMieszkanBezMaksPieter regr.randomForest    8 1244385.7
## 69 cenaMieszkanBezMaksPieter regr.randomForest    9 2156677.1
## 70 cenaMieszkanBezMaksPieter regr.randomForest   10 1377081.3
## 71 cenaMieszkanBezMaksPieter         regr.nnet    1 2215076.8
## 72 cenaMieszkanBezMaksPieter         regr.nnet    2 2124022.1
## 73 cenaMieszkanBezMaksPieter         regr.nnet    3 3233803.6
## 74 cenaMieszkanBezMaksPieter         regr.nnet    4 2441985.1
## 75 cenaMieszkanBezMaksPieter         regr.nnet    5 2895856.1
## 76 cenaMieszkanBezMaksPieter         regr.nnet    6 2672517.0
## 77 cenaMieszkanBezMaksPieter         regr.nnet    7 2454300.3
## 78 cenaMieszkanBezMaksPieter         regr.nnet    8 2424117.6
## 79 cenaMieszkanBezMaksPieter         regr.nnet    9 3669234.9
## 80 cenaMieszkanBezMaksPieter         regr.nnet   10 2599188.6
## 81 cenaMieszkanBezMaksPieter         regr.ksvm    1 1203005.3
## 82 cenaMieszkanBezMaksPieter         regr.ksvm    2 1362469.8
## 83 cenaMieszkanBezMaksPieter         regr.ksvm    3 1865918.2
## 84 cenaMieszkanBezMaksPieter         regr.ksvm    4 1501489.8
## 85 cenaMieszkanBezMaksPieter         regr.ksvm    5 1681702.0
## 86 cenaMieszkanBezMaksPieter         regr.ksvm    6 1853996.5
## 87 cenaMieszkanBezMaksPieter         regr.ksvm    7 1458107.3
## 88 cenaMieszkanBezMaksPieter         regr.ksvm    8 1629955.8
## 89 cenaMieszkanBezMaksPieter         regr.ksvm    9 2481233.7
## 90 cenaMieszkanBezMaksPieter         regr.ksvm   10 1589512.6
```


## Benchmark


```r
getBMRAggrPerformances(bench_regr)
```

```
## $cenaMieszkan
## $cenaMieszkan$regr.randomForest
## mse.test.mean 
##       1098514 
## 
## $cenaMieszkan$regr.nnet
## mse.test.mean 
##       2673211 
## 
## $cenaMieszkan$regr.ksvm
## mse.test.mean 
##       1671630 
## 
## 
## $cenaMieszkanBezDzielnicy
## $cenaMieszkanBezDzielnicy$regr.randomForest
## mse.test.mean 
##       1724701 
## 
## $cenaMieszkanBezDzielnicy$regr.nnet
## mse.test.mean 
##       2673073 
## 
## $cenaMieszkanBezDzielnicy$regr.ksvm
## mse.test.mean 
##       2216437 
## 
## 
## $cenaMieszkanBezMaksPieter
## $cenaMieszkanBezMaksPieter$regr.randomForest
## mse.test.mean 
##       1436513 
## 
## $cenaMieszkanBezMaksPieter$regr.nnet
## mse.test.mean 
##       2673010 
## 
## $cenaMieszkanBezMaksPieter$regr.ksvm
## mse.test.mean 
##       1662739
```

## Benchmark


```r
getBMRPerformances(bench_regr)
```

```
## $cenaMieszkan
## $cenaMieszkan$regr.randomForest
##    iter       mse
## 1     1  839348.3
## 2     2  874275.2
## 3     3 1299829.0
## 4     4 1510080.1
## 5     5  784144.1
## 6     6 1067753.7
## 7     7 1000952.8
## 8     8 1013920.2
## 9     9 1297249.9
## 10   10 1297583.5
## 
## $cenaMieszkan$regr.nnet
##    iter     mse
## 1     1 2104482
## 2     2 2381277
## 3     3 3447642
## 4     4 3568702
## 5     5 1822719
## 6     6 2588842
## 7     7 2533394
## 8     8 2469885
## 9     9 2702902
## 10   10 3112268
## 
## $cenaMieszkan$regr.ksvm
##    iter     mse
## 1     1 1273267
## 2     2 1563242
## 3     3 2086075
## 4     4 2279128
## 5     5 1080269
## 6     6 1612142
## 7     7 1537292
## 8     8 1476518
## 9     9 1878614
## 10   10 1929748
## 
## 
## $cenaMieszkanBezDzielnicy
## $cenaMieszkanBezDzielnicy$regr.randomForest
##    iter     mse
## 1     1 1503598
## 2     2 1730503
## 3     3 1739299
## 4     4 2229320
## 5     5 1752890
## 6     6 1979819
## 7     7 1383730
## 8     8 1173487
## 9     9 1827983
## 10   10 1926376
## 
## $cenaMieszkanBezDzielnicy$regr.nnet
##    iter     mse
## 1     1 2263569
## 2     2 2484105
## 3     3 2885505
## 4     4 3368083
## 5     5 2763016
## 6     6 3050600
## 7     7 2043085
## 8     8 1953869
## 9     9 3074899
## 10   10 2844002
## 
## $cenaMieszkanBezDzielnicy$regr.ksvm
##    iter     mse
## 1     1 1754017
## 2     2 2142754
## 3     3 2305377
## 4     4 2925468
## 5     5 2342743
## 6     6 2657186
## 7     7 1645303
## 8     8 1467251
## 9     9 2681122
## 10   10 2243155
## 
## 
## $cenaMieszkanBezMaksPieter
## $cenaMieszkanBezMaksPieter$regr.randomForest
##    iter     mse
## 1     1 1093193
## 2     2 1204704
## 3     3 1709391
## 4     4 1295037
## 5     5 1527194
## 6     6 1462621
## 7     7 1294842
## 8     8 1244386
## 9     9 2156677
## 10   10 1377081
## 
## $cenaMieszkanBezMaksPieter$regr.nnet
##    iter     mse
## 1     1 2215077
## 2     2 2124022
## 3     3 3233804
## 4     4 2441985
## 5     5 2895856
## 6     6 2672517
## 7     7 2454300
## 8     8 2424118
## 9     9 3669235
## 10   10 2599189
## 
## $cenaMieszkanBezMaksPieter$regr.ksvm
##    iter     mse
## 1     1 1203005
## 2     2 1362470
## 3     3 1865918
## 4     4 1501490
## 5     5 1681702
## 6     6 1853997
## 7     7 1458107
## 8     8 1629956
## 9     9 2481234
## 10   10 1589513
```

## Benchmark


```r
plotBMRBoxplots(bench_regr)
```

![plot of chunk unnamed-chunk-11](/images/STWUR/stwur5_prezentacja/figure/unnamed-chunk-11-1.png)

## Zadanie

Z pomocą skryptu *classification_affordable_apartments.R* przewidźmy na jakie mieszkanie stać typowego wrocławianina.

http://tinyurl.com/stwur5 - kody i dane do dzisiejszego spotkania.

Dziękujemy firmie Kruk SA za wspieranie spotkań STWURa.

<img src='https://stwur.github.io/STWUR//images/kruk_logo.jpg' id="logo" height="35%" width="35%"/>
