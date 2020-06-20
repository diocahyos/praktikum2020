#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sentiment Analysis"),
    textOutput("currentTime"),
    h4("Tweets:"),
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
        #  dataTable0utput('tweets_table')
        ),

        # Show a plot of the generated distribution
        mainPanel(
          
          tabsetPanel(type = "tabs",
            tabPanel("Data", DT::dataTableOutput('tbl')),# Data dalam tabel
            
            plotOutput("distPlot"),
            sidebarPanel(
              plotOutput("positive_wordcloud")
            ),
            sidebarPanel(
              plotOutput("negative_wordcloud")
            ),
            sidebarPanel(
              plotOutput("neutral_wordcloud")
            )
        )
    )
)))
