library("digest")

# Encryption function --------------------------------

# Write encrypted account info to file
write.aes <- function(dfInfo, fnInfo, key) {
    require("digest")
    zz <- textConnection("out", "w")
    write.csv(dfInfo, zz, row.names = F)
    close(zz)
    out <- paste(out, collapse = "\n")
    dat <- charToRaw(out)
    dat <- c(dat, as.raw(rep(0, 16 - length(dat)%%16)))  # len of raw = times of 16
    aes <- AES(key, mode = "ECB")
    aes$encrypt(dat)
    writeBin(aes$encrypt(dat), fnInfo)
}

# read encrypted data from file
read.aes <- function(fnInfo, key) {
    require("digest")
    bin <- readBin(fnInfo, "raw", n=1000)
    aes <- AES(key, mode = "ECB")
    dat <- aes$decrypt(bin, raw=TRUE)
    txt <- rawToChar(dat[dat > 0])
    read.csv(text=txt, stringsAsFactors = F)
}

#Make a key and save it to file
key.make <- function() {
    mykey <- as.raw(sample(1:16, 16))
    save(mykey, file="mykey.RData")
}


# Test code ------------------

# Generate key file:
key.make()

# Save account info:
df <- data.frame(username = "myname",
                 password = "mycode")  # compose a data frame by pseudo account info

load(file="mykey.RData")  # retrieve the key from 'mykey.Rdata' file
write.aes(df, "myaccount", mykey)



# Retrieve account info:
load(file="mykey.RData")
dfAccount <- read.aes("myaccount", mykey)
dfAccount

name = as.character(dfAccount[1,"username"])
name
pswd = as.character(dfAccount[1,"password"])
pswd
