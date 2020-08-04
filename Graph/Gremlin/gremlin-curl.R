library(curl)
library(jsonlite)


# curl ###############################
#curl::curl_version()
#curl::curl_options()

server <- "http://192.168.1.52:8182"                  # URL of janusgraph/gremlin server
query <- '{"gremlin":"g.V().range(0,10).count()"}'
auth <- "user1234:pass1234"

h <- curl::new_handle()

curl::handle_setopt(
  handle = h,
  httpauth = 1,
  userpwd = auth,
  postfields = query
)

curl::handle_setheaders(
  handle = h,
  "Content-Type" = "application/json"
)

resp <- curl::curl_fetch_memory(url = server , handle = h)
resp$status_code    # 'status_code' should be '200' (200=OK)

content <- rawToChar(resp$content)
content             # result returned by gremlin server in json format

data <- fromJSON(content)    # convert json data to R object 'data'
data
data$result$data$'@value'$'@value'   # the count


