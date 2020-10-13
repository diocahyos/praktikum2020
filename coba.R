##Mencoba menambahkan komen
###membangkitkan data
set.seed(123)
x = rnorm(n = 100, mean =0, sd =1)
y = rnorm(n = 100, mean =0, sd =1)

#membuat data frame
data<-data.frame(x,y)

#setting direktori penyimpanan
setwd('D:/Daigaku/praktikum2020/Shiny')

#simpan file dengan format csv
write.csv(data, file ='regresi.csv')

#membaca data
regresi = read.csv('D:\\Daigaku\\praktikum2020\\data-raw\\CoronavirusUSA_13_4_to_29_4-2020_Clean_Data3.csv')

##memanggil package
library(shiny)

ui <- fluidPage(
  titlePanel("Model Regresi"),
  sidebarLayout(
    sidebarPanel(
      selectInput("vardep", label = h3("Dependen"),
                  choices = list("y" = "y"), selected = 1),
      
      selectInput("varindep", label = h3("Independen"),
                  choices = list("x" = "x"), selected = 1)
      
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Scatterplot", plotOutput("scatterplot")), # Plot
                  tabPanel("Ringkasan Model", verbatimTextOutput("summary")), # output Regresi
                  tabPanel("Data", DT::dataTableOutput('tbl')) # Data dalam tabel
      )
    )
  ))
# SERVER
server <- function(input, output) {
  #  Output Regresi
  output$summary <- renderPrint({
    fit <- lm(regresi[,input$vardep] ~ regresi[,input$varindep])
    names(fit$coefficients) <- c("Intercept", 'var_independen')
    summary(fit)
  })
  
  # Output Data
  output$tbl = DT::renderDataTable({
    DT::datatable(regresi, options = list(lengthChange = FALSE))
  })
  
  
  # Output Scatterplot 
  output$scatterplot <- renderPlot({
    wordcloud(paste(regresi$text, collapse = " "), min.freq = 0,
              random.color = TRUE, max.words = 100, colors = brewer.pal(8,"Dark2"))
  }, height=400)
}
shinyApp(ui = ui, server = server)
