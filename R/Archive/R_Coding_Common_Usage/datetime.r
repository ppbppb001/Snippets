setwd("../projects/r practice/r_coding_common_usage")
rm(list=ls())

# date and time

Sys.Date() #current date
as.Date('2010-12-31') #convert a string to a date

format(Sys.Date()) #convert a date to a string
format(Sys.Date(), format='%d/%m/%y')
as.character(Sys.Date()) #convert a date to a string

ISOdate(2012, 2, 29) #convert year, month and day to a date
as.Date(ISOdate(2012, 2, 29))

d <- as.Date('2010-03-15') #extract parts of a date
p <- as.POSIXlt(d)
p$mday #day of month
p$mon #month
p$year + 1900 #year

