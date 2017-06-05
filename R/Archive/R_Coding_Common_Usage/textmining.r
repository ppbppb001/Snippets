setwd('../projects/r practice/r_coding_common_usage')
rm(list=ls())

library(tm)
library(SnowballC)
library(wordcloud)
library(ggplot2)

# load files into a Corpus object
docs <- Corpus(DirSource("textmining_data"))

# inspect a particular document
writeLines(as.character(docs[[30]]))

# function that replaces a specified character by space
toSpace <- content_transformer(function(x, pattern) {return(gsub(pattern, " ", x))})

# use toSpace to eliminate colons and hypens:
docs <- tm_map(docs, toSpace, "-")
docs <- tm_map(docs, toSpace, ":")

# remove punctuation, replace punctuation marks with " "
docs <- tm_map(docs, removePunctuations)

# transform to lower case
docs <- tm_map(docs, content_transformer(tolower))

# remove digits
docs <- tm_map(docs, removeNumbers)

# remove stopwords such as a, an and the
docs <- tm_map(docs, removeWords, stopwords("english"))

# stem document, reduce related words to their common root
docs <- tm_map(docs, stemDocument)

# further clean up
docs <- tm_map(docs, content_transformer(gsub), pattern='organiz', replacement='organ')

# create document term matrix (DTM), documents by rows and words by columns
dtm <- DocumentTermMatrix(docs)

# inspect DTM
inspect(dtm[1:2, 1000:1005])

# frequency of occurrence of each word
freq <- colSums(as.matrix(dtm))
ord <- order(freq, decreasing=TRUE)
freq[head(ord)]
freq[tail(ord)]

# create DTM, include words with length 4~20, words that occur in 3~27 documents
dtmr <- DocumentTermMatrix(docs, control=list(wordLengths=c(4, 20), 
                                              bounds=list(global=c(3, 27))))

# terms that occur at least 100 times
findFreqTerms(dtmr, lowfreq=80)

findAssocs(dtmr, "project", 0.6)

# word cloud
wordcloud(names(freqr), freqr, min.freq=70, colors=brewer.pal(6, "Dark2"))





