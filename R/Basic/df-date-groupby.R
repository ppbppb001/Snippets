# <df-date-groupby.r> -------------------------------------
#  1) Grouped by date(yyyy-mm)
#
#  [2017-07-12] - r1
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
#   Make secondary date vector which is composed 
#   just by years and months and append this vector to 
#   source data frame
# **********************************************************

# source date ("yyyy-mm-dd") tranlate to posix date
date.pox <- strptime(as.character(source.df$EDate), "%Y-%m-%d")  

# New col 'EDate2' ("yyyy-mm") added
source.df$EDate2 <- strftime(date.pox, "%Y-%m")                  

# **********************************************************


# **********************************************************
#   Test: 
# **********************************************************

test.df <- source.df

# Split/group 'EDate'(yyyy-mm-dd) by 'EDate2'(yyyy-mm) 
date2.group <- split(test.df$EDate, test.df$EDate2)
date2.group

# Count of sub-items groupped by 'EDate2'(yyyy-mm)
date2.count <- tapply(test.df$EDate, test.df$EDate2, function(x) length(x))
date2.count

# out.df.all = count of each columns when aggergatting by 'EDate2'
out.df.all <- aggregate(test.df, by=list(test.df$EDate2), FUN=length)
head(out.df.all)

# out.df.group = count of 'Group' when aggregating by 'EDate2'
out.df.group <- aggregate(test.df$Group, by=list(test.df$EDate2), FUN=length)
head(out.df.group)

