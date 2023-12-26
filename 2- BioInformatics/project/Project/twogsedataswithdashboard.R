# Gerekli kütüphaneleri yükle
if (!require("shiny")) install.packages("shiny")
if (!require("GEOquery")) install.packages("GEOquery")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("plotly")) install.packages("plotly")
if (!require("DT")) install.packages("DT")

library(shiny)
library(GEOquery)
library(shinydashboard)
library(plotly)
library(DT)
library(genefilter)

getGSE <- function(gseNumber) {
  gse <- getGEO(gseNumber, GSEMatrix = TRUE, AnnotGPL = TRUE)
  exprs <- exprs(gse[[1]])
  exprs1 <- (gse[[1]])
  
  return(list(exprs = exprs, exprs1 = exprs1))
}

# UI oluştur
ui <- dashboardPage(
  dashboardHeader(title = "GSE Veri İşleme"),
  dashboardSidebar(
    textInput("gse1", "İlk GSE Veri Numarası:", value = "GSE1010"),
    textInput("gse2", "İkinci GSE Veri Numarası:", value = "GSE1009"),
    selectInput("columnSelect1", "Sütun Seç 1:", choices = NULL),
    selectInput("columnSelect2", "Sütun Seç 2:", choices = NULL),
    actionButton("submitBtn", "Verileri Getir"),
    actionButton("StunBtn", "Pdata Getir"),
    actionButton("cleanNABtn", "Clean NA Data"),
    actionButton("mergeBtn", "Merge Cleaned Data"),
    actionButton("filterBtn", "Filtrele")  # Yeni eklenen Filtrele butonu
  ),
  dashboardBody(
    box(title = "İlk GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse1Table")),
    box(title = "İkinci GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse2Table")),
    box(title = "Temizlenmiş Veri", width = 6, solidHeader = TRUE, tableOutput("cleanedTable")),
    box(title = "Pdata veri", width = 6, solidHeader = TRUE, DTOutput("PdataTable")),
    box(title = "Pdata veri", width = 6, solidHeader = TRUE, DTOutput("PdataTable1")),
    box(title = "Birleştirilmiş Veri", width = 6, solidHeader = TRUE, tableOutput("mergedTable")),
    box(title = "Görselleştirme", width = 12, solidHeader = TRUE, plotlyOutput("mergedPlot")),
    box(title = "Filtre GSE1", width = 6, solidHeader = TRUE, DTOutput("filteredGSE1Table")),  # Yeni eklenen Filtre GSE1 tablosu
    box(title = "Filtre GSE2", width = 6, solidHeader = TRUE, DTOutput("filteredGSE2Table"))   # Yeni eklenen Filtre GSE2 tablosu
  )
)

# Server oluştur
server <- function(input, output, session) {
  # GSE verilerini alma fonksiyonu
  getGSEData <- reactive({
    gse1Data <- getGSE(input$gse1)
    gse2Data <- getGSE(input$gse2)
    return(list(gse1Data = gse1Data, gse2Data = gse2Data))
  })
  
  # Veri alma butonu için tepki
  observeEvent(input$submitBtn, {
    # GSE verilerini al
    gse1Data <- getGSE(input$gse1)
    gse2Data <- getGSE(input$gse2)
    
    colnames_pdata <- colnames(gse1Data$exprs1@phenoData@data)
    colnames_pdata1 <- colnames(gse2Data$exprs1@phenoData@data)
    updateSelectInput(session, "columnSelect1", choices = colnames_pdata)
    updateSelectInput(session, "columnSelect2", choices = colnames_pdata1)
    
    # İlk GSE verisini ekranda göster
    output$gse1Table <- renderTable({
      head(gse1Data$exprs)  # Veri çerçevesini direkt göster
    })
    
    # İkinci GSE verisini ekranda göster
    output$gse2Table <- renderTable({
      head(gse2Data$exprs)  # Veri çerçevesini direkt göster
    })
  })
  
  # Filtrele butonu için tepki
  observeEvent(input$filterBtn, {
    gse1Data <- getGSEData()$gse1Data
    gse2Data <- getGSEData()$gse2Data
    
    # GSE verilerini nsFilter işlemine tabi tut
    eset1 <- gse1Data$exprs1
    annotation(eset1) <- "hgu133plus2.db"
    filtrelenmis1 <- nsFilter(
      eset1,
      require.entrez = TRUE,
      require.GOBP = FALSE,
      require.GOCC = FALSE,
      require.GOMF = FALSE,
      require.CytoBand = FALSE,
      remove.dupEntrez = TRUE,
      var.func = IQR,
      var.cutoff = 0.90,
      var.filter = TRUE,
      filterByQuantile = TRUE,
      feature.exclude = "^AFFX"
    )
    sonveri1 <- data.frame(t(exprs(filtrelenmis1$eset)))
    
    eset2 <- gse2Data$exprs1
    annotation(eset2) <- "hgu133plus2.db"
    filtrelenmis2 <- nsFilter(
      eset2,
      require.entrez = TRUE,
      require.GOBP = FALSE,
      require.GOCC = FALSE,
      require.GOMF = FALSE,
      require.CytoBand = FALSE,
      remove.dupEntrez = TRUE,
      var.func = IQR,
      var.cutoff = 0.90,
      var.filter = TRUE,
      filterByQuantile = TRUE,
      feature.exclude = "^AFFX"
    )
    sonveri2 <- data.frame(t(exprs(filtrelenmis2$eset)))
    
    # Filtrelenmiş GSE verilerini ekranda göster
    output$filteredGSE1Table <- renderDT({
      datatable(sonveri1, options = list(scrollX = TRUE, scrollY = TRUE))
    })
    
    output$filteredGSE2Table <- renderDT({
      datatable(sonveri2, options = list(scrollX = TRUE, scrollY = TRUE))
    })
  })
  
  # ... (Diğer kod parçacıkları)
}

# Uygulamayı çalıştır
shinyApp(ui, server)
