library('tidyr')
library('dplyr')

# using tidyr  
url = 'http://pub.data.gov.bc.ca/datasets/77eeadf4-0c19-48bf-a47a-fa9eef01f409/sample_CO_hourly.csv'
cMonoxide = read.csv(url)
head(cMonoxide)

# split the date and time
cMonoxide = cMonoxide %>% separate('date_time', into = c("date", "time"), sep = " ")
head(cMonoxide)

# break the date up into y/m/d
cMonoxide = cMonoxide %>% separate('date', into = c("year", "month", "day"), sep = "-")
head(cMonoxide)

# oh crap we have two years
cMonoxide$year = NULL
head(cMonoxide)

# aw man now the columns are in weird order
cMonoxide = cMonoxide[, c(1,2,3,7,4,5,6,8,9)]
head(cMonoxide)

# challenge: split the time into h/m/s

# but, many of these columns contain only one value
unique(cMonoxide$ems_id)

# we can associate this with the data once, using a attribute
attr(cMonoxide,"EMS_ID") = as.character(cMonoxide$ems_id[1])
cMonoxide$ems_id = NULL
attr(cMonoxide, "EMS_ID")

# challenge: do this for all the other redundant columns
# challenge: move the units into the value column header, since they're all redundant
