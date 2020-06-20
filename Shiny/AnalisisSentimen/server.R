#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)
library(wordcloud)
library(twitteR)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  setup_twitter_oauth(consumer_key = "JVvDx5BcWJYvLEouiAQSvAD5v", consumer_secret = "QdozYX5Ui4DKLNm7X8K3mmnkOG5MKy8ND4d6gxuQp6fpePMJ41", 
                      access_token = "3064151198-2GtphBmlDeL1NSa1gwKwBQ5g46KnC0xQe1qADTa", access_secret = "tLML5aG3RgFtmrYi9azmIFrPLfgMFN238HWuRrg8ocZvR")
  token <- get("oauth_token", twitteR:::oauth_cache)
  token$cache()
  output$currentTime <- renderText({invalidateLater(1000, session)
    paste("Current time is: ",Sys.time())})
  observe({
    invalidateLater(60000,session)
    count_positive = 0
    count_negative = 0
    count_neutral = 0
    positive_text <- vector()
    negative_text <- vector()
    neutral_text <- vector()
    vector_users <- vector()
    vector_sentiments <- vector()
    tweets_result = ""
    #tweets_result = searchTwitter("word-to-find-in-twitter", lang = "en")
    for (tweet in tweets_result){
      print(paste(tweet$screenName, ":", tweet$text))
      vector_users <- c(vector_users, as.character(tweet$screenName));
      if (grepl("lindo", tweet$text, ignore.case = TRUE) == TRUE | grepl("Wonderful", tweet$text, ignore.case = TRUE) | grepl("Awesome", tweet$text, ignore.case = TRUE)){
        count_positive = count_positive + 1

        vector_sentiments <- c(vector_sentiments, "Positive")
        positive_text <- c(positive_text, as.character(tweet$text))
      } else if (grepl("Boring", tweet$text, ignore.case = TRUE) | grepl("I'm sleeping", tweet$text, ignore.case = TRUE)) { 
        count_negative = count_negative + 1

        vector_sentiments <- c(vector_sentiments, "Negative")
        negative_text <- c(negative_text, as.character(tweet$text))
      } else {
        count_neutral = count_neutral + 1

        vector_sentiments <- c(vector_sentiments, "Neutral")
        neutral_text <- c(neutral_text, as.character(neutral_text))
      }
    }
    df_users_sentiment <- data.frame(vector_users, vector_sentiments)
    output$tweets_table = renderDataTable({
      df_users_sentiment
    })
    
    output$distPlot <- renderPlot({
      results = data.frame(tweets = c("Positive", "Negative", "Neutral"), numbers = c(count_positive,count_negative,count_neutral))
      barplot(results$numbers, names = results$tweets, xlab = "Sentiment", ylab = "Counts", col = c("Green","Red","Blue"))
      if (length(positive_text) > 0){
        output$positive_wordcloud <- renderPlot({ wordcloud(paste(positive_text, collapse=" "), min.freq = 0, random.color=TRUE, max.words=100 ,colors=brewer.pal(8, "Dark2"))  })
      }
      if (length(negative_text) > 0) {
        output$negative_wordcloud <- renderPlot({ wordcloud(paste(negative_text, collapse=" "), random.color=TRUE,  min.freq = 0, max.words=100 ,colors=brewer.pal(8,"Set3"))  })
      }
      if (length(neutral_text) > 0){
        output$neutral_wordcloud <- renderPlot({ wordcloud(paste(neutral_text, collapse=" "), min.freq = 0, random.color=TRUE , max.words=100 ,colors=brewer.pal(8, "Dark2"))  })
      }
    })
  })
})