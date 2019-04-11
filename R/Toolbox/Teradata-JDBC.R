library("RJDBC")
library("rJava")
library("DBI")

# Define the driver
drv <- JDBC("com.teradata.jdbc.TeraDriver", 
            "c:\\progtools\\R\\terajdbc\\terajdbc4.jar;c:\\progtools\\R\\terajdbc\\tdgssconfig.jar")


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
tdlogin <- "tduser"
tdpwd <- "tdpasswd"
conn <- dbConnect(drv, "jdbc:teradata://myhost/database=mydb", tdlogin, tdpwd)

