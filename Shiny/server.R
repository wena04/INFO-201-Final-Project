library(plotly)
library(ggplot2)

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  output$your_viz_1_output_id <- renderPlotly({
    #Make Plotly graph
    first_plot <- ggplot()
    
    return(ggplotly(first_plot))
  })
}