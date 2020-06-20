library(e1071)
library(twitteR)
library(ROAuth)
library(tm)
library(ggplot2)
library(wordcloud)
library(sentimentr)
library(devtools)
library(plyr)
library(RTextTools)

install.packages("Rstem", repos="http://www.omegahat.net/R", type="source")
#jika Rstem sudah tidak available, ganti dengan SnowballC
install.packages("SnowballC", repos='http://cran.us.r-project.org')
#install package sentiment
require(devtools)
install_url("http://cran.r-project.org/src/contrib/Archive/sentiment/sentiment_0.2.tar.gz")
require(SentimentAnalysis)
ls("package:SentimentAnalysis")

consumer_key = "rUs1wBCulACVQAJB40LMibkZq"
consumer_secret = "aYLywV40t99Y0IX7KKmI7lspCXDZ1vCFAHeedhwwMPruzzd4iX"
access_token = "3064151198-NRMZBTm2AaSbqR59uKEg8e9pGp9NweAEZHwXgDw"
access_secret = "Evf2vJbfoMXDwuVcEhfUAfiS39c6kQ2TXO5WXhlYDeiAT"
setup_twitter_oauth(consumer_key,consumer_secret,access_token,access_secret)

miningtweets = searchTwitter('iKON+YG', lang = "en", n=1000,resultType = "recent")
miningtweets_text = sapply(miningtweets,function(x) x$getText())
str(miningtweets_text)

tw = read.csv('D:\\Daigaku\\praktikum2020\\data-raw\\CoronavirusUSA_13_4_to_29_4-2020_Clean_Data2.csv')
twet_text = tw$tweet_text
twet_text
covid = read.csv('D:\\Daigaku\\praktikum2020\\data-raw\\covid.csv')
str(covid)

some_txt = covid$text
some_txt
# akan dibuang kata - kata retweet
some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)","",some_txt)
# dibuang mention - mention
some_txt = gsub("@\\w+","",some_txt)
# dibuang tanda baca
some_txt = gsub("[[:punct:]]","",some_txt)
# dibuang angka
some_txt = gsub("[[:digit:]]","",some_txt)
# dibuang link - link
some_txt = gsub("http\\w+","",some_txt)
# dibuang spasi yang tidak berguna
some_txt = gsub("[\t]{2,}","",some_txt)
some_txt = gsub("[\n]","",some_txt)
some_txt = gsub("^\\s+|\\s+$","",some_txt)
some_txt
# fungsi error
try.error = function(x)
{
  # create missing value
  y = NA
  # tryCatch error
  try.error = tryCatch(tolower(x),error=function(e)e)
  # if not an error
  if(!inherits(try.error,"error"))
    y = tolower(x)
  # result
  return(y)
}

# lower case using try.error with sapply
some_txt = sapply(some_txt,try.error)
# remove NAs in some_txt
some_txt = some_txt[!is.na(some_txt)]
wordcloud(some_txt)
names(some_txt) = NULL
# classify emotion
#library(sentiment)
class_emo = classify_emotion(some_txt,algorithm="bayes",priot=1.0)
# get emotion best fit
emotion = class_emo[,7]
# substitute NA's by "unknown"
emotion[is.na(emotion)] = "unknown"
# classify polarity
class_pol = classify_polarity(some_txt,algorithm="bayes")
# get polarity best fit
polarity = class_pol[,4]

# data frame with results
sent_df = data.frame(text = some_txt, emotion=emotion,polarity=polarity,stringsAsFactors = FALSE)

# sort data frame
sent_df = within(sent_df,emotion <- factor(emotion,levels = names(sort(table(emotion),
decreasing = TRUE))))
# plot distribution of emotions
ggplot(sent_df,aes(x = emotion)) +
  geom_bar(aes(y=..count..,fill=emotion))+
  scale_fill_brewer(palette="Dark2")+
  labs(x="emotion categories",y="number of tweets")
######
ggplot(sent_df,aes(x=polarity))+
  geom_bar(aes(y=..count..,fill=polarity))+
  scale_fill_brewer(palette="RdGy")+
  labs(x="polarity categories",y="number of tweets")
######
emos=levels(factor(sent_df$emotion))
nemo=leght(emos)
emo.docs=rep("",nemo)
for(i in 1:nemo)
{
  temp=some_txt[emotion==emos[i]]
  emo.docs[i]=paste(temp,collapse = "")
}
####
# remove stopwords
emo.docs=removeWords(emo.docs,stopwords("english"))
# create corpus
corpus = Corpus(VectorSource(emo.docs))
tdm=TermDocumentMatrix(corpus)
tdm=as.matrix(tdm)
colnames(tdm)=emos
# comparison word cloud
comparison.cloud(tdm,colors = brewer.pal(nemo,"Dark2"),
                 scale=c(3,.5),random.order = FALSE,title.size = 1.5)



kasar_corpus <- VCorpus(VectorSource(twet_text))
inspect(kasar_corpus)
bajak = tm_map(kasar_corpus, removePunctuation)
bajak = tm_map(bajak, removeNumbers)
bajak = tm_map(bajak, stripWhitespace)
warning()
warning(wordcloud(bajak))
