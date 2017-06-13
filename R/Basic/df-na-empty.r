#----------------------------------------
# <df-na-empty.r>
#  how to deal with na value or empty value 
#  in data.frame
#
#  [2017-06-13] - Start
#----------------------------------------


dat.cnt <- 100          # Length of testing data set
bad.cnt <- 10        # count of bad cells

# Make a 2-cols data frame 'df.src' ...............
val.qty <- sample(dat.cnt)
val.item <- sample(c("Apple","Pear","Berry","Peach","Banana"), 
                   dat.cnt, 
                   replace=TRUE)
df.src <- data.frame(Item = val.item,           # column as character (with factors)
                     Quantity = val.qty,        # column as numeric
                     stringsAsFactors = FALSE)        


# deal with 'NA'......................
df.src.na <- df.src                   # 'df.test.na' as data source for NA experiment

# Make some cells as NA

ixs <- sample(dat.cnt)[1:bad.cnt]         # select cells randomly as bad cell
df.src.na[ixs, "Item"] = NA

ixs <- sample(dat.cnt)[1:bad.cnt]         # select cells randomly as bad cell
df.src.na[ixs, "Quantity"] = NA


# ***Fill*** NA cells with given value
dfx <- df.src.na                  
num.na <- 0                         # replace NA with 'num.na' when class is numeric
chr.na <- "X"                       # replace NA with 'chr.na' when class is character

# Fix cells in 'Item'
# dfx$Item <- as.character(dfx$Item)  # Add this line if 'Item' is factor class
ixs <- which(is.na(dfx$Item))
dfx[ixs,"Item"] <- chr.na
# dfx$Item <- as.factor(dfx$Item)     # Add this line if 'Item' needs to be factor class

# Fix cells in 'Quantity'
ixs <- which(is.na(dfx$Quantity))
dfx[ixs,"Quantity"] <- num.na

dfx     # Dispaly the result
 

# ***Remove*** NA cells
# Using this approach with vector only, data frame is not applicable
dfx <- df.src.na

items <- as.character(dfx[,"Item"])   # copy 'Item' column to 'items' vector
ixs <- which(is.na(items))            # indices of NA
items <- items[-ixs]                  # remove NAs
items                                 # display result
length(items)

qty <- dfx[,"Quantity"]               # copy 'Quantity' column to 'qty' vector
ixs <- which(is.na(qty))              # indices of NA
qty <- qty[-ixs]                      # remove NAs
qty                                   # display result
length(qty)




# deal with Empty......................
df.src.empty <- df.src                 # 'df.test.na' as data source for NA experiment

# Make some cells as Empty
ixs <- sample(dat.cnt)[1:bad.cnt]         # select cells randomly as bad cell
df.src.empty[ixs, "Item"] = ""         # only character class can be empty


# ***Fill*** Empty cells with given value
dfx <- df.src.empty                  
chr.empty <- "<Empty>"                 # replace empty with 'chr.empty'

# dfx$Item <- as.character(dfx$Item)   # Add this line if 'Item' is a factor class
ixs <- which(dfx$Item=="")
dfx[ixs,"Item"] <- chr.empty
# dfx$Item <- as.factor(dfx$Item)      # Add this line if 'Item' does need to be factor class


# ***Remove*** NA cells
# Using this approach with vector only, data frame is not applicable
dfx <- df.src.empty

items <- as.character(dfx[,"Item"])   # copy 'Item' column to 'items' vector
ixs <- which(items=="")               # indices of Empty
items <- items[-ixs]                  # remove Empty
items                                 # display result
length(items)

