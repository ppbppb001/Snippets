library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  # App title ---
  titlePanel("Hello Shiny!"),
  
  # Sidebar layout with input and output definition ---
  sidebarLayout(
  
    # Sidebar panel for inputs ---
    sidebarPanel(
      
      # Input: Slider for the number of bins ---
      sliderInput(inputId = "bins",
                  label = "Number of bins",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    
    # Main panel for displaying outputs ---
    mainPanel(
      #Output: Histogram ---
      plotOutput(outputId = "distPlot")
    )
  )
)


server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins)
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption in (mins)",
         main = "Histogram of waiting times")
  })

}

options(shiny.port = 7777)
shinyApp(ui = ui, server = server)

