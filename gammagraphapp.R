library("shiny")

ui <- fluidPage(
  titlePanel("Making a Gamma Dist"),
  sidebarLayout(
    position = "left",
    sidebarPanel(
      width = 9,
      fluidRow(
        column(
          width = 3,
          numericInput(inputId = "inputx", 
                       value = 25,
                       label="Number of observations"
                       )
        ),
        column(
          width = 3,
          numericInput(inputId = "inputshape",
                       value = 1,
                       label = "Shape parameter",
                       step = 0.1,
                       min = 0)
        ),
        column(
          width = 3,
          numericInput(inputId = "inputscale",
                       value = 0.5,
                       label = "Scale parameter",
                       step = 0.1,
                       min = 0.001)
        )
      )
    ),
    mainPanel(
      width = 12,
      plotOutput(outputId = "gammaplot"))
  )
  
)
  
server <- function(input, output) {
  
  output$gammaplot <- renderPlot(
    plot(pgamma(q = c(1:input$inputx)/input$inputx, shape = input$inputshape, scale = input$inputscale))
  )
}

shinyApp(ui = ui, server = server)
