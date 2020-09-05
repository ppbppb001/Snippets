library(shiny)
library(shinydashboard)
library(DT)
# library(shinydashboardPlus)
library(ggplot2)
library(visNetwork)
library(igraph)

setwd('D:\\User\\StudyAndTest\\R\\Shiny')

data("iris")

selectedSrcRows <- NULL

dfRaw = read.csv('IER_simu_data1.csv')
dfSel = dfRaw[,c(1,2)]



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
  
          tags$head(
            tags$style(
              type="text/css",
              ".datatables {font-size: 90%}
              .main-header.logo {width: 300px}"
            )
          ),
  
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
                          id = "panel_c1r1",
                          title = "Selection", status = "primary", solidHeader = TRUE,
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
                            tabPanel("Seletion-1", DT::dataTableOutput("table_sele_1")),
                            tabPanel("Seletion-2", 
                                     actionButton("btnX", label = "Button",
                                                  style = "width: 120px; margin-bottom: 12px; font-weight: bold"),
                                     DT::dataTableOutput("table_sele_2"))
                          )
                      )

                    ),

                    column(
                      width = 8,
                      style = "padding: 0px; margin: 0px;",
                      
                      box(
                        width = 12,
                        id = "panel_c2r1",
                        title = "Output", status = "success", solidHeader = TRUE,
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

server <- function(input, output, session) {

  
  # [Box_Selection] ###############
  
  output$table_sele_1 <- DT::renderDataTable({
    DT::datatable(dfSel, options = list(pageLength = 15))
  })
  
  output$table_sele_2 <- DT::renderDataTable({
    DT::datatable(iris, options = list(pageLength = 15))
  })
  
  proxyC1T1 <- DT::dataTableProxy("table_sele_1")
  proxyC1T2 <- DT::dataTableProxy("table_sele_2")
  observeEvent(input$btnSelectReset, {
    proxyC1T1 %>% selectRows(NULL)
    proxyC1T2 %>% selectRows(NULL)
  })
  

  # [Box_Plot] ###############
  
  observeEvent(input$btnPlot,{
    selectedSrcRows <- input$table_sele_1_rows_selected
    cat("[",selectedSrcRows,"]")
    
    output$plot_1 <- renderPlot({
      g <- make_ring(10)
      plot.igraph(g, layout=layout_with_kk, vertex.color="green")
    })
  })
  
  
  # [Box_Details] ###############
  
  output$table_detail_1 <- DT::renderDataTable({
    DT::datatable(dfSel, options = list(pageLength = 3))
  })
  
  
  
  

  # Stop server after brower closed
  session$onSessionEnded(function() {
    stopApp(message("Shiny App Stopped!"))
  })
  
}



# Shiny main loop ------------------------------
options(shiny.port = 7777)
shinyApp(ui, server)
