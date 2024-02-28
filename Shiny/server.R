library(plotly)
library(ggplot2)

final_df <- read.csv(final_df)

server <- function(input, output){
  
  # TODO Make outputs based on the UI inputs here
  output$your_viz_1_output_id <- renderPlotly({
    #Make Plotly graph
    first_plot <- ggplot(final_df)
    
    return(ggplotly(first_plot))
  })
}