#------------------------------------------------
# Convert format of TXT file from UTF-16/Unicode
# to UTF-8
#------------------------------------------------

# Input file:
# fnrx <- "Test-Unicode-2gb.csv"   # Name of the file encoded in unicode format
fnrx <- "Test-mix.csv"   # Name of the file encoded in unicode format
frx <- file(fnrx, "rb", encoding = "UTF-16")   # define file object (format=Unicode/UTF-16)
frsize <- file.size(fnrx)        # get size of the input file
# frsize <- 1e7                  # for TESTing only! limit file size to a given number

# Output file:
fnwx <- "Output-UTF8.csv"     # name of output file
fwx <- file(fnwx, "w")        # define file object

# Define key const:
EOL <- 0x0d                   # mark of End_OF_LINE
BOM <- as.raw(c(0xff, 0xfe))  # mark of Unicode/UTF-16
chunksize <- 5e8              # block size of reading = 500MB
if (chunksize > frsize){      # chunksize not large than the size of input file
    chunksize <- frsize       
}

# Scan the input file:
frleft <- frsize    # bytes left to be processed
inpcnt <- 0         # counter of input lines
outcnt <- 0         # counter of output lines 
while (frleft > 0) {

    # Read raw data from the input file
    in.raw <- readBin(frx,
                      what = "raw",
                      n = chunksize,
                      size = 1)
    
    # Generate the index of the end of line mark
    in.eol <- which(in.raw == EOL)   # in.eol = index of lines
    if (length(in.eol) == 0) {
        break
    }
    
    # Initialize running varibles:
    in.ptr <- 1    # pointer of the to-be-processed data in 'in.raw'
    
    # Loop through the 'in.raw' by indices stored in 'in.eol'
    for (i in seq(length(in.eol))) {
        inpcnt <- inpcnt + 1     # Increase the input line counter
        
        s.raw <- in.raw[in.ptr : (in.eol[i] - 1)]  # s.saw = one line
        in.ptr <- in.eol[i] + 4     # move pointer to the next line
        
        if (!all(s.raw[1:2] == BOM)) {    # Check presenting of the unicode prefix
            s.raw <- c(BOM, s.raw)        # add unicode prefix if not presented
        }
        s.str <- iconv(list(s.raw),
                       from = "UTF-16",
                       to = "UTF-8")      # convert unicode/utf-16 to utf-8 general string
        
        if ((length(s.str) > 0) && (!is.na(s.str))) {  # check result of conversion
            writeLines(s.str, fwx)        # write the utf-8 string to output file
            outcnt <- outcnt + 1
        }
    }
    
    # check how many bytes left to be processed
    frleft <- frleft - chunksize
    if (frleft > 0 && frleft < chunksize) {
        chunksize <- frleft
    } 
        
}
# Close the opened files:
close(frx)  # close input file
close(fwx)  # close output file



# Display the statistics:
cat("# Count of input lines = ", inpcnt, "\n")
cat("# Count of output lines = ", outcnt, "\n")
cat("# Count of dropped lines = ", inpcnt - outcnt, "\n")


