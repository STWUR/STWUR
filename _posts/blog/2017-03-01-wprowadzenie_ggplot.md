---
layout: post
title: "STWUR #2: Wizualizacja w R"
modified:
author: piotr
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-03-01
output:
  md_document:
    variant: markdown_github
---


Dlaczego wizualizacja jest ważna?

* jest użyteczna, pomaga w odbiorze danych
* potrafi być piękna
* służy jako narzędzie do opowiadania historii

![ ](https://mir-s3-cdn-cf.behance.net/project_modules/fs/7b83fd26654547.563587c568703.png)

#### Kilka słów wstępu

Na początek uporządkujmy kilka rzeczy. Istnieją trzy główne pakiety graficzne w R - base, lattice i ggplot.
Każdy ma bardzo duże możliwości, my skupimy się na tym ostatnim, ponieważ sposób tworzenia grafiki
jest w nim przejrzysty i spójny.

Temat wizualizacji jest bardzo szeroki. Od percepcji obrazu i kolorów przez ludzki mózg do 
dobrych praktyk. Odsyłam do książki Przemysława Biecka ,,Eseje o sztuce prezentowania danych" (dostępna też online na http://www.biecek.pl/Eseje/).

#### Ładowanie danych


```r
library(ggplot2)
library(dplyr)
load("osoby_wybrane_kolumny.Rdata")
load("osobyDict.RData")
```



```r
library(haven)
temp = osoby %>%
  select(fp4, plec_all, waga_2011_ind, wiek6_2011) %>%
  filter(!is.na(fp4)) %>%
  mutate_each(funs(as_factor), -waga_2011_ind) %>% #tutaj potrzebujemy pakietu haven
  group_by(fp4, plec_all, wiek6_2011) %>%
  summarise(waga = sum(waga_2011_ind, na.rm = TRUE), rok = 2011) %>%
  na.omit() %>% ungroup %>%
  rename("zadowolenie" = fp4, "plec" = plec_all, "wiek_kat" = wiek6_2011)

temp2 = osoby %>% select(ap4, plec_all, waga_2000_ind, wiek6_2000) %>% 
  filter(!is.na(ap4)) %>% 
  mutate_each(funs(as_factor), -waga_2000_ind) %>% 
  group_by(ap4, plec_all, wiek6_2000) %>% 
  summarise(waga = sum(waga_2000_ind, na.rm = TRUE), rok = 2000) %>% 
  na.omit() %>% ungroup %>% 
  rename(zadowolenie = ap4, plec = plec_all, wiek_kat = wiek6_2000)

zycie89 = rbind(temp, temp2) %>% 
  mutate(zadowolenie = factor(tolower(zadowolenie), levels = levels(temp$zadowolenie)[-1], ordered = TRUE))
```



```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity")
```

![plot of chunk unnamed-chunk-3](./figure/unnamed-chunk-3-1.png)

Z tym wykresem jest tak dużo problemów, że trudno nawet go poprawiać krok po kroku... Ale spróbujmy...

Najpierw zmieńmy sumę wag na procent odpowiedzi (mierzony wagami).


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill")
```

![plot of chunk unnamed-chunk-4](./figure/unnamed-chunk-4-1.png)

Jak pamiętamy, nasze danę dotyczą lat 2003 i 2011. Możemy je rozdzielić za pomocą funkcji *facet_wrap*.


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1)
```

![plot of chunk unnamed-chunk-5](./figure/unnamed-chunk-5-1.png)

Dla większej przejrzystości umieścmy legendę na dole. W ggplot można sterować każdym elementem wyglądu wykresu
korzystając z funkcji *theme*.


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal")
```

![plot of chunk unnamed-chunk-6](./figure/unnamed-chunk-6-1.png)

Zmieńmy kolory na wybrane przez nas.


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal") + 
  scale_fill_manual(name = "", values = c("chartreuse3", "gray", "blue", "red"))
```

![plot of chunk unnamed-chunk-7](./figure/unnamed-chunk-7-1.png)

### Manipulacja osi

Zmieńmy oznaczenia na osi y i x. Na osi y chcemy mieć procenty, a osi x chcemy zmienić nazwę.


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal") + 
  scale_fill_manual(name = "", values = c("chartreuse3", "gray", "blue", "red")) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek")
```

![plot of chunk unnamed-chunk-8](./figure/unnamed-chunk-8-1.png)

### Wybór kolorów

Można skorzystać z pakiety **RColorBrewer**, aby skorzystać z palet kolorów zdefiniowanych
przez [Cynthię Brewer](http://www.colorbrewer.org/).


```r
library(RColorBrewer)
display.brewer.all()
```

![plot of chunk unnamed-chunk-9](./figure/unnamed-chunk-9-1.png)


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal") + 
  scale_fill_manual(name = "", values = brewer.pal(4, "Set1"))
```

![plot of chunk unnamed-chunk-10](./figure/unnamed-chunk-10-1.png)

### Oznaczenia na osiach


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal") + 
  scale_fill_manual(name = "", values = brewer.pal(4, "Set1")) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") 
```

![plot of chunk unnamed-chunk-11](./figure/unnamed-chunk-11-1.png)


### Wygląd całego wykresu

W ggplot definiować można swoje własne motywy wykresu (*themes*). Część popularnych, między innymi wzorowanych
na znanych programach, portalach i czasopismach, znajduje się w pakiecie **ggthemes**. Dostajemy dodatkowo
mnóstwo nowych palet kolorów!


```r
library(ggthemes)
theme_wsj
```

```
## function (base_size = 12, color = "brown", base_family = "sans", 
##     title_family = "mono") 
## {
##     colorhex <- ggthemes_data$wsj$bg[color]
##     (theme_foundation(base_size = base_size, base_family = base_family) + 
##         theme(line = element_line(linetype = 1, colour = "black"), 
##             rect = element_rect(fill = colorhex, linetype = 0, 
##                 colour = NA), text = element_text(colour = "black"), 
##             title = element_text(family = title_family, size = rel(2)), 
##             axis.title = element_blank(), axis.text = element_text(face = "bold", 
##                 size = rel(1)), axis.text.x = element_text(colour = NULL), 
##             axis.text.y = element_text(colour = NULL), axis.ticks = element_line(colour = NULL), 
##             axis.ticks.y = element_blank(), axis.ticks.x = element_line(colour = NULL), 
##             axis.line = element_line(), axis.line.y = element_blank(), 
##             legend.background = element_rect(), legend.position = "top", 
##             legend.direction = "horizontal", legend.box = "vertical", 
##             panel.grid = element_line(colour = NULL, linetype = 3), 
##             panel.grid.major = element_line(colour = "black"), 
##             panel.grid.major.x = element_blank(), panel.grid.minor = element_blank(), 
##             plot.title = element_text(hjust = 0, face = "bold"), 
##             plot.margin = unit(c(1, 1, 1, 1), "lines"), strip.background = element_rect()))
## }
## <environment: namespace:ggthemes>
```


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal") + 
  scale_fill_manual(name = "", values = brewer.pal(4, "Set1")) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_tufte()
```

![plot of chunk unnamed-chunk-13](./figure/unnamed-chunk-13-1.png)

Zobaczmy teraz na motyw wzorowany na gazecie Wall Street Journal, użyjemy też paletę kolorów 
tam wykorzystywaną.


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  theme(legend.position = "bottom", legend.box = "horizontal") + 
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj()
```

![plot of chunk unnamed-chunk-14](./figure/unnamed-chunk-14-1.png)

My nadal chcemy mieć legendę na dole. Dodatkowo chcemy białe tło:


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() + #legenda na górze zostanie nadpisana
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = "white"))
```

![plot of chunk unnamed-chunk-15](./figure/unnamed-chunk-15-1.png)

Poradźmy sobie teraz z legendą, która nie mieści się na wykresie


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_wrap(~ rok, ncol = 1) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() + #legenda na górze zostanie nadpisana
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = "white"))+ 
  guides(fill = guide_legend(nrow = 2, byrow = TRUE))  #nadpisujemy legendę
```

![plot of chunk unnamed-chunk-16](./figure/unnamed-chunk-16-1.png)

A może dodatkowo podział na kobiety i mężczyzn? Wprowadzamy go funkcją *facet_grid*.


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_grid(plec~rok) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() + 
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = "white"))+ 
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) 
```

![plot of chunk unnamed-chunk-17](./figure/unnamed-chunk-17-1.png)

Poprawmy nieco wygląd osi


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga, fill = zadowolenie)) + 
  geom_bar(stat = "identity", position = "fill") +
  facet_grid(plec~rok) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() + 
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(size = 13, face = "plain", angle = 90),
        strip.text.x = element_text(size = 15),
        strip.text.y = element_text(size = 14)) + 
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) 
```

![plot of chunk unnamed-chunk-18](./figure/unnamed-chunk-18-1.png)

#### Dodawanie tekstu

Barplot nie jest jedyną możliwością zrobienia wykresu w ggplot. Aby to zobrazować dodajmy nową informację do naszego wykresu. Interesujące jest, jaki jest stosunek liczby osób lepiej oceniających swoje życie przed 89 rokiem niż obecnie.


```r
zycie89_ratio = zycie89 %>%
  group_by(rok, plec, wiek_kat) %>%
  summarize(ratio = waga[zadowolenie == 'łatwiej żyło mi się przed rokiem 1989']/waga[zadowolenie == 'obecnie żyje mi się łatwiej'],
            position = waga[zadowolenie == 'łatwiej żyło mi się przed rokiem 1989']/sum(waga))

ggplot(zycie89, aes(x = wiek_kat, y = waga)) + 
  geom_bar(mapping = aes(fill = zadowolenie), stat = "identity", position = "fill") +
  geom_text(data = zycie89_ratio, aes(x = wiek_kat, y = 1-position, label = paste0('x', formatC(ratio, digits = 2))),
            nudge_y = -0.1) +
  facet_grid(plec~rok) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() + 
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(size = 13, face = "plain", angle = 90),
        strip.text.x = element_text(size = 15),
        strip.text.y = element_text(size = 14)) + 
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) 
```

![plot of chunk unnamed-chunk-19](./figure/unnamed-chunk-19-1.png)

Kolor czcionki można zmienić, aby wykres był czytelniejszy.


```r
zycie89_ratio = zycie89 %>%
  group_by(rok, plec, wiek_kat) %>%
  summarize(ratio = waga[zadowolenie == 'łatwiej żyło mi się przed rokiem 1989']/waga[zadowolenie == 'obecnie żyje mi się łatwiej'],
            position = waga[zadowolenie == 'łatwiej żyło mi się przed rokiem 1989']/sum(waga))

ggplot(zycie89, aes(x = wiek_kat, y = waga)) + 
  geom_bar(mapping = aes(fill = zadowolenie), stat = "identity", position = "fill") +
  geom_text(data = zycie89_ratio, aes(x = wiek_kat, y = 1-position, label = paste0('x', formatC(ratio, digits = 2))),
            nudge_y = -0.1, color = "white") +
  facet_grid(plec~rok) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() + 
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(size = 13, face = "plain", angle = 90),
        strip.text.x = element_text(size = 15),
        strip.text.y = element_text(size = 14)) + 
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) 
```

![plot of chunk unnamed-chunk-20](./figure/unnamed-chunk-20-1.png)

#### Dodanie tytułu wykresu


```r
ggplot(zycie89, aes(x = wiek_kat, y = waga)) + 
  geom_bar(mapping = aes(fill = zadowolenie), stat = "identity", position = "fill") +
  geom_text(data = zycie89_ratio, 
            aes(x = wiek_kat, y = 1-position, 
                label = paste0('x', formatC(ratio, digits = 2))),
            nudge_y = -0.05, size = 7, color = "white") +
  facet_grid(plec~rok) +
  scale_fill_manual(name = "", values = wsj_pal()(4)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") +
  theme_wsj() +
  theme(legend.position = "bottom", legend.box = "horizontal",
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        legend.background = element_rect(fill = "white"),
        legend.text = element_text(size = 20),
        strip.background = element_rect(fill = "white"),
        axis.text.x = element_text(size = 18, face = "plain", angle = 90),
        strip.text.x = element_text(size = 20),
        strip.text.y = element_text(size = 20, angle = 0),
        plot.title = element_text(size = 40, hjust = 0.5),
        plot.subtitle = element_text(size = 20, hjust = 0.5)) + 
  guides(fill = guide_legend(nrow = 2, byrow = TRUE, override.aes = aes(size = 10))) +
  ggtitle("Stosunek Polaków do życia w PRL", 
          subtitle = "liczby na wykresie odpowiadają temu, ile razy więcej \n jest oceniających lepiej swoje życie w PRL")
```

![plot of chunk unnamed-chunk-21](./figure/unnamed-chunk-21-1.png)

### Jak to zrobić źle?

Na przestrogę zostawiam też formatowanie kodu. Nie należy tego powielać!!!


```r
background <- "white"
main_color <- rgb(red=197, green=38, blue=36, maxColorValue = 255)
blue = rgb(red=7, green=58, blue=118, maxColorValue = 255)
white <-  "#FFFFFF"
grid <- "grey"
labels <- "black"

myTheme <- theme(
  legend.position = "top",
  legend.direction = "horizontal", legend.box = "vertical",
  legend.title = element_text(family = "Impact",  face = "italic", colour = main_color, size = 15),
  legend.background = element_rect(fill = background),
  legend.key = element_rect(fill = background, colour = background),
  legend.text = element_text(family = "Impact", colour = labels, size = 14),
  plot.background = element_rect(fill = background, colour = background),
  panel.background = element_rect(fill = "white",colour = grid),
  axis.text = element_text(colour = labels, family = "Impact"),
  plot.title = element_text(colour = main_color, face = "bold.italic", size = 28, 
                            vjust = 1, family = "Impact"),
  axis.title = element_text(colour = main_color, face = "italic", size = 20, family = "Impact"),
  axis.title.x = element_text(colour = main_color, face = "italic", size = 20, family = "Impact"),
  panel.grid.major.y = element_line(colour = grid),
  panel.grid.minor.y = element_blank(),
  panel.grid.major.x = element_line(colour = grid),
  panel.grid.minor.x = element_blank(),
  strip.text.x = element_text(family = "Impact", colour = main_color, size=12),
  strip.text.y = element_text(size=12, face="bold"),
  strip.background = element_rect(colour=main_color, fill="white"),
  axis.ticks = element_line(colour = labels))

ggplot(zycie89, aes(x=wiek_kat, y=waga, fill=zadowolenie)) + 
  geom_bar(stat="identity", position="fill") + facet_wrap(~plec+rok) +
  theme(legend.position="top") + 
  scale_fill_manual(name="", 
                    values=c(main_color, "chartreuse3", "gray", "blue")) +
  guides(fill=guide_legend(nrow=2,byrow=TRUE)) +
  scale_y_continuous(labels = scales::percent) +
  ylab("Procent osób") + xlab("Wiek") + myTheme
```

![plot of chunk unnamed-chunk-22](./figure/unnamed-chunk-22-1.png)

### Co dalej?

* Bardzo dobra ściągawka https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
* Książka Winstona Changa http://www.cookbook-r.com/Graphs/
* Prezentacja autora pakietu Hadleya Wickhama na temat gramatyki grafiki (*grammar of graphics*) http://ggplot2.org/resources/2007-past-present-future.pdf

* Galeria przykładowych grafik (z kodami!) http://www.r-graph-gallery.com/portfolio/ggplot2-package/

### Przykładowe dane

Przygotowaliśmy zestaw danych dotyczących wykształcenie Polaków w podziale na płcie i lata:
https://raw.githubusercontent.com/STWUR/STWUR-2017-03-01/master/education_data.csv


```r
download.file(url = "https://github.com/STWUR/STWUR-2017-03-01/blob/master/education_data.csv",
              destfile = "education_data.csv")
edu_dat <- read.csv("education_data.csv")
```

Jakie dane wybraliśmy?

 - płeć,
 - edukację (skategoryzowana),
 - wiek (skategoryzowany) - wyłącznie osoby po 25 roku życia,
 - województwo,
 - podregion66 (podregion z wydzieleniem dużych aglomeracji),
 - waga,
 - rok w którym przeprowadzono badanie (2000, 2003, 2005, 2007, 2009, 2011, 2013, 2015).
 
### Kody i dane

Kody **R** niezbędne do odtworzenie wizualizacji przedstawionych w tym dokumencie, a także dane znajdują się w [repozytorium spotkania](https://raw.githubusercontent.com/STWUR/STWUR-2017-03-01/).
