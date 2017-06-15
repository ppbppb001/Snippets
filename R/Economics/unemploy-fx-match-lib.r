# [Readme] ----------------------------
#   <unemploy-fx-match-lib.r>
#   - Based on <unemploy-fx-match-r3.r>
#   - Input data frame with date of obs
#     Output is a data frame with appened
#     data columns about unemployment and 
#     fx.
#
#   [2017-6-15]
# -------------------------------------

# Global varibles:
lookup.UempFx <- NULL     

# Function <matchUempFx()>
matchUempFx <- function(data = NULL, 
                        datename = "Date",
                        dateformat = "%Y-%m-%d") {
    
    lookup.csv <- "aus-unemploy-fx.csv"  # file name of source data of lookup table
    lookup.dateformat <- "%d-%b-%y"      # date format string for lookup, like'20-May-16'
    # column name of 'lookup.dfnew':
    cn.k.date <- "Date"
    cn.k.ue <- "Unemployment.Rate"
    cn.k.uea <- "Unemployment.Rate.Annual"
    cn.k.uek1 <- "Unemployment.K1"        # 'Unemployment.K1' = Value.Year(i-1) - Value.Year(i-2)
    cn.k.uek2 <- "Unemployment.K2"        # 'Unemployment.K2' = K1/Value.Year(i-2)
    cn.k.uek3 <- "Unemployment.K3"        # 'Unemployment.K3' = K2*(Value.Year(i-1) - 0.05)
    cn.k.datefx <- "Date.FX"
    cn.k.aud <- "AUDUSD"
    cn.k.auda <- "AUDUSD.Annual"
    cn.k.audk1 <- "AUDUSD.K1"             # 'AUDUSD.K1' = Value.Year(i-1) - Value.Year(i-2)
    cn.k.audk2 <- "AUDUSD.K2"             # 'AUDUSD.K2' = K1/Value.Year(i-2)
    cn.k.audk3 <- "AUDUSD.K3"             # 'AUDUSD.K3' = K2*(Value.Year(i-1) - 0.5)
    # column name of source data frame 'data':
    cn.t.ue <- "Unemployment.Rate"
    cn.t.uea <- "Unemployment.Rate.Annual"
    cn.t.uek1 <- "Unemployment.K1"
    cn.t.uek2 <- "Unemployment.K2"
    cn.t.uek3 <- "Unemployment.K3"
    cn.t.aud <- "AUDUSD"
    cn.t.auda <- "AUDUSD.Annual"
    cn.t.audk1 <- "AUDUSD.K1"
    cn.t.audk2 <- "AUDUSD.K2"
    cn.t.audk3 <- "AUDUSD.K3"    
    
    # Load unemployment and FX data lookup table
    lookup.df <- read.csv(lookup.csv,
                          stringsAsFactors = FALSE)
    if (is.null(lookup.df))
        return(NULL)
    lookup.rows <- dim(lookup.df)[1]
    if (lookup.rows < 1)  # Lookup table available ?
        return(NULL)
    
    # Make a new lookup dataframe with 2 extra columns for annual values:
    lookup.dfnew <- data.frame(Date = lookup.df[,"Date"],                            # Date (mm-yy)
                               Unemployment.Rate = lookup.df[,"Unemployment.Rate"],  # Unemployment.Rate
                               Unemployment.Rate.Annual = rep(NA, lookup.rows),      # Unemployment.Rate.Annual
                               Unemployment.K1 = rep(NA, lookup.rows),               # Unemployment.K1
                               Unemployment.K2 = rep(NA, lookup.rows),               # Unemployment.K2
                               Unemployment.K3 = rep(NA, lookup.rows),               # Unemployment.K3
                               Date.FX = lookup.df[,"Date.FX"],                      # Date.FX (dd-mm-yy)
                               AUDUSD = lookup.df[,"AUDUSD"],                        # AUDUSD
                               AUDUSD.Annual = rep(NA, lookup.rows),                 # AUDUSD.Annual
                               AUDUSD.K1 = rep(NA, lookup.rows),                     # AUDUSD.K1
                               AUDUSD.K2 = rep(NA, lookup.rows),                     # AUDUSD.K2
                               AUDUSD.K3 = rep(NA, lookup.rows),                     # AUDUSD.K3
                               stringsAsFactors = FALSE)                             # No factors for string type
    
    # Calculate and Fill up 'lookup.dfnew':
    # K1/K2/K3 calculated and assigned to lookup table
    lookup.datefx <- strptime(lookup.df[,"Date.FX"], lookup.dateformat)
    ue.annual <- NULL                                       # save annual value of unemployment
    aud.annual <- NULL                                      # save annual value of AUD
    lastyear <- 0
    for (i in seq(lookup.rows)) {
        if (lastyear != lookup.datefx[i]$year){
            lastyear <- lookup.datefx[i]$year
            
            ixs <- which(lookup.datefx$year == lastyear)     # Indices of matched items
            
            xmean.ue <- mean(lookup.dfnew[ixs, cn.k.ue])
            lookup.dfnew[ixs, cn.k.uea] <- xmean.ue          # Annual mean of Unemployment.Rate
            
            xmean.aud <- mean(lookup.dfnew[ixs, cn.k.aud])
            lookup.dfnew[ixs, cn.k.auda] <- xmean.aud        # Annual mean of AUDUSD
            
            ue.annual <- c(ue.annual, xmean.ue)              # Append annual value
            aud.annual <- c(aud.annual, xmean.aud)           # Append annual value
            
            # Unemploymeny.K1/K2/K3:
            lx <- length(ue.annual)
            if (lx >= 3) {                                   
                # Calculate Unemployment.K1/K2/K3
                k1 <- ue.annual[lx-1] - ue.annual[lx-2]
                k2 <- k1 / ue.annual[lx-2]
                k3 <- k2 * (ue.annual[lx-1] - 0.05)
                # Assign Unemployment.K1/K2/K3
                lookup.dfnew[ixs, cn.k.uek1] <- k1
                lookup.dfnew[ixs, cn.k.uek2] <- k2
                lookup.dfnew[ixs, cn.k.uek3] <- k3
            }
            
            # AUDUSD.K1/K2/K3:
            lx <- length(aud.annual)
            if (lx >= 3) {                                   
                # Calculate AUDUSD.K1/K2/K3
                k1 <- aud.annual[lx-1] - aud.annual[lx-2]
                k2 <- k1 / aud.annual[lx-2]
                k3 <- k2 * (aud.annual[lx-1] - 0.5)
                # Assign AUDUSD.K1/K2/K3
                lookup.dfnew[ixs, cn.k.audk1] <- k1
                lookup.dfnew[ixs, cn.k.audk2] <- k2
                lookup.dfnew[ixs, cn.k.audk3] <- k3
            }
        }    
    }
    
    lookup.UempFx <<- lookup.dfnew
                             
    # Add extra columns to source data frame by matching lookup table:
    if (!is.data.frame(data))
        return(NULL)
    
    target.rows <- length(data[,1])   # get row count of df.src
    if (target.rows < 1) {
        return(NULL)
    }
    
    target.dfnew <- data.frame(data,                                            # Source data frame
                               Unemployment.Rate = rep(NA, target.rows),        # Unemployment.Rate
                               Unemployment.Rate.Annual = rep(NA, target.rows), # Unemployment.Rate.Annual
                               Unemployment.K1 = rep(NA, target.rows),          # Unemployment.K1
                               Unemployment.K2 = rep(NA, target.rows),          # Unemployment.K2
                               Unemployment.K3 = rep(NA, target.rows),          # Unemployment.K3
                               AUDUSD = rep(NA, target.rows),                   # AUDUSD
                               AUDUSD.Annual = rep(NA, target.rows),            # AUDUSD.Annual
                               AUDUSD.K1 = rep(NA, target.rows),                # AUDUSD.K1
                               AUDUSD.K2 = rep(NA, target.rows),                # AUDUSD.K2
                               AUDUSD.K3 = rep(NA, target.rows),                # AUDUSD.K3
                               stringsAsFactors = FALSE)
    
    
    
    # Build a string vector in format of lookup.dateformat 
    # to reflect target date column:
    xdate <- strptime(as.character(target.dfnew[,datename]), dateformat)    # string -> xdate
    target.datestr.aslookup <- strftime(xdate, lookup.dateformat)           # xdate -> string in lookup format
    
    # scan and match: loop through 'lookup.dfnew':
    for (i in seq(lookup.rows)) {
        k.row <- lookup.dfnew[i,]                                # one row in 'lookup.dfnew'
        k.date <- as.character(k.row[, cn.k.date])               # k.date = date in string
        ixs <- grep(k.date, target.datestr.aslookup)             # indices of target items matching k.date
        if (length(ixs) > 0){                                    # index set available?
            target.dfnew[ixs, cn.t.ue] <- k.row[, cn.k.ue]       # copy "Unemployment.Rate"
            target.dfnew[ixs, cn.t.uea] <- k.row[, cn.k.uea]     # copy "Unemployment.Rate.Annual"
            target.dfnew[ixs, cn.t.uek1] <- k.row[, cn.k.uek1]   # copy "Unemployment.K1"
            target.dfnew[ixs, cn.t.uek2] <- k.row[, cn.k.uek2]   # copy "Unemployment.K2"
            target.dfnew[ixs, cn.t.uek3] <- k.row[, cn.k.uek3]   # copy "Unemployment.K3"
            target.dfnew[ixs, cn.t.aud] <- k.row[, cn.k.aud]     # copy "AUDUSD"
            target.dfnew[ixs, cn.t.auda] <- k.row[, cn.k.auda]   # copy "AUDUSD.Annual"
            target.dfnew[ixs, cn.t.audk1] <- k.row[, cn.k.audk1] # copy "AUDUSD.K1"
            target.dfnew[ixs, cn.t.audk2] <- k.row[, cn.k.audk2] # copy "AUDUSD.K1"
            target.dfnew[ixs, cn.t.audk3] <- k.row[, cn.k.audk3] # copy "AUDUSD.K1"
        }
    }
    
    return(target.dfnew)
}



