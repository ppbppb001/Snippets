setwd('../projects/r practice/r_coding_common_usage')
rm(list=ls())

#sql queries with r
library(RMySQL)

# con <- dbConnect(MySQL(), user='root', password='mysql', host='127.0.0.1', 
#                  client.flag=CLIENT_MULTI_RESULTS)
con <- dbConnect(MySQL(), user='root', password='mysql', host='127.0.0.1')
# con <- dbConnect(MySQL(), client.flag=CLIENT_MULTI_RESULTS)

sql <- "select * from sakila.actor"
# rows <- dbGetQuery(con, sql)
res <- dbSendQuery(con, sql)
rows <- dbFetch(res)

all_cons <- dbListConnections(MySQL())
for (tcon in all_cons)
{
  dbDisconnect(tcon)
}


# practice...
con <- dbConnect(MySQL(), user='root', password='mysql', host='127.0.0.1')
sql <- "select * from sakila.actor;"
res <- dbSendQuery(con, sql)
rows <- dbFetch(res)

dbDisconnect(con)




