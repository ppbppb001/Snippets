#-------------------------------------------
#  Decorate XLSX file
#    - v1.0 2019-04-24
#-------------------------------------------


library("xlsx")

data("iris")
df.iris <- iris


#---[Plan-1] Write data frame to XLS then load it to workbook ---
write.xlsx(df.iris, file = "iris-test.xlsx",
                    sheetName = "Iris-test",
                    row.names = FALSE)
wb <- loadWorkbook("iris-test.xlsx")
sheets <- getSheets(wb)
sheet <- sheets[[1]]
rowcnt <- length(getCells(row = getRows(sheet), colIndex = 1))
colcnt <- length(getCells(row = getRows(sheet, rowIndex = 1)))


#---[Plan-2] Create workbook from data frame ----
# wb <- createWorkbook()
# sheet <- createSheet(wb, sheetName = "Iris-1")
# addDataFrame(df.iris, sheet, row.names = FALSE)


#--- Plot background stripes ---
color1 <- "#f7fbff"
color2 <- "#c6dbef"
fi1 <- Fill(foregroundColor = color1)  # setup light stripe
cs1 <- CellStyle(wb, fill = fi1)
fi2 <- Fill(foregroundColor = color2)  # setup dark stripe
cs2 <- CellStyle(wb, fill = fi2)

# Traverse rows and paint the stripes
for (i in 2:rowcnt) {
  rows <- getRows(sheet, rowIndex = i)
  cells <- getCells(rows, colIndex = 2:5)  # get cells other than those of col-1
  if (bitwAnd(i,1) == 0){
    lapply(names(cells),
           function(x) setCellStyle(cells[[x]], cs1))  # Rows with even index
  } else {
    lapply(names(cells),
           function(x) setCellStyle(cells[[x]], cs2))  # Rows with odd index
  }
}


#--- Plot Color shades to reflect the values ---
valmin <- min(df.iris[1], na.rm = TRUE)
valmax <- max(df.iris[1], na.rm = TRUE)
ss <- seq(valmin, valmax, by=(valmax-valmin)/5)  # Levels of shade

# colors copied from "http://colorbrewer2.org":
# colorshade <- c("#e5f5f9", 
#                 "#ccece6", 
#                 "#99d8c9",
#                 "#66c2a4",
#                 "#41ae76",
#                 "#238b45",
#                 "#006d2c"
#                 )  # palette of shade
css <- c(
         list(CellStyle(wb, fill = Fill(foregroundColor = "#319d7c"))),
         list(CellStyle(wb, fill = Fill(foregroundColor = "#43ab85"))),
         list(CellStyle(wb, fill = Fill(foregroundColor = "#51be96"))),
         list(CellStyle(wb, fill = Fill(foregroundColor = "#66c2a4"))),
         list(CellStyle(wb, fill = Fill(foregroundColor = "#99d8c9"))),
         list(CellStyle(wb, fill = Fill(foregroundColor = "#ccece6"))), 
         list(CellStyle(wb, fill = Fill(foregroundColor = "#e5f5f9"))) 
        )  # background colors of cell to reflect the levels

rows <- getRows(sheet, rowIndex = 2:rowcnt)
cells <- getCells(rows, colIndex = 1)  # cells of col-1
values <- lapply(cells, getCellValue)     
for (ix in names(values)) {
  x <- as.numeric(values[ix])    # x = value of the cell
  ic <- findInterval(x, ss)      # ic = index of level
  if (x >= 5) {
    setCellStyle(cells[[ix]], css[[ic]])
  } else {
    # any value less than 5 is marked in red
    setCellStyle(cells[[ix]], 
                 css[[ic]] + Font(wb,color = "yellow", isBold = TRUE, isItalic = TRUE))
  }
}

# blues <- NULL
# reds <- NULL
# lapply(names(cells[blues]),
#        function (x) setCellStyle(cells[[x]], cs12))
# lapply(names(cells[reds]),
#        function (x) setCellStyle(cells[[x]], cs22))


#--- Decorate the columin names (1st row) ---
rows <- getRows(sheet, rowIndex = 1) # rows = row no.1
cells <- getCells(rows)  # cells of row-1
cstitle <- CellStyle(wb, fill = Fill(foregroundColor = "gold"),
                         font = Font(wb, color = "darkgreen", isBold = TRUE),
                         alignment = Alignment(h = "ALIGN_CENTER", v = "VERTICAL_CENTER"))
                        # cell style of title
lapply(names(cells),
       function(x) setCellStyle(cells[[x]], cstitle))  # apply the cell style to cells of title
setRowHeight(rows, multiplier = 1.5)  # set to 1.5 times of default row height


#--- Adjust column width ---
autoSizeColumn(sheet, colIndex = 1:colcnt)


#--- Save result to another XLS file ---
saveWorkbook(wb, file = "iris-test-decorate.xlsx")



