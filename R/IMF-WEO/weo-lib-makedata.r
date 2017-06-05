#==================================================
#
#  <weo-lib-makedata.R>: 
#    The library of user defined functions for making
#    test data models.
#
#==================================================


#-----------------------------------------------
# Make a 2-cols data.frame by applying isocodes 
# and year range to the sample() function
#-----------------------------------------------
makeDataModel1 <- function(isocode, years, size) {
  vCode <- sample(isocode, size, replace = TRUE)  # vector of iso code
  vYear <- sample(years, size, replace = TRUE)  # vector of year
  
  dfX <- data.frame(vCode, vYear)  # make the 2-column data.frame
  names(dfX) <- c("ISO", "Year")  # re-define the column names of data.frame
  
  return(dfX)
}


