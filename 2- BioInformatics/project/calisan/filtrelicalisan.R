# Gerekli kütüphaneleri yükle
if (!require("shiny")) install.packages("shiny")
if (!require("GEOquery")) install.packages("GEOquery")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("plotly")) install.packages("plotly")
if (!require("DT")) install.packages("DT")
if (!require("openxlsx")) install.packages("openxlsx")

library(shiny)
library(GEOquery)
library(shinydashboard)
library(plotly)
library(DT)
library(genefilter)
library(openxlsx)

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
    textInput("gse1", "İlk GSE Veri Numarası:", value = "GSE3467"),
    textInput("gse2", "İkinci GSE Veri Numarası:", value = "GSE6004"),
    selectInput("columnSelect1", "Sütun Seç 1:", choices = NULL),
    selectInput("columnSelect2", "Sütun Seç 2:", choices = NULL),
    actionButton("submitBtn", "Verileri Getir"),
    actionButton("mergeBtn", "Birleştir"),
    actionButton("excelBtn", "Excele Aktar"),  # Excele Aktar butonu eklendi
    actionButton("importExcelBtn", "Excel İçe Aktar")  # Excel İçe Aktar butonu eklendi
  ),
  dashboardBody(
    box(title = "İlk GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse1Table")),
    box(title = "İkinci GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse2Table")),
    box(title = "Birleştirilmiş Veri", width = 12, solidHeader = TRUE, DTOutput("mergedTable"))
  )
)

# Server oluştur
server <- function(input, output, session) {
  
  values <- reactiveValues(
    merged_df = NULL
  )
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
    
    # values içindeki gse1Data ve gse2Data'yi güncelle
    values$gse1Data <- gse1Data
    values$gse2Data <- gse2Data
  })
  
  # Birleştirme butonu için tepki
  observeEvent(input$mergeBtn, {
    # Gerekli verilere ulaş
    gse1Data <- values$gse1Data
    gse2Data <- values$gse2Data
    
    gen1 <- gse1Data$exprs
    gen2 <- gse2Data$exprs
    
    common_gene <- intersect(rownames(gen1), rownames(gen2))
    
    common_data_gse1 <- gen1[common_gene, ]
    common_data_gse2 <- gen2[common_gene, ]
    
    # İki veri setini birleştirin
    birlestirilmis_data <- cbind(common_data_gse1, common_data_gse2)
    
    selected_column_gse1 <- input$columnSelect1
    selected_column_gse2 <- input$columnSelect2
    
    # Sınıf etiketlerini al
    durum_gse1 <- factor(pData(gse1Data$exprs1)[, selected_column_gse1])
    durum_gse2 <- factor(pData(gse2Data$exprs1)[, selected_column_gse2])
    
    # Faktörleri içeren iki veri çerçevesi oluştur
    df1 <- data.frame(durum_gse1)
    df2 <- data.frame(durum_gse2)
    
    # Birleştirilmiş veri çerçevesini güncelle
    values$merged_df <- cbind(df1, df2)
    
    # Ekrana yazdır
    output$mergedTable <- renderDT({
      datatable(head(values$merged_df), 
                options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
    })
    
  })
  
  # Excele Aktar butonu için tepki
  observeEvent(input$excelBtn, {
    # Dosyayı bulunduğunuz klasöre kaydet
    if (!is.null(values$merged_df)) {
      write.xlsx(values$merged_df, file = "veri_cercevesi.xlsx")
    }
  })
  
  # Excel İçe Aktar butonu için tepki
  observeEvent(input$importExcelBtn, {
    # Önceki Excele Aktar işlemi sonucu oluşan dosyayı oku
    birlestirilmis_durum <- read.xlsx("veri_cercevesi.xlsx")
    
    # Ekrana yazdır
    output$mergedTable <- renderDT({
      datatable(birlestirilmis_durum, 
                options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
    })
  })
}

# Uygulamayı çalıştır
shinyApp(ui, server)
