---
layout: post
title: "Materiały ze spotkania eRementarz #5: R od środka"
---



Lutowe spotkanie STWUR-a poprowadził Michał Kurtys, a zorganizował Jarosław Chilimoniuk. Zachęcamy do zapoznania się z materiałami.


## Materiały - R od środka

[https://github.com/STWUR/eRementarz5]

### R
 
- Język/Standard - R Language (jak ANSI C, C++14)
- Implementacja - GNU R ( gcc, Visual C++ )
- W R różnica jest trochę zatarta

### Struktury danych
 

|   |Homogeneous   |Heterogenous |
|:--|:-------------|:------------|
|1d |Atomic vector |List         |
|2d |Matrix        |Data Frame   |
|nd |Array         |-            |

Vectors: logical, integer, double (often called numeric), character, complex, raw

### Wektory
 

```r
x <- 1:5
typeof(x)
```

```
## [1] "integer"
```

```r
class(x)
```

```
## [1] "integer"
```

```r
is.atomic(x)
```

```
## [1] TRUE
```

### Skalary - wektory długości 1
 

```r
x <- 1
typeof(x)
```

```
## [1] "double"
```

```r
typeof(1L)
```

```
## [1] "integer"
```

### Wektory długości 0
 

```r
(1:10)[numeric(0)]
```

```
## integer(0)
```

```r
(10:20)[-(1:3)]
```

```
## [1] 13 14 15 16 17 18 19 20
```

```r
x <- 10:20
x[-which(x==100)]
```

```
## integer(0)
```


### Nazwy


```r
x <- c(a = 1, b = 2, c = 3)
x <- 1:3; names(x) <- c("a", "b", "c") 
x <- setNames(1:3, c("a", "b", "c"))
attributes(x)
```

```
## $names
## [1] "a" "b" "c"
```

### Macierze


```r
mat <- matrix(1:25, nrow=5, ncol=5)
mat
```

```
##      [,1] [,2] [,3] [,4] [,5]
## [1,]    1    6   11   16   21
## [2,]    2    7   12   17   22
## [3,]    3    8   13   18   23
## [4,]    4    9   14   19   24
## [5,]    5   10   15   20   25
```

```r
class(mat)
```

```
## [1] "matrix"
```

```r
typeof(mat)
```

```
## [1] "integer"
```

### Macierze
 

```r
attributes(mat)
```

```
## $dim
## [1] 5 5
```

```r
dim(mat)
```

```
## [1] 5 5
```

```r
x <- 1:20
dim(x) <- c(4,5)
attr(x, "dim") <- c(5,4)
```


### Ramki Danych
 


```r
df <- data.frame(x=1:3,y=4:6)
class(df)
```

```
## [1] "data.frame"
```

```r
typeof(df)
```

```
## [1] "list"
```

```r
attributes(df)
```

```
## $names
## [1] "x" "y"
## 
## $row.names
## [1] 1 2 3
## 
## $class
## [1] "data.frame"
```


### Pętle 1


```r
times_two_1 <- function(x)
{
  new_vector = c()
  for(value in x)
  {
    new_value = value*2
    new_vector = c(new_vector,new_value)
  }
  new_vector
}
x <- 1:10
times_two_1(x)
```

```
##  [1]  2  4  6  8 10 12 14 16 18 20
```

### Pętle 2


```r
times_two_2 <- function(x)
{
  for(i in 1:length(x))
    x[i] = x[i]*2
  x
}
x <- 1:10
times_two_2(x)
```

```
##  [1]  2  4  6  8 10 12 14 16 18 20
```

```r
x
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

```r
x[11] <- 11
x
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10 11
```

```r
x[20] <- 20
```


### Rcpp
 

```r
library(Rcpp)
cppFunction(
  'std::vector<int> times_two_cpp_1(NumericVector x) {
  std::vector<int> out;
  int n = x.size();
  for(int i = 0; i < n; ++i) {
    out.push_back(x[i]*2);
  }
  return out;
}')
x <- 1:10
times_two_cpp_1(x)
```

```
##  [1]  2  4  6  8 10 12 14 16 18 20
```

```r
x
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

### Rcpp 2
 

```r
cppFunction(
  'NumericVector times_two_cpp_2(NumericVector x) {
  int n = x.size();
  for(int i = 0; i < n; ++i) {
    x[i] = x[i]*2;
  }
  return x;
}')
x <- 1:10
times_two_cpp_2(x)
```

```
##  [1]  2  4  6  8 10 12 14 16 18 20
```

```r
x
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

### Microbenchmark
 
microbenchmark serves as a more accurate replacement of the often seen `system.time(replicate(1000, expr))` expression.

microbenchmark(..., list = NULL, times = 100L, unit, check = NULL,
  control = list())


```r
library(microbenchmark)
microbenchmark(
  (1:10)*(1:10),
  mapply("*",1:10,1:10)
)
```

```
## Unit: nanoseconds
##                     expr   min      lq     mean  median      uq   max
##          (1:10) * (1:10)   405   476.0   807.87   615.5   676.5 13828
##  mapply("*", 1:10, 1:10) 17361 18122.5 19457.65 18375.5 18680.5 76105
##  neval cld
##    100  a 
##    100   b
```

```r
mb <- microbenchmark(
  vectorized = (1:10)*(1:10),
  mapply = mapply("*",1:10,1:10)
)

print(mb, unit="relative")
```

```
## Unit: relative
##        expr     min       lq     mean   median       uq      max neval cld
##  vectorized  1.0000  1.00000  1.00000  1.00000  1.00000 1.000000   100  a 
##      mapply 44.1784 31.76694 21.72461 28.52665 29.56658 2.743807   100   b
```

### Microbenchmark - nasze funkcje
 

```r
x<-1:10e3
microbenchmark(
times_two_1(x),
times_two_2(x),
times_two_cpp_1(x),
times_two_cpp_2(x),
list = list( expression(x*2)),
times = 3L,
unit = "ms"
)
```

```
## Unit: milliseconds
##                expr        min          lq         mean     median
##      times_two_1(x) 103.270977 105.3815760 106.08523433 107.492175
##      times_two_2(x)   0.630641   0.6337660   1.72979767   0.636891
##  times_two_cpp_1(x)   0.043655   0.0478280   0.05163633   0.052001
##  times_two_cpp_2(x)   0.019163   0.0192315   0.02244600   0.019300
##   expression(x * 2)   0.000021   0.0000905   0.00019800   0.000160
##           uq        max neval cld
##  107.4923630 107.492551     3   b
##    2.2793760   3.921861     3  a 
##    0.0556270   0.059253     3  a 
##    0.0240875   0.028875     3  a 
##    0.0002865   0.000413     3  a
```

### Microbenchmark - nasze funkcje 2
 

```r
x<-1:10e7
microbenchmark(
times_two_2(x),
times_two_cpp_1(x),
times_two_cpp_2(x),
list = list( expression(x*2)),
times = 3L,
unit = "ms"
)
```

```
## Unit: milliseconds
##                expr         min           lq         mean      median
##      times_two_2(x) 7132.559041 7259.1777435 7.432300e+03 7385.796446
##  times_two_cpp_1(x) 1101.980806 1122.8490165 1.168001e+03 1143.717227
##  times_two_cpp_2(x)  518.208544  557.9278270 5.865563e+02  597.647110
##   expression(x * 2)    0.000004    0.0000945 1.573333e-04    0.000185
##           uq         max neval  cld
##  7582.171048 7778.545650     3    d
##  1201.010651 1258.304075     3   c 
##   620.730248  643.813385     3  b  
##     0.000234    0.000283     3 a
```

### Microbenchmark - Klasa


```r
class(mb)
typeof(mb)library(microbenchmark)

names(attributes(mb))
```

```
## Error: <text>:2:11: nieoczekiwany symbol
## 1: class(mb)
## 2: typeof(mb)library
##              ^
```

### Microbenchmark - Klasa S3
 

```r
library(pryr)
```

```
## Error in library(pryr): there is no package called 'pryr'
```

```r
otype(mb)
```

```
## Error in otype(mb): nie udało się znaleźć funkcji 'otype'
```

```r
methods(class = "microbenchmark")
```

```
## [1] autoplot boxplot  print    summary 
## see '?methods' for accessing help and source code
```

```r
methods(class = "data.frame")
```

```
##   [1] [                      [[                     [[<-                  
##   [4] [<-                    $                      $<-                   
##   [7] aggregate              anti_join              anyDuplicated         
##  [10] arrange_               arrange                as_data_frame         
##  [13] as_tibble              as.data.frame          as.list               
##  [16] as.matrix              as.tbl_cube            as.tbl                
##  [19] by                     capLargeValues         cbind                 
##  [22] coerce                 coerce<-               collapse              
##  [25] collect                compute                createDummyFeatures   
##  [28] dim                    dimnames               dimnames<-            
##  [31] distinct_              distinct               do_                   
##  [34] do                     droplevels             duplicated            
##  [37] edit                   filter_                filter                
##  [40] format                 formula                fortify               
##  [43] full_join              ggplot                 glimpse               
##  [46] group_by_              group_by               group_indices_        
##  [49] group_indices          group_size             groups                
##  [52] head                   impute                 initialize            
##  [55] inner_join             intersect              is.na                 
##  [58] left_join              Math                   merge                 
##  [61] mutate_                mutate                 n_groups              
##  [64] na.contiguous          na.exclude             na.omit               
##  [67] normalizeFeatures      Ops                    plot                  
##  [70] print                  prompt                 pull                  
##  [73] rbind                  reimpute               removeConstantFeatures
##  [76] rename_                rename                 right_join            
##  [79] row.names              row.names<-            rowsum                
##  [82] same_src               sample_frac            sample_n              
##  [85] select_                select                 semi_join             
##  [88] setdiff                setequal               show                  
##  [91] slice_                 slice                  slotsFromS3           
##  [94] split                  split<-                stack                 
##  [97] str                    subset                 summarise_            
## [100] summarise              summarizeColumns       summarizeLevels       
## [103] summary                Summary                t                     
## [106] tail                   tbl_vars               transform             
## [109] type_sum               ungroup                union_all             
## [112] union                  unique                 unstack               
## [115] within                
## see '?methods' for accessing help and source code
```

```r
methods(boxplot)
```

```
## [1] boxplot.default         boxplot.formula*        boxplot.matrix         
## [4] boxplot.microbenchmark*
## see '?methods' for accessing help and source code
```

### S3 - Funkcje generyczne
 
*UseMethod()*

```r
ftype(print)
```

```
## Error in ftype(print): nie udało się znaleźć funkcji 'ftype'
```

```r
print
```

```
## function (x, ...) 
## UseMethod("print")
## <bytecode: 0x55eab70>
## <environment: namespace:base>
```

```r
getS3method("print","microbenchmark")
```

```
## function (x, unit, order, signif, ...) 
## {
##     s <- summary(x, unit = unit)
##     timing_cols <- c("min", "lq", "median", "uq", "max")
##     if (!missing(signif)) {
##         s[timing_cols] <- lapply(s[timing_cols], base::signif, 
##             signif)
##     }
##     cat("Unit: ", attr(s, "unit"), "\n", sep = "")
##     if (!missing(order)) {
##         if (order %in% colnames(s)) {
##             s <- s[order(s[[order]]), ]
##         }
##         else {
##             warning("Cannot order results by", order, ".")
##         }
##     }
##     print(s, ..., row.names = FALSE)
## }
## <bytecode: 0x7d34368>
## <environment: namespace:microbenchmark>
```

### S3 - Funkcje generyczne
 

```r
mean
```

```
## function (x, ...) 
## UseMethod("mean")
## <bytecode: 0x79a5318>
## <environment: namespace:base>
```

```r
methods(mean)
```

```
##  [1] mean,ANY-method          mean,Matrix-method      
##  [3] mean,sparseMatrix-method mean,sparseVector-method
##  [5] mean.Date                mean.default            
##  [7] mean.difftime            mean.IDate*             
##  [9] mean.POSIXct             mean.POSIXlt            
## [11] mean.yearmon*            mean.yearqtr*           
## [13] mean.zoo*               
## see '?methods' for accessing help and source code
```

```r
getS3method("mean","default")
```

```
## function (x, trim = 0, na.rm = FALSE, ...) 
## {
##     if (!is.numeric(x) && !is.complex(x) && !is.logical(x)) {
##         warning("argument is not numeric or logical: returning NA")
##         return(NA_real_)
##     }
##     if (na.rm) 
##         x <- x[!is.na(x)]
##     if (!is.numeric(trim) || length(trim) != 1L) 
##         stop("'trim' must be numeric of length one")
##     n <- length(x)
##     if (trim > 0 && n) {
##         if (is.complex(x)) 
##             stop("trimmed means are not defined for complex data")
##         if (anyNA(x)) 
##             return(NA_real_)
##         if (trim >= 0.5) 
##             return(stats::median(x, na.rm = FALSE))
##         lo <- floor(n * trim) + 1
##         hi <- n + 1 - lo
##         x <- sort.int(x, partial = unique(c(lo, hi)))[lo:hi]
##     }
##     .Internal(mean(x))
## }
## <bytecode: 0x79a4168>
## <environment: namespace:base>
```

### S3 - Konstruktory
 

```r
ftype(microbenchmark)
```

```
## Error in ftype(microbenchmark): nie udało się znaleźć funkcji 'ftype'
```


### Klasy S4 i RC
 
* S4 = S3 + więcej formalizmu
* RC pozwalają na przekazywanie przez referencje

### Bezpośrednie używanie metod
 
However, this is just as dangerous as changing the class of an object, so you shouldn’t do it. Please don’t point the loaded gun at your foot! The only reason to call the method directly is that sometimes you can get considerable performance improvements by skipping method dispatch. [Advanced R]


### Wartości NA
 

```r
evalCpp("std::numeric_limits<int>::min()")
```

```
## [1] NA
```

```r
evalCpp("std::numeric_limits<double>::min()")
```

```
## [1] 2.225074e-308
```


### Funkcje
 
    > To understand computations in R, two slogans are helpful:
    >    Everything that exists is an object.
    >    Everything that happens is a function call."

    — John Chambers

### Funkcje - przykłady
 

```r
#dynamiczne typowanie!
"+"(1,2)
```

```
## [1] 3
```

```r
"["(c(3,6,9),2)
```

```
## [1] 6
```

```r
sapply(list(1:10,
            11:20), "[", 2)
```

```
## [1]  2 12
```


### Primitive functions
 

```r
length
```

```
## function (x)  .Primitive("length")
```

```r
sum
```

```
## function (..., na.rm = FALSE)  .Primitive("sum")
```

```r
show_c_source(.Primitive(sum(x)))
```

```
## Error in show_c_source(.Primitive(sum(x))): nie udało się znaleźć funkcji 'show_c_source'
```


### .Internal vs. Primitive
 

.Internal and .Primitive refer to the interface used to call C-code. Internal is the standard approach, since you can check arguments in R-code before you call the C-code. Primitive is higher performance, but does not allow any R-code in the function.

### Lazy Evaluation
 

```r
f <- function(x) 
{
  2
}

f(doesnt_matter)
```

```
## [1] 2
```

### Quote i Substitute
 

```r
f <- function(x) {
  cat(deparse(substitute(x)), "==", x)
}
x <- 5
f( (2+x) )
```

```
## (2 + x) == 7
```

### Environments
 

```r
gg <- function()
{
  ff <- function(x)
  {
    print(parent.frame())
    print(environment())
  }
}
```

### Closures
 

```r
power <- function(exponent) {
  function(x) {
    x ^ exponent
  }
}

square <- power(2)
square(2)
```

```
## [1] 4
```


### Closures 2


```r
fib <- function(n)
{
  if(n<=1)
    return(n)
  else
    return( fib(n-1) + fib(n-2))
  
}

fib(8)
```

```
## [1] 21
```


### Closures 3
 

```r
library(memoise)
fib2 <- memoise(fib)
fib2(8)
```

```
## [1] 21
```

### Źródła
 
* Advanced R by Hadley Wickham
* https://cran.r-project.org/manuals.html
* R Inferno
