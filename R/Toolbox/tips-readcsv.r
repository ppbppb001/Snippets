df <- read.csv("bad-utf8-ps.csv", skipNul = TRUE, fileEncoding = "Latin1")  # Encoding = Latin1

df <- read.csv("bad-utf8-ps.csv", skipNul = TRUE, fileEncoding = "UCS-2LE")  # Encoding = UCS-2LE (Windows Unicode)


