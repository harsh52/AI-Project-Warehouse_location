library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(magrittr)
library(leaflet) # devtools::install_github('rstudio/leaflet')
library(highcharter) # devtools::install_github('jbkunst/highcharter')
library(plotly) # devtools::install_github('ropensci/plotly')
library(ggplot2) # devtools::install_github('hadley/ggplot2')
library(sp)
library(dplyr)
library(flexdashboard) # devtools::install_github('rstudio/flexdashboard')
library(rgeos)
library(mapproj)
library(maptools)
library(readr)
library(ggthemes)
library(knitr)
library(viridis)
library(formattable)
library(ggrepel)
library(ompr)
library(ompr.roi)
library(ROI.plugin.glpk)
library(Rglpk)
source(file = "helper.R")

ui <-shinyUI(tagList(
  # tags$head(tags$link(rel = "stylesheet", 
  #                     type = "text/css", 
  #                     href = "css/custom.css")),
  dashboardPage(
    dashboardHeader(title="AI Project"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Warehouse Location", tabName = "grid", icon = icon("dashboard"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = "grid",
                sidebarLayout(
                  sidebarPanel(
                    background="navy", solidHeader=TRUE, height=600, width=3,
                    numericInput(inputId = "grid_size", "Enter the Gird Size", value = 1000),
                    sliderInput(inputId = "warehouse_num", label = "Select the Number of Warehouses:", min = 10, max = 30, value = 20),
                    sliderInput(inputId = "customer_num", label = "Select the Number of Customers:", min = 50, max = 150, value = 100),
                    actionButton(inputId = "solve_it", label = "  Solve  ")
                    #submitButton("simulate!")
                  ),
                  mainPanel(plotlyOutput("output1") %>% withSpinner())
                )
        )
      )
    )
  )
)
)


server <- function(input, output, session) {
  
  output$output1 <-renderPlotly({
    #input$solve_it 
    if(input$solve_it == 0){
     # print("in if")
      return(ggplotly(PlotSetup(n = input$customer_num, m = input$warehouse_num, grid_size = input$grid_size)))
    } else {
      isolate({  
       # print("in else")
        withProgress(message = 'Optimization in Progress', value = 0, {
          incProgress(0.4)
          return(ggplotly(SolvedPlot(n = input$customer_num, m = input$warehouse_num, grid_size = input$grid_size)))
        })
      })
      
    }
  })
  
}


shinyApp(ui, server)