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
  
  
  characteristic_mapping <- c(
    "GDP" = "Gdp",
    "GDP per Capita" = "Gdp_per_cap",
    "Average Temperature" = "Average_temp",
    "CO2 Emissions" = "CO2_emissions",
    "Population" = "Population",
    "Cereal Yield" = "Cereal_yield"
  )
  
  #Updating the options for users to select countries or characteristics
  observe({
    updateSelectInput(session, "char_country_input", choices = final_df$Country, selected = "China")
    updateSelectInput(session, "char_input", choices = names(characteristic_mapping), selected = "GDP")
  })
  
  output$dynamic_plots <- renderUI({
    req(input$char_input)  # Ensure that input$char_input is not NULL
    selected_labels <- input$char_input  # Store the selected labels
    
    # Use the mapping to get the actual dataframe column names
    selected_columns <- characteristic_mapping[selected_labels]
    
    # Create a list of plot outputs only for the selected characteristics
    plot_output_list <- lapply(selected_labels, function(label) {
      column(4, plotlyOutput(outputId = paste0("plot_", gsub(" ", "_", label))))
    })
    
    # Create rows of plot outputs, grouping them by 3 per row as needed
    plot_rows <- lapply(seq(1, length(plot_output_list), by = 3), function(i) {
      fluidRow(plot_output_list[i:min(i+2, length(plot_output_list))])
    })
    
    # Combine all rows into a single UI element
    do.call(tagList, plot_rows)
  })
  
  # Create the renderPlotly outputs dynamically based on selected characteristics
  observe({
    lapply(seq_along(input$char_input), function(i) {
      label <- input$char_input[i]
      column_name <- characteristic_mapping[[label]]
      output_id <- paste0("plot_", gsub(" ", "_", label))
      
      output[[output_id]] <- renderPlotly({
        # Generate the plot for the current characteristic using the actual dataframe column name
        gg <- ggplot(data = final_df, aes_string(x = "Year", y = column_name)) +
          geom_point() +
          ggtitle(paste("Graph for", label))
        
        # Convert ggplot object to ggplotly
        ggplotly(gg)
      })
    })
  })
  
  # ... rest of server logic ...
  
  #output$plot1 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Gdp)) + geom_point()) })
  #output$plot2 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Gdp_per_cap)) + geom_point()) })
  #output$plot3 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Average_temp )) + geom_point()) })
  #output$plot4 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = CO2_emissions)) + geom_point()) })
  #output$plot5 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Population)) + geom_point()) })
  #output$plot6 <- renderPlotly({ ggplotly(ggplot(data = final_df, aes(x = Year, y = Cereal_yield)) + geom_point()) })
}