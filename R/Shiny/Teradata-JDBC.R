library("RJDBC")
library("rJava")
library("DBI")

# Define the driver
drv <- JDBC("com.teradata.jdbc.TeraDriver", 
            "c:\\progtools\\Teradata\\terajdbc\\terajdbc4.jar;c:\\progtools\\Teradata\\terajdbc\\tdgssconfig.jar")


#--- [Optional codes]: Check the path of java classes ---
jclass <- .jclassPath()
print (jclass)
# Console output:
# [1] "C:\\ProgTools\\R\\R-3.5.3\\library\\rJava\\java"           
# [2] "c:\\progtools\\R\\terajdbc\\terajdbc4.jar"                 
# [3] "c:\\progtools\\R\\terajdbc\\tdgssconfig.jar"               
# [4] "C:\\ProgTools\\R\\R-3.5.3\\library\\RJDBC\\java\\RJDBC.jar"

#--- [Optional codes]: Test existing of the java files ---
for (path in jclass) {
    print (path)
    print (file.exists(path))
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


# Connect with teradata
# tdlogin <- "dbc"
# tdpwd <- "dbc"
# conn <- dbConnect(drv, "jdbc:teradata://192.168.1.249/database=dbc", 
#                   tdlogin, tdpwd)

tdlogin <- "bear"
tdpwd <- "teradata"
conn <- dbConnect(drv, "jdbc:teradata://192.168.1.249/database=bear", 
                       tdlogin, tdpwd)

# tdlogin <- "cat"
# tdpwd <- "teradata"
# conn <- dbConnect(drv, "jdbc:teradata://192.168.1.249/database=cat", 
#                        tdlogin, tdpwd)

data(iris)
dbWriteTable(conn, 'iris', iris[,1:2])

data("mtcars")
dbWriteTable(conn, "mtcars", mtcars)

c1 <- c("a","b","c")
c2 <- c(1,10,100)
df <- data.frame(c1,c2)
dbWriteTable(conn, "rtest1", df)

dbDisconnect(conn)


