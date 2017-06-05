#==================================================
#
#  <weo-lib-lookup.R>: 
#    The library of user defined functions for 
#    WEO/GDP lookup table.
#
#==================================================


#---------------------------------------------------
# Load WEOAll csv to build the simplized data.frame
#---------------------------------------------------
createWEOSimple <- function(fname) {

  # dfWEO = the complete table/data.frame
  dfWEO <- read.csv(fname, header = TRUE, na.strings = "n/a")
  # cat("$ dfWEO: ","rows =",length(dfWEO[,1]),", cols =",length(dfWEO[1,]))
  
  # dfNGDPDPC is the data.frame in which GDP per captia is contained
  dfNGDPDPC <- dfWEO[dfWEO$WEO.Subject.Code=="NGDPDPC",]
  # cat("$ dfNGDPDPC: ","rows =",length(dfNGDPDPC[,1]),", cols =",length(dfNGDPDPC[1,]))
  
  # dfNSimple is the data.frame with irrelevant cols removed
  dfNSimple <- data.frame(dfNGDPDPC[1:4], dfNGDPDPC[10:53])
  # cat("$ dfNSimple: ","rows =",length(dfNSimple[,1]),", cols =",length(dfNSimple[1,]))
  # head(dfNSimple)
  
  return (dfNSimple)
}


#----------------------------------------------------------------
# Create up the lookup table to which the data.frame is reflected
#----------------------------------------------------------------
createGDPPCLookupTable <- function(dfSimple){
  
  lstLookup <- list()  # create an empty lookup table
  # print (lstLookup)
  
  dfX <- dfSimple       # dfX <- dfNSimple
  numCols <- length(dfX) # numCols = number of columns of dfNSimple
  
  # push the col-1:4 to lookup table
  for (ixCol in 1:4) {
    f <- dfX[,ixCol]
    v <- as.vector(f)
    lstLookup <- c(lstLookup,list(v))
  }
  
  # push (col-5):(END-1) to the lookup table
  for (ixCol in 5:(numCols-1)) {
    f <- dfX[,ixCol]
    v <- as.numeric(gsub(",","",as.vector(f)))
    xmin <- min(v, na.rm = TRUE)
    xmax <- max(v, na.rm = TRUE)
    xmean <- mean(v, na.rm = TRUE)
    xmedian <- median(v, na.rm = TRUE)
    v <- c(v,xmin,xmax,xmean,xmedian)
    lstLookup <- c(lstLookup,list(v))
  }
  
  # Push estimated years to the lookup table
  f <- dfX[,numCols]
  v <- as.vector(f)
  lstLookup <- c(lstLookup,list(v))
  
  # Push column names to the lookup table
  v <- names(dfX)
  lstLookup <- c(lstLookup,list(v))
  
  return(lstLookup)
}


#---------------------------------------------
# Get list index of the lookup table 
# by column name
#---------------------------------------------
getColumnIndex <- function(lookup,colname) {
  l <- length(lookup)
  # ix <- which(unlist(lookup[l]) %in% colname)
  ix <- which(lookup[[l]] %in% colname)  # another approach
  return(ix)
}


#---------------------------------------------
# Get cell index of the vector retrieved from 
# the lookup table by ISO country code
#---------------------------------------------
getCountryIndex <- function(lookup, country) {
  ixISO <- getColumnIndex(lookup, "ISO")
  # vISO <- unlist(lookup[ixISO])
  vISO <- lookup[[ixISO]] # another approach
  ixC <- which(vISO %in% country)
  return(ixC)
}


#--------------------------------------------
# Return the vector of a column by giving 
# the name
#--------------------------------------------
lookByColumnName <- function(lookup,colname) {
  lt <- length(lookup)
  ix <- getColumnIndex(lookup, colname)
  # vx <- unlist(lookup[ix])
  vx <- lookup[[ix]]  # another approach
  return(vx)
}


#--------------------------------------------
# Return the vector of year by checking the
# lookup tabel
#--------------------------------------------
lookByYear <- function(lookup,year) {
  # sy <- gsub(" ", "", paste("X", year))
  sy <- paste("X", year, sep = "")
  return(lookByColumnName(lookup,sy))
}


#--------------------------------------------
# Return the annual value of country by 
# checking the lookup tabel
#--------------------------------------------
lookByYearCountry <- function(lookup, year, country) {
  vyear <- lookByYear(lookup, year)
  ic <- getCountryIndex(lookup, country)
  vc <- vyear[ic]
  return(vc)
}

