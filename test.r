#-----------------------------------------------------------------------
# [ch4.2.4]

findwords <- function(tf) {
    # read in the words from the file, into a vector of mode character
    txt <- scan(tf, "")
    wl <- list()
    for (i in 1:length(txt)) {
        wrd <- txt[i]
        wl[[wrd]] <- c(wl[[wrd]], i)
    }
    return(wl)
}

res <- findwords("testconcord.txt")
res

