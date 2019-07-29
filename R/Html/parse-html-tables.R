#---------------------------------------------
# V0.22  ~ 2019-07-29 16:30
# V0.21  ~ 2019-07-29 12:07
# v0.2   ~ 2019-07-29
#---------------------------------------------



# ***********************************************
#
#  Functions
#
# ***********************************************

# ---Function: Load the predefined column names from file
loadColNames <- function(filename = NULL){
  fn <- filename
  fr <- file(fn, "r")
  
  output <- list()
  len <- 1
  while (len > 0) {
    ln <- readLines(fr, n=1)
    len <- length(ln)
    if (len > 0){
      if (nchar(ln)>0){
        ln <- trimws(ln)  # V0.22
        p <- regexpr("#", ln, ignore.case = TRUE)
        if (p[[1]][1] != 1) {
          output <- c(output, ln)
        }
      }
    }
  }
  
  close(fr)
  return(output)
}


# ---Function: Load the file which hold the list of data files in html format:
loadHtmlFileNames <- function (filename=NULL){
  output <- list()  
  print(filename)
  
  # fr <- file(filename,"r",encoding = "UTF-16")
  # fr <- file(filename,"r",encoding = "UTF-8")
  fr <- file(filename,"r")
  lns <- readLines(fr,n=1000000)
  close(fr)
  
  lns <- trimws(lns)
  count <- length(lns)
  for (i in 1:count){
    n <- grep("\\.HTML", lns[i], ignore.case = TRUE)
    if (length(n)>0){
      s <- strsplit(lns[i], " ")
      l = length(s[[1]])
      ss <- s[[1]][l]
      ss <- trimws(ss)  # V0.22
      output <- c(output, ss)
    }
  }
  return (output)
}


# ---Function: extract text body between the tag pair
htmlExtractTaggedText <- function(input = NULL,
                               tag1 = NULL,
                               tag2 = NULL) {
  output <- list()
  
  p1 <- gregexpr(pattern = tag1, input)
  if (p1[[1]][1] < 1){
    return (output)
  }
  p2 <- gregexpr(pattern = tag2, input)
  if (p2[[1]][1] < 1){
    return(output)
  }
  
  count <- length(p1[[1]])
  for (i in 1:count) {
    ix1 <- p1[[1]][i]
    ix2 <- p2[[1]][i]
    s <- substr(input, ix1, ix2-1)
    s <- trimws(s)  # V0.22
    x1 <- gregexpr(pattern = ">", s)
    if (x1[[1]][1] > 0){
      s <- substr(s, x1[[1]][1]+1, nchar(s))
      s <- trimws(s)  # V0.22
      output <- c(output, list(s))
    }
  }
  
  return(output)
}


# ---Function: extract tables from html text data
htmlExtractTables <- function(input = NULL) {
  tag1 <- "<table"
  tag2 <- "</table>"
  output <- htmlExtractTaggedText(input, tag1, tag2)
  return(output)
}


# ---Function: extract rows from the table part
htmlExtractRows <- function(input = NULL) {
  tag1 <- "<tr"
  tag2 <- "</tr>"
  output <- htmlExtractTaggedText(input, tag1, tag2)
  return(output)
}


#---Function: extract columns from the row part
htmlExtractCols <- function(input = NULL) {
  tag1 <- "<td"
  tag2 <- "</td>"
  
  output <- htmlExtractTaggedText(input, tag1, tag2)
  if (length(output) < 1){
    tag1 <- "<th"
    tag2 <- "</th>"
    output <- htmlExtractTaggedText(input, tag1, tag2)
    
    if (DEBUG) { print ('Using TH') }  # DEBUG_PRINT # V0.22
  } 
  if (DEBUG) {  print (output) }       # DEBUG_PRINT # V0.22
  
  return(output)
}


#--- Function: extract data from the html table
htmlExtractData <- function(input = NULL){
  output <- list()
  
  tbs <- htmlExtractTables(input)
  if (length(tbs) < 1){
    # stop("Failed to parse html file to extract tabel(s).")
    return (output)
  }

  for (i in 1:length(tbs)){
    tb <- tbs[[i]]
    rows <- htmlExtractRows(tb)
    
    # Process the table which have more than 2 rows
    if (length(rows) > 1){  
      cols1 <- htmlExtractCols(rows[[1]])
      cols2 <- htmlExtractCols(rows[[2]])
      # V0.22: align the list of names and list of values
      lc1 <- length(cols1)
      lc2 <- length(cols2)
      if (lc1>0 && lc2>0) {
        lc3 <- min(lc1,lc2)
        output$name <- c(output$name, cols1[1:lc3])
        output$value <- c(output$value, cols2[1:lc3])
      }
      # V0.22 ---
    }
  }
  return(output)
}


#--- Function: create a one row data from the html parsing output
makeDataFrameFromHTML <- function(input=NULL, names=NULL){
  data <- htmlExtractData(input)
  # V0.22 ---
  if (length(data) < 1){
    return(NULL)
  }
  # V0.22 --
  
  in.name <- data$name
  in.value <- data$value
  # V0.22 ---
  # Check length
  d1 <- length(in.name)
  d2 <- length(in.value)
  if (d1<1 || d2<1 || d1!=d2 ){
    return(NULL)
  }
  # make names unique
  in.name <- make.names(in.name, unique = TRUE)
  # V0.22 ---
  
  # Make an empty data frame from 'colNames'
  cells <- rep("", length=length(names))
  df <- data.frame(as.list(cells), stringsAsFactors = FALSE)
  # colnames(df) <- make.names(names)
  names <- make.names(names, unique = TRUE)  # make names unique # V0.22 
  colnames(df) <- names
  
  ixb <- in.name %in% names
  matchedName <- in.name[ixb]
  matchedValue <- in.value[ixb]
  
  for (i in 1:length(names)){
    ix <- which(matchedName %in% names[[i]])
    # V0.2: check integrity of index 'ix
    if (length(ix)>0){
      if (ix>0){
        df[1,i] <- as.character(matchedValue[[ix]])
      }
    }
    # V0.2: ---
  }
  
  return(df)
}







# ***********************************************
#
#  <<< Main entry of the code >>>
#
#  Retrieve data from the html tables
#
# ***********************************************

DEBUG <- FALSE

# Configurations:
result.fn <- "result.csv"                   # save result data frame to this file

colNames.fn <- "colnames.txt"               # definitions of column name

htmlFiles.folder <- ".\\htmlfiles_test\\"   # the folder where html data files are stored

htmlFiles.fn <- "htmlfiles.txt"             # name list of the html data files
#
# *** How to generate name list of the html files ***
#
# [Approach-1]:
#    - Open Powershell console
#    - Enter the folder where the html data files are stored
#    - type command as following: 
#        dir *.html | out-file -encoding ASCII htmlfiles.txt
#
# [Approach-2]:
#    - Open Powershell console
#    - Enter the folder where the html data files are stored
#    - Copy the 'list.bat' batch file from the 'htmlfiles_test' folder
#    - Run 'list.bat' batch file by typing command as following:
#        .\list.bat
#


# Benchmark
tmStart <- proc.time()[3]


# Load predefined column names 
colNames.list <- loadColNames(colNames.fn)
if (length(colNames.list) < 1){
  stop("Failed to load definitions of column name")
}
colNames.count <- length(colNames.list)


# Load name list of the html data files
htmlFiles.fileNames <- loadHtmlFileNames(paste(htmlFiles.folder, htmlFiles.fn, sep=""))
htmlFiles.count <- length(htmlFiles.fileNames)
if (htmlFiles.count < 1) {
  stop("<<<STOP>>> No html file to process!")
}


# Make data frame from the html files
failed.fn <- list()   # V0.22
result.df <- NULL
filecount <- 0        # V0.22

for (i in 1:length(htmlFiles.fileNames)){
  fn <- paste(htmlFiles.folder, htmlFiles.fileNames[[i]], sep = "")
  fr<-file(fn,"rb")
  htmltext <- rawToChar(readBin(fr,what="raw",n=1000000,1))
  close(fr)
  cat("\n\n>>> Scan html file (",i,") <" , fn, "> ... ... \n")   # DEBUG_PRINT  # V0.22
  filecount <- filecount + 1    # V0.22
  
  df <- makeDataFrameFromHTML(htmltext, colNames.list)
  if (!is.null(df)){  # V0.22
    if (is.null(result.df)){
      result.df <- df
    } else {
      result.df <- rbind(result.df, df)
    }
    print (">>> Result = OK!")      # DEBUG_PRINT  # V0.22
  } else {  # V0.22
    print (">>> Result = Failed!")  # DEBUG_PRINT  # V0.22
    failed.fn <- c(failed.fn, fn)
  }
}

# Check the result
if (is.null(result.df) || nrow(result.df) < 1){
  Stop("<<<STOP>>> Nothing retrieved! STOP!!!")
}


# Save data frame to file:
write.csv(result.df, file = result.fn, row.names = FALSE)


# Benchmark
tmFinish <- proc.time()[3]
cat(">>> Time consumed =", (tmFinish - tmStart), "(s)\n")
cat(">>> Total", filecount, "(files) processed.\n")    # V0.22

# Display failed files:  # V0.22
d <- length(failed.fn)
cat(">>> Total", d, "(files) failed.\n")
if (d >0){
  print(">>> Failed files: ")
  print(failed.fn)
}
capture.output(failed.fn, file = "FailedFiles.txt")  # save list of failed files to a file


# CHECK by reading back
dfcheck <- read.csv(result.fn, header = TRUE, stringsAsFactors = FALSE)
