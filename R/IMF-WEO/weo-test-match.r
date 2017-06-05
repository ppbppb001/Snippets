#==================================================
#
#  <weo-test-match.R>:
#    The test bed of making new table by matching country and year
#
#  * Load 'WEOApr2017All.csv' and make a data.frame
#    'dfWEOSimple' with the irrelevant items removed.
#  * Make a lookup table 'lstGDPPCLookup' which contains
#    GDP per captia data set.
#  * Make a test data.frame 'dfInput' by sample() function, which
#    is composed with 2 cols of data: ISO(country) and Year.
#  * Apply the user-defined functions to the data.frame 'dfInput'
#    to generate GDP output by checking ISO/Year of each row in
#    the lookup table 'lstGDPPCLookup'.
#  * Append the GDP output to 'dfMake' to generate a new data.frame
#    'dfOutput' as the final result
#  * The appended GDP data has 5 columns:
#       col-3: GDP (GDP in USD of the given country in the given year)
#       col-4: GDP.Min (Minimum GDP of all countries in the given year)
#       col-5: GDP.Max (Maximum GDP of all countries in the given year)
#       col-6: GDP.Meam (Mean GDP of all countries in the given year)
#       col-7: GDP.Median (Median GDP of all countries in the given year)
#
#==================================================


#--------------------------------------
# Import function modules
#--------------------------------------
source("weo-lib-lookup.r")      # functions applied to lookup table
source("weo-lib-makedata.r")   # functions to generate data for testing

# Benchmark: save the time when starting for benchmarking
tmStart <- proc.time()


#--------------------------------------
# Load data file and make lookup table
#--------------------------------------
# define the name of the csv file
fname <- "WEOApr2017all.csv"

# load csv and dfWEOSimple
dfWEOSimple <- createWEOSimple(fname)

# create the lookup table from dfWEOSimple
lstGDPPCLookup <- createGDPPCLookupTable(dfWEOSimple)

# Benchmark: save time when loading completed
tmLoad <- proc.time()


#------------------------------------------------
# Test-1:
# Create data.frame by matching GDP/year/Country
# to a generated test data model
# -----------------------------------------------
# Make a data model for testing: dfTest
lenTest <- 100000
years <- 1990:2010
isocodes <- lookByColumnName(lstGDPPCLookup, "ISO")
dfInput <- makeDataModel1(isocodes, years, lenTest)
print(head(dfInput))
print(tail(dfInput))


# Get vector of GDP by matching country/year in lookup tabel with 'dfTest'
# Define a function for country/year matching to use with 'apply':
fMatchGDP <- function(input) {   # 'input' = row of the data.frame to 
                                 # which this function will be applied
  country <- input[1]     # 'input[1]' = col-1(country) of the input row 
  year <- input[2]        # 'input[2]' = col-2(year) of the input row
  gdp <- lookByYearCountry(lstGDPPCLookup, year, country)
  return(gdp)
}
vGDP <- apply(dfInput, 1, fMatchGDP)  # class(vGDP)='numeric' (vector)

# Define a function for annual GDP params matching to use with 'apply':
# Annual GDP params: [1]=min, [2]=max, [3]=mean, [4]=median
fMatchGDPParam <- function(input) {
  year <- input[2]
  gdpyear <- lookByYear(lstGDPPCLookup, year)
  len <- length(gdpyear)
  vmin <- gdpyear[len - 3]
  vmax <- gdpyear[len - 2]
  vmean <- gdpyear[len - 1]
  vmedian <- gdpyear[len]
  v <- c(vmin, vmax, vmean, vmedian)
  return(v)
}
vGDPParam <- apply(dfInput, 1, fMatchGDPParam) # class(vGDPParam)='matrix'


# Append a new column named as "GDP" to the 'dfTest'
dfOutput <- data.frame(dfInput,
                       vGDP,
                       vGDPParam[1,],
                       vGDPParam[2,],
                       vGDPParam[3,],
                       vGDPParam[4,])
# name the appended columns
names(dfOutput)[3:7] <- c("GDP",
                          "GDP.Min",
                          "GDP.Max",
                          "GDP.Mean",
                          "GDP.Median")

# Benchmark: save the time when the job finished
tmFinish <- proc.time()

# Display the final result:
print(head(dfOutput))
print(tail(dfOutput))

# Benchmark: the summary
cat("Benchmark: size =", lenTest, "(rows)")
cat("Benchmark: loading =", (tmLoad[3] - tmStart[3]), "(s)")
cat("Benchmark: making =", (tmFinish[3] - tmLoad[3]), "(s)")
cat("Benchmark: total =", (tmFinish[3] - tmStart[3]), "(s)")

