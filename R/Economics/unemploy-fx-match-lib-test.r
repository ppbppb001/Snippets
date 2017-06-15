
source("unemploy-fx-match-lib.r")   # Load and run external code module



# *** COMPOSE pseudo source data 'target.df' ***

target.dateformat <- "%Y-%m-%d"                          # target date format: '2016-05-20'
target.rows <- 10000                                     # rows of pseudo target data frame

# Make pseudo X data series:
target.colx <- sample(100, target.rows, replace = TRUE)  # colx of target is for nothing
# Make pseudo date series
xyears <- sample(2010:2016, target.rows, replace = TRUE)  # random years: 2010~2016
xmonths <- sample(1:12, target.rows, replace = TRUE)      # random months: 1~12
xdays <- sample(1:28, target.rows, replace = TRUE)        # random days: 1~28
xdatestr <- paste(as.character(xyears),"-",
                  as.character(xmonths),"-",
                  as.character(xdays),
                  sep="")                                 
xdate <- strptime(xdatestr, "%Y-%m-%d")                   # format of random date string is like "YYYY-MM-DD"
target.coldate <- strftime(xdate, target.dateformat)      # date column of target as character


# Compose target.df by the given data series. 
# Only 2 pseudo data series are used in the following demo code, you may put
# whatever data series concerned onto the param list of 'data.frame()':
target.df <- data.frame(Date = target.coldate,            # Col-1: Date
                        X = target.colx,                  # Col-2: X
                        stringsAsFactors = FALSE)         # No factors for string type
# *** COMPOSE - END ***






# *** TEST Function < matchUempFx() > ***
tm.Start <- proc.time()    # Time of Start


df.new <- matchUempFx(data = target.df, 
                      datename = "Date",
                      dateformat = "%Y-%m-%d")           # df.new is the matched/amended data frame


tm.Finish <- proc.time()   # Time of Finish



# Check result: ..............
print (head(df.new))
print (tail(df.new))
cat("\nTime Consumed = ", (tm.Finish - tm.Start)[3],"(s)")

# *** END OF TEST ***
