# Gerekli kütüphaneleri yükleyin
install.packages(c("shiny", "shinydashboard"))

# Kütüphaneleri yükleyin
library(shiny)
library(shinydashboard)

# UI tanımı
ui <- dashboardPage(
  dashboardHeader(title = "GSE Veri Masaüstü Uygulaması"),
  
  dashboardSidebar(
    textInput("gse1", "GSE1 ID:", ""),
    textInput("gse2", "GSE2 ID:", ""),
    actionButton("showDataButton", "Verileri Göster")
  ),
  
  dashboardBody(
    fluidRow(
      box(
        title = "GSE Verileri",
        status = "primary",
        solidHeader = TRUE,
        width = 12,
        tableOutput("gseTable")
      )
    )
  )
)

# Server fonksiyonu
server <- function(input, output) {
  observeEvent(input$showDataButton, {
    # GSE verilerini indirme ve işleme işlemleri burada gerçekleşir
    # input$gse1 ve input$gse2 kullanılarak girilen GSE ID'leri alınabilir
    
    # Örnek: Verileri dataframe olarak oluşturun
    gseData <- data.frame(
      Sample = c("Sample1", "Sample2", "Sample3"),
      Value = c(1.5, 2.0, 0.8)
    )
    
    # Oluşturulan dataframe'i tablo olarak göster
    output$gseTable <- renderTable({
      gseData
    })
  })
}

# Uygulamayı başlatın
shinyApp(ui, server)
