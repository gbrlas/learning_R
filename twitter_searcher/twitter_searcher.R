library(wordcloud) 
library(RColorBrewer)
library(tm)
library(stringr)
library(twitteR) 
library(httr)
library(devtools) 
library(base64enc)

consumer_key <- "IrVLadT3tJHJoSLCoUgjErDjO"
consumer_secret <- "JzQv9D6AYto0I79zlWMDU3PkFhOFBj9sxJz0X4cXKdoq74zGnm"
access_token <- "864423190902296576-sz859R7c1J5dnQSp6FqxW86qaGc1tit"
access_secret <- "WiVdsd0bv6cnPZE1AgjG3Nmp0ubEorwz4Gre163lPBs6D"

setup_twitter_oauth(consumer_key = consumer_key,
                    consumer_secret = consumer_secret,
                    access_token = access_token,
                    access_secret = access_secret)

dtsc <- searchTwitter("#food",n=2000, lang = "en")

dtsc_text <- sapply(dtsc, function(x) x$getText())
dtsc_text <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", dtsc_text)
dtsc_text <- gsub("(f|ht)tps(s?)://(.*)[.][a-z]+", "", dtsc_text)
dtsc_text <- gsub("https","",dtsc_text)
dtsc_text <- str_replace_all(dtsc_text,"[^a-zA-Z\\s]", " ")

dtsc_corpus <- Corpus(VectorSource(dtsc_text))
tdm <- TermDocumentMatrix(
  dtsc_corpus,
  control = list(
    stopwords = c("food",
                  stopwords("english")))
)

m<-as.matrix(tdm)
word_freqs <- sort(rowSums(m), decreasing = TRUE)
word_freqs<-word_freqs
dm <- data.frame(word = names(word_freqs), freq = word_freqs)

wordcloud(dm$word, dm$freq, random.order = FALSE,scale=c(4,.5), 
          colors = brewer.pal(8, "Dark2"))

