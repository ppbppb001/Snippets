#----------------------------------
# <unemploy-fx-match-r2.r>
#  Improve the target table with 
#  unemployment and FX data colmum
#  date matcing
#----------------------------------


# Key Constants: ........................
lookup.dateformat <- "%d-%b-%y"     # date format string for lookup, like'20-May-16'
target.dateformat <- "%Y-%m-%d"     # target date format: '2016-05-20'
# target.dateformat <- "%d-%b-%Y"     # target date format: '20-May-2016'
# target.dateformat <- "%d-%b-%y"     # target date format: '20-May-16'
# target.dateformat <- "%b %d, %Y"    # target date format: 'May 20, 2016'
# target.dateformat <- "%b %d, %y"    # target date format: 'May 20, 16'
# target.dateformat <- "%d/%m/%Y"     # target date format: '20/5/2016'
#
target.rows <- 10000                  # rows of target data frame
# column name of 'lookup.dfnew'
cn.k.date <- "Date"
cn.k.ue <- "Unemployment.Rate"
cn.k.uea <- "Unemployment.Rate.Annual"
cn.k.datefx <- "Date.FX"
cn.k.aud <- "AUDUSD"
cn.k.auda <- "AUDUSD.Annual"
cn.k.audk1 <- "AUDUSD.K1"             # 'AUDUSD.K1' = AUD.Year(i-1) - AUD.Year(i-2)
# column name of 'target.dfnew'
cn.t.date <- "Date"
cn.t.x <- "X"
cn.t.ue <- "Unemployment.Rate"
cn.t.uea <- "Unemployment.Rate.Annual"
cn.t.aud <- "AUDUSD"
cn.t.auda <- "AUDUSD.Annual"
cn.t.audk1 <- "AUDUSD.K1"


# Load unemployment and Fx historical data: ..................
lookup.df <- read.csv("aus-unemploy-fx.csv", stringsAsFactors = FALSE) 
lookup.rows <- dim(lookup.df)[1]


# Make a new lookup dataframe with 2 extra columns for annual values:
lookup.dfnew <- data.frame(Date = lookup.df[,"Date"],                            # Col-1: Date (mm-yy)
                           Unemployment.Rate = lookup.df[,"Unemployment.Rate"],  # Col-2: Unemployment.Rate
                           Unemployment.Rate.Annual = rep(NA, lookup.rows),      # Col-3: Unemployment.Rate.Annual
                           Date.FX = lookup.df[,"Date.FX"],                      # Col-4: Date.FX (dd-mm-yy)
                           AUDUSD = lookup.df[,"AUDUSD"],                        # Col-5: AUDUSD
                           AUDUSD.Annual = rep(NA, lookup.rows),                 # Col-6: AUDUSD.Annual
                           AUDUSD.K1 = rep(NA, lookup.rows),          # Col-7: AUDUSD.K1
                           stringsAsFactors = FALSE
)
# Calculate means of year and write back to 'lookup.dfnew'
lookup.datefx <- strptime(lookup.df[,"Date.FX"], lookup.dateformat)
aud.annual <- NULL   # save annual value of AUD
lastyear <- 0
for (i in seq(lookup.rows)) {
    if (lastyear != lookup.datefx[i]$year){
        lastyear <- lookup.datefx[i]$year
        
        ixs <- which(lookup.datefx$year == lastyear)     # Indices of matched items
        
        xmean.ue <- mean(lookup.dfnew[ixs, cn.k.ue])
        lookup.dfnew[ixs, cn.k.uea] <- xmean.ue          # Annual mean of Unemployment.Rate
        
        xmean.aud <- mean(lookup.dfnew[ixs, cn.k.aud])
        lookup.dfnew[ixs, cn.k.auda] <- xmean.aud        # Annual mean of AUDUSD
        
        aud.annual <- c(aud.annual, xmean.aud)           # Append annual value
        lx <- length(aud.annual)
        if (lx >= 3) {                                   # Calculate AUDUSD.K1
            lookup.dfnew[ixs, cn.k.audk1] <- aud.annual[lx-1] - aud.annual[lx-2]
        }
    }    
}



# Make pseudo target table to be improved: ...................
target.colx <- sample(100, target.rows, replace = TRUE)  # colx of target is for nothing

# Make the random date series
xyears <- sample(2010:2016, target.rows, replace = TRUE)  # random years
xmonths <- sample(1:12, target.rows, replace = TRUE)      # random months
xdays <- sample(1:28, target.rows, replace = TRUE)        # random days
xdatestr <- paste(as.character(xyears),"-",
                  as.character(xmonths),"-",
                  as.character(xdays),
                  sep=""
)                                        # random date as string
xdate <- strptime(xdatestr, "%Y-%m-%d")                   # format of random date string is like "YYYY-MM-DD"
# Convert random xdate to target date
target.coldate <- strftime(xdate, target.dateformat)      # date column of target as character
# Make the target
target.df <- data.frame(Date = target.coldate,            # Col-1: Date
                        X = target.colx,                  # Col-2: X
                        stringsAsFactors = FALSE
)


# Improve/Match the target data frame with unemployment and AUD .............................. 

tm.Start <- proc.time()        # Time of Start

# Add 4 extra column to represent unemployment and AUD:
target.dfnew <- data.frame(target.df,                                       # Col-1~n: Original target
                           Unemployment.Rate = rep(NA, target.rows),        # Col-n+1: Unemployment.Rate
                           Unemployment.Rate.Annual = rep(NA, target.rows), # Col-n+2: Unemployment.Rate.Annual
                           AUDUSD = rep(NA, target.rows),                   # Col-n+3: AUDUSD
                           AUDUSD.Annual = rep(NA, target.rows),            # Col-n+4: AUDUSD.Annual
                           AUDUSD.K1 = rep(NA, target.rows),                # Col-n+5: AUDUSD.K1
                           stringsAsFactors = FALSE
)

# Build a string vector in format of lookup.dateformat 
# to reflect target date column:
xdate <- strptime(as.character(target.dfnew$Date), target.dateformat)  # string -> xdate
target.datestr.aslookup <- strftime(xdate, lookup.dateformat)          # xdate -> string in lookup format

# scan and match: loop through 'lookup.dfnew':
for (i in seq(lookup.rows)) {
    k.row <- lookup.dfnew[i,]                                # one row in 'lookup.dfnew'
    k.date <- as.character(k.row[, cn.k.date])               # k.date = date in string
    ixs <- grep(k.date, target.datestr.aslookup)             # indices of target items matching k.date
    if (length(ixs) > 0){                                    # index set available?
        target.dfnew[ixs, cn.t.ue] <- k.row[, cn.k.ue]       # copy "Unemployment.Rate"
        target.dfnew[ixs, cn.t.uea] <- k.row[, cn.k.uea]     # copy "Unemployment.Rate.Annual"
        target.dfnew[ixs, cn.t.aud] <- k.row[, cn.k.aud]     # copy "AUDUSD"
        target.dfnew[ixs, cn.t.auda] <- k.row[, cn.k.auda]   # copy "AUDUSD.Annual"
        target.dfnew[ixs, cn.t.audk1] <- k.row[, cn.k.audk1] # copy "AUDUSD.K1"
    }
}

tm.Finish <- proc.time()   # Time of Finish


# Check result: ..............
print (head(target.dfnew))
print (tail(target.dfnew))
cat("\nTime Consumed = ", (tm.Finish - tm.Start)[3],"(s)")





