# <df-groupby.r> -------------------------------------
#  1) Grouped by index column
#  2) Doing calculations based on the groups
#
#  [2017-06-17] - r1
#  [2017-06-23] - r2: fiter of date range
#  [2017-06-25] - r3: date format coversion added
#-----------------------------------------------------


# Defeine key params -------------------------------
elements.len <- 1000
groups.len <- 100


# **********************************************************
#   Make pseudo data frame
# **********************************************************
groups.value <- sample(1:groups.len, elements.len, replace = TRUE)
groups.status <- ifelse(groups.value %% 4 == 0, "X","Y")

elements.value <- sample(elements.len)
elements.status <- sample(c("A","B","C"), elements.len, replace = TRUE)

# element date:
yy <- sample(2005:2015, elements.len, replace = TRUE)
mm <- sample(1:12, elements.len, replace = TRUE)
dd <- sample(1:28, elements.len, replace = TRUE)
ds <- sprintf("%4.4d-%2.2d-%2.2d", yy, mm, dd)

# Compose pseudo data frame: test.df
source.df <- data.frame(Group = groups.value,
                        GStatus = groups.status,
                        Element = elements.value,
                        EStatus = elements.status,
                        EDate = ds)


# **********************************************************
#   Pick data in the given date range
# **********************************************************
# 1) convert format of date of source to ISO:
# 1.1) - pick date column of source:
srcdate.str <- as.character(source.df$EDate)   

# 1.2) - Convert date string to posix date object by specifying date format of source:
srcdate.posx <- strptime(srcdate.str, format = "%Y-%m-%d")  # format of source like: 2017-06-20
# srcdate.posx <- strptime(srcdate.str, format = "%d-%b-%Y")  # format of source like: 20-Jun-2017
# srcdate.posx <- strptime(srcdate.str, format = "%d-%m-%Y")  # format of source like: 06-20-2017

# 1.3) - convert posix date object to date string in ISO format:
srcdate.striso <- strftime(srcdate.posx, format = "%Y-%m-%d")  # format of ISO like: 2017-06-20

# 2) locate and pick the rows match the date range requirement:
ix <- which(srcdate.striso >="2014-01-01" &
            srcdate.striso <="2014-12-31")   # compare date in ISO format
test.df <- source.df[ix,]
# **********************************************************


# **********************************************************
#   Grouped by using 'test.df$Group' as index column
# **********************************************************
# Use test.df$group as index column:
out.group <- split(test.df$Group, test.df$Group)  
out.group <- names(out.group)                        # group

out.gs <- split(test.df$GStatus, test.df$Group)
out.gs <- sapply(out.gs, function(x) x[1])           # group status

out.etotal <- tapply(test.df$Element, 
                     test.df$Group, 
                     function(x) length(x))          # total element

out.esa <- tapply(test.df$EStatus,
                  test.df$Group,
                  function(x) length(which(x=="A"))) # total element with status = A

out.esb <- tapply(test.df$EStatus,
                  test.df$Group,
                  function(x) length(which(x=="B"))) # total element with status = B

out.esc <- tapply(test.df$EStatus,
                  test.df$Group,
                  function(x) length(which(x=="C"))) # total element with status = C

out.df <- data.frame(Group = out.group,
                     G.Status = out.gs,
                     E.Total = out.etotal,
                     E.A = out.esa,
                     E.B = out.esb,
                     E.C = out.esc)                 # out.df = grouped result

out.df.x <- subset(out.df, out.df$G.Status=="X")    # out.df.x = subset of out.df with G.Status = X
out.df.y <- subset(out.df, out.df$G.Status=="Y")    # out.df.x = subset of out.df with G.Status = Y

