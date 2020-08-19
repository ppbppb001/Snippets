library("digest")


fnKey <- "mykey.rdata"
fnSettings <- "mysettings"

mySettings <- NULL



# Encryption function --------------------------------

# Write encrypted account info to file
writeAES <- function(dfInfo, fnInfo, key) {
  require("digest")
  zz <- textConnection("out", "w")
  write.csv(dfInfo, zz, row.names = F)
  close(zz)
  out <- paste(out, collapse = "\n")
  dat <- charToRaw(out)
  dat <- c(dat, as.raw(rep(0, 16 - length(dat)%%16)))  # len of raw = times of 16
  aes <- AES(key, mode = "ECB")
  aes$encrypt(dat)
  writeBin(aes$encrypt(dat), fnInfo)
}

# read encrypted data from file
readAES <- function(fnInfo, key) {
  require("digest")
  bin <- readBin(fnInfo, "raw", n=1000)
  aes <- AES(key, mode = "ECB")
  dat <- aes$decrypt(bin, raw=TRUE)
  txt <- rawToChar(dat[dat > 0])
  read.csv(text=txt, stringsAsFactors = F)
}

# Load key file
loadKey <- function(){
  mykey <- NULL
  load(file = fnKey)  # retrieve the 'mykey' from 'mykey.Rdata' file
  return(mykey)
}


# Load settings
loadSettings <- function(){
  df <- NULL
  xkey <- loadKey()
  if (!is.null(xkey)){
    df <- readAES(fnSettings, xkey)
    mySettings <<- df
  } else {
    df <- newSettings()
  }
  return (df)
}

# Save settings
saveSettings <- function() {
  res <- FALSE
  xkey <- loadKey()
  if (!is.null(xkey)){
    writeAES(mySettings, fnSettings, xkey)
    res <- TRUE
  }
  return(res)
}

# Create new settings data frame
newSettings <- function() {
  df <- data.frame(TDHost = "host", 
                   TDHostPort = "1234",
                   TDUser="user", 
                   TDPassword="password",
                   TDPassword2="password")
  mySettings <<- df
  return(df)
}

# Check settings
checkSettings <- function(){
  res <- list()
  
  # Check TDHost
  s1 <- trimws(mySettings[1,"TDHost"])
  # Length?
  if (nchar(s1) < 3){
    res <- c(res, "> Error: Invalid setting of Teradata host .")
  }

  # Check TDHostPort
  s1 <- trimws(mySettings[1,"TDHostPort"])
  n1 <- as.numeric(s1)
  if (is.na(n1)) {
    res <- c(res, "> Error: Teradata host port should be numeric.")
  } else if (n1<0 || n1>65535) {
    res <- c(res, "> Error: Invalid setting of Teradata host port .")
  }
  
    
  # Check TDUser
  s1 <- trimws(mySettings[1,"TDUser"])
  # length?
  if (nchar(s1) < 3){
    res <- c(res, "> Error: Invalid setting of Teradata user .")
  }

  # Check TDPassword
  s1 <- trimws(mySettings[1,"TDPassword"])
  s2 <- trimws(mySettings[1,"TDPassword2"])
  # Length?
  if (nchar(s1) < 8){
    res <- c(res, "> Error: Teradata password MUST NOT be less than 8 characters.")
  }
  # Identical?
  if (!identical(s1,s2)){
    res <- c(res, "> Error: Teradata password input DOST NOT match with each other .")
  }
  
  return(res)
}


# Set value of 'mySettings'
setSettingValue <- function(key, value){
  mySettings[1,key] <<- value
}
# Get value of 'mySettings'
getSettingValue <- function(field){
  return(mySettings[1,field])
}