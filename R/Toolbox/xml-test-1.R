library(xml2)
library(XML)
library(tidyr)


f1 <- readLines("workspace.xml")
f1s <- paste(f1, collapse = "")
xml1 <- read_xml(f1s)

n1 <- xml_find_all(xml1, ".//component")
xml_path(n1)

c1 <- xml_child(n1[[1]])
c1
class(c1)

a1 <- xml_attrs(c1)
names(a1)

v1 <- xml_attr(c1, "default")
v1


ln1 <- as_list(n1)
x <- ln1[[1]]
x[[1]]




