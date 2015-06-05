# Exploring Grizzly Data
  
June 5, 2015  




```r
## getting the data
mortality <- read.csv("http://www.env.gov.bc.ca/soe/archive/data/plants-and-animals/2012_Grizzly_Status/Grizzly_bear_mortality_history.csv")

population <- read.csv("http://www.env.gov.bc.ca/soe/archive/data/plants-and-animals/2012_Grizzly_Status/Grizzly_population_estimate_2012.csv")
```


Now that we have the data, let's look at the top of it. 


```r
knitr::kable(head(mortality, format = "markdown"))
```

     X   HUNT_YEAR    MU   GBPU_ID  GBPU_NAME                KILL_CODE     SEX   AGE_CLASS   SPATIAL   X.1   X.2   X.3   X.4                                                                                                                                                                                                                         
------  ----------  ----  --------  -----------------------  ------------  ----  ----------  --------  ----  ----  ----  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 12038        1976   316        40  Stein-Nahatlatch         Hunter Kill   M     '5-9        no        NA    NA    NA    Notes                                                                                                                                                                                                                       
 12137        1976   332        36  South Chilcotin Ranges   Hunter Kill   M     '0-2        no        NA    NA    NA    Prior to 2004, road and rail kills were not distinguished and were documented with 'Pick Ups'.                                                                                                                              
 12077        1976   332        36  South Chilcotin Ranges   Hunter Kill   M     NA          no        NA    NA    NA    A Limited Entry Hunt (LEH) was instituted province-wide for grizzly bears in 1996.                                                                                                                                          
 12090        1976   402        35  Flathead                 Hunter Kill   F     '10-14      no        NA    NA    NA    There was a province-wide moratorium on hunting grizzly bears in the spring of 2001.                                                                                                                                        
 12100        1976   402        35  Flathead                 Hunter Kill   M     '10-14      no        NA    NA    NA    A limited number of records with a value of 'no' in the SPATIAL column have not been spatially verified and thus may be assigned to the incorrect Management Unit (MU); most of these assignment errors are from 1976-1980. 
 12099        1976   402        35  Flathead                 Hunter Kill   M     '15+        no        NA    NA    NA                                                                                                                                                                                                                                

We're going to use packages to organize and clean our data.


```r
library(tidyr)
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
## let's get rid of unused columns
mortality <- mortality %>% 
  select(-contains("X."))
  

clean_mort <- mortality %>%
  separate(AGE_CLASS, into = c("minimum_age", "maximum_age"), sep = "-", extra = "merge") %>% 
  mutate(minimum_age = extract_numeric(minimum_age),
         maximum_age = extract_numeric(maximum_age))

knitr::kable(head(clean_mort, format = "markdown"))
```

     X   HUNT_YEAR    MU   GBPU_ID  GBPU_NAME                KILL_CODE     SEX    minimum_age   maximum_age  SPATIAL 
------  ----------  ----  --------  -----------------------  ------------  ----  ------------  ------------  --------
 12038        1976   316        40  Stein-Nahatlatch         Hunter Kill   M                5             9  no      
 12137        1976   332        36  South Chilcotin Ranges   Hunter Kill   M                0             2  no      
 12077        1976   332        36  South Chilcotin Ranges   Hunter Kill   M               NA            NA  no      
 12090        1976   402        35  Flathead                 Hunter Kill   F               10            14  no      
 12100        1976   402        35  Flathead                 Hunter Kill   M               10            14  no      
 12099        1976   402        35  Flathead                 Hunter Kill   M               15            NA  no      


