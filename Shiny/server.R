library(plotly)
library(ggplot2)
library(maps)
library(dplyr)
library(stringr)
library(bslib)
library(shiny)
library(viridis)
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
    #changing the color of the legend/scale on the right side along with its limits "scale_fill_continuous(low = "#F3E0A5", high = "#ED5A26", limits = c(-10, 30))"
    #changing the title of the graph and the theme
    #render the plotly back to ui page
    wm <- ggplot(data = world_with_temp,aes(x = long, y = lat, group = group, fill = Average_temp, text = paste0("Country: ", region, "<br>", "Average Temperature: ", round(Average_temp, 5)))) + scale_fill_viridis_c(option = "magma", direction = -1, limits = c(-10, 30)) + geom_polygon(aes(fill = Average_temp)) + labs(title = paste("Average Temperature By Country in", selected_year), fill = "Temperature (C)") + theme(panel.background = element_rect(fill = "#e5ecf6"))
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
    #changing the color of the legend/scale on the right side along with its limits
    #changing the title of the graph and the theme 
    #render the plotly back to ui page
    wmc <- ggplot(data = world_with_co2, aes(x = long, y = lat, group = group, fill = CO2_emissions, text = paste0("Country: ", region, "<br>", "CO2 emissions per capita: ", CO2_emissions))) + scale_fill_viridis_c(option = "viridis",direction = -1,begin = 0.7, limits = c(0, 20)) + geom_polygon(aes(fill = CO2_emissions)) + labs(title = paste("Carbon Emissions By Country in", selected_year), fill = "CO2 per capita (metric tons)") + theme(panel.background = element_rect(fill = "#e5ecf6"))
    return(ggplotly(wmc, tooltip = "text"))
  })
  
  #plotting graph for average temperature vs carbon dioxide emissions
  output$Develop_map <- renderPlotly({
    g2 <- ggplot(data = final_df, aes(x = CO2_emissions, y = Average_temp))+
      geom_point(aes(color = economic_status,text = Country))+
      facet_wrap(~economic_status, nrow = 2)+
      labs(title = "Average Temperature VS CO2 Emissions per Capita", x = "Carbon Dioxide Emissions", y = "Average Temperature")+scale_color_viridis(discrete = TRUE, option = "D",direction = -1)+
      scale_fill_viridis(discrete = TRUE,direction = -1) +theme(panel.background = element_rect(fill = "#e5ecf6"))
    return(ggplotly(g2, tooltip = c("text", "Average_temp", "CO2_emissions")))
  })
  
  
  
  
  #Tab 2 Server Side Information
  #Updating the options for users to select countries or characteristics based on user status. search up selectize to understand more.
  observe({
    updateSelectInput(session, "char_country_input", choices = unique(final_df$Country), selected = c("United States","China","Japan"))
    updateSelectInput(session, "char_input", choices = names(characteristic_mapping), selected = c("CO2 Emissions","Population"))
    updateSelectInput(session, "CountryName", choices = unique(final_df$Country), selected = "United States")
  })
  
  # Reactive expression/function for the filtered data to check user movements
  filtered_data <- reactive({
    req(input$char_country_input)  # Ensure that input$char_country_input is not NULL
    sel_country_df <- final_df %>% filter(Country %in% input$char_country_input) #filtering the dataset for the selected countries 
  })
  
  #Plotting all the graphs that were selected
  output$dynamic_plots <- renderUI({
    req(input$char_input)  # Ensure that input$char_input is not NULL
    selected_labels <- input$char_input  # Store the selected labels or characteristics wanting to plot

    # Use the mapping to get the actual dataframe column names
    selected_columns <- characteristic_mapping[selected_labels]
    # Create a list of plot outputs only for the selected characteristics (where and how to plot), kind of like a function that will be called to graph the plots based on the characteristics passed in
    plot_output_list <- lapply(selected_labels, function(label) {
      column(6, plotlyOutput(outputId = paste0("plot_", gsub(" ", "_", label))))
    })
    
    # Create rows of plot outputs, grouping them by 2 per row 
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
      
      #getting the corresponding units for each thing
      if(label == "GDP" | label == "GDP per Capita") units <- " U.S. dollars (Billions)"
      if(label == "Average Temperature") units <- " (Celcius)"
      if(label == "CO2 Emissions") units <- " per capita (metric tons)"
      if(label == "Population") units <- " (Millions)"
      if(label == "Cereal Yield") units <- " (kg per hectar)"
      
      output[[output_id]] <- renderPlotly({
        # Generate the plot for the current characteristic using the actual dataframe column name
        gg <- ggplot(data = filtered_data(),mapping = aes(x = .data$Year, y = .data[[column_name]], color = .data$Country, group = .data$Country, text = paste0("Year: ",Year, "<br>",label,": ",.data[[column_name]],"<br>","Country: ",.data$Country))) + labs(title = paste("Graph for", label), x = "Year", y = paste0(label,units)) + scale_color_viridis(discrete = TRUE, option = "D") + scale_fill_viridis(discrete = TRUE) + geom_line() + theme(panel.background = element_rect(fill = "#e5ecf6"))
        # Convert ggplot object to ggplotly
        pp <- ggplotly(gg, tooltip = "text")
      
        # Add JavaScript code to capture hover events and make the lines highlight or unhighlight based on where mouse is
        pp <- htmlwidgets::onRender(pp, "
          function(el, x) {
            // Store original colors
            var originalColors = [];
            var updateColors = function(hoveredTraceIndex) {
              // Update to set the hovered line to its original color, others to 'lightgray'
              var newColors = originalColors.map(function(color, index) {
                return index === hoveredTraceIndex ? originalColors[hoveredTraceIndex] : 'lightgray';
              });
              Plotly.restyle(el, {'line.color': newColors});
            };

          el.on('plotly_beforehover', function() {
            if (originalColors.length === 0) { // Initialize original colors once
              originalColors = x.data.map(function(trace) { return trace.line.color; });
            }
          });

          el.on('plotly_hover', function(data) {
            var hoveredTraceIndex = data.points[0].curveNumber;
            updateColors(hoveredTraceIndex);
          });

          el.on('plotly_unhover', function(data) {
            // Revert to original colors when not hovering over any trace
            Plotly.restyle(el, {'line.color': originalColors});
            });
          }
        ")
        return(pp)
      })
    })
  })
  
  #Tab 3 server side information
  
  filtered_data_3 <- reactive({
    req(input$CountryName)  # Ensure that input$char_country_input is not NULL
    sel_country_df_3 <- final_df %>% filter(Country == input$CountryName) %>% select(Country, Year, CO2_emissions,Average_temp,Cereal_yield,Gdp_per_cap)
  })
  
  #Plotting graph comparing CO2 & Average Temperature (Tab 3)   
  output$CO2_Tem <- renderPlotly({
    
    p <- plot_ly(data = filtered_data_3(), x = ~Year)
    # Add the first trace for CO2 emissions on the primary y-axis
    p <- add_trace(p, y = ~CO2_emissions, name = 'CO2 Emissions', mode = 'lines', 
                   line = list(color = "#ff7f0e"))
    # Add the second trace for Average Temperature on the secondary y-axis
    p <- add_trace(p, y = ~Average_temp, name = 'Average Temperature', mode = 'lines', 
                   line = list(color = "#00BFC4"), yaxis = 'y2')
    # Set the layout for the secondary y-axis
    p <- layout(p,
                title = "CO2 Emissions per capita and Average Temperature Over Time",
                plot_bgcolor='#e5ecf6',
                yaxis2 = list(
                  overlaying = "y",
                  side = "right",
                  tickfont = list(color = '#00BFC4', size=11),color = '#00BFC4',title = "Average Temperature (C)"
                ),
                yaxis = list(
                  title = "CO2 Emissions per capita (metric tons)", tickfont = list(color = '#ff7f0e', size=11), color='#ff7f0e'
                ),
                hovermode = "x unified"
    )
    return(p)
  })
  
  #Plotting graph comparing CO2 & Cereal Yield per Capita (Tab 3)    
  output$Tem_AG <- renderPlotly({
    
    p <- plot_ly(data = filtered_data_3(), x = ~Year)
    # Add the first trace for Average Temperature on the primary y-axis on the left
    p <- add_trace(p, y = ~Average_temp, name = 'Average Temperature (C)', mode = 'lines', 
                   line = list(color = "#ff7f0e"))
    # Add the second trace for Cereal yield per capita on the secondary y-axis on the right
    p <- add_trace(p, y = ~Cereal_yield, name = 'Cereal Yield (kg per hectare)', mode = 'lines', 
                   line = list(color = "#00BFC4"), yaxis = 'y2')
    # Set the layout for the secondary y-axis 
    p <- layout(p,
                title = "Average Temperature and Cereal Yield",
                plot_bgcolor='#e5ecf6', 
                yaxis2 = list(
                  overlaying = "y",
                  side = "right",
                  tickfont = list(color = '#00BFC4', size=11),color = '#00BFC4',title = "Average Temperature (C)"
                ),
                yaxis = list(
                  title = "Cereal Yield (kg per hectare)", tickfont = list(color = '#ff7f0e', size=11), color='#ff7f0e'
                ), 
                hovermode = "x unified"
    )
    return(p)
  })
  
  #Plotting graph comparing Cereal Yield per Capita and Gdp per capita (Tab 3)
  output$Cereal_GDP <- renderPlotly({
    
    p <- plot_ly(data = filtered_data_3(), x = ~Year)
    # Add the first trace for Cereal Yield per Capita on the primary y-axis on the left
    p <- add_trace(p, y = ~Cereal_yield, name = 'Cereal Yield', mode = 'lines', 
                   line = list(color = "#ff7f0e"))
    # Add the second trace for GDP per capita on the secondary y-axis on the right
    p <- add_trace(p, y = ~Gdp_per_cap, name = 'GDP Per Capita', mode = 'lines', 
                   line = list(color = "#00BFC4"), yaxis = 'y2')
    # Set the layout for the secondary y-axis
    p <- layout(p,
                title = "Cereal Yield and GDP per Capita Over Time",
                plot_bgcolor='#e5ecf6',
                yaxis2 = list(
                  overlaying = "y",
                  side = "right",
                  tickfont = list(color = '#00BFC4', size=11),color = '#00BFC4',title = "Cereal Yield"
                ),
                yaxis = list(
                  title = "GDP per Capita", tickfont = list(color = '#ff7f0e', size=11), color='#ff7f0e'
                ),
                hovermode = "x unified"
    )
    return(p)
  })
  
}