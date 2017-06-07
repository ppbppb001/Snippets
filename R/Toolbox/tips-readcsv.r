# Suggested ways of using read.csv():

# [1].
# Error: read.csv() complete successfully but a lot data rows are missed in the output data.frame.
# Workaround: Set 'colClasses' in read.csv() explicitly 
df <- read.csv("mydata.csv", colClasses="character")   # read each coloumn as character(string)

# [2].
# Warning: Embedded nul(s) found in input
# Workaround: set 'skipNul' parameter explicitly
df <- read.csv("mydata.csv", colClasses="character", skipNul=TRUE)




