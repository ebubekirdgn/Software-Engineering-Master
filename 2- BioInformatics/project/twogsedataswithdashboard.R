# Gerekli kütüphaneleri yükle
if (!require("shiny")) install.packages("shiny")
if (!require("GEOquery")) install.packages("GEOquery")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("plotly")) install.packages("plotly")

library(shiny)
library(GEOquery)
library(shinydashboard)
library(plotly)

# UI oluştur
ui <- dashboardPage(
  dashboardHeader(title = "GSE Veri İşleme"),
  dashboardSidebar(
    textInput("gse1", "İlk GSE Veri Numarası:", value = ""),
    textInput("gse2", "İkinci GSE Veri Numarası:", value = ""),
    actionButton("submitBtn", "Verileri Getir"),
    actionButton("cleanNABtn", "Clean NA Data"),
    actionButton("mergeBtn", "Merge Cleaned Data")
  ),
  dashboardBody(
    box(title = "İlk GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse1Table")),
    box(title = "İkinci GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse2Table")),
    box(title = "Temizlenmiş Veri", width = 6, solidHeader = TRUE, tableOutput("cleanedTable")),
    box(title = "Birleştirilmiş Veri", width = 6, solidHeader = TRUE, tableOutput("mergedTable")),
    box(title = "Görselleştirme", width = 12, solidHeader = TRUE, plotlyOutput("mergedPlot"))
  )
)

# Server oluştur
server <- function(input, output, session) {
  # GSE verilerini alma fonksiyonu
  getGSE <- function(gseNumber) {
    gse <- getGEO(gseNumber, GSEMatrix = TRUE, AnnotGPL = TRUE)
    exprs <- exprs(gse[[1]])
    exprs <- exprs[, order(colnames(exprs))]
    return(exprs)
  }
  
  # Veri alma butonu için tepki
  observeEvent(input$submitBtn, {
    # GSE verilerini al
    gse1Data <- getGSE(input$gse1)
    gse2Data <- getGSE(input$gse2)
    
    # İlk GSE verisini ekranda göster
    output$gse1Table <- renderTable({
      head(gse1Data)
    })
    
    # İkinci GSE verisini ekranda göster
    output$gse2Table <- renderTable({
      head(gse2Data)
    })
  })
  
  # NA temizleme butonu için tepki
  observeEvent(input$cleanNABtn, {
    # GSE verilerini al
    gse1Data <- getGSE(input$gse1)
    gse2Data <- getGSE(input$gse2)
    
    # NA değerleri temizle (complete.cases kullanılarak)
    cleanedData1 <- gse1Data[complete.cases(gse1Data), ]
    cleanedData2 <- gse2Data[complete.cases(gse2Data), ]
    
    # Temizlenmiş veriyi ekranda göster
    output$cleanedTable <- renderTable({
      head(cleanedData1)
    })
  })
  
  # Birleştirme butonu için tepki
  observeEvent(input$mergeBtn, {
    # Temizlenmiş GSE verilerini al
    cleanedData1 <- getGSE(input$gse1)[complete.cases(getGSE(input$gse1)), ]
    cleanedData2 <- getGSE(input$gse2)[complete.cases(getGSE(input$gse2)), ]
    
    # İki veriyi birleştir (dplyr paketinden bind_rows kullanarak)
    mergedData <- dplyr::bind_rows(
      data.frame(ID = rownames(cleanedData1), cleanedData1),
      data.frame(ID = rownames(cleanedData2), cleanedData2),
      .id = "Source"
    )
    
    # Birleştirilmiş veriyi ekranda göster
    output$mergedTable <- renderTable({
      head(mergedData)
    })
    
    # Görselleştirme için plotly grafiği oluştur
    output$mergedPlot <- renderPlotly({
      plot_ly(data = mergedData, x = ~ID, y = ~`ID`, type = 'scatter', mode = 'lines+markers', color = ~Source)
    })
  })
}

# Uygulamayı çalıştır
shinyApp(ui, server)
