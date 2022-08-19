library(digest)


# Generate encryption key:
GenKey <- function(){
    key <- sample(0:255, 16, replace = T)
    return (key)
}

# Encrypt username/password and save to rdata file
SaveCredentials <- function(walletfile="wallet.RData", username="user", password="pass", key=seq(1:16)){
    msglen <- 1024
    key <- sample(0:255, 16, replace = T)
    
    rusr <- charToRaw(username)
    lenusr <- length(rusr)
    msgusr <- c(lenusr,  rusr, sample(seq(from=32, to=127),(msglen - lenusr -1), replace = T))
    rmsgusr <- as.raw(msgusr)
    
    rpwd <- charToRaw(password)
    lenpwd <- length(rpwd)
    msgpwd <- c(lenpwd,  rpwd, sample(seq(from=32, to=127),(msglen - lenpwd -1), replace = T))
    rmsgpwd <- as.raw(msgpwd)
    
    rmsg <- c(rmsgusr, rmsgpwd)
    aes <- AES(key, mode="ECB")
    msg <- aes$encrypt(rmsg)
    
    # wallet <- list()
    # wallet$key <- key
    # wallet$msg <- emsg
    # save(wallet, file = walletfile)
    save(msg, file = walletfile)  # save credentials
    
    save(key, file = "walletkey.RData") # save AES key
}


# Load and decrypt 
LoadCredentials <- function(walletfile="wallet.RData", key=seq(1:16)){
    msglen <- 1024
    load(file = walletfile)
    
    aes <- AES(key, mode="ECB")
    msg <- aes$decrypt(msg, raw = T)
    
    credentials <- list()
    
    lusr <- as.integer(msg[1])
    credentials$username <- rawToChar(msg[2:(1+lusr)])
    
    lpwd <- as.integer(msg[msglen+1])
    credentials$password <- rawToChar(msg[(msglen+2):(msglen+1+lpwd)])
    
    return(credentials)
}




############################################################

# Test: save credentils
username <- "myname008"
password <- "passwor008"
key <- GenKey()
SaveCredentials("wallet.Rdata", username, password, key)   # save credentials file and key file 

# Test: restrieve credentials
load(file = "walletkey.RData")             # load key
x <- LoadCredentials("wallet.RData", key)  # load credentials
x$username
x$password

