#
# The Reactivity Shiny Example - updated to enable URL bookmarking
# shiny::runExample("03_reactivity")
#

library(shiny)

ui <- function(req){
    fluidPage(
        
        titlePanel("Bookmarkable URL Example"),
        
        sidebarLayout(
            
            sidebarPanel(
                
                textInput(inputId = "caption",
                          label = "Caption:",
                          value = "Data Summary"),
                
                selectInput(inputId = "dataset",
                            label = "Choose a dataset:",
                            choices = c("rock", "pressure", "cars")),
                
                numericInput(inputId = "obs",
                             label = "Number of observations to view:",
                             value = 10)
                
            ),
            
            mainPanel(
                
                h3(textOutput("caption", container = span)),
                
                verbatimTextOutput("summary"),
                
                tableOutput("view")
                
            )
        )
    )
}


server <- function(input, output, session) {
    
    observe({
        # Trigger this observer every time an input changes
        reactiveValuesToList(input)
        session$doBookmark()
    })
    
    datasetInput <- reactive({
        switch(input$dataset,
               "rock" = rock,
               "pressure" = pressure,
               "cars" = cars)
    })
    
    output$caption <- renderText({
        input$caption
    })
    
    output$summary <- renderPrint({
        dataset <- datasetInput()
        summary(dataset)
    })
    
    output$view <- renderTable({
        head(datasetInput(), n = input$obs)
    })
    
    onBookmarked(function(url) {
        updateQueryString(url)
    })
    
}

enableBookmarking(store = "url")
shinyApp(ui, server)