library(jsonlite)

py <- '"c:\\apps.code\\python\\anaconda3\\python.exe"'  
script <- '"d:\\user\\studyandtest\\r\\github.com\\graph\\py_requests_gremlin.py"'
url <- '--url http://192.168.1.52:8182'
auth <- '--auth user1234:pass1234'
gremlin <- '--gremlin g.V().range(0,10).count()'
# outfile <- '--outfile d:\\user\\studyandtest\\r\\github.com\\graph\\res.txt'
outfile <- ''

cmd <- paste(py, script, url, auth, gremlin, outfile)
cmd

res <- system(cmd, intern = TRUE)
length(res)
res[1]
res[2]

x <- jsonlite::fromJSON(res[2])
d <- x$result$data$'@value'$'@value'
d


