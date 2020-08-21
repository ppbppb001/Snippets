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
header <- dashboardHeader(title = "Shiny Prototype 1")
                          
## Sidebar contents
sidebar <- dashboardSidebar(
              collapsed = TRUE,
              sidebarMenu(
                  id = "sidebar",
                  menuItem("Page-1", tabName = "page_1", icon = icon("share-alt"))
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
              HTML('
                # .col-sm-4 {
                #   margin: 0px;
                #   padding: 0px;
                # }
                # .col-sm-8 {
                #   margin: 2px;
                #   padding: 2px;
                # }
                # .col-sm-12 {
                #   margin: 2px;
                #   padding: 2px;
                # }
                # .box {
                #   margin: 1px;
                #   padding: 1px;
                # }
                # .box-body {
                #   margin: 1px;
                #   padding: 1px;
                # }
              ')
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
                          style = "padding: 8px; margin: 0px; height: 90vh; background-color: #fafafa",
                          id = "panel_c1r1",
                          title = "Search Potential DUplicate by Similarity Metric", status = "primary", solidHeader = TRUE,
                          # collapsible = TRUE,
                          
                          actionButton("btnSelectReset","Reset Selection", 
                                       style = "width: 120px; margin: 12px; float: right; font-weight: bold"),
                          actionButton("btnSelect","Select", 
                                       style = "width: 120px; margin: 12px; float: right; font-weight: bold"),
                          # textOutput("lb_selectedRows"),
                          # verbatimTextOutput("lb_selectedRows2"),
                          
                          tabBox(
                            title = "Similarity",
                            id = "tabbox_r1c1",
                            width = 12,
                            tabPanel("Tabel-1", DT::dataTableOutput("table_c1t1")),
                            tabPanel("Tabel-2", DT::dataTableOutput("table_c1t2"))
                          )
                      )

                    ),

                    column(
                      width = 8,
                      style = "padding: 0px; margin: 0px;",
                      
                      box(
                        width = 12,
                        style = "padding: 8px; margin: 0px; height: 60vh; background-color: #fafafa",
                        id = "panel_c2r1",
                        title = "Outcome Plots", status = "success", solidHeader = TRUE,
                        # collapsible = TRUE,
                        
                        actionButton("btnPlotTest","Test", 
                                     style = "width: 120px; margin: 12px; float: right; font-weight: bold;"),
                        actionButton("btnPlot","Plot", 
                                     style = "width: 120px; margin: 12px; float: right; font-weight: bold;"),
                        
                        tabBox(
                          title = "Data Plots",
                          id = "tabbox_plots",
                          width = 12,
                          height = "52vh",
                          tabPanel("Plot-1", plotOutput("plot_1")),
                          tabPanel("Plot-2", plotOutput("plot_2"))
                        ),
                        
                      ),
                      
                      box(
                        width = 12,
                        style = "padding: 8px; margin: 4px; height: 25vh; background-color: #fafafa",
                        id = "panel_c2r2",
                        title = "Outcome Details", status = "warning", solidHeader = TRUE,
                        # collapsible = TRUE,
                        tabBox(
                          title = "Details",
                          id = "tabbox_details",
                          width = 12,
                          tabPanel("Tabel-1", DT::dataTableOutput("table_detail_1")),
                          tabPanel("Tabel-2", DT::dataTableOutput("table_detail_2"))
                        )
                      )
                      
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

server <- function(input, output, session) {

  
  # [Box_Selection] ###############
  
  output$table_c1t1 <- DT::renderDataTable({
    DT::datatable(dfSel, options = list(pageLength = 15))
  })
  
  output$table_c1t2 <- DT::renderDataTable({
    DT::datatable(diamonds, options = list(pageLength = 15))
  })
  
  # output$lb_selectedRows <- renderText("Selected Rows:")
  # output$lb_selectedRows2 <- renderText(" ")

  observeEvent(input$btnSelect, {
    selectedSrcRows <- input$table_c1t1_rows_selected
    cat(selectedSrcRows)
  })  
  
  proxyC1T1 <- DT::dataTableProxy("table_c1t1")
  observeEvent(input$btnSelectReset, {
    proxyC1T1 %>% selectRows(NULL)
  })
  

  # [Box_Plot] ###############
  
  observeEvent(input$btnPlot,{
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
