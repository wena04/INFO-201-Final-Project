library(plotly)
library(ggplot2)
library(maps)
library(dplyr)
library(stringr)
library(bslib)
library(shiny)
#loading the final csv file from the data wrangling assignment
final_df <- read.csv("www/final_df.csv")

#Providing all the characteristics choices for the second tab while mapping each map to its corresponding column in the final_df column 
characteristic_mapping <- c("GDP" = "Gdp","GDP per Capita" = "Gdp_per_cap","Average Temperature" = "Average_temp","CO2 Emissions" = "CO2_emissions","Population" = "Population","Cereal Yield" = "Cereal_yield")

server <- function(input, output, session) {
  
  #Plotting the Country Heat Maps for Average Temperature (Tab 1)
  output$World_map <- renderPlotly({
    #Getting the input from the slider
    selected_year = input$Heat_slider
    #loading the world map data
    world_map <- map_data("world")
    #creating a dataframe with only the selected year
    sel_year_df <- final_df %>% filter(Year == selected_year)
    #joining the longitutde and latitude datas on the world with the final_df
    world_with_temp <-
      world_map %>% left_join(sel_year_df, by = c("region" = "Country"))
    #plotting the graph, filling each country shape with the average temperature
    wm <- ggplot(data = world_with_temp,aes(x = long, y = lat, group = group, fill = Average_temp, text = paste0("Country: ", region, "<br>", "Average Temperature: ", round(Average_temp, 5)))) 
    #changing the color of the legend/scale on the right side along with its limits
    + scale_fill_continuous(low = "#F3E0A5", high = "#ED5A26", limits = c(-10, 30)) + geom_polygon(aes(fill = Average_temp)) 
    #changing the title of the graph and the theme 
    + labs(title = paste("Average Temperature By Country in", selected_year), fill = "Temperature (C)") + theme_gray()
    #render the plotly back to ui page
    return(ggplotly(wm, tooltip = "text"))
  })
  
  #Plotting the Country Heat Maps for Carbon Emissions (Tab 1)
  output$CO2_map <- renderPlotly({
    #Getting the input from the slider
    selected_year = input$Heat_slider
    #loading the world map
    world_map <- map_data("world")
    #creating a dataframe with only the selected year
    sel_year_df <- final_df %>% filter(Year == selected_year)
    #joining the longitutde and latitude datas on the world with the final_df
    world_with_co2 <-
      world_map %>% left_join(sel_year_df, by = c("region" = "Country"))
    #plotting the graph, filling each country shape with the carbon emissions
    wmc <- ggplot(data = world_with_co2, aes(x = long, y = lat, group = group, fill = CO2_emissions, text = paste0("Country: ", region, "<br>", "Carbon Emissions Rate: ", CO2_emissions))) 
    #changing the color of the legend/scale on the right side along with its limits
    + scale_fill_continuous(low = "#F3E0A5", high = "#ED5A26", limits = c(0, 20)) + geom_polygon(aes(fill = CO2_emissions)) 
    #changing the title of the graph and the theme 
    + labs(title = paste("Carbon Emissions By Country in", selected_year), fill = "CO2 (metric tons)") + theme_gray()
    #render the plotly back to ui page
    return(ggplotly(wmc, tooltip = "text"))
  })
  
  #Updating the options for users to select countries or characteristics
  observe({
    updateSelectInput(session, "char_country_input", choices = unique(final_df$Country), selected = c("China","United States","Brazil","Argentina","Japan"))
    updateSelectInput(session, "char_input", choices = names(characteristic_mapping), selected = c("GDP","Population","CO2 Emissions"))
  })
  
  # Reactive expression for the filtered data
  filtered_data <- reactive({
    req(input$char_country_input)  # Ensure that input$char_country_input is not NULL
    sel_country_df <- final_df %>% filter(Country %in% input$char_country_input)  # Use %in% for multiple selection
  })
  
  output$dynamic_plots <- renderUI({
    req(input$char_input)  # Ensure that input$char_input is not NULL
    selected_labels <- input$char_input  # Store the selected labels

    # Use the mapping to get the actual dataframe column names
    selected_columns <- characteristic_mapping[selected_labels]
    # Create a list of plot outputs only for the selected characteristics
    plot_output_list <- lapply(selected_labels, function(label) {
      column(6, plotlyOutput(outputId = paste0("plot_", gsub(" ", "_", label))))
    })
    
    # Create rows of plot outputs, grouping them by 2 per row as needed
    plot_rows <- lapply(seq(1, length(plot_output_list), by = 2), function(i) {
      fluidRow(plot_output_list[i:min(i+1, length(plot_output_list))])
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
        gg <- ggplot(data = filtered_data(),mapping = aes(x = .data$Year, y = .data[[column_name]], color = .data$Country, group = .data$Country)) + labs(title = paste("Graph for", label)) +
          geom_line() + theme_gray()
        # Convert ggplot object to ggplotly
        ggplotly(gg) 
      })
    })
  })
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  #Tab 3 server side information
  
}