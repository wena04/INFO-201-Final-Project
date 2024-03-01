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
    updateSelectInput(session, "char_input", choices = characteristic_choice, selected = "Carbon Dioxide Emissions")
  })
  
  # Generate sample data
  set.seed(123)
  countries <- c("USA", "Canada", "UK", "Germany", "France")
  years <- 2000:2020
  gdp <- runif(length(countries) * length(years), min = 1000, max = 10000)
  population <- sample(1000000:10000000, length(countries) * length(years), replace = TRUE)
  
  # Create the dataframe
  df <- expand.grid(Country = countries, Year = years)
  df$GDP <- gdp
  df$Population <- population
  
  output$gdp_graph <- renderPlot({
    selected_countries <- input$country_input
    graph_type <- input$graph_input
    
    df_subset <- df[df$Country %in% selected_countries, ]
    
    ggplot(df_subset, aes(x = Year, y = GDP, color = Country)) +
      geom_line() +
      labs(title = "GDP Over Time", x = "Year", y = "GDP")
  })
  
  output$population_graph <- renderPlot({
    selected_countries <- input$country_input
    graph_type <- input$graph_input
    
    df_subset <- df[df$Country %in% selected_countries, ]
    
    ggplot(df_subset, aes(x = Year, y = Population, color = Country)) +
      geom_line() +
      labs(title = "Population Over Time", x = "Year", y = "Population")
  })
}