library("RJDBC")
library("rJava")
library("DBI")


# Global varibles:
DEBUG_TERADATA <- FALSE


# Teradata connection, database and tables:
tdConn <- NULL
tdDatabase <- list("bear", 
                   "cat")
tdTables <- list("economics",
                 "iris2",
                 "mpg2",
                 "timeseries",
                 "txhousing3")


# Define the driver
drv <- JDBC("com.teradata.jdbc.TeraDriver", 
            "terajdbc/terajdbc4.jar;terajdbc/tdgssconfig.jar")


if (DEBUG_TERADATA){
  #--- [Optional codes]: Check the path of java classes ---
  jclass <- .jclassPath()
  cat ("> jclass path:\n")
  print (jclass)
  # Console output:
  # [1] "C:\\ProgTools\\R\\R-3.5.3\\library\\rJava\\java"           
  # [2] "c:\\progtools\\R\\terajdbc\\terajdbc4.jar"                 
  # [3] "c:\\progtools\\R\\terajdbc\\tdgssconfig.jar"               
  # [4] "C:\\ProgTools\\R\\R-3.5.3\\library\\RJDBC\\java\\RJDBC.jar"
  
  #--- [Optional codes]: Test existing of the java files ---
  cat ("> check jclass path:\n")
  for (path in jclass) {
    cat ("path =<", path, "> is ")
    cat (file.exists(path), "\n")
  }
  # Console output:
  # [1] "C:\\ProgTools\\R\\R-3.5.3\\library\\rJava\\java"
  # [1] TRUE
  # [1] "c:\\progtools\\R\\terajdbc\\terajdbc4.jar"
  # [1] TRUE
  # [1] "c:\\progtools\\R\\terajdbc\\tdgssconfig.jar"
  # [1] TRUE
  # [1] "C:\\ProgTools\\R\\R-3.5.3\\library\\RJDBC\\java\\RJDBC.jar"
  # [1] TRUE
}


# --- [ Logon to database server ] ---
dbLogon <- function(host, user, pwd, database) {
  if (DEBUG_TERADATA) {
    cat("\n<dbLogon>:\n")
    cat(" host =",host,"\n")
    cat(" user =",user,"\n")
    cat(" pwd = ",pwd,"\n")
    cat(" database =",database,"\n")
  }
    
  cmds <- sprintf("jdbc:teradata://%s/database=%s",
                  trimws(host),
                  trimws(database))
  if (DEBUG_TERADATA){
    cat(" cmdstring = ",cmds,"\n")
  }
  try(  
    tdConn <<- dbConnect(drv, cmds, trimws(user), trimws(pwd))
  )
  if (DEBUG_TERADATA) {
    cat(" tdConn =", class(tdConn),!is.null(tdConn),"\n")
  }
    
  return (!is.null(tdConn))
}


# --- [ Logout from database server ] ---
dbLogout <- function () {
  if (!is.null(tdConn)){
    try(
      dbDisconnect(tdConn)
    )
    tdConn <<- NULL
    return(TRUE)
  } else {
    return (FALSE)
  }
}


# --- [ List tables ] ---
dbListTables <- function() {
  res <- NULL
  res <- dbListTables(tdConn)
  return(res)
}

