#--------------------------------------------------
# <df-dummy.r>
#  1) Add dummy columns to reflect dirty cells
#  2) Modify the dirty cells with predefined
#     Value.
#
#  [2017-06-14] - Start
#--------------------------------------------------


dat.len <- 1000               # length of data set / rows of data frame
bad.len <- dat.len * 0.3      # 30% bad data


# Make a data frame with dirty data .............
# numeric/double data type:
dat.nums <- runif(dat.len)
ixs <- sample(1:dat.len)[1:bad.len]
dat.nums[ixs] <- NA                         # Make the dirts

# character data type:
dat.chrs <- sample(c("Salmon","Lamb", "Beef", "Pork", "Duck", "Chicken"), 
                   dat.len,
                   replace = TRUE)
ixs <- sample(1:dat.len)[1:(bad.len/2)]
dat.chrs[ixs] <- NA                         # Make the dirts
ixs <- sample(1:dat.len)[1:(bad.len/2)]
dat.chrs[ixs] <- ""                         # Make the dirts

# Make a data frame with dirty data
df.src <- data.frame(NUM = dat.nums,
                     CHR = dat.chrs)



# Process the 'dirty' data frame .................
df.test <- df.src                        # df.test is a copy of df.src

# Define the replacements
replacement.num <- mean(df.test$NUM, na.rm = TRUE)
replacement.chr <- "<BAD>"

# Make dummy data series
dummy.num <- ifelse(is.na(df.test$NUM),0,1)  # Dummy: Normal=1, NA=0
dummy.chr <- ifelse((is.na(df.test$CHR) | df.test$CHR==""), 0, 1)

# Fill dirty cells with predefined value
ixs <- which(dummy.num == 0)
df.test[ixs, "NUM"] <- replacement.num

ixs <- which(dummy.chr == 0)
tmp <- as.character(df.test[, "CHR"])     # un-factor
tmp[ixs] <- replacement.chr               # filled with the replacements
df.test[, "CHR"] <- as.factor(tmp)        # as-factor and assign

# Make new dataframe with extra dummy columns
df.new <- data.frame(df.test,
                     NUM.Dummy = dummy.num,
                     CHR.Dummy = dummy.chr)
print(head(df.new))

print(replacement.num)
print(replacement.chr)


