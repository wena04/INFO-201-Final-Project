library(plotly)
library(ggplot2)
library(maps)
library(dplyr)
library(stringr)
library(bslib)
library(shiny)
#loading the final csv file from the data wrangling assignment
final_df <- read.csv("www/final_df.csv")
characteristic_choice <- c("GDP","GDP Per Capita","Population","Total Investment","Average Temperature","Carbon Dioxide Emissions")

server <- function(input, output, session) {
  
  #Plotting the Country Heat Maps for Average Temperature
  output$World_map <- renderPlotly({
    selected_year = input$Heat_slider
    #loading the world map
    world_map <- map_data("world")
    #creating a dataframe with only the selected year
    sel_year_df <- final_df %>% filter(Year == selected_year)
    #joining the longitutde and latitude datas on the world with the final_df
    world_with_temp <-
      world_map %>% left_join(sel_year_df, by = c("region" = "Country"))
    #plotting the graph
    wm <-
      ggplot(data = world_with_temp,
             aes(
               x = long,
               y = lat,
               group = group,
               fill = Average_temp,
               text = paste0(
                 "Country: ",
                 region,
                 "<br>",
                 "Average Temperature: ",
                 round(Average_temp, 5)
               )
             )) + scale_fill_continuous(
               low = "#F3E0A5",
               high = "#ED5A26",
               limits = c(-10, 30)
             ) + geom_polygon(aes(fill = Average_temp)) + labs(
               title = paste("Average Temperature By Country in",
                             selected_year),
               fill = "Temperature (C)"
             ) + theme_gray()
    #render the plotly back to ui page
    return(ggplotly(wm, tooltip = "text"))
  })
  
  #Plotting the Country Heat Maps for Carbon Emission
  output$CO2_map <- renderPlotly({
    selected_year = input$Heat_slider
    #loading the world map
    world_map <- map_data("world")
    #creating a dataframe with only the selected year
    sel_year_df <- final_df %>% filter(Year == selected_year)
    #joining the longitutde and latitude datas on the world with the final_df
    world_with_co2 <-
      world_map %>% left_join(sel_year_df, by = c("region" = "Country"))
    #plotting the graph
    wmc <-
      ggplot(data = world_with_co2,
             aes(
               x = long,
               y = lat,
               group = group,
               fill = CO2_emissions,
               text = paste0(
                 "Country: ",
                 region,
                 "<br>",
                 "Carbon Emissions Rate: ",
                 CO2_emissions
               )
             )) + scale_fill_continuous(
               low = "#F3E0A5",
               high = "#ED5A26",
               limits = c(0, 20)
             ) + geom_polygon(aes(fill = CO2_emissions)) + labs(
               title = paste("Carbon Emissions By Country in",
                             selected_year),
               fill = "CO2 (metric tons)"
             ) + theme_gray()
    #render the plotly back to ui page
    return(ggplotly(wmc, tooltip = "text"))
  })
  
  #Updating the options for users to select countries or characteristics
  observe({
    updateSelectInput(session, "char_country_input", choices = final_df$Country, selected = "China")
    updateSelectInput(session, "char_input", choices = list(
      "GDP" = "plot1",
      "GDP per Capita" = "plot2",
      "Average Temperature" = "plot3",
      "CO2 Emissions" = "plot4",
      "Population" = "plot5",
      "Cereal Yield" = "plot6"
    ), selected = "plot1")
  })
  
  output$plot1 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Gdp)) + geom_point()) })
  output$plot2 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Gdp_per_cap)) + geom_point()) })
  output$plot3 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Average_temp )) + geom_point()) })
  output$plot4 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = CO2_emissions)) + geom_point()) })
  output$plot5 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Population)) + geom_point()) })
  output$plot6 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Cereal_yield)) + geom_point()) })
}