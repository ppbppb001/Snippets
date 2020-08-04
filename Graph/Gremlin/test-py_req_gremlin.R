library(jsonlite)

py <- '"c:\\apps.code\\python\\anaconda3\\python.exe"'  
script <- '"d:\\user\\studyandtest\\r\\github.com\\graph\\py_requests_gremlin.py"'
url <- '--url http://192.168.1.52:8182'
auth <- '--auth user1234:pass1234'
gremlin <- '--gremlin g.V().range(0,10).count()'
# outfile <- '--outfile d:\\user\\studyandtest\\r\\rtest-1\\res.txt'
outfile <- ''

cmd <- paste0(py,' ',
              script, ' ',
              url, ' ',
              auth, ' ',
              gremlin, ' ',
              outfile)
cmd

res <- system(cmd, intern = TRUE)
length(res)
res[1]
res[2]

x <- jsonlite::fromJSON(res[2])
d <- x$result$data$'@value'$'@value'
d

# dlen <- length(d[[1]])
# for (i in seq(dlen/2)) {
#   s <- paste0 (i, '=> ', d[[1]][[i*2-1]], ' | ',d[[1]][[i*2]])
#   print (s)
# }


