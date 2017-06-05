#==================================
# Split big file into small chunks
#==================================

linesPerChunk <- 500           # lines of each small chunk
fnIn <- "Test-mix.csv"      # file name of the source file
fnOutPrefix <- "OutPart-"     # prefix string used for making chunks' file name
fOutCount <- 1000                # counter for output chunk files
fOutCountMax <- 1050             # the maximum number allowed, quit when exceeded
firstLine <- NULL                # save the firstline/header in this vector
insertFirstLine <- TRUE         # switch to determine whether put header to every chunk file

# Open the source/input file:
fIn <- file(fnIn, "r")

# Loop to scan the input file and split it into numbers of small chunk file:
while (fOutCount < fOutCountMax) {
  # Read 'linesPerChunk' of lines from the source file 
  lns <- readLines(fIn, n=linesPerChunk)
  # Check the lines loaded, exit if no lines is available
  if (length(lns) == 0) {
    print(lns)
    print(length(lns))
    print("END oF FILE")
    break
  }

  # Make the file name for the output chunk file
  # The file name of output chunk = fnOutPrefix + fOutCount + ",csv"
  fOutCount <- fOutCount + 1
  fnOut <- paste(fnOutPrefix, fOutCount, ".CSV", sep="")
  # Open the output chunk file
  fOut <- file(fnOut, "w")
  # Check the switch to determine whether write header as the 1st line
  if (insertFirstLine && length(firstLine) > 0) {
    lns <- c(firstLine, lns)
  }
  # Write lines loaded from the source file
  writeLines(lns, fOut)
  close(fOut)
  
  # Initialize the 'firstLine' when it is not allocated
  if (length(firstLine) == 0) {
    firstLine <- lns[1]
  }
}

# Close the source/input file
close(fIn)

# Display the counter content for the last chunk file
print(fOutCount)


