#---------------------------------------------
#
# v0.27  ~ 2019-09-16 10:38
#          - List file by R function <list.files>
#
# v0.26  ~ 2019-08-01 20:10
#          - Merge multiple rows of a table
#
# v0.25  ~ 2019-07-30 20:12
#          - Use the 2nd data row if there are more than 2 rows of data in a table
#
# v0.23  ~ 2019-07-29 21:00
#          - make the source file name as a column appened to the end of data frame
#
# v0.22  ~ 2019-07-29 16:30
#          - make names unique by applying 'make.names()'
#
# v0.21  ~ 2019-07-29 12:07
#          - apply 'trimws()' to all extracted strings
#
# v0.2   ~ 2019-07-29
#
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


#--- Function: extract data from the html table  # v0.26
htmlExtractData <- function(input = NULL){
  output <- list()
  
  # extract data tables ...
  tbs <- htmlExtractTables(input)
  if (length(tbs) < 1){
    # stop("Failed to parse html file to extract tabel(s).")
    return (output)
  }

  # extract name/value rows ...
  tbdata <- list()
  for (i in 1:length(tbs)){
    tb <- tbs[[i]]
    rows <- htmlExtractRows(tb)
    rcnt <- length(rows)
    if (rcnt > 1) {  # Only collect table with more than 2 rows
      sect <- list()
      for (ii in 1:rcnt){
        cols <- htmlExtractCols(rows[[ii]])
        sect <- c(sect, list(cols))
      }
      tbdata <- c(tbdata, list(sect))
    }
  }
  if (length(tbdata) < 1) {
    # stop("Failed to extract valid rows from tables.")
    return (output)
  }

  # padding data rows ...
  maxrcnt <- 0
  for (i in 1:length(tbdata)){
    maxrcnt <- max(maxrcnt, length(tbdata[[i]]))
  }
  for (i in 1:length(tbdata)){
    rcnt <- length(tbdata[[i]])
    rlast <- tbdata[[i]][rcnt]
    pads <- maxrcnt - rcnt
    if (pads > 0){
      for (ii in 1:pads){
        tbdata[[i]] <- append(tbdata[[i]], rlast)
      }
    }
  }

  tbcnt <- length(tbdata)
  rowcnt <- length(tbdata[[1]])

  # align columns for each table ...
  for (i in 1:tbcnt){
    ccmin <- 100000
    for (ii in 1:rowcnt){
      ccmin <- min(ccmin, length(tbdata[[i]][[ii]]))
    }
    # cat("tb=",i,"ccmin=",ccmin,"\n")
    for (ii in 1:rowcnt){
      tbdata[[i]][[ii]] <- tbdata[[i]][[ii]][1:ccmin]     
    }
  }

  # Generate the output data ...
  for (i in 1:rowcnt){
    x <- list()
    for (ii in 1:tbcnt){
      x <- c(x, tbdata[[ii]][[i]])
    }
    output <- c(output, list(x))
  }

  return(output)
}


#--- Function: create a one row data from the html parsing output  #v0.26
makeDataFrameFromHTML <- function(input=NULL, names=NULL, source=NULL){
  data <- htmlExtractData(input)
  in.rowcnt <- length(data)
  if (in.rowcnt < 1){
    return(NULL)
  }

  in.name <- data[[1]]           # row#1 = names
  in.value <- data[2:in.rowcnt]  # row#2..n = values
  in.colcnt <- length(in.name)
  
  # Check length ...
  for (i in 2:in.rowcnt) {
    if (length(in.value[[i-1]]) != in.colcnt){
      return(NULL)
    }
  }
  
  # make names unique ...
  in.name <- make.names(in.name, unique = TRUE)
  defnames <- make.names(names, unique = TRUE)
  
  # Make an empty data frame to match structures of input data ...
  cells <- as.list(rep("", length=length(defnames)))
  df <- data.frame(cells, stringsAsFactors = FALSE)
  colnames(df) <- defnames
  df[1,ncol(df)] <- source
  if (in.rowcnt > 2){  # if there are more than 1 row of value
    dfx <- df
    for (i in 1:(in.rowcnt-2)){
      df <- rbind(df,dfx)
    }
  }
  

  # Compose the output data frame ...
  ixb <- in.name %in% defnames
  matchedName <- in.name[ixb]
  for (i in 1:length(defnames)){
    ix <- which(matchedName %in% defnames[[i]])
    # check integrity of index 'ix
    if (length(ix)>0){
      if (ix>0){
        for (ii in 1:(in.rowcnt-1)){
          matchedValue <- in.value[[ii]][ixb]
          df[ii,i] <- as.character(matchedValue[[ix]])
        }
      }
    }
  }
  
  # print (df)
  # stop("Terminated by user!")
  
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

# Configurations ---------------------------------
result.fn <- "result.csv"                   # save result data frame to this file

colNames.fn <- "colnames.txt"               # definitions of column name

htmlFiles.folder <- ".\\htmlfiles_test\\"   # the folder where html data files are stored


# Benchmark
tmStart <- proc.time()[3]


# Load predefined column names -----------------------------
colNames.list <- loadColNames(colNames.fn)
if (length(colNames.list) < 1){
  stop("Failed to load definitions of column name")
}
colNames.list <- append(colNames.list, "Remark.DataSource") # v0.23
colNames.count <- length(colNames.list)


# Load name list of the html data files ----------------------
htmlFiles.fileNames <- list.files(path = htmlFiles.folder, pattern = "*.html")   # v0.27
htmlFiles.count <- length(htmlFiles.fileNames)
if (htmlFiles.count < 1) {
  stop("<<<STOP>>> No html file to process!")
}


# Make data frame from the html files -------------------------
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
  
  df <- makeDataFrameFromHTML(htmltext, colNames.list, htmlFiles.fileNames[[i]])  # v0.23
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
