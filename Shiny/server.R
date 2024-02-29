library(plotly)
library(ggplot2)
library(maps)
library(dplyr)
library(stringr)
library(bslib)
library(shiny)
#loading the final csv file from the data wrangling assignment
final_df <- read.csv("../final_df.csv")

server <- function(input, output) {
  
  # You can access the value of the widget with input$slider1, e.g.
  output$value <- renderPrint({ input$Heat_slider })
  output$World_map <- renderPlotly({
    selected_year = input$Heat_slider
    #loading the world map
    world_map <- map_data("world")
    #creating a dataframe with only the selected year
    sel_year_df <- final_df %>% filter(Year == selected_year)
    #joining the longitutde and latitude datas on the world with the final_df
    world_with_temp <- world_map %>% left_join(sel_year_df, by = c("region" = "Country"))
    #plotting the graph
    wm <-
      ggplot(data = world_with_temp, aes(x = long,y = lat, group = group,fill = Average_temp,text = paste0("Country: ",region,"<br>","Average Temperature: ",round(Average_temp, 5)))) + scale_fill_continuous(low = "#F3E0A5",high="#ED5A26",limits = c(-10, 30)) + geom_polygon(aes(fill = Average_temp)) + labs(
          title = paste("Average Temperature By Country in", 
                        selected_year),
          fill = "Temperature (C)"
        ) + theme_gray()
    #render the plotly back to ui page
    return(ggplotly(wm,tooltip = "text"))
  })
}