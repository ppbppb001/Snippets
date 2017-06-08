#----------------------------------------
# <datetime.r>
#  Basic tricks for datetime manipulation
# 
#  [2017-06-08] - Start
#----------------------------------------



    
# Explaination of the Format string: ......................
#   %Y : 4 digits year, like '2017'
#   %y : 2 digits year, like '17'
#   %m : month as decimal number (01-12)
#   %d : day of month as decimal number (01-31)
#   %H : hour of day as decimal number (00-23)
#   %M : minute of hour as decimal number (00-59)
#   %S : second of minute as decimal number (00-59)
#   %b : abbreviated month name, such as "Jun","Oct",etc.


# Predefined constants ......................................
yearBase <- 1900
monthBase <- 1

year <- 2017     
month <- 5         # June (1-12)
mday <- 15          # day of month (1-31)
hour <- 10         # 10am (0-23)
minute <- 11       # minutes of hour (0-59)
second <- 12       # seconds of minute (0-59)
timeZone <- "GMT"  # timezone = GMT



# [1] Create a datetime object ........................

# (1) From number to datetime
dt.str <- paste(as.character(year), "-",
                as.character(month), "-",
                as.character(mday), " ",
                as.character(hour), ":",
                as.character(minute), ":",
                as.character(second), " ",
                sep="")
# Convert string to datetime object without timezone setting
dt <- strptime(dt.str, format = "%Y-%m-%d %H:%M:%S")    
dt

# it also works without explicitly giving the 'format' key word 
dt <- strptime(dt.str, "%Y-%m-%d %H:%M:%S")  
dt
# Convert string to datetime object with timezone setting
dtz <- strptime(dt.str, "%Y-%m-%d %H:%M:%S", tz=timeZone) 
dtz


# (2) From string to datetime
dt2.str <- "25/May/2017"
dt2 <- strptime(dt2.str, "%d/%b/%Y")
dt2

dt2.str <- "May 25, 2017"
dt2 <- strptime(dt2.str, "%b %d, %Y")
dt2

dt2.str <- "25 May, 2017 10:11:12"
dt2 <- strptime(dt2.str, "%d %b, %Y %H:%M:%S")
dt2

dt2.str <- "25/May/2017 10:11:12"
dt2 <- strptime(dt2.str, "%d/%b/%Y %H:%M:%S", tz=timeZone)
dt2




# [2] Retrieve date time elements as numeric from the datetime object .........

dt2$year + yearBase    # retrieve year as numeric
dt2$mon+ monthBase     # retrieve month of year as numeric
dt2$mday               # retrieve day of month as numeric

dt2$hour               # retrieve hour of day
dt2$min                # retrieve minute of hour
dt2$sec                # retrieve second of minute     

dt2$wday               # retrieve day of week
dt2$yday               # retrieve day of year

attributes(dt2)$tzone  # retrieve time zone



# [3] datetime object to string ........................
toString(dt2)                          # in ISO date time format
strftime(dt2,"%d/%b/%Y")               # like '25/May/2017'
strftime(dt2,"%b %d, %Y %H:%M")        # like 'May 25, 2017 10:11'
strftime(dt2,"%Y-%m-%d %H:%M:%S %Z")   # like '2017-05-25 10:11:12 GMT'




# [4] Get difference/distance between datetime objects ............ 
x.weeks <- as.numeric(difftime(dt2, dt, units="weeks"))     # distance in weeks
x.weeks
x.days <- as.numeric(difftime(dt2, dt, units="days"))       # distance in days
x.days
x.hours <- as.numeric(difftime(dt2, dt, units="hours"))     # distance in days
x.hours
x.minutes <- as.numeric(difftime(dt2, dt, units="mins"))    # distance in days
x.minutes
x.seconds <- as.numeric(difftime(dt2, dt, units="secs"))    # distance in days
x.seconds

