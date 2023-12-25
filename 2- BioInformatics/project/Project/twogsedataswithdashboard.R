library(shiny)
library(GEOquery)
library(shinydashboard)
library(plotly)
library(DT)

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
    textInput("gse1", "İlk GSE Veri Numarası:", value = ""),
    textInput("gse2", "İkinci GSE Veri Numarası:", value = ""),
    selectInput("columnSelect1", "Sütun Seç 1:", choices = NULL),
    selectInput("columnSelect2", "Sütun Seç 2:", choices = NULL),
    actionButton("submitBtn", "Verileri Getir"),
    actionButton("StunBtn", "Pdata Getir"),
    actionButton("mergeBtn", "Merge Cleaned Data"),
    actionButton("pdataMergeBtn", "PData Merge")  # PData Merge butonu eklendi
  ),
  dashboardBody(
    box(title = "İlk GSE Verisi", width = 6, solidHeader = TRUE, DTOutput("gse1Table")),
    box(title = "İkinci GSE Verisi", width = 6, solidHeader = TRUE, DTOutput("gse2Table")),
    box(title = "Pdata veri 1", width = 6, solidHeader = TRUE, DTOutput("PdataTable")),
    box(title = "Pdata veri 2", width = 6, solidHeader = TRUE, DTOutput("PdataTable1")),
    box(title = "Birleştirilmiş Veri", width = 6, solidHeader = TRUE, DTOutput("mergedTable")),
    box(title = "Birleştirilmiş Pdata", width = 6, solidHeader = TRUE, DTOutput("mergedPDataTable")), # Ekran için yeni bir tablo eklendi
    box(title = "Görselleştirme", width = 12, solidHeader = TRUE, plotlyOutput("mergedPlot")),
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
    tryCatch({
      gse1Data <- getGSE(input$gse1)
      gse2Data <- getGSE(input$gse2)
      
      colnames_pdata <- colnames(gse1Data$exprs1@phenoData@data)
      colnames_pdata1 <- colnames(gse2Data$exprs1@phenoData@data)
      updateSelectInput(session, "columnSelect1", choices = colnames_pdata)
      updateSelectInput(session, "columnSelect2", choices = colnames_pdata1)
      
      output$gse1Table <- renderDT({
        datatable(head(gse1Data$exprs), options = list(pageLength = 10))
      })
      
      output$gse2Table <- renderDT({
        datatable(head(gse2Data$exprs), options = list(pageLength = 10))
      })
    }, error = function(e) {
      showModal(
        modalDialog(
          title = "Hata",
          "Veri alma sırasında bir hata oluştu. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.",
          easyClose = TRUE,
          footer = NULL
        )
      )
      shinyjs::reset("errorButton")
      shinyjs::enable("errorButton")
      shinyjs::runjs('Shiny.onInputChange("error", true);')
    })
  })
  
  observeEvent(input$StunBtn, {
    gse1Data <- getGSE(input$gse1)
    gse2Data <- getGSE(input$gse2)
    selected_column1 <- input$columnSelect1
    selected_column2 <- input$columnSelect2
    output$PdataTable <- renderDT({
      datatable(as.data.frame(gse1Data$exprs1@phenoData@data[, selected_column1]), options = list(scrollX = TRUE, scrollY = TRUE, pageLength = 10))
    })
  })
  
  observeEvent(input$pdataMergeBtn, {
    gse1Data <- getGSEData()$gse1Data
    gse2Data <- getGSEData()$gse2Data
    selected_column1 <- input$columnSelect1
    selected_column2 <- input$columnSelect2
    
    pdata1 <- gse1Data$exprs1@phenoData@data[, selected_column1]
    pdata2 <- gse2Data$exprs1@phenoData@data[, selected_column2]
    
    # PData1 ve PData2'yi alt alta birleştir
    mergedPData <- rbind(
      data.frame(PData = pdata1),
      data.frame(PData = pdata2)
    )
    
    # Birleştirilmiş PData'yı yazdır
    output$mergedPDataTable <- renderDT({
      datatable(mergedPData, options = list(scrollX = TRUE, scrollY = TRUE, pageLength = 10))
    })
  })
  
  observeEvent(input$mergeBtn, {
    cleanedData1 <- getGSEData()$gse1Data$exprs[complete.cases(getGSEData()$gse1Data$exprs), ]
    cleanedData2 <- getGSEData()$gse2Data$exprs[complete.cases(getGSEData()$gse2Data$exprs), ]
    
    mergedData <- dplyr::bind_rows(
      data.frame(ID = rownames(cleanedData1), cleanedData1),
      data.frame(ID = rownames(cleanedData2), cleanedData2),
      .id = "Source"
    )
    
    output$mergedTable <- renderDT({
      datatable(head(mergedData), options = list(pageLength = 10))
    })
    
    output$mergedPlot <- renderPlotly({
      plot_ly(data = mergedData, x = ~ID, y = ~`ID`, type = 'scatter', mode = 'lines+markers', color = ~Source)
    })
  })
  
  observe({
    shinyjs::enable("errorButton")
  })
  
  observeEvent(input$error, {
    if (input$error) {
      showModal(
        modalDialog(
          title = "Hata",
          "Veri alma sırasında bir hata oluştu. Lütfen bağlantınızı kontrol edin ve tekrar deneyin.",
          easyClose = TRUE,
          footer = NULL
        )
      )
      shinyjs::reset("errorButton")
      shinyjs::enable("errorButton")
      shinyjs::runjs('Shiny.onInputChange("error", false);')
    }
  })
}

# Uygulamayı çalıştır
shinyApp(ui, server)
