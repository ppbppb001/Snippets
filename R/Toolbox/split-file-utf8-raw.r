#=====================================
# <split-file-utf8-raw.r>:
#  Split big file into small chunks
#  by readBin/writeBin functions 
#  (file encoed in UTF-8/ASCII)
#=====================================


# Define the input file:
fnIn <- "output-utf8.csv"      # file name of the source file
fInSize <- file.size(fnIn)     # get size of the input file
fIn <- file(fnIn, "rb")        # Open the input file in binary mode


# Define params for the output files:
linesPerFile <- 1000           # lines in each small output file
fnOutPrefix <- "OutPart-"      # prefix string used for making chunks' file name
fOutCount <- 1000              # counter for small output files
fOutCountMax <- 1010           # the maximum number allowed, quit when exceed
headerLine <- NULL             # save the header line in this vector
insertHeaderLine <- TRUE       # flag to determine whether put header to every chunk file


# Define the params for the input scanner:
chunkSize <- 1e7              # block size of reading = 10MB
# chunkSize <- 2e6            # block size of reading = 2MB
if (chunkSize > fInSize) {
    # chunkSize can not be larger than the size of input file
    chunkSize <- fInSize
}
EOL <- 0x0d                   # mark of End_OF_LINE
EOL.size <- 2                 # default size of EOL mark (utf8)


# Initialize varibles for the scanning
frleft <- fInSize             # bytes left to be processed
inpcnt <- 0                   # counter of input lines
outcnt <- 0                   # counter of output lines
in.raw <- raw()        # the buffer holding lines to be processed

# Benchmark: starting point
tmStart <- proc.time()


# Loop to scan the input file and split it into numbers of small chunk file:
while (fOutCount < fOutCountMax) {
    
    # Read a chunk of raw data from the input file
    in.buf <- readBin(fIn,
                      what = "raw",
                      n = chunkSize,
                      size = 1)  # read raw data into temporary buffer 'in.buf'
    in.raw <- c(in.raw, in.buf)  # append 'in.buf' to the end of 'in.raw'
    in.raw.len <- length(in.raw) 
    if (in.raw.len == 0) {
        break
    }
    
    # Generate the index of the end of line mark
    in.eol <- which(in.raw == EOL)   # in.eol = index of lines
    in.eol.len <- length(in.eol)
    if (in.eol.len == 0) {
        break   # End of scanning when ther is no complete line available
    }    
    
    
    # Split and output:
    fc <- trunc(in.eol.len / linesPerFile)
    # cat(in.eol.len, fc, "\n")
    if (fc > 0) {
        
        ix.eol <- linesPerFile
        ix.inraw <- 1
        ix.inraw.end <- 0
        
        while (ix.eol <= in.eol.len) {
            # cat("ix.raw=",ix.raw,", ix.eol=",ix.eol,"\n")
            
            ix.inraw.end <- in.eol[ix.eol] + EOL.size - 1
            out.raw <- in.raw[ix.inraw : ix.inraw.end]
            
            ix.inraw <- in.eol[ix.eol] + EOL.size
            ix.eol <- ix.eol + linesPerFile
            
            # Make the output file name:
            fOutCount <- fOutCount + 1
            fnOut <- paste(fnOutPrefix, fOutCount, ".CSV", sep="")
            fOut <- file(fnOut, "wb")
            
            # Check the switch to determine whether write header as the 1st line
            if (insertHeaderLine && length(headerLine) > 0) {
                out.raw <- c(headerLine, out.raw)
            }
            
            # Write lines loaded from the source file
            writeBin(out.raw, fOut)
            close(fOut)
            # cat("out.raw.len=",length(out.raw), ", foutcnt=", fOutCount,"\n")
            
            # Check and save the header line
            if (length(headerLine) == 0) {
                headerLine <- in.raw[1 : (in.eol[1]+EOL.size-1)]
            }
        }
        
        # Check and save the left unprocessed data in in.raw buffer:
        if (ix.inraw.end < in.raw.len) {
            # There are data unprocessed:
            in.raw <- in.raw[(ix.inraw.end+1) : in.raw.len]
            # cat(">>> in.raw left=",(in.raw.len-ix.inraw.end)," len(in.raw)=", length(in.raw),"\n")
        } else {
            # No data left unprocessed:
            in.raw <- raw()
            # cat(">>> in.raw left=",length(in.raw),"\n")
        }
        
    }
    
}

# Close the source/input file
close(fIn)


# Benchmark: save the time when job done
tmFinish <- proc.time()

# Display the statistics:
cat("# Count of output files = ", fOutCount, "\n")
cat("# Time consumed =", (tmFinish[3] - tmStart[3]), "(s)")




