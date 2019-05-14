#-------------------------------------------
#  Decorate XLSX file by 'openxlsx' pacakge
#    - v1.0 2019-05-14
#-------------------------------------------


library("openxlsx")

data("iris")
df.iris <- iris


#---[Plan-1] Write data frame to XLS then load it to workbook ---
write.xlsx(df.iris, file = "iris-test2.xlsx",
           sheetName = "Iris",
           row.names = FALSE)
wb <- loadWorkbook("iris-test2.xlsx")


#---[Plan-2] Create workbook from data frame ----
# wb <- createWorkbook()
# addWorksheet(wb, "Iris")
# writeData(wb, sheet = 1, df.iris)
# saveWorkbook(wb,"iris-test2.xlsx", overwrite = TRUE)


#--- Load xlsx file into data frame ---
df <- readWorkbook("iris-test2.xlsx")
rowcnt <- length(df[,1])
colcnt <- length(df[1,])


#--- Plot background stripes ---
color1 <- "#f7fbff"
color2 <- "#c6dbef"
style1 <- createStyle(fgFill = color1) # style for odd line number
style2 <- createStyle(fgFill = color2) # style for even line number
rows1 <- as.integer(seq(from=2, to=rowcnt+1, by=2))  # odd rows
rows2 <- as.integer(seq(from=3, to=rowcnt+1, by=2))  # even rows
for (i in 1:colcnt) {
    addStyle(wb, sheet = 1, 
             cols = i, rows = rows1, 
             style = style1)
    addStyle(wb, sheet = 1, 
             cols = i, rows = rows2, 
             style = style2)
} 


#--- Plot Color shades to reflect the values ---
valmin <- min(df.iris[1], na.rm = TRUE)
valmax <- max(df.iris[1], na.rm = TRUE)
ss <- seq(valmin, valmax, by=(valmax-valmin)/5)  # Levels of shade
css <- c(
            createStyle(fgFill = "#319d7c"),
            createStyle(fgFill = "#43ab85"),
            createStyle(fgFill = "#51be96"),
            createStyle(fgFill = "#66c2a4"),
            createStyle(fgFill = "#99d8c9"),
            createStyle(fgFill = "#ccece6"), 
            createStyle(fgFill = "#e5f5f9")
        )  # background colors of cell to reflect the levels
style3 <- createStyle(fontColour = "yellow", textDecoration = "bold")
values <- df[,1]
for (i in 1:rowcnt) {
    x <- df[i,1]
    ix <- findInterval(x, ss)
    addStyle(wb, sheet=1, cols=1, rows=i+1, style = css[[ix]])  # mark the value by color shades
    if (x>=5) {
        addStyle(wb, sheet=1, cols=1, rows=i+1, style=style3, stack = TRUE ) # mark special value with bold font
    }
}


#--- Decorate the columin names (1st row) ---
styleTitle <- createStyle(fontColour = "darkgreen", textDecoration = "bold", 
                          halign = "center", valign = "center",
                          fgFill = "gold")
addStyle(wb, sheet=1, cols=1:colcnt, rows=1, style=styleTitle)
setRowHeights(wb, sheet=1, rows=1, heights=20)  # default height defined by excel is '15'

#--- Adjust column width ---
setColWidths(wb, sheet=1, cols=1:colcnt, widths="auto")

#--- Save result to another XLS file ---
saveWorkbook(wb,"iris-test-decorate2.xlsx", overwrite = TRUE)

