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
regresi <-read.csv('regresi.csv')

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
    plot(regresi[,input$varindep], regresi[,input$vardep], main="Scatterplot",
         xlab=input$varindep, ylab=input$vardep, pch=19)
    abline(lm(regresi[,input$vardep] ~ regresi[,input$varindep]), col="red")
    lines(lowess(regresi[,input$varindep],regresi[,input$vardep]), col="blue")
  }, height=400)
}
shinyApp(ui = ui, server = server)
