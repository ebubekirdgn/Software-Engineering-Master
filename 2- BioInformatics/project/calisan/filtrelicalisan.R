# Gerekli kütüphaneleri yükle
if (!require("shiny")) install.packages("shiny")
if (!require("GEOquery")) install.packages("GEOquery")
if (!require("shinydashboard")) install.packages("shinydashboard")
if (!require("plotly")) install.packages("plotly")
if (!require("DT")) install.packages("DT")
if (!require("openxlsx")) install.packages("openxlsx")
if (!require("genefilter")) install.packages("genefilter")
if (!require("Biobase")) install.packages("Biobase")
if (!require("caret")) install.packages("caret")
if (!require("hgu133plus2.db")) install.packages("hgu133plus2.db")

library(shiny)
library(GEOquery)
library(shinydashboard)
library(plotly)
library(DT)
library(hgu133plus2.db)
library(genefilter)
library(openxlsx)
library(Biobase)
library(caret)

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
    actionButton("excelBtn", "Excele Aktar"),
    actionButton("importExcelBtn", "Excel İçe Aktar"),
    selectInput("filterMethod", "Filtreleme Yöntemi:", choices = c("nsFilter", "varFilter")),
    actionButton("filterBtn", "Filtrele"),
    selectInput("mlAlgorithm", "Makine Öğrenmesi Seçimi:",
                choices = c("knn", "lda", "rf", "lm", "glm", "svmLinear", "gbm", "neuralnet", "glmnet", "xgbTree", "glmnet", "kmeans")),
    actionButton("trainBtn", "Eğit"),
    # Sonuç butonu
    actionButton("resultBtn", "Sonuç")
  ),
  dashboardBody(
    box(title = "İlk GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse1Table")),
    box(title = "İkinci GSE Verisi", width = 6, solidHeader = TRUE, tableOutput("gse2Table")),
    box(title = "Birleştirilmiş Veri", width = 12, solidHeader = TRUE, DTOutput("mergedTable")),
    box(title = "Filtrelenmiş", width = 12, solidHeader = TRUE, DTOutput("filteredGSE1Table")),
    box(title = "Sonuç", width = 12, solidHeader = TRUE, DTOutput("featureImportanceTable")),
    box(title = "En Önemli Gen", width = 12, solidHeader = TRUE, verbatimTextOutput("topGenes"))
  )
)

# Server oluştur
server <- function(input, output, session) {
  
  values <- reactiveValues(
    merged_df = NULL,
    gse1Data = NULL,
    gse2Data = NULL,
    birlestirilmis_data = NULL,
    sonveri = NULL,
    birlestirilmis_durum = NULL,
    feature_importance = NULL
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
    values$birlestirilmis_data <- cbind(common_data_gse1, common_data_gse2)
    print(class(values$birlestirilmis_data))
    
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
    values$birlestirilmis_durum <- read.xlsx("veri_cercevesi.xlsx")
    
    # Ekrana yazdır
    output$mergedTable <- renderDT({
      datatable(values$birlestirilmis_durum, 
                options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
    })
  })
  
  # Eğit butonu için tepki
  observeEvent(input$trainBtn, {
    selectedAlgorithm <- input$mlAlgorithm
    
    if (is.null(values$birlestirilmis_data)) {
      return(NULL)
    }
    
    # Eğitim veri çerçevesini oluştur
    data_frame1 <- as.data.frame(values$sonveri)
    data_frame1$durum <- values$birlestirilmis_durum 
    data_frame1$durum <- as.factor(data_frame1$durum$durum_gse1)
    
    # Modeli eğit
    model <- train(durum ~ ., data = data_frame1, method = selectedAlgorithm)
    
    # Özellik önem sıralamasını al
    values$feature_importance <- as.data.frame(varImp(model)$importance)
    
    # Sonucu ekrana datatable olarak yazdır
    output$featureImportanceTable <- renderDT({
      datatable(values$feature_importance, 
                options = list(lengthMenu = c(5, 10, 20), pageLength = 5))
    })
  })
  
  # Sonuç butonu için tepki
  observeEvent(input$resultBtn, {
    req(values$feature_importance)
    
    # Seçilecek özellik adlarını al ve X harfini sil
    
    
    selected_features <- gsub("^X", "", head(rownames(values$feature_importance)[order(-values$feature_importance$Overall)][1:6]))
    
    # Veritabanından ilgili gen bilgilerini al
    gene_info <- select(hgu133plus2.db, keys = selected_features, columns = c("PROBEID", "SYMBOL", "GENENAME"))
    
    # En Önemli Geni yazdır
    print("En Önemli Genler:")
    print(gene_info)
  })
  
  # Filtrele butonu için tepki
  observeEvent(input$filterBtn, {
    selectedFilter <- input$filterMethod
    eset1 <- ExpressionSet(assayData = values$birlestirilmis_data)
    annotation(eset1) <- "hgu133plus2.db"
    if (selectedFilter == "nsFilter") {
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
      values$sonveri <- data.frame(t(exprs(filtrelenmis1$eset)))
      
    } else if (selectedFilter == "varFilter") {
      
      eset1 <- ExpressionSet(assayData = values$birlestirilmis_data)
      varFilter(eset1, var.func=IQR, var.cutoff=0.5, filterByQuantile=TRUE)
      
      filtrelenmis1<- varFilter(eset1,var.cutoff = 0.90)
      values$sonveri <- data.frame(filtrelenmis1)
    }
    
    # Filtrelenmiş GSE verilerini ekranda göster
    output$filteredGSE1Table <- renderDT({
      datatable(values$sonveri, options = list(scrollX = TRUE, scrollY = TRUE))
    })
  })
  
}

# Uygulamayı çalıştır
shinyApp(ui, server)
