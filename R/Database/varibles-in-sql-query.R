idlist <- c('51001', '51002', '51003')
idqs <- ""
for (c in idlist) {
  idqs <- paste0(idqs,",'",c,"'")
}
idqs <- substr(idqs,2,nchar(idqs))
idqs<- paste0('(',idqs,')')

qs <- sprintf("select * from tb1 where ID in %s", idqs)
qs
