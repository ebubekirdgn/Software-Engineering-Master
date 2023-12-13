library(shiny)
library(GEOquery)
library(limma)
library(ggplot2)
library(shinyjs)

ui <- fluidPage(
  titlePanel("GSE Veri Çekme ve Feature Selection Uygulaması"),
  sidebarLayout(
    sidebarPanel(
      textInput("gse1", "İlk GSE Numarası:", value = ""),
      textInput("gse2", "İkinci GSE Numarası:", value = ""),
      actionButton("cek", "Verileri Çek"),
      textOutput("loading_message"),
      downloadButton("indir", "Verileri İndir"),
      actionButton("feature_selection", "Feature Selection")
    ),
    mainPanel(
      tableOutput("gse1_table"),
      tableOutput("gse2_table"),
      plotOutput("feature_selection_plot"),
      verbatimTextOutput("log_output")
    )
  )
)

server <- function(input, output, session) {
  gse1_data <- reactiveVal(NULL)
  gse2_data <- reactiveVal(NULL)
  operation_log <- reactiveVal(character())
  
  observeEvent(input$cek, {
    shinyjs::disable("cek")
    shinyjs::disable("gse1")
    shinyjs::disable("gse2")
    shinyjs::disable("feature_selection")
    shinyjs::disable("indir")
    output$loading_message <- renderText({
      "Loading..."
    })
    
    gse1_data_raw <- getGEO(input$gse1, GSEMatrix = TRUE, AnnotGPL = TRUE)
    gse2_data_raw <- getGEO(input$gse2, GSEMatrix = TRUE, AnnotGPL = TRUE)
    
    gse1_data(gse1_data_raw$data)
    output$gse1_table <- renderTable({
      gse1_data()
    })
    operation_log(c(operation_log(), paste("GSE", input$gse1, "verileri çekildi")))
    
    gse2_data(gse2_data_raw$data)
    output$gse2_table <- renderTable({
      gse2_data()
    })
    operation_log(c(operation_log(), paste("GSE", input$gse2, "verileri çekildi")))
    
    shinyjs::enable("indir")
    shinyjs::enable("cek")
    shinyjs::enable("gse1")
    shinyjs::enable("gse2")
    shinyjs::enable("feature_selection")
  })
  
  observeEvent(input$feature_selection, {
    shinyjs::disable("feature_selection")
    shinyjs::disable("indir")
    
    if (!is.null(gse1_data()) && !is.null(gse2_data())) {
      # Feature Selection İşlemi
      selected_genes_gse1 <- feature_selection(gse1_data())
      selected_genes_gse2 <- feature_selection(gse2_data())
      
      # Sonuçları Grafikle Göster
      output$feature_selection_plot <- renderPlot({
        ggplot() +
          geom_bar(aes(x = "GSE1", y = length(selected_genes_gse1)), stat = "identity", fill = "blue") +
          geom_bar(aes(x = "GSE2", y = length(selected_genes_gse2)), stat = "identity", fill = "red") +
          labs(title = "Seçilen Gen Sayısı", x = "", y = "Gen Sayısı") +
          theme_minimal()
      })
      
      operation_log(c(operation_log(), "Feature Selection işlemi tamamlandı"))
      shinyjs::enable("feature_selection")
      shinyjs::enable("indir")
    }
  })
  
  output$indir <- downloadHandler(
    filename = function() {
      paste("GSE_Verileri_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(isolate(gse1_data()), file)
    }
  )
  
  feature_selection <- function(gse_data) {
    # Feature Selection İşlemi
    # Burada, limma paketi veya başka bir yöntemle feature selection işlemi gerçekleştirilebilir.
    # Bu örnekte basit bir örnek sunulmuştur.
    selected_genes <- rownames(gse_data)[1:100]  # İlk 100 geni seçelim (örnek amaçlı)
    return(selected_genes)
  }
  
  output$log_output <- renderPrint({
    cat(paste("İşlemler Listesi:\n", paste(operation_log(), collapse = "\n")))
  })
}

shinyApp(ui = ui, server = server)
