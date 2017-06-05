#------------------------------------------------
# Convert format of CSV file from utf8/utf16 mixed
# format to UTF-8
#------------------------------------------------

# Input file:
fnrx <- "Test-Unicode-2gb.csv"   # Name of the file encoded in unicode format
# fnrx <- "Test-mix.csv"        # Name of the file encoded in mixed format
frx <- file(fnrx, "rb")       # define file object (format=Unicode/UTF-16)
frsize <- file.size(fnrx)     # get size of the input file
# frsize <- 1e7               # for TESTing only! limit file size to a given number

# Output file:
fnwx <- "Output-UTF8.csv"     # name of output file
fwx <- file(fnwx, "w")        # define file object

# Define key const:
chunksize <- 5e8              # block size of reading = 500MB
# chunksize <- 2e6            # block size of reading = 2MB
if (chunksize > frsize) {
    # chunksize can not be larger than the size of input file
    chunksize <- frsize
}
EOL <- 0x0d                   # mark of End_OF_LINE
EOL.size <- 2                 # default size of EOL mark (utf8)
BOM <- as.raw(c(0xff, 0xfe))  # mark of Unicode/UTF-16
isUnicode <- FALSE

# Initialize varibles for the scanning
frleft <- frsize        # bytes left to be processed
inpcnt <- 0             # counter of input lines
outcnt <- 0             # counter of output lines
in.raw <- as.raw(NULL)  # the buffer holding lines to be processed

# Start the scanning loop: ..............
while (frleft > 0) {
    
    # Read a chunk of raw data from the input file
    in.buf <- readBin(frx,
                      what = "raw",
                      n = chunksize,
                      size = 1)  # read raw data into temporary buffer 'in.buf'
    in.raw <- c(in.raw, in.buf)  # append 'in.buf' to the end of 'in.raw'
    
    # Generate the index of the end of line mark
    in.eol <- which(in.raw == EOL)   # in.eol = index of lines
    if (length(in.eol) == 0) {
        break   # End of scanning when ther is no complete line available
    }
    
    # Initialize running varibles:
    in.ptr <- 1    # pointer of the to-be-processed data in 'in.raw'
    
    
    # Loop through the 'in.raw' by the indices stored in 'in.eol' .........
    for (i in seq(length(in.eol))) {
        inpcnt <- inpcnt + 1     # Increase the input line counter
        
        # Check EOL bytes to see if it is unicode
        if (in.raw[in.eol[i]+1] == 0x00) {
            isUnicode <- TRUE
            EOL.size <- 4       # size of EOL of unicode is 4 bytes
        } else {
            isUnicode <- FALSE
            EOL.size <- 2       # size of EOL of utf8 is 2 bytes
        }
        
        # Fetch a line from 'in.raw'
        s.raw <- in.raw[in.ptr : (in.eol[i] - 1)]  # s.saw = one line
        in.ptr <- in.eol[i] + EOL.size             # move pointer to the next line
        
        # Doing the conversion
        if (isUnicode) {
            # A line in Unicode:
            if (!all(s.raw[1:2] == BOM)) {    # Check presenting of the unicode prefix
                s.raw <- c(BOM, s.raw)        # add unicode prefix if not presented
            }
            s.str <- iconv(list(s.raw),
                           from = "UTF-16",
                           to = "UTF-8")      # convert unicode/utf-16 to utf-8 general string
        } else {
            # Not a line in Unicode:
            s.str <- iconv(list(s.raw))       # convert raw to string without coding translation
        }
        
        # Write the result to the output file
        if ((length(s.str) > 0) && (!is.na(s.str))) {  # check result of conversion
            writeLines(s.str, fwx)        # write the utf-8 string to output file
            outcnt <- outcnt + 1
        }
    }
    
    # Collecting unprocessed data:
    # Use the left unprocessed bytes as the head of 'in.raw',
    # these bytes will be joint and processed with the next chunk 
    ix <- in.eol[length(in.eol)] + EOL.size  # ix = location/index of the 1st unprocessed byte
    lx <- length(in.buf)                     # lx = lenght of the loaded chunk
    if (ix <= lx) {               # any bytes left unprocessed?
        in.raw <- in.buf[ix:lx]   # 'YES' => in.raw' = left unprocessed bytes
    } else {
        in.raw <- as.raw(NULL)    # 'NO' => in.raw' = empty
    }
        
    # check how many bytes left to be processed
    frleft <- frleft - chunksize
    # Check chunksize with 'frleft', truncate it if necessary
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


