---
layout: post
title: "Skąd się biorą STWURy"
modified:
author: michal
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-03-24
output:
  md_document:
    variant: markdown_github
---

### ggmap i dane z Google Analytics

Nasza strona, [stwur.pl](stwur.pl) istnieje już kilka miesięcy i od początku swojego istnienia cieszy się spory zainteresowaniem miłośników R z całego świata. Są dane, warto je zwizualizować, zwłaszcza, że pasują do tematyki naszego następnego spotkania [I ty możesz zostać kartografem!](https://www.meetup.com/Wroclaw-R-Users-Group/events/238204653/). 


```r
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)
library(reshape2)
library(RColorBrewer) # potrzebujemy ladnych kolorow

# o tym jak pobierać dane z google analytics innym razem - teraz skupimy się na samej wizualizacji
dat <- read.csv("https://raw.githubusercontent.com/STWUR/gdzie-mieszkaja-STWURy/master/STWURy.csv")

# nazwy UK i USA trzeba dostosowac do nazw z pakietu mapdata
summaries_country <- group_by(dat, country) %>% 
  summarise(sessions = sum(sessions),
            users = sum(users),
            newUsers = sum(newUsers)) %>% 
  mutate(region = factor(country, labels = c("Denmark", "Finland", "Germany", "Iceland", 
                                             "Ireland", "Italy", "Netherlands", "Norway", 
                                             "Poland", "Slovenia", "Spain", "Sweden", 
                                             "Switzerland", "UK", "USA"))) %>% 
  select(-country)

# tworzymy mape swiata
world_map <- map_data("world")

other_countries <- unique(world_map[["region"]])[!(unique(world_map[["region"]]) %in% summaries_country[["region"]])]

# jeszcze dluga droga przed STWURem - w tylu krajach o nas nie slyszeli!
print(other_countries)
```

```
##   [1] "Aruba"                              
##   [2] "Afghanistan"                        
##   [3] "Angola"                             
##   [4] "Anguilla"                           
##   [5] "Albania"                            
##   [6] "Andorra"                            
##   [7] "United Arab Emirates"               
##   [8] "Argentina"                          
##   [9] "Armenia"                            
##  [10] "American Samoa"                     
##  [11] "Antarctica"                         
##  [12] "Australia"                          
##  [13] "French Southern and Antarctic Lands"
##  [14] "Antigua"                            
##  [15] "Barbuda"                            
##  [16] "Austria"                            
##  [17] "Azerbaijan"                         
##  [18] "Burundi"                            
##  [19] "Belgium"                            
##  [20] "Benin"                              
##  [21] "Burkina Faso"                       
##  [22] "Bangladesh"                         
##  [23] "Bulgaria"                           
##  [24] "Bahrain"                            
##  [25] "Bahamas"                            
##  [26] "Bosnia and Herzegovina"             
##  [27] "Saint Barthelemy"                   
##  [28] "Belarus"                            
##  [29] "Belize"                             
##  [30] "Bermuda"                            
##  [31] "Bolivia"                            
##  [32] "Brazil"                             
##  [33] "Barbados"                           
##  [34] "Brunei"                             
##  [35] "Bhutan"                             
##  [36] "Botswana"                           
##  [37] "Central African Republic"           
##  [38] "Canada"                             
##  [39] "Chile"                              
##  [40] "China"                              
##  [41] "Ivory Coast"                        
##  [42] "Cameroon"                           
##  [43] "Democratic Republic of the Congo"   
##  [44] "Republic of Congo"                  
##  [45] "Cook Islands"                       
##  [46] "Colombia"                           
##  [47] "Comoros"                            
##  [48] "Cape Verde"                         
##  [49] "Costa Rica"                         
##  [50] "Cuba"                               
##  [51] "Curacao"                            
##  [52] "Cayman Islands"                     
##  [53] "Cyprus"                             
##  [54] "Czech Republic"                     
##  [55] "Djibouti"                           
##  [56] "Dominica"                           
##  [57] "Dominican Republic"                 
##  [58] "Algeria"                            
##  [59] "Ecuador"                            
##  [60] "Egypt"                              
##  [61] "Eritrea"                            
##  [62] "Canary Islands"                     
##  [63] "Estonia"                            
##  [64] "Ethiopia"                           
##  [65] "Fiji"                               
##  [66] "Falkland Islands"                   
##  [67] "Reunion"                            
##  [68] "Mayotte"                            
##  [69] "French Guiana"                      
##  [70] "Martinique"                         
##  [71] "Guadeloupe"                         
##  [72] "France"                             
##  [73] "Faroe Islands"                      
##  [74] "Micronesia"                         
##  [75] "Gabon"                              
##  [76] "Georgia"                            
##  [77] "Guernsey"                           
##  [78] "Ghana"                              
##  [79] "Guinea"                             
##  [80] "Gambia"                             
##  [81] "Guinea-Bissau"                      
##  [82] "Equatorial Guinea"                  
##  [83] "Greece"                             
##  [84] "Grenada"                            
##  [85] "Greenland"                          
##  [86] "Guatemala"                          
##  [87] "Guam"                               
##  [88] "Guyana"                             
##  [89] "Heard Island"                       
##  [90] "Honduras"                           
##  [91] "Croatia"                            
##  [92] "Haiti"                              
##  [93] "Hungary"                            
##  [94] "Indonesia"                          
##  [95] "Isle of Man"                        
##  [96] "India"                              
##  [97] "Cocos Islands"                      
##  [98] "Christmas Island"                   
##  [99] "Chagos Archipelago"                 
## [100] "Iran"                               
## [101] "Iraq"                               
## [102] "Israel"                             
## [103] "San Marino"                         
## [104] "Jamaica"                            
## [105] "Jersey"                             
## [106] "Jordan"                             
## [107] "Japan"                              
## [108] "Siachen Glacier"                    
## [109] "Kazakhstan"                         
## [110] "Kenya"                              
## [111] "Kyrgyzstan"                         
## [112] "Cambodia"                           
## [113] "Kiribati"                           
## [114] "Nevis"                              
## [115] "Saint Kitts"                        
## [116] "South Korea"                        
## [117] "Kosovo"                             
## [118] "Kuwait"                             
## [119] "Laos"                               
## [120] "Lebanon"                            
## [121] "Liberia"                            
## [122] "Libya"                              
## [123] "Saint Lucia"                        
## [124] "Liechtenstein"                      
## [125] "Sri Lanka"                          
## [126] "Lesotho"                            
## [127] "Lithuania"                          
## [128] "Luxembourg"                         
## [129] "Latvia"                             
## [130] "Saint Martin"                       
## [131] "Morocco"                            
## [132] "Monaco"                             
## [133] "Moldova"                            
## [134] "Madagascar"                         
## [135] "Maldives"                           
## [136] "Mexico"                             
## [137] "Marshall Islands"                   
## [138] "Macedonia"                          
## [139] "Mali"                               
## [140] "Malta"                              
## [141] "Myanmar"                            
## [142] "Montenegro"                         
## [143] "Mongolia"                           
## [144] "Northern Mariana Islands"           
## [145] "Mozambique"                         
## [146] "Mauritania"                         
## [147] "Montserrat"                         
## [148] "Mauritius"                          
## [149] "Malawi"                             
## [150] "Malaysia"                           
## [151] "Namibia"                            
## [152] "New Caledonia"                      
## [153] "Niger"                              
## [154] "Norfolk Island"                     
## [155] "Nigeria"                            
## [156] "Nicaragua"                          
## [157] "Niue"                               
## [158] "Bonaire"                            
## [159] "Sint Eustatius"                     
## [160] "Saba"                               
## [161] "Nepal"                              
## [162] "Nauru"                              
## [163] "New Zealand"                        
## [164] "Oman"                               
## [165] "Pakistan"                           
## [166] "Panama"                             
## [167] "Pitcairn Islands"                   
## [168] "Peru"                               
## [169] "Philippines"                        
## [170] "Palau"                              
## [171] "Papua New Guinea"                   
## [172] "Puerto Rico"                        
## [173] "North Korea"                        
## [174] "Madeira Islands"                    
## [175] "Azores"                             
## [176] "Portugal"                           
## [177] "Paraguay"                           
## [178] "Palestine"                          
## [179] "French Polynesia"                   
## [180] "Qatar"                              
## [181] "Romania"                            
## [182] "Russia"                             
## [183] "Rwanda"                             
## [184] "Western Sahara"                     
## [185] "Saudi Arabia"                       
## [186] "Sudan"                              
## [187] "South Sudan"                        
## [188] "Senegal"                            
## [189] "Singapore"                          
## [190] "South Sandwich Islands"             
## [191] "South Georgia"                      
## [192] "Saint Helena"                       
## [193] "Ascension Island"                   
## [194] "Solomon Islands"                    
## [195] "Sierra Leone"                       
## [196] "El Salvador"                        
## [197] "Somalia"                            
## [198] "Saint Pierre and Miquelon"          
## [199] "Serbia"                             
## [200] "Sao Tome and Principe"              
## [201] "Suriname"                           
## [202] "Slovakia"                           
## [203] "Swaziland"                          
## [204] "Sint Maarten"                       
## [205] "Seychelles"                         
## [206] "Syria"                              
## [207] "Turks and Caicos Islands"           
## [208] "Chad"                               
## [209] "Togo"                               
## [210] "Thailand"                           
## [211] "Tajikistan"                         
## [212] "Turkmenistan"                       
## [213] "Timor-Leste"                        
## [214] "Tonga"                              
## [215] "Trinidad"                           
## [216] "Tobago"                             
## [217] "Tunisia"                            
## [218] "Turkey"                             
## [219] "Taiwan"                             
## [220] "Tanzania"                           
## [221] "Uganda"                             
## [222] "Ukraine"                            
## [223] "Uruguay"                            
## [224] "Uzbekistan"                         
## [225] "Vatican"                            
## [226] "Grenadines"                         
## [227] "Saint Vincent"                      
## [228] "Venezuela"                          
## [229] "Virgin Islands"                     
## [230] "Vietnam"                            
## [231] "Vanuatu"                            
## [232] "Wallis and Futuna"                  
## [233] "Samoa"                              
## [234] "Yemen"                              
## [235] "South Africa"                       
## [236] "Zambia"                             
## [237] "Zimbabwe"
```

```r
# dodajmy informacje, ze mamy 0 uzytkownikow w kazdym z krajow ze zmiennej other_countries
country_full <- rbind(summaries_country, 
                  data.frame(sessions = 0,
                             users = 0,
                             newUsers = 0,
                             region = other_countries)) %>% 
  mutate(usersF = cut(users, c(0, 1, 10, 30, 550), include.lowest = TRUE))
# tworzymy zmienna dyskretna userF, aby mapa wygladala ladniej

# to nasi uzytkownicy z calego swiata
ggplot(country_full, aes(map_id = region)) + 
  geom_map(aes(fill = usersF), map = world_map) +
  expand_limits(x = world_map$long, y = world_map$lat) +
  theme_bw() +
  scale_fill_manual("STWURy", values = brewer.pal(5, "GnBu"))
```

![plot of chunk STWUR_map](./figure/STWUR_map-1.png)

```r
# skupmy sie na Europie

ggplot(country_full, aes(map_id = region)) + 
  geom_map(aes(fill = usersF), map = world_map) +
  expand_limits(x = c(-10, 35), y = c(35, 70)) +
  theme_bw() +
  scale_fill_manual("STWURy", values = brewer.pal(5, "GnBu"))
```

![plot of chunk STWUR_map](./figure/STWUR_map-2.png)
