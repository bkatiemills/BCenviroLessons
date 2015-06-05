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

#what if we have a time series, but there are gaps in it?
url='http://pub.data.gov.bc.ca/datasets/77eeadf4-0c19-48bf-a47a-fa9eef01f409/sample_SO2_hourly.csv'
sDioxide = read.csv(url, stringsAsFactors=FALSE) #stringsAsFactors makes sure that the character strings are encoded as characters, not factors

#this dataset has a time series, but it has several gaps.
#we could identify the gaps by counting, but R can find them for us if we encode the date/time column in the POSIX format
sDioxide$date_time=as.POSIXct(sDioxide$date_time)
x=sDioxide$date_time

#now we can spot gaps in the time series by using the diff function
diff(x)

#and how many there are
which(diff(x) > 1)
length(which(diff(x) > 1))

#now let's expand the series so it has every point in the time series, even the missing ones
full_dates=seq(min(x), max(x), by="1 hour")

#and now we can merge full_dates with sDioxide to create a full time series complete with NA values where no observations were made
full_dates <- data.frame(date_time = full_dates) #encode full_dates as a dataset with one column, called "date_time"

#and now the merge (MUST make sure that not only are both columns called "date_time", but that the encoding is the same (i.e. you can't merge the original untouched data with the differently encoded full_dates object)
complete_data <- merge(full_dates, sDioxide, by = "date_time", all.x = TRUE)
