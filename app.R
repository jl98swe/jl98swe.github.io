# app.R
# Explicit deklaration av alla nödvändiga paket
if (!require(shiny)) install.packages("shiny")
if (!require(leaflet)) install.packages("leaflet")
if (!require(maps)) install.packages("maps")
if (!require(shinylive)) install.packages("shinylive")

library(shiny)
library(leaflet)
library(maps)
library(shinylive)

# Resten av koden förblir oförändrad
ui <- fluidPage(
  titlePanel("Interaktiv Karta med Mapview"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataset", "Välj dataset:",
                  choices = c("Världsstäder" = "cities",
                              "Quakes" = "quakes"))
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    req(input$dataset)
    
    output$map <- renderLeaflet({
      if (input$dataset == "cities") {
        data <- maps::world.cities  # Begränsa till 1000 städer för bättre prestanda
        m <- leaflet(data) %>%
          addTiles() %>%
          addCircleMarkers(
            ~long, ~lat, 
            radius = ~sqrt(pop)/100,
            popup = ~paste(name, "<br>Population:", pop)
          )
      } else {
        data <- quakes
        m <- leaflet(data) %>%
          addTiles() %>%
          addCircleMarkers(
            ~long, ~lat, 
            radius = ~mag * 2,
            popup = ~paste("Magnitude:", mag, "<br>Depth:", depth)
          )
      }
      m
    })
  })
}

# Kör appen
shinyApp(ui = ui, server = server)
