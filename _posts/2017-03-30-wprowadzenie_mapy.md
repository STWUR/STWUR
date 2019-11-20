---
layout: post
title: "I Ty możesz zostać kartografem!"
---

Warsztaty odbywają się w ramach [GeekWeekWro](www.facebook.com/geekweekwro/)



Czego nauczymy się na tych warsztatach?

1. Ściągania map google, nanoszenia punktów na te mapy 
2. Znajdowania współrzędnych geograficznych miejscowości
2. Tworzenia map z obszarmi wyodrębnionymi kolorem (*choropleth*)

Zacznijmy naszą przygodę.

#### Instalacja niezbędnych pakietów


```r
install.packages(c("dplyr", "ggplot2", "ggthemes", "ggmap"))
```


```r
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggmap)
library(ggthemes)
```

#### Ściąganie mapy z google lub open street maps

Dzięki pakietowi *ggmap* jest to niezwykle proste


```r
wroclaw_mapa <- get_map(location = "wrocław", zoom = 10)
```

```
## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=wroc%C5%82aw&zoom=10&size=640x640&scale=2&maptype=terrain&language=en-EN&sensor=false
```

```
## Information from URL : http://maps.googleapis.com/maps/api/geocode/json?address=wroc%C5%82aw&sensor=false
```

```r
ggmap(wroclaw_mapa, extent = "normal")
```

![plot of chunk unnamed-chunk-3](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-3-1.png)



```r
wroclaw_mapa <- get_map(location = c(17, 51.1), zoom = 12)
```

```
## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=51.1,17&zoom=12&size=640x640&scale=2&maptype=terrain&language=en-EN&sensor=false
```

```r
ggmap(wroclaw_mapa)
```

![plot of chunk unnamed-chunk-4](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-4-1.png)

Jeśli nie będzie działało to trzeba zainstalować starszą wersję *ggplot2*.


```r
devtools::install_github("hadley/ggplot2@v2.2.0")
```


#### Zaznaczanie punktów

Oznaczmy na mapie Wrocławia miejsca, w których odbywały się spotkania STWURa.


```r
miejsca <- c("Wydział Biotechnologii, Wrocław", "Infopunkt Łokietka", "Wydział Matematyki PWr")
wspolrzedne <- geocode(miejsca)
miejsca <- cbind(miejsca, wspolrzedne)
miejsca$liczba_spotkan <- c(3, 1, 1)
```

Weżmy mapę, którą wcześniej ściągnęliśmy


```r
ggmap(wroclaw_mapa) +
  geom_point(data = miejsca, aes(x = lon, y = lat))
```

![plot of chunk unnamed-chunk-7](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-7-1.png)


```r
ggmap(wroclaw_mapa) +
  geom_point(data = miejsca, aes(x = lon, y = lat, size = liczba_spotkan)) +
  theme_map()
```

![plot of chunk unnamed-chunk-8](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-8-1.png)


```r
wroclaw_mapa <- get_map(location = "wrocław", zoom = 13, maptype = "roadmap", color = "bw")
```

```
## Map from URL : http://maps.googleapis.com/maps/api/staticmap?center=wroc%C5%82aw&zoom=13&size=640x640&scale=2&maptype=roadmap&language=en-EN&sensor=false
```

```
## Information from URL : http://maps.googleapis.com/maps/api/geocode/json?address=wroc%C5%82aw&sensor=false
```

```r
ggmap(wroclaw_mapa) +
  geom_point(data = miejsca, aes(x = lon, y = lat, color = miejsca, size = liczba_spotkan)) +
  theme_map() +
  scale_fill_discrete(name = "")
```

![plot of chunk unnamed-chunk-9](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-9-1.png)

### Choreopleth

Jeśli chcemy wyróżnić konkretne obszary kolorem, np. województwo w zależności od procenta ludności z wyższym wykształceniem,
to potrzebujemy nieco innych narzędzi w R, a przede wszystkim potrzebujemy danych definiujących poszczególne obszary.
Takie dane często zapisywane są w plikach shapefile (.shp) lub GeoJSON. Dla zastosowań nie komercyjnych podział Polski i Europy można
ściągnąć ze stron GUSu i Eurostatu. Tutaj stosujemy już przetworzone dane. Skrypt służące do ich wygenerowania znajdują się na githubie.


#### Najpierw przetwarzamy dane


```r
internet_dat <- read.csv(file = "internet_data.csv")
load("ksztalt_wojewodztw_data_frame.Rdata")

internet_podsumowanie <- internet_dat %>% 
  filter(rok == 2015) %>%
  group_by(wojewodztwo) %>%
  summarise(przecietnie_godzin_internetu = sum(waga*godzin_internetu)/sum(waga)) %>%
  mutate(wojewodztwo = tolower(wojewodztwo)) %>% 
  inner_join(wojewodztwa_nazwy_kody, by = c("wojewodztwo"="woj"))
```

```
## Warning in inner_join_impl(x, y, by$x, by$y, suffix$x, suffix$y): joining
## character vector and factor, coercing into character vector
```

```r
plotData <- inner_join(Wojewodztwa, internet_podsumowanie, by = "id")
```
Co się dzieje w kodzie powyżej krok po kroku:

Filtrowanie obserwacji z roku 2015

```r
internet_dat %>% 
  filter(rok == 2015) 
```

Policzenie procenta osób z wyższym wykształceniem w podziale na województwa

```r
group_by(wojewodztwo) %>%
  summarise(przecietnie_godzin_internetu = sum(waga*godzin_internetu)/sum(waga)) 
```

Techniczne. Połączenie z data.frame *wojewodztwa_nazwy_kody*.


```r
mutate(wojewodztwo = tolower(wojewodztwo)) %>% 
  inner_join(wojewodztwa_nazwy_kody, by = c("wojewodztwo"="woj")) 
```

Połączenie z data.frame zwierającym definicje obszarów województw


```r
plotData <- inner_join(Wojewodztwa, edu_podsumowanie, by = "id")
```

#### Wizualizacja

Wrzucamy do R i mamy nadzieję, że wyjdzie coś, co przyzwoicie działa


```r
library(scales) #pretty breaks, percent
ggplot(data = plotData, mapping = aes(x = long, y = lat)) +
  geom_polygon(mapping = aes(group = group, fill = przecietnie_godzin_internetu))
```

![plot of chunk unnamed-chunk-15](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-15-1.png)

![https://s-media-cache-ak0.pinimg.com/564x/07/59/d9/0759d9f019a16d630705a0e0b3eab357.jpg](figure/sad_puppy.jpeg)

**Jak to naprawić?** 

Zacznijmy od zmiany palety kolorów. Weźmiemy *'YlGn'* z pakietu *RColorBrewer*.


```r
ggplot(data = plotData, mapping = aes(x = long, y = lat)) +
  geom_polygon(mapping = aes(group = group, fill = przecietnie_godzin_internetu)) +
  scale_fill_distiller("h", palette = "YlGn", breaks = pretty_breaks(n = 6),
                       trans = "reverse")
```

![plot of chunk unnamed-chunk-16](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-16-1.png)

Teraz technikalia:

* Usuwamy opisu osi
* Zmieniamy kolejność kolorów i wielkość legendy
* Dodajemy tytuł wykresu


```r
ggplot(data = plotData, mapping = aes(x = long, y = lat)) +
  geom_polygon(mapping = aes(group = group, fill = przecietnie_godzin_internetu)) +
  scale_fill_distiller("Godzin", palette = "YlGn", breaks = pretty_breaks(n = 6),
                       trans = "reverse") +
  guides(fill = guide_legend(reverse = TRUE)) +
  ggtitle(label = "Liczba godzin spędzanych tygodniowo w internecie", subtitle = "Średnia w podziale na województwa w 2015") + 
  theme_map(base_size = 18) +
  theme(plot.title = element_text(size = 20, hjust = 0.5, family = "mono"),
        plot.subtitle = element_text(size = 18, hjust = 0.5, family = "mono"),
        legend.position = "right",
        legend.key.height = unit(1.7, "cm"),
        legend.key.width = unit(1.1, "cm"))
```

![plot of chunk unnamed-chunk-17](/images/STWUR/wprowadzenie_mapy/figure/unnamed-chunk-17-1.png)

