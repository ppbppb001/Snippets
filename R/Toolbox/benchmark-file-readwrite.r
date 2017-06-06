#==========================================
# <benchmark-file-readwrite.r>:
#   Test performance of text file 
#   reading/writing
#==========================================


fn <- "test-rd-wr.txt"
maxLineNum <- 1e5    # 100k lines



# [ Writing Test ] ................
# Test file writing by making a file
tmStart <- proc.time()  # time when start

line.raw <- as.raw(sample(33:125, 1000, replace = TRUE))
line.utf8 <- iconv(list(line.raw), to="UTF-8")  # make a line as the test data

lineCount <- 0
fw <- file(fn,"w")
for (i in (1:maxLineNum)) {
    writeLines(line.utf8, fw)    
    lineCount <- lineCount + 1
}
close(fw)

tmFinish <- proc.time()  # time when finish
cat("### Line count =", lineCount)
cat("### Writing Test: Time consumed =", (tmFinish[3] - tmStart[3]), "(s)")



# [ Reading Test ] ................
# Test file reading
tmStart <- proc.time()  # time when start

linesPerRead <- 1000
lineCount <- 0
fr <- file(fn,"r")
while(lineCount < (maxLineNum+1e4)) {
    in.buf <- readLines(fr, n=linesPerRead)
    if (length(in.buf)==0) {
        break
    }
    lineCount <- lineCount + linesPerRead
}
close(fr)

tmFinish <- proc.time()  # time when finish
cat("### Line count =", lineCount)
cat("### Writing Test: Time consumed =", (tmFinish[3] - tmStart[3]), "(s)")


