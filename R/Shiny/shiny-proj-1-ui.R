library(shiny)
library(shinydashboard)
library(shinyjs)
library(ggplot2)
library(visNetwork)



# UI ----------------------------------------------------
## Header
header <- dashboardHeader(title = "Shiny Project 1",
                          dropdownMenuOutput("messageMenu"),
                          dropdownMenuOutput("notificationMenu"),
                          dropdownMenuOutput("taskMenu")
                          )

## Sidebar contents
sidebar <- dashboardSidebar(
  sidebarMenu(
    id = "sidebar",
    width = "240",
    menuItem("Data Source", tabName = "datasrc", icon = icon("database")),
    menuItem("ggplot2", tabName = "ggplot2", icon = icon("gg")),
    menuItem("visNetwork", tabName = "visnetwork", icon = icon("share-alt")),
    menuItem("Settings", tabName = "settings", icon = icon("wrench"))
  )
)

## Body content:
body <- dashboardBody(
  useShinyjs(),  
  
  # Customised JS and CSS:
  tags$head(
    HTML('<script src="shiny-proj-1.js"></script>'),
    HTML('<link type="text/css" rel="stylesheet" href="shiny-proj-1.css">')
  ),
  

  tabItems(

    # <data source>:
    tabItem(tabName = "datasrc",
      box(width = 12,
          title = "Teradata connection",
          solidHeader = TRUE,
          status = "primary"
          # column(width = 6,
          #   selectInput("datasrcDataBase","Database:", choices = list(""))
          # ),
          # column(width = 6,
          #   actionButton("datasrcConnect", "Connect"),
          #   actionButton("datasrcDisconnect", "Disconnect"),
          # )
      )
      
          # status = "primary",
          # solidHeader = TRUE)
            # fluidRow(
            #   # box(title = "iris",
            #   #     status = "primary",
            #   #     solidHeader = TRUE,
            #   #     collapsible = TRUE,
            #   #     textInput("tab4input", "Input", value="")
            #   # )
            #   tabBox(
            #     title = "Data Tables",
            #     id = "tab4data",
            #     width = 12,
            #     tabPanel("diamonds", DT::dataTableOutput("mytable1")),
            #     tabPanel("mtcars", DT::dataTableOutput("mytable2")),
            #     tabPanel("iris", DT::dataTableOutput("mytable3"))
            #   )
            # )
    ),
    
    # <ggplot2>:
    tabItem(tabName = "ggplot2",
            fluidRow(
              # box(
              #   width = 12, 
              #   title = "ggplot2 test",
              #   status = "primary",
              #   solidHeader = TRUE,
              #   collapsible = TRUE,
              
              tabBox(width = 12,
                     tabPanel("Plot", plotOutput("tab51plot")),
                     # tabPanel("Data", DT::dataTableOutput("tab51data"))
                     tabPanel("Data", DT::dataTableOutput("tab51data"))
              ),
              
              box(width = 12,
                  column(width = 6,
                         sliderInput("tab51from", "ID from",100,120,106,step = 1),
                         sliderInput("tab51to", "ID to",100,120,110,step = 1)
                  ),
                  
                  column(width = 6,
                         selectInput("tab51palette", "Palette",
                                     choices = list("Set1", "Set2", "Set3",
                                                    "Pastel1", "Pastel2",
                                                    "Accent",
                                                    "Dark2",
                                                    "Paired",
                                                    "Spectral",
                                                    "Greens", "Blues", "Oranges"),
                                     selected = "Set1")
                  ),
                  
                  column(width = 12,
                         verbatimTextOutput("tab51output")
                  )
              )
              # )
            )
    ),
    
    # <visnetwork>:
    tabItem(tabName = "visnetwork",
            fluidRow(
              tabBox(width = 12, height = "100%",
                     tabPanel("Network", visNetworkOutput("tab6network", 
                                                          width = "100%",
                                                          height = 600)),
                     tabPanel("Nodes", DT::dataTableOutput("tab6nodes")),
                     tabPanel("Edges", DT::dataTableOutput("tab6edges"))
              ),
              
              box(width = 12,
                  column(width = 12,
                         sliderInput("tab6nodenum", "Node number", 3,100,10,step = 1)
                  ),
                  column(width = 12,
                         verbatimTextOutput("tab6output")
                  )
              )
            )
    ),
    
    # <settings>:
    tabItem(tabName = "settings",
      tabBox(width =12,
          # tabPanel("User",
          #   passwordInput("settingPassword1", "User's password"),
          #   passwordInput("settingPassword2", "Confirm password")
          # ),
        tabPanel("Teradata",
          textInput("settingTDHost", "Teradata Host", width = "100%", value = mySettings[1,"TDHost"]),
          # textInput("settingTDHostPort", "Teradata Host Port", value = mySettings[1,"TDHostPort"]),
          hr(),
          textInput("settingTDUser", "Account Name", value = mySettings[1,"TDUser"]),
          passwordInput("settingTDPassword1", "Logon password", value = mySettings[1,"TDPassword"]),
          passwordInput("settingTDPassword2", "Confirm password", value = mySettings[1,"TDPassword"]),
          hr(),
          actionButton("settingTDTest","Test connection", 
                       width = 240,
                       style = "font-weight: bold")
        )
      ),
      column(width = 12,
        verbatimTextOutput("settingMsg"),
        actionButton("settingSave","Confirm & Save", 
                     width = 240, class = "alignRight", style = "font-weight: bold")
      )
    )
    
    #End
  )
)

ui <- dashboardPage(header=header, 
                    sidebar = sidebar, 
                    body = body,
                    skin = "green",
                    title = "Shiny Project 1"
      )

