#   v0.2 - 2019-08-22 19:59
#
#
#
#

library("RJDBC")
library("rJava")
library("DBI")

DEBUG_JCLASS <- TRUE
DEBUG_SQL <- TRUE

# Define the driver
drv <- JDBC("com.teradata.jdbc.TeraDriver", 
            "c:\\progtools\\Teradata\\terajdbc\\terajdbc4.jar;c:\\progtools\\Teradata\\terajdbc\\tdgssconfig.jar")


#--- [Optional codes]: Check the path of java classes ---
if (DEBUG_JCLASS) {
  jclass <- .jclassPath()
  # print (jclass)
  # Console output:
  # [1] "C:\\ProgTools\\R\\R-3.5.3\\library\\rJava\\java"           
  # [2] "c:\\progtools\\R\\terajdbc\\terajdbc4.jar"                 
  # [3] "c:\\progtools\\R\\terajdbc\\tdgssconfig.jar"               
  # [4] "C:\\ProgTools\\R\\R-3.5.3\\library\\RJDBC\\java\\RJDBC.jar"
  
  for (path in jclass) {
    cat ("jclass path <",path, "> = ", file.exists(path), "\n")
  }
}


# --- Connect with teradata ---
tdlogin <- "bear"
tdpwd <- "teradata"
conn <- dbConnect(drv, "jdbc:teradata://192.168.1.249/database=bear", 
                  tdlogin, tdpwd)

# Test-1: read whole table
# df1 <- dbReadTable(conn,"timeseries")
# head(df1)

# Test-2: read whole table by sending SQL query
# qs <- "select * 
#        from bear.timeseries as bts;"
# rs <- dbSendQuery(conn, qs)
# df2<-dbFetch(rs)
# dbClearResult(rs)

# SQL query with sliding datetime window:
dt1 <- strptime("2019-08-18 14:08:00","%Y-%m-%d %H:%M:%S")   # end
dt2 <- dt1 - 8*3600      # minus 8 hours

for (i in 1:10) {
  
  # Query: dt2 <= DateTime < dt1 -------------------------
  
  # [Method-1]: TYPE_DATE/TYPE_TIME -> TIMESTAMP
  # qs <- sprintf("select *
  #                from bear.timeseries as bts
  #                where 
  #                (cast(bts.datex as timestamp(0)) + ((bts.timex - TIME '00:00:00' HOUR to SECOND)) >= 
  #                cast('%s' as timestamp(0) format 'YYYY-MM-DDBHH:MI:SS'))
  #                and
  #                (cast(bts.datex as timestamp(0)) + ((bts.timex - TIME '00:00:00' HOUR to SECOND)) < 
  #                cast('%s' as timestamp(0) format 'YYYY-MM-DDBHH:MI:SS'));",
  #               as.character(dt2), as.character(dt1))
  
  # [Method-2]: TYPE_DATE/TYPE_TIME -> STRING -> TIMESTAMP (using 'concat')
#   qs <- sprintf(
# "select * from bear.timeseries as bts
# where 
# to_timestamp(concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') >= 
# to_timestamp('%s', 'YYYY-MM-DD HH24:MI:SS')
# and
# to_timestamp(concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') < 
# to_timestamp('%s', 'YYYY-MM-DD HH24:MI:SS');",
#                 as.character(dt2), as.character(dt1))
  
  # [Method-3]: TYPE_DATE/TYPE_TIME -> STRING -> TIMESTAMP (using operator '||')
  qs <- sprintf(
    "select * from bear.timeseries as bts
where 
to_timestamp((to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') >= 
to_timestamp('%s', 'YYYY-MM-DD HH24:MI:SS')
and
to_timestamp((to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') < 
to_timestamp('%s', 'YYYY-MM-DD HH24:MI:SS');",
    as.character(dt2), as.character(dt1))
  
  if (DEBUG_SQL){
    cat(">>> SQL Query =[\n ",qs,"\n]\n")
  }
  
  # Send the query and wait for the result
  rs <- dbSendQuery(conn, qs)
  
  # Get the result data frame
  dfx<-dbFetch(rs)
  
  # Clear the resource committed for this query
  dbClearResult(rs)
  if (DEBUG_SQL){
    cat(">>> row count of result =",nrow(dfx),"\n")
  }
  
  # Move the date time sliding window backward
  dt1 <- dt2
  dt2 <- dt1 - 8*3600
  
  # Save the result data frame to file
  fn <- sprintf("slide-datatime-%3.3d.csv",i)
  write.csv(dfx, fn, row.names = FALSE)
}

# Close the connection with teradata
dbDisconnect(conn)
