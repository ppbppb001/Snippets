#----------------------------------
# <unemploy-fx-match.r>
#  Improve the target table with 
#  unemployment and FX data colmum
#  date matcing
#----------------------------------


# Key Constants: ........................
lookup.dateformat <- "%d-%b-%y"     # date format string for lookup, like'05-May-16'
target.dateformat <- "%d-%b-%Y"     # date format string for target, like'05-May-2016'
#
target.rows <- 10000                # rows of target data frame
# column index of 'lookup.dfnew'
ci.k.date <- 1                      # Col-1: Date
ci.k.ue <- 2                        # Col-2: Unemployment.Rate
ci.k.uea <- 3                       # Col-3: Unemployment.Rate.Annual (mean)
ci.k.datefx <- 4                    # Col-4: Date.FX
ci.k.aud <- 5                       # Col-5: AUDUSD
ci.k.auda <- 6                      # Col-6: AUDUSD.Annual (mean)
# column index of 'target.dfnew'
ci.t.date <- 1                      # Col-1: Date
ci.t.x <- 2                         # Col-2: X
ci.t.ue <- 3                        # Col-3: Unemployment.Rate
ci.t.uea <- 4                       # Col-4: Unemployment.Rate.Annual (mean)
ci.t.aud <- 5                       # Col-5: AUDUSD
ci.t.auda <- 6                      # Col-6: AUDUSD.Annual (mean)


# Load unemployment and Fx historical data: ..................
lookup.df <- read.csv("aus-unemploy-fx.csv", stringsAsFactors = FALSE) 
lookup.rows <- dim(lookup.df)[1]

# Make a new lookup dataframe with 2 extra columns for annual values:
lookup.dfnew <- data.frame(Date = lookup.df[,"Date"],                            # Col-1: Date (mm-yy)
                           Unemployment.Rate = lookup.df[,"Unemployment.Rate"],  # Col-2: Unemployment.Rate
                           Unemployment.Rate.Annual = rep(NA, lookup.rows),      # Col-3: Unemployment.Rate.Annual
                           Date.FX = lookup.df[,"Date.FX"],                      # Col-4: Date.FX (dd-mm-yy)
                           AUDUSD = lookup.df[,"AUDUSD"],                        # Col-5: AUDUSD
                           AUDUSD.Annual = rep(NA, lookup.rows)                  # Col-6: AUDUSD.Annual
                           )
# Calculate means of year and write back to 'lookup.dfnew'
lookup.datefx <- strptime(lookup.df[,"Date.FX"], lookup.dateformat)
lastyear <- 0
for (i in seq(lookup.rows)) {
    if (lastyear != lookup.datefx[i]$year){
        lastyear <- lookup.datefx[i]$year
        
        ixs <- which(lookup.datefx$year == lastyear)     # Indices of matched items
        
        xmean.ue <- mean(lookup.dfnew[ixs, ci.k.ue])
        lookup.dfnew[ixs, ci.k.uea] <- xmean.ue          # Annual mean of Unemployment.Rate
        
        xmean.aud <- mean(lookup.dfnew[ixs, ci.k.aud])
        lookup.dfnew[ixs, ci.k.auda] <- xmean.aud        # Annual mean of AUDUSD
    }    
}



# Make pseudo target table to be improved: ...................
target.colx <- sample(100, target.rows, replace = TRUE)  # colx of target is for nothing

# Make data vector of date column of target
xyears <- sample(2010:2016, target.rows, replace = TRUE)  # random years
xmonths <- sample(1:12, target.rows, replace = TRUE)      # random months
xdays <- sample(1:28, target.rows, replace = TRUE)        # random days
xdatestr <- paste(as.character(xyears),"-",
                  as.character(xmonths),"-",
                  as.character(xdays),
                  sep=""
                 )                                        # random date as string
xdate <- strptime(target.datestr, "%Y-%m-%d")             # format of random date string is like "YYYY-MM-DD"
target.coldate <- strftime(xdate, target.dateformat)      # date column of target as character



# Improve/Match the target data frame with unemployment and AUD .............................. 

tm.Start <- proc.time()        # Time of Start

# Add 2 extra column to represent unemployment and AUD:
target.dfnew <- data.frame(Date = target.coldate,                           # Col-1: Date
                           X = target.colx,                                 # Col-2: X
                           Unemployment.Rate = rep(NA, target.rows),        # Col-3: Unemployment.Rate
                           Unemployment.Rate.Annual = rep(NA, target.rows), # Col-4: Unemployment.Rate.Annual
                           AUDUSD = rep(NA, target.rows),                   # Col-5: AUDUSD
                           AUDUSD.Annual = rep(NA, target.rows)             # Col-6: AUDUSD.Annual
                          )

# Build a string vector in format of lookup.dateformat 
# to reflect target date column:
xdate <- strptime(as.character(target.dfnew$Date), target.dateformat)  # string -> xdate
target.datestr.aslookup <- strftime(xdate, lookup.dateformat)          # xdate -> string in lookup format

# scan and match: loop through 'lookup.dfnew':
for (i in seq(lookup.rows)) {
    k.row <- lookup.dfnew[i,]                               # one row in 'lookup.dfnew'
    k.date <- k.row[, ci.k.date]                            # k.date = date in string
    ixs <- grep(k.date, target.datestr.aslookup)            # indices of target items matching k.date
    if (length(ixs) > 0){                                   # index set available?
        target.dfnew[ixs, ci.t.ue] <- k.row[, ci.k.ue]      # copy "Unemployment.Rate"
        target.dfnew[ixs, ci.t.uea] <- k.row[, ci.k.uea]    # copy "Unemployment.Rate.Annual"
        target.dfnew[ixs, ci.t.aud] <- k.row[, ci.k.aud]    # copy "AUDUSD"
        target.dfnew[ixs, ci.t.auda] <- k.row[, ci.k.auda]  # copy "AUDUSD.Annual"
    }
}

tm.Finish <- proc.time()   # Time of Finish


# Check result: ..............
print (head(target.dfnew))
print (tail(target.dfnew))
cat("\nTime Consumed = ", (tm.Finish - tm.Start)[3],"(s)")


