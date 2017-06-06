#------------------------------------------------
# Convert format of CSV file from utf8/utf16 mixed
# format to UTF-8
#
# Version-2
#------------------------------------------------

# Input file:
fnr <- "Test-mix-big.csv"     # Name of the input file
fr <- file(fnr, "rb")         # define file object (format=Unicode/UTF-16)
frsize <- file.size(fnr)      # get size of the input file
# frsize <- 1e7               # for TESTing only! 
# limit file size to a given number for a test run

# Output file:
fnw <- "Output-UTF8-v2.csv"   # name of output file
fw <- file(fnw, "w")          # define file object

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

# Benchmark: starting point
tmStart <- proc.time()

# Start the scanning loop: ..............
while (frleft > 0) {
    
    # Read a chunk of raw data from the input file
    in.buf <- readBin(fr,
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
            isUnicode <- TRUE           # is Unicode
            if (in.raw[in.eol[i]+2] == 0x0a) {
                if (in.raw[in.eol[i]+3] == 0x00) {
                    EOL.size <- 4       # 4 bytes EOL: 0x0d,0x00,0x0a,0xaa
                } else {
                    EOL.size <- 3       # 3 bytes EOL: 0x0d,0x00,0x0a
                }
            } else {
                EOL.size <- 2
            }
        } else { 
            isUnicode <- FALSE      # not unicode
            if (in.raw[in.eol[i]+1] == 0x0a){
                EOL.size <- 2       # 2 bytes EOL: 0x0d,0x0a
            } else {
                EOL.size <- 1       # 1 bytes EOL: 0x0d
            }
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
            s.raw <- as.raw(bitwAnd(as.numeric(s.raw), 0x7f)) # Mask bit-7
            s.str <- iconv(list(s.raw), to="UTF-8")           # convert raw to UTF-8
        }
        
        # Write the result to the output file
        if ((length(s.str) > 0) && (!is.na(s.str))) {  # check result of conversion
            writeLines(s.str, fw)        # write the utf-8 string to output file
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
close(fr)  # close input file
close(fw)  # close output file

# Benchmark: save the time when job done
tmFinish <- proc.time()


# Display the statistics:
cat("# Count of input lines = ", inpcnt, "\n")
cat("# Count of output lines = ", outcnt, "\n")
cat("# Count of dropped lines = ", inpcnt - outcnt, "\n")
cat("# Time consumed =", (tmFinish[3] - tmStart[3]), "(s)")

