# Gerekli kütüphaneleri yükle
if (!require("shiny")) install.packages("shiny")
if (!require("GEOquery")) install.packages("GEOquery")
if (!require("shinydashboard")) install.packages("shinydashboard")

library(shiny)
library(GEOquery)
library(shinydashboard)

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
    box(title = "Birleştirilmiş Veri", width = 6, solidHeader = TRUE, tableOutput("mergedTable"))
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
    
    # NA değerleri temizle
    cleanedData1 <- na.omit(gse1Data)
    cleanedData2 <- na.omit(gse2Data)
    
    # Temizlenmiş veriyi ekranda göster
    output$cleanedTable <- renderTable({
      head(cleanedData1)
    })
  })
  
  # Birleştirme butonu için tepki
  observeEvent(input$mergeBtn, {
    # Temizlenmiş GSE verilerini al
    cleanedData1 <- na.omit(getGSE(input$gse1))
    cleanedData2 <- na.omit(getGSE(input$gse2))
    
    # İki veriyi birleştir
    mergedData <- merge(cleanedData1, cleanedData2, by = "row.names", all = TRUE)
    rownames(mergedData) <- mergedData$Row.names
    mergedData <- mergedData[, -1]
    
    # Birleştirilmiş veriyi ekranda göster
    output$mergedTable <- renderTable({
      head(mergedData)
    })
  })
}

# Uygulamayı çalıştır
shinyApp(ui, server)
