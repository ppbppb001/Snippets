library(shiny)
library(shinydashboard)
# library(shinydashboardPlus)
library(ggplot2)
library(visNetwork)

data("iris")


# UI ----------------------------------------------------
## Header
header <- dashboardHeader(title = "Shiny Test [2]",
                          dropdownMenuOutput("messageMenu"),
                          dropdownMenuOutput("notificationMenu"),
                          dropdownMenuOutput("taskMenu"))

## Sidebar contents
sidebar <- dashboardSidebar(
                # width = "480",
                sidebarSearchForm(textId = "searchText", 
                                buttonId = "searchButton",
                                label = "Search..."),
                
                sidebarMenu(
                  id = "sidebar",
                  menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                  menuItem("Tabs", tabName = "tabs", icon = icon("th"),
                           badgeLabel = "New", badgeColor = "green"),
                  menuItem("InfoBox", tabName = "infobox", icon = icon("th-list")),
                  menuItem("DataTable", tabName = "datatable", icon = icon("table")),
                  menuItem("ggplot2", tabName = "ggplot2", icon = icon("gg")),
                  menuItem("visNetwork", tabName = "visnetwork", icon = icon("share-alt"))
                ),
                
                tags$hr(),
                sliderInput("slider1","Value",1,100,30),
                
                dateRangeInput("dateRange", "Date Range:",
                               format = "yyyy-mm-dd", startview = "month",
                               separator = "to"),
                
                textInput("text1", "Text Input:", value = "", placeholder = "placeholder"),
                
                numericInput("numeric1", "Numeric Input:", value = 0),
                
                tags$hr(),
                fileInput("loadRFile", "Load R file", accept = c("R source code",".r"))
          )
          
## Body content:
body <- dashboardBody(
          tabItems(
            # First tab content:
            tabItem(tabName = "dashboard",
                    fluidRow(
                        box(
                          width = 12,
                          title = "Histogram",
                          status = "primary",
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          plotOutput("plot1", height = 250)
                        ),
                        box(
                          title = "Inputs",
                          status = "warning",
                          solidHeader = TRUE,
                          collapsible = TRUE,
                          sliderInput("slider2", "Number of observations:",1,100,50),
                          textInput("text2", "Text Input:", value="")
                        )
                    )
            ),
            
            # Second tab content:
            tabItem(tabName = "tabs",
                    fluidRow(
                      tabBox(
                        title = "First tabbox",
                        id = "tabset1", height = "250px",
                        tabPanel("Tab1", "Tab content 1"),
                        tabPanel("Tab2", "Tab content 2")
                      ),
                      tabBox(
                        id = "tabset2",
                        side = "right", height = "250px",
                        selected = "Tab3",
                        tabPanel("Tab1", "Tab content 1"),
                        tabPanel("Tab2", "Tab content 2"),
                        tabPanel("Tab3", "Note that when side=right, the tab order is reversed.")
                      )
                    ),
                    fluidRow(
                      tabBox(
                        title = tagList(shiny::icon("gear"), "tabBox status"),
                        id = "tabset3",
                        tabPanel("Tab1",
                                 "Currently selected tab from first box:",
                                 verbatimTextOutput("tabset1Selected")),
                        tabPanel("Tab2", "Tab content 2")
                      )                      
                    )
            ),
            
            # Third tab content:
            tabItem(tabName = "infobox",
              fluidRow(
                infoBox("New Orders", 10*2, icon = icon("credit-card")),
                infoBoxOutput("progressBox"),
                infoBoxOutput("approvalBox")
              ),
              fluidRow(
                infoBox("New Orders", 10*2, icon = icon("credit-card"), fill = TRUE),
                infoBoxOutput("progressBox2"),
                infoBoxOutput("approvalBox2")
              ),
              fluidRow(
                valueBox(10*2, "New Orders", icon = icon("credit-card")),
                valueBoxOutput("progressValueBox"),
                valueBoxOutput("approvalValueBox")
              ),
              fluidRow(
                box(width = 4, actionButton("count", "Increment progress"))
              )
            ),
            
            # Fourth tab content:
            tabItem(tabName = "datatable",
              fluidRow(
                      # box(title = "iris",
                      #     status = "primary",
                      #     solidHeader = TRUE,
                      #     collapsible = TRUE,
                      #     textInput("tab4input", "Input", value="")
                      # )
                tabBox(
                  title = "Data Tables",
                  id = "tab4data",
                  width = 12,
                  tabPanel("diamonds", DT::dataTableOutput("mytable1")),
                  tabPanel("mtcars", DT::dataTableOutput("mytable2")),
                  tabPanel("iris", DT::dataTableOutput("mytable3"))
                )
              )
            ),
            
            # Fifth tab content:
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
            
            # Sixth tab content:
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
            )
            
            #End
          )
      )

ui <- dashboardPage(header=header, 
                    sidebar = sidebar, 
                    body = body,
                    skin = "green",
                    title = "Dashboard Demo"
                )



# SERVER -------------------------------------------------

## display the plot1
plot1 <- function(input, output){
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider1)]
    hist(data)
  })
}

## show message menu
msgMenu <- function(input, output){
  output$messageMenu <- renderMenu({
    dropdownMenu(type = "messages",
                 messageItem(
                   from = "Sales Dept",
                   message = "Sales are steady this month."
                 ),
                 messageItem(
                   from = "New User",
                   message = "How do I register?",
                   icon = icon("question"),
                   time = "13:45"
                 ),
                 messageItem(
                   from = "Support",
                   message = "The new server is ready.",
                   icon = icon("life-ring"),
                   time = "2014-12-01"
                 )
    )
  })
}

## show notification menu
notificationMenu <- function(input, output){
  output$notificationMenu <- renderMenu({
    dropdownMenu(type = "notifications",
                 notificationItem(
                   text = "5 new users today",
                   icon("users")
                 ),
                 notificationItem(
                   text = "12 items delivered",
                   icon("truck"),
                   status = "success"
                 ),
                 notificationItem(
                   text = "Server load at 86%",
                   icon = icon("exclamation-triangle"),
                   status = "warning"
                 )
    )
  })
}

## show task menu
taskMenu <- function(input, output){
  output$taskMenu <- renderMenu({
    dropdownMenu(type = "tasks", 
                 badgeStatus = "success",
                 taskItem(value = 90, color = "green",
                          "Documentation"
                 ),
                 taskItem(value = 17, color = "aqua",
                          "Project X"
                 ),
                 taskItem(value = 75, color = "yellow",
                          "Server deployment"
                 ),
                 taskItem(value = 80, color = "red",
                          "Overall project"
                 )
    )
  })
}

## show infobox
infoBoxes <- function(input, output){
  output$progressBox <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple"
    )
  })
  output$approvalBox <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up"),
      color = "yellow")
  })
  
  output$progressBox2 <- renderInfoBox({
    infoBox(
      "Progress", paste0(25 + input$count, "%"), icon = icon("list"),
      color = "purple", fill = TRUE
    )
  })
  output$approvalBox2 <- renderInfoBox({
    infoBox(
      "Approval", "80%", icon = icon("thumbs-up"),
      color = "yellow")
  })
  
  output$progressValueBox <- renderValueBox({
    valueBox(
      paste0(25 + input$count, "%"),
      "Progress", icon = icon("list"),
      color = "purple")
  })
  output$approvalValueBox <- renderValueBox({
    valueBox(
      "80%", "Arrpoval", icon = icon("thumbs-up"),
      color = "yellow"
    )
  })
}


## show data tables
dataTables <- function(input, output){
  output$mytable1 <- DT::renderDataTable({
    DT::datatable(diamonds)
  })
    
  output$mytable2 <- DT::renderDataTable({
    DT::datatable(mtcars)
  })
  
  output$mytable3 <- DT::renderDataTable({
    DT::datatable(iris)
  })
}
  
## show ggplot2 test plot
ggplot2Test <- function(input, output){
  output$tab51output <- renderText({
    idFrom <- input$tab51from
    idTo <- input$tab51to
    idSize <- idTo - idFrom + 1
    c("idSize =",idSize, "| Palette = ",input$tab51palette)
  })
    
  output$tab51plot <- renderPlot({
    idFrom <- input$tab51from
    idTo <- input$tab51to
    df <- df.tab5
    p <- ggplot(df, aes(x=Company, y=Value, fill=Year)) +           # colored ribon for each year
                geom_area() +                                       # area fill (ribon)
                labs(x="X=COMPANY", y="Y=VALUE", title="TITLE") +   # x/y labels and title
                theme(plot.title = element_text(hjust=0.5))         # center the title
    p + scale_fill_brewer(palette = input$tab51palette)
  })
  
  # output$tab51data <- DT::renderDataTable(df.tab5)
  output$tab51data <- DT::renderDataTable({
    idFrom <- input$tab51from
    idTo <- input$tab51to
    df.tab5
  })
  
}

## show visnetwork test plot
visNetworkTest <- function(input, output){
  output$tab6output <- renderText({
    nodenum <- input$tab6nodenum
    nodenum <- round(nodenum * 0.3333) * 3
    samplenum <- round(nodenum*0.25) * 3
    df.node <<- data.frame(id = 1:nodenum,
                           label = paste("Node", 1:nodenum),
                           group = c("G1", "G2", "G3"),
                           value = 1:nodenum,
                           title = paste0("<p><b>", 1:nodenum, "</b><br>Node!</p>"),
                           shadow = c(FALSE, TRUE, TRUE),
                           shape = c("star", "triangle", "circle")
                           )
    df.edge <<- data.frame(from = sample(1:nodenum, samplenum),
                           to = sample(1:nodenum, samplenum),
                           label = paste("Edge", 1:samplenum),
                           title = paste("Edge-T", 1:samplenum),
                           length = c(100,200,500),
                           arrows = c("to", "from", "middle"),
                           dashes = c(TRUE, FALSE, FALSE)
                           )
    c("node number =", nodenum, "| sample num =", samplenum)    
  })
  
  output$tab6network <- renderVisNetwork({
    nodenum <- input$tab6nodenum
    v <- visNetwork(nodes = df.node, edges = df.edge, width = "100%")
    v
    # nodes <- data.frame(id = 1:3)
    # edges <- data.frame(from = c(1,2), to = c(1,3))
    # visNetwork(nodes, edges)
  })  
  
  output$tab6nodes <- DT::renderDataTable({
    nodenum <- input$tab6nodenum
    df.node
  })
  
  output$tab6edges <- DT::renderDataTable({
    nodes <- input$tab6nodenum
    df.edge
  })
  
}


server <- function(input, output, session) {
  # Ask PIN code at startup
  showModal(modalDialog(
    title = "Please input your PIN code",
    passwordInput("startupPINCode", "PIN Code", placeholder = "Type your PIN code here"),
    div("Note1 blablabla..."),
    div("Note1 blablabla..."),
    footer = tagList(
      actionButton("startupOK","OK", width = 160)
    ),
    easyClose = FALSE
  ))
  observeEvent(input$startupOK,{
    removeModal()
    cat("PIN Code =", input$startupPINCode, "\n")
  })
  
  
  msgMenu(input, output)
  notificationMenu(input, output)
  taskMenu(input, output)
  
  plot1(input, output)
  infoBoxes(input, output)
  dataTables(input, output)
  ggplot2Test(input, output)
  visNetworkTest(input, output)
  
  output$tabset1Selected <- renderText({
    input$tabset1
  })

  # Event: input$tab51from | input$tab51to  
  observeEvent(
    {
      input$tab51from 
      input$tab51to
    }, 
    {
      idFrom <- input$tab51from
      idTo <- input$tab51to
      idSize <- idTo - idFrom + 1
      x <- rep(seq(from=idFrom, to=idTo),6)  # Compand's id number
      y <- rnorm(idSize * 6) * 5 + 15              # values
      z <- c(rep(2001,idSize), rep(2002,idSize), rep(2003,idSize), rep(2004,idSize), rep(2005,idSize), rep(2006,idSize))  # years
      z <- as.character(z)              # convert 'years' from int to string
      df.tab5 <<- data.frame(Company=x, Value=y, Year=z)   # compose a data frame
      # cat("new df.tab5\n")
    }
  )
  
  # Event: input$openfile
  observeEvent(input$loadRFile, {
    rfile <- input$loadRFile
    cat("file name = ",rfile$name, "\n")
    cat("file path = ",rfile$datapath, "\n")
    cat("file size = ",rfile$size, "\n")
    cat("file type = ",rfile$type, "\n")
  })
  
  
  # Stop server after brower closed
  session$onSessionEnded(function() {
    stopApp(message("Shiny App Stopped!"))
  })
  
}



# Shiny main loop ------------------------------
options(shiny.port = 7777)
shinyApp(ui, server)
