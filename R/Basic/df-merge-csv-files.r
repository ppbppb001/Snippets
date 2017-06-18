
csvcnt <- 3                               # number of csv files

# Make list of csv file names
fnlist <- list()
for (i in 1:csvcnt) {            
    fn <- paste0("df-",i,".csv")          # generate file name by 'i': "df-1.csv","df-2.csv" ,,,
    fnlist <- c(fnlist, fn)
}

# Read csv files and merge into output data frame:
df.out <- NULL                            # initialize output data frame: df.out
for (i in 1:csvcnt) {           
    fn <- fnlist[[i]]                     # get file name of csv file
    df <- read.csv(fn)                    # read csv into df
    df.out <- rbind(df.out, dflist[[i]])  # bind df with df.out
}


df.out                                    # print df.out             

