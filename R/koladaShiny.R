#' @name koladaShiny
#' @title A Shiny app to visualise kolada data
#' @description A Shiny app to visualise kolada data fetched using AdvanceRConnectingToAPI.
#' @import shiny
#' @import remotes
#' @export koladaShiny
#' 

remotes::install_github('SpikeStriker/AdvanceRConnectingToAPI')
remotes::install_deps(dependencies = TRUE)

koladaShiny <- function() {
  ui <- fluidPage(
    titlePanel("Kolada Data"),
    sidebarLayout(
      sidebarPanel(
        textAreaInput("kpiCodes", "Enter the codes for KPI(s) (comma seperated with no spaces):", "", rows = 1),
        helpText("Example: N40005,N25026,N45001,N45030,N45031"),
        textAreaInput("yrs", "Enter the years (comma seperated with no spaces):", "", rows = 1),
        helpText("Example: 2019,2020,2021,2022,2023,2024"),
        actionButton("go", "FetchData")
      ),
      mainPanel(
        verbatimTextOutput("urlOutput"),
        tableOutput("dataOutput")
      )
    )
  )
  server <- function(input, output) {
    observeEvent(input$go, {
      if (!requireNamespace("AdvanceRConnectingToAPI", quietly = TRUE)) {
        stop("Package 'AdvanceRConnectingToAPI' is required but not installed.")
      }
      kpi <- strsplit(input$kpiCodes, ",")[]
      years <- strsplit(input$yrs, ",")[]
      apiCall<-AdvanceRConnectingToAPI::AdvanceRConnectingToAPI$new(kpi=kpi[[1]],year=years[[1]])
      output$urlOutput <- renderPrint({
        cat("The URL used to fetch data:",apiCall$url)
      })
      output$dataOutput <- renderTable({
        apiCall$fetchedData
      })
    })
  }
  
  shinyApp(ui = ui, server = server)
}

# devtools::install_github("SpikeStriker/AdvanceRConnectingToAPI")@import devtools
