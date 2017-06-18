# *** FOLLOWING MAY BE MASKED OFF ****

# Make pseudo data frames ------------ 

keysize <- 15                                              # size of key pool
keyset <- sapply(seq(keysize), function(x) paste0("K",x))  # make key strings

# Define pseudo data.frame-1: 'gl.df'
gl.dlen <- 10                                              # size of gl.df
ix <- sample(keysize)[1:gl.dlen]                           # fetch keys from key pool       
gl.df <- data.frame(Key = keyset[ix],
                    G1 = sapply(ix, function(x) paste0("G-1-",x)),
                    G2 = sapply(ix, function(x) paste0("G-2-",x)),
                    G3 = sapply(ix, function(x) paste0("G-3-",x))
                    )                                      # make gl.df

# Define pseudo data.frame-2: 'dm.df'
dm.dlen <- 8                                               # size of dm.df
ix <- sample(keysize)[1:dm.dlen]                           # fetch keys from key pool
dm.df <- data.frame(Key = keyset[ix],
                    D1 = sapply(ix, function(x) paste0("D-1-",x)),
                    D2 = sapply(ix, function(x) paste0("D-2-",x))
                    )                                      # make dm.df

# *** ABOVE MAY BE MASKED OFF ***



ix.gofd <- gl.df$Key %in% dm.df$Key   # logical series to indicate which gl.df is in dm.df
gl.df.sub <- gl.df[ix.gofd,]          # gl.df.sub is subset contained in dm.df

ix.dofg <- dm.df$Key %in% gl.df$Key   # logical series to indicate which dm.df is in gl.df
dm.df.sub <- dm.df[ix.dofg,]          # dm.df.sub is subset contained in gl.df

final.df <- merge(gl.df.sub, dm.df.sub, by.x = "Key")  # merge 2 sub dataframe


