---
layout: post
title: "STWUR #6: materiały ze spotkania"
---

Czy stać mnie na mieszkanie moich marzeń we Wrocławiu?



## Link do repotyzorium

https://tinyurl.com/stwur6 - kody i dane do dzisiejszego spotkania.


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

## Sieci neuronowe

<center><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Colored_neural_network.svg/296px-Colored_neural_network.svg.png"></center>

Źródło: wikipedia


## Głębokie sieci neuronowe

<center><img src="http://www.opennn.net/images/deep_neural_network.png"></center>

Źródło: www.opennn.net


## Tuning

Tuning to wybór optymalnych parametrów dla predyktora.

## Stworzenie klasyfikatora


```r
predict_price <- makeRegrTask(id = "affordableApartments", 
                              data = mieszkania, target = "cena_m2")

learnerNN <- makeLearner("regr.nnet")
```

## Zakresy parametrów


```r
all_params <- makeParamSet(
  makeDiscreteParam("size", values = c(1, 3, 4, 5)),
  makeDiscreteParam("decay", values = seq(0.3, 0.8, length.out = 5))
)
```

## Tuning


```r
set.seed(1792)

res <- tuneParams(learnerNN, task = predict_price, 
                  resampling = makeResampleDesc("CV", iters = 10L),
                  par.set = all_params, 
                  control =  makeTuneControlGrid())
```

## Wyniki tuningu


```r
res
```

```
## Tune result:
## Op. pars: size=3; decay=0.55
## mse.test.mean=2.17e+06
```

## Wyniki tuningu


```r
as.data.frame(res[["opt.path"]]) %>% 
  mutate(blad_cena = sqrt(mse.test.mean)) %>% 
  ggplot(aes(x = size, y = blad_cena, color = as.factor(decay))) +
  geom_point() +
  theme_bw()
```

## Wyniki tuningu

![plot of chunk unnamed-chunk-7](/images/STWUR/stwur6_prezentacja/figure/unnamed-chunk-7-1.png)

## Ile będzie kosztować mieszkanie moich marzeń?


```r
res
```

```
## Tune result:
## Op. pars: size=3; decay=0.55
## mse.test.mean=2.17e+06
```

```r
chosen_predictor <- train(makeLearner("regr.nnet", size=3, decay=0.55), predict_price)
```

```
## # weights:  37
## initial  value 238035929745.582245 
## iter  10 value 15657831540.057598
## iter  20 value 15645425668.036921
## iter  30 value 15642912148.601988
## iter  40 value 15275600608.502558
## iter  50 value 15141425598.357445
## iter  60 value 15115083103.665110
## iter  70 value 15113357333.149073
## iter  80 value 15076401496.920248
## iter  90 value 15072711730.562948
## iter 100 value 15069490596.957043
## final  value 15069490596.957043 
## stopped after 100 iterations
```

## Ile będzie kosztować mieszkanie moich marzeń?


```r
predict(chosen_predictor, newdata = data.frame(n_pokoj = 3, 
                                               metraz = 55, 
                                               rok = 1920, 
                                               pietro = 3, 
                                               pietro_maks = 7, 
                                               dzielnica = "Stare Miasto"))
```

```
## Prediction: 1 observations
## predict.type: response
## threshold: 
## time: 0.00
##   response
## 1 5996.988
```

## Zadanie

Z pomocą skryptu *exploration.R* przewidźmy czy typowego wrocławianina stać na mieszkanie naszych marzeń.

http://tinyurl.com/stwur6 - kody i dane do dzisiejszego spotkania.

Dziękujemy firmie Kruk SA i Wydziałowi Biotechnologii UWr za wspieranie spotkań STWURa.

<img src='https://stwur.github.io/STWUR//images/kruk_logo.jpg' id="logo" height="35%" width="35%"/>
