#===========================================
# <mask-ctrlz.r>:
#  Replace Ctrl-Z/EOF char with SPACE char
#===========================================


# Define input file:
fnIn <- "bad-ctrlz.csv"             # input file
fInSize <- file.info(fnIn)$size     # size of input file
# fInSize <- file.size(fnIn)
fIn <- file(fnIn, "rb")  

# Define output file:
fnOut <- "output.csv"               # name of processed file
fOut <- file(fnOut, "wb")

# Define target and replacement
target <- 0x1a                # target = Ctrl-Z = 0x1a
replacement <- 0x20           # replacement = Space = 0x20

# Define params for input scanning:
chunkSize <- 1e6              # block size = 1MB
if (chunkSize > fInSize) {
    # chunkSize should not be larger than input file size
    chunkSize <- fInSize
}

# Initialize varibles for scanning
frleft <- fInSize      # bytes to be processed
cnt.chunk <- 0         # chunks counter
cnt.ctrlz <- 0         # ctrl-z counter
in.raw <- raw()        # buffer of lines to be processed

# Benchmark: starting point
tmStart <- proc.time()

while (frleft > 0) {
    # Read a chunk of raw data from input file
    in.raw <- readBin(fIn,
                      what = "raw",
                      n = chunkSize,
                      size = 1)  # read raw data into temporary buffer 'in.buf'
    in.raw.len <- length(in.raw) 
    if (in.raw.len == 0) {
        break
    } 
    
    # Locate Ctrl-Z and replace it
    ctrlz.locs <- which(in.raw == target)
    ctrlz.cnt <- length(ctrlz.locs)
    if (ctrlz.cnt> 0) {
        for (i in 1:ctrlz.cnt) {
            ix <- ctrlz.locs[i]
            in.raw[ix] <- as.raw(replacement)
        }
        cnt.ctrlz <- cnt.ctrlz + ctrlz.cnt
    }
    
    # Write back 
    writeBin(in.raw, fOut)
        
    cnt.chunk <- cnt.chunk + 1
    frleft <- frleft - chunkSize
}

close(fIn)
close(fOut)


# Benchmark: save the time when job done
tmFinish <- proc.time()

# Display the statistics:
cat("# Size of input file = ", fInSize, "\n")
cat("# Count of processed chunks = ", cnt.chunk, "\n")
cat("# Count of ctrl-z found and masked = ", cnt.ctrlz, "\n")
cat("# Time consumed =", (tmFinish[3] - tmStart[3]), "(s)")
