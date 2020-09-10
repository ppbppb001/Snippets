library(shiny)
library(shinydashboard)
library(DT)
library(shinybusy)
# library(shinydashboardPlus)

library(ggplot2)
library(visNetwork)
library(igraph)

setwd('D:\\User\\StudyAndTest\\R\\Shiny')

data("iris")

selectedRowsTab1 <- NULL
selectedRowsTab2 <- as.integer(c(1,2))

dfRaw <- read.csv('IER_simu_data1.csv', header=T, stringsAsFactors = F)
dfSel <- dfRaw[1,c(1,2)]
dfSel <- dfSel[-1,]

dfSimi <- read.csv('IER_simi_attrib.csv', header=T, stringsAsFactors = F)



# UI ----------------------------------------------------
## Header
header <- dashboardHeader(title = "Shiny Prototype 1 -akldjlaskdjklasdjklasjdlka", titleWidth = 500)
                          
## Sidebar contents
sidebar <- dashboardSidebar(
              width = 500,
              collapsed = TRUE,
              sidebarMenu(
                  id = "sidebar",
                  menuItem(text = "Page-1", tabName = "page_1", icon = icon("share-alt"))
                  # menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                  # menuItem("Tabs", tabName = "tabs", icon = icon("th")),
                  # menuItem("DataTable", tabName = "datatable", icon = icon("table")),
                  # menuItem("visNetwork", tabName = "visnetwork", icon = icon("share-alt"), badgeLabel = "New",badgeColor = "green")
              )
          )
          
## Body content:
body <- dashboardBody(
  
          # Customised JS and CSS:
          tags$head(
            HTML('<script src="shiny-prototype-1.js"></script>'),
            # HTML('<link type="text/css" rel="stylesheet" href="shiny-prototype-1.css">'),
            tags$style(
              type="text/css",
              ".datatables {font-size: 90%}
              .main-header.logo {width: 300px}"
            )
          ),

          add_busy_bar(timeout =  1000, color = "yellow", height = "8px"),
          add_busy_spinner(timeout = 1000, spin = "fading-circle",
                           position = "top-left", color = "yellow"),
          
          tabItems(
            
            # Tab content [functiona]:
            tabItem(tabName = "page_1",
                fillPage(
                  fluidRow(
                    
                    column(
                      width = 4,
                      style = "padding: 0px; margin: 0px;",
                      
                      box(
                          width = 12,
                          id = "panel_selection",
                          # title = "Selection", 
                          title = textOutput('title_panel_selection'),
                          status = "primary", 
                          solidHeader = TRUE,
                          # collapsible = TRUE,
                          style = "padding: 8px; margin: 0px; height: 90vh; background-color: #fafafa",
                          
                          actionButton("btnSelectReset",label = "Reset Selection", 
                                       style = "width: 120px; margin: 12px; float: right; font-weight: bold"),
                          actionButton("btnPlot",label = "Plot", 
                                       style = "width: 120px; margin: 12px; float: right; font-weight: bold"),
                          # textOutput("lb_selectedRows"),
                          # verbatimTextOutput("lb_selectedRows2"),
                          
                          tabBox(
                            title = "Similarity",
                            id = "tabbox_r1c1",
                            width = 12,
                            tabPanel("Seletion-1", 
                                     actionButton("btnSearch", label = "Search",
                                                  style = "width: 120px; margin-bottom: 12px; font-weight: bold"),
                                     DT::dataTableOutput("table_sele_1")),
                            tabPanel("Seletion-2", 
                                     DT::dataTableOutput("table_sele_2"))
                          )
                      )

                    ),

                    column(
                      width = 8,
                      style = "padding: 0px; margin: 0px;",
                      
                      box(
                        width = 12,
                        id = "panel_plot",
                        # title = "Output", 
                        title = textOutput("title_panel_plot"),
                        status = "success", 
                        solidHeader = TRUE,
                        # collapsible = TRUE,
                        style = "padding: 8px; margin: 0px; height: 90vh; background-color: #fafafa",
                        
                        actionButton("btnDistinct", label = "Mark Distinct", 
                                     style = "width: 120px; margin: 12px; float: right; font-weight: bold;"),
                        actionButton("btnMerge", label = "Merge", 
                                     style = "width: 120px; margin: 12px; float: right; font-weight: bold;"),
                        
                        tabBox(
                          title = "Data Plots",
                          id = "tabbox_plots",
                          width = 12,
                          height = "60vh",
                          tabPanel("Plot-1", plotOutput("plot_1")),
                          tabPanel("Plot-2", plotOutput("plot_2"))
                        ),
                      # ),
                      # 
                      # box(
                      #   width = 12,
                      #   id = "panel_c2r2",
                      #   title = "Outcome Details", status = "warning", solidHeader = TRUE,
                      #   # collapsible = TRUE,
                      #   style = "padding: 8px; margin: 4px; height: 25vh; background-color: #fafafa;
                      #            font-szie: 10%;",
                        
                        tabBox(
                          title = "Details",
                          id = "tabbox_details",
                          width = 12,
                          tabPanel("Details-1", DT::dataTableOutput("table_detail_1")),
                          tabPanel("Details-2", DT::dataTableOutput("table_detail_2"))
                        )
                      )
                       
                    )
                  )
                )
            )
            

            #End
          )
      )

ui <- dashboardPage(header = header, 
                    sidebar = sidebar, 
                    body = body,
                    skin = "green",
                    title = "Dashboard Demo"
                )



# SERVER -------------------------------------------------

messagebox <- function(title="Notification", msg1="", msg2="") {
  showModal(modalDialog(
    title = title,
    div(msg1),
    div(msg2),
    footer = tagList(
      actionButton("btnMessageBoxOK","OK", width = 160)
    ),
    easyClose = FALSE
  ))
}


server <- function(input, output, session) {
  cat('\n###Server Start###\n')
  
  # [Box_Selection] ###############
  output$title_panel_selection <- renderText({"Selection"})
  
  output$table_sele_1 <- DT::renderDataTable({
    DT::datatable(dfSel, 
                  options = list(pageLength = 15),
                  selection = 'single')
  })
  
  output$table_sele_2 <- DT::renderDataTable({
    DT::datatable(dfSimi, 
                  options = list(pageLength = 15, stateSave = TRUE),
                  selection = list(mode = 'multiple', selected = selectedRowsTab2))
  })
  
  proxyC1T1 <- DT::dataTableProxy("table_sele_1")
  proxyC1T2 <- DT::dataTableProxy("table_sele_2")
  
  # [Button_Search]:
  observeEvent(input$btnSearch, {
    cat("\n#btnSearch:")
    ### Simulate running time of calling a function: ###
    Sys.sleep(1)
    
    dfSel <<- dfRaw[,c(1,2)]  
    output$table_sele_1 <- DT::renderDataTable({
      DT::datatable(dfSel, options = list(pageLength = 15))
    })    
    
  })
  
  # [Button_Reset_Selection]:
  observeEvent(input$btnSelectReset, {
    cat("\n#btnSelectReset:")
    proxyC1T1 %>% selectRows(NULL)
    # selectRows(proxyC1T1, NULL)
    proxyC1T2 %>% selectRows(NULL)
    # selectRows(proxyC1T2, NULL)
  })
  
  
  
  # [Box_Plot] ###############
  output$title_panel_plot <- renderText({"Plot"})
  
  observeEvent(input$btnPlot,{
    cat("\n#btnPlot:")
    if (length(input$table_sele_1_rows_current) > 0){
      selectedRowsTab1 <<- input$table_sele_1_rows_selected
      cat("\n$selectedRowsTab1=",selectedRowsTab1)
    }
    if (length(input$table_sele_2_rows_current) > 0){
      selectedRowsTab2 <<- input$table_sele_2_rows_selected
      cat("\n$selectedRowsTab2=",selectedRowsTab2)
    }
    
    if (is.null(selectedRowsTab1))
    {
      output$title_panel_selection <- renderText("Selection")
      messagebox("Notification","Error!","No selection is valid")
    }
    else
    {
      output$title_panel_selection <- renderText(paste0("Selection - ", length(selectedRowsTab1)))
    }
    
    
    output$plot_1 <- renderPlot({
      g <- make_ring(10)
      plot.igraph(g, layout=layout_with_kk, vertex.color="green")
    })
  })
  
  
  # [Box_Details] ###############
  
  output$table_detail_1 <- DT::renderDataTable({
    DT::datatable(dfSel, options = list(pageLength = 3))
  })
  
  
  

  # [Misc Events] ###############  
  observeEvent(input$btnMessageBoxOK,{
    removeModal()
  })  
  

  # Stop server after brower closed ################
  session$onSessionEnded(function() {
    stopApp(message("\n\nShiny App Stopped!\n"))
  })
  
}



# Shiny main loop ------------------------------
options(shiny.port = 7777)
shinyApp(ui, server)
