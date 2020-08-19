library(shiny)
library(shinydashboard)
library(shinyjs)
library(ggplot2)
library(visNetwork)



# SERVER -------------------------------------------------

## show data tables
dataSource <- function(input, output){
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

## show ggplot2 test plot ------------------------------------------------------------
ggplot2Test1 <- function(input, output){
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
    }
  )
  
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
ggplot2Test2 <- function(input, output, session){
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
      dfx <- data.frame(Company=x, Value=y, Year=z)   # compose a data frame
      
      output$tab51plot <- renderPlot({
        df <- dfx
        p <- ggplot(df, aes(x=Company, y=Value, fill=Year)) +           # colored ribon for each year
          geom_area() +                                       # area fill (ribon)
          labs(x="X=COMPANY", y="Y=VALUE", title="TITLE") +   # x/y labels and title
          theme(plot.title = element_text(hjust=0.5))         # center the title
        p + scale_fill_brewer(palette = input$tab51palette)
      })
      
      output$tab51output <- renderText({
        # c("PlotWidth =", session$clientData$output_tab51plot_width, "| idSize =",idSize, "| Palette = ",input$tab51palette)
        c("SessionToken =", session$token, "| idSize =",idSize, "| Palette = ",input$tab51palette)
      })
      
      output$tab51data <- DT::renderDataTable({
        dfx
      })
    }
  )
  
  # output$tab51output <- renderText({
  #   idFrom <- input$tab51from
  #   idTo <- input$tab51to
  #   idSize <- idTo - idFrom + 1
  #   c("idSize =",idSize, "| Palette = ",input$tab51palette)
  # })
  
  # output$tab51plot <- renderPlot({
  #   idFrom <- input$tab51from
  #   idTo <- input$tab51to
  #   df <- df.tab5
  #   p <- ggplot(df, aes(x=Company, y=Value, fill=Year)) +           # colored ribon for each year
  #     geom_area() +                                       # area fill (ribon)
  #     labs(x="X=COMPANY", y="Y=VALUE", title="TITLE") +   # x/y labels and title
  #     theme(plot.title = element_text(hjust=0.5))         # center the title
  #   p + scale_fill_brewer(palette = input$tab51palette)
  # })
  
  # output$tab51data <- DT::renderDataTable(df.tab5)
  # output$tab51data <- DT::renderDataTable({
  #   idFrom <- input$tab51from
  #   idTo <- input$tab51to
  #   df.tab5
  # })
  
}

## show visnetwork test plot  ------------------------------------------------------------
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


## Settings ------------------------------------------------------------
settings <- function(input, output, session){
  
  # Confirm and Save
  observeEvent(input$settingSave,
    {
      setSettingValue("TDHost", trimws(as.character(input$settingTDHost)))
      # setSettingValue("TDHostPort", trimws(as.character(input$settingTDHostPort)))
      setSettingValue("TDUser", trimws(as.character(input$settingTDUser)))
      setSettingValue("TDPassword", trimws(as.character(input$settingTDPassword1)))
      setSettingValue("TDPassword2", trimws(as.character(input$settingTDPassword2)))
      
      rs <- checkSettings()
      rsn <- length(rs)
      
      if (rsn <= 0){
        iconname <- "check"
        addClass("settingSave", "colorGreen")
        saveSettings()  # Save settings to file
      } else {
        iconname <- "times"
        addClass("settingSave", "colorRed")
      } 
      updateActionButton(session, "settingSave", "Confirm & Save", icon = icon(iconname))
      
      
      output$settingMsg <- renderText({
        addClass("settingMsg", "colorRed")
        paste(rs, collapse ='\n')
      })
    }
  )
  
  # Test connection
  observeEvent(input$settingTDTest, {
    # print (input$settingTDHost)
    # print (input$settingTDUser)
    # print (input$settingTDPassword1)
    # print (tdDatabase[[1]])
    r <- dbLogon(input$settingTDHost,
                 input$settingTDUser,
                 input$settingTDPassword1,
                 tdDatabase[[1]])
    # print(r)
    if (r) {
      updateActionButton(session, "settingTDTest",
                         "Test connection ... Successful",
                         icon = icon("check"))
      addClass(id="settingTDTest", class = "colorGreen")
    } else {
      updateActionButton(session, "settingTDTest",
                         "Test connection ... Failed",
                         icon = icon("times"))
      addClass(id="settingTDTest", class = "colorRed")
    }
    dbLogout()
  })
  
  # Watching the input
  observeEvent({
      input$settingTDHost
      input$settingTDUser
      input$settingTDPassword1
      input$settingTDPassword2
    },
    { 
      updateActionButton(session, "settingTDTest", 
                         "Test connection", 
                         icon = character(0))
      removeClass("settingTDTest", "colorGreen")
      removeClass("settingTDTest", "colorRed")
      updateActionButton(session, "settingSave", 
                         "Confirm & Save", 
                         icon = character(0))
      removeClass("settingSave", "colorGreen")
      removeClass("settingSave", "colorRed")
    }
  )
  
  # observeEvent({
  #   input$settingTDHost
  #   input$settingTDUser
  #   input$settingTDPassword1
  #   input$settingTDPassword2
  # },
  # { 
  #   output$settingMsg <- renderText({""}) 
  # }
  # )
}



## Server
server <- function(input, output, session) {
  
  dataSource(input, output)
  
  ggplot2Test2(input, output, session)
  
  visNetworkTest(input, output)
  
  settings(input, output, session)
  
  # Stop server after brower closed
  session$onSessionEnded(function() {
    stopApp(message("Shiny App Stopped!"))
  })
}
