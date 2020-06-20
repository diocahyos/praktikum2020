library(twitteR)
library(ROAuth)
library(RCurl)

download.file(url = "http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

reqURL <- "https://api.twitter.com/oauth/request_token"
 accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
 CUSTOMER_KEY <- "7Ak4K07sgybwoSJiyQKUPceSE" 
 CUSTOMER_SECRET <- "vWYQQoiZroT5YpywIUW6zqW5Yk8jVaf1ueG5NHuQCDp7pRFLkq"
 ACCESS_TOKEN <- "3064151198-zXeE0e2q5LYP6NV4qLBHaBr5dDaj7lcm7Hjjizs"
 ACCESS_secret<-"mugtl4lxYfVL98iofIC3lgvIkc6cpZQ8IY9TAuw6HollB"
 
setup_twitter_oauth(CUSTOMER_KEY, CUSTOMER_SECRET, ACCESS_TOKEN, ACCESS_secret)

Covid <- searchTwitter('Covid', n= 1000, lang = "id") 
df_Covid<- do.call("rbind", lapply(Covid, as.data.frame))
View(df_Covid)
warning(df_Covid)
write.csv(df_Covid, file='D:/Daigaku/praktikum2020/data-raw/covid.csv',row.names=FALSE)

pos = scan('D:/s-pos.txt',what='character', comment.char=';')
neg = scan('D:/s-neg.txt',what='character', comment.char=';')

pos.words = c(pos)
neg.words = c(neg)

sentences<-read.csv("D:/Daigaku/praktikum2020/data-raw/covid.csv", header=TRUE)

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{ 
  require(plyr)
  require(stringr)
  
  # we got a vector of sentences. plyr will handle a list
  # or a vector as an "l" for us
  # we want a simple array of scores back, so we use
  # "l" + "a" + "ply" = "laply":
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    #gsub() function replaces all matches of a string
    # clean up sentences with R's regex-driven global substitute, gsub():
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence) #angka
    # and convert to lower case:
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    word.list = str_split(sentence, '\\s+')
    # sometimes a list() is one level of hierarchy too much
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    # we just want a TRUE/FALSE:
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

hasil = score.sentiment(sentences$text, pos.words, neg.words)
View(hasil)

sum(hasil$score)

hasil$klasifikasi<- ifelse(hasil$score>0,"Positif", ifelse (hasil$score<0,"Negatif", "Netral"))
hasil$klasifikasi
View(hasil)

data <- hasil[c(3,1,2)]
View(data)
write.csv(data, file = "Label_Tweet_covid.csv")
text<-hasil[2]
View(text)
write.table(text, file = 'tweet_covid.txt', sep = '')
