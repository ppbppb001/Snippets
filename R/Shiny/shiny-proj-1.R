library(shiny)
library(shinydashboard)

source("shiny-proj-1-teradata.r")
source("shiny-proj-1-settings.r")
loadSettings()


source("shiny-proj-1-ui.r")
source("shiny-proj-1-server.r")


# Shiny main loop ------------------------------

options(shiny.port = 7777)
shinyApp(ui, server)
