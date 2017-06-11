#==================================================
#
#  <weo-test.R>: 
#    The test bed for general purpose.
#
#==================================================

source("weo-lib-lookup.r") # load function module


fname <- "WEOApr2017all.csv"  # define the name of the csv file

# load csv and dfWEOSimple
dfWEOSimple <- createWEOSimple(fname) 

# create the lookup table from dfWEOSimple
lstGDPPCLookup <- createGDPPCLookupTable(dfWEOSimple) 


# -----------------------------------------------------
# Exmaple-1: Get ISO country codes:
# -----------------------------------------------------
ixISO <- getColumnIndex(lstGDPPCLookup, "ISO") # col index of "ISO"
vISO <- unlist(lstGDPPCLookup[ixISO])         # vectors in which ISO contry code is contained
print(vISO)


# -----------------------------------------------------
# Exmaple-2: GPD per captia of AUS in 1999:
# -----------------------------------------------------
ix1999 <- getColumnIndex(lstGDPPCLookup, "X1999") # col index of "X1999"
v1999 <- unlist(lstGDPPCLookup[ix1999])          # vectors of GDP per captia in 1999
ixAUS <- getCountryIndex(lstGDPPCLookup, "AUS")   # cell index of AUS in vector 'v1999'
vGDPPCAus <- v1999[ixAUS]                        # GDP per captia of AUS in 1999
print (vGDPPCAus)


# -----------------------------------------------------
# Exmaple-3: min/max/mean GDP per captia in 1999:
# -----------------------------------------------------
min1999 <- min(v1999, na.rm = TRUE)
print (min1999)
max1999 <- max(v1999, na.rm = TRUE)
print (max1999)
mean1999 <- mean(v1999, na.rm = TRUE)
print (mean1999)


# -----------------------------------------------------
# Exmaple-4: retrive GDP per captia in 2002 by
#            using function 'lookByYear':
# -----------------------------------------------------
v2000 <- lookByYear(lstGDPPCLookup, 2002)
print(v2000)


# -----------------------------------------------------
# Exmaple-5: retrive GDP per captia of Australia in 2002
#            by using function 'lookByYearCountry':
# -----------------------------------------------------
vAUS2000 <- lookByYearCountry(lstGDPPCLookup, 2002, "AUS")
print(vAUS2000)


# -----------------------------------------------------
# Exmaple-6: retrive ISO country code by using 
#            function 'lookByColumnName':
# -----------------------------------------------------
vISO <- lookByColumnName(lstGDPPCLookup, "ISO")
print(vISO)

