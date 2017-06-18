# Define set of csv file names:
csvnames <- c("df-1.csv",
              "df-2.csv",
              "df-3.csv")
csvcnt <- length(csvnames) 

# Load csv into a list of data frame:
dflist <- list()
for (i in 1:csvcnt) {           
    fn <- csvnames[i]                     # get file name of csv file
    df <- read.csv(fn)                    # read csv into df
    dflist <- c(dflist, list(df))
}

# Merge list of data frame into one output:
df.out <- NULL
for (i in 1:length(dflist)) {
    df.out <- rbind(df.out, dflist[[i]])
}

df.out
