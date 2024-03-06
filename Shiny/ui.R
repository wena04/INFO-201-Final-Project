library(plotly)
library(ggplot2)
library(maps)
library(dplyr)
library(stringr)
library(bslib)
library(shiny)
library(markdown)

## OVERVIEW TAB INFO

overview_tab <- tabPanel("Introduction",
   h1("Global Economy and Climate Change",align = "center"),
   HTML('<center><img src="Photo 1.jpg"></center>'),
   includeMarkdown("Intro Text.md")
)

## HEAT MAP TAB INFO

viz_1_sidebar <- sidebarPanel(
  p("Graph may take a second to load"),
  h3("Move slider to select a date"),
  sliderInput("Heat_slider", label = "select a date", min = 1990, max = 2010, value = 2000)
)

viz_1_main_panel <- mainPanel(
  tabsetPanel(
    tabPanel("Average Temperature",br(), plotlyOutput("World_map")),
    tabPanel("Carbon Dioxide Emissions",br(),plotlyOutput("CO2_map")),
    tabPanel("Country Development Levels",br(),plotlyOutput("Develop_map"))
  )
)

viz_1_tab <- tabPanel("World Maps with Temperature and CO2",
  h2("Heat Map for Average Temperature & CO2 Emissions",align = "center"),
  p("These visualizations were created to answer questions: How has global temperature changed over time?  How has carbon dioxide emission changed over time? How these two variables correlate with each other?  These questions  were accomplished by creating a visualization to represent average temperature in each country along with another visualization to represent the change in emission in each country within different continents between 1990 to 2010. Adjust the slider to visualize temperature and emission change over time. Also, a scatter plot’ s listed to show the correlation between these two variables within different economic status.
"),
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel 
  ),
  p("The visual representation indicates a consistent upward trend in both temperature and CO2 emissions. Countries with different economic levels (devloping, developed, etc) were all still had a high positive correlation and increase between temperature and CO2 emissions per capita. Notably, the Eurasian continent, particularly Russia and China, has witnessed the most substantial temperature increase. Eastern Europe has also emerged as a notable region experiencing gradual warming. Surprisingly, despite being a developed nation with a diverse economy, Canada encountered the most  significant warming among both North and South America.
    
Analyzing the scatter plot leads to the conclusion that countries with lower income (indicative of a poor economic status) are more prone to heightened CO2 emissions and elevated temperatures. This correlation can be attributed to the primary income sources of these nations, where developing countries heavily rely on the manufacturing industry, leading to increased greenhouse gas production and subsequent temperature rise.")
)

## INDIVIDUAL COUNTRY ANALYSIS TAB INFO

viz_2_sidebar <- sidebarPanel(
  p("Graph may take a second to load"),
  h3("Try selecting more characteristics"),
  selectInput("char_country_input", label = "Select Country", choices = NULL, multiple = TRUE),
  selectInput("char_input", label = "Select Characteristics", choices = NULL, multiple = TRUE),
  width = 3
)

viz_2_main_panel <- mainPanel(
  uiOutput("dynamic_plots"),
  width = 9
)

viz_2_tab <- tabPanel("Climate and Economy Characteristics",
  h2("Analyzing By Characteristics",align = "center"),
  p("This page was created to explore the relationship between climate and economic characteristics and answer the following question: Are climate changes in different countries over the past two decades related to their level of economic development? The option box on the left provides multiple options. Users can select different countries and different characteristics to generate corresponding line charts. These characteristics include CO2 emissions, population, GDP per capita, total GDP and average temperature, and the time range covers 1990 to 2010. Through these line charts, users can visually compare the changing trends of these characteristics in different countries, thereby gaining a deeper understanding of the interrelationship between climate change and economic development."),
  fluidRow(viz_2_sidebar,viz_2_main_panel),
  p("These line graphs show how climate and economic characteristics have changed in different countries over the past two decades. Data show that CO2 emissions are on the rise in most countries and are closely related to population growth and economic development. At the same time, per capita GDP and total GDP have also increased significantly in many countries, indicating that economic development has played a certain role in promoting the increase in CO2 emissions. However, some countries have shown better results in controlling CO2 emissions, which may be related to the environmental protection policies and technological innovations they have adopted. In addition, changes in average temperature also reflect the trend of climate change to a certain extent, showing a gradual upward trend, which may have an important impact on human society and the ecological environment.")
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  p("Graph may take a second to load"),
  h3("Hover over the lines for more info"),
  selectInput("CountryName", 
              label = "select country",
              choices = NULL,
              multiple = FALSE, selected = "United States")
  
)

viz_3_main_panel <- mainPanel(
  tabsetPanel(
    tabPanel("CO2 Emission & Average Temperature", br(), plotlyOutput("CO2_Tem")),
    tabPanel("Average Temperature & Cereal Yield" , br(), plotlyOutput("Tem_AG")),
    tabPanel("Cereal Yield & Economy", br(), plotlyOutput("Cereal_GDP"))
  )
)

viz_3_tab <- tabPanel("Globol Warming VS World Economy",
                      h2("Analyzing the relation between each characteristics", align = "center"),
                      p("This analysis delves into the intricate relationship between CO2 emissions and the global economy, shedding light on how the phenomenon of global warming impacts financial landscapes worldwide. As users navigate through the available options, they can explore the dynamics between different variables across nations. The interactive interface allows for a nuanced examination, offering insights into the interplay between CO2 emissions, average temperature, cereal yield, and economic indicators from 1990 to 2010. Each facet of the analysis unveils a facet of the complex tapestry linking environmental factors to economic prosperity or decline.
"),
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel
                      ),
                      p("Through the presentation of different chart options, we can clearly see the impact of climate change on the global economy. The strong link between carbon dioxide emissions and average temperatures highlights the important impact of environmental factors on the economy. At the same time, the impact of average temperatures on food production highlights the challenges facing the agricultural sector and the urgency of adaptive strategies needed to combat climate change. These charts remind us that addressing climate change is not only an environmental issue, but also an important issue related to sustainable economic development.
")
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Conclusion",align = "center"),
 includeMarkdown("Conclusion Text.md")
)

# Original: #E8F2F9
#CFF09E
#C6DAF2
#E46410 orange
#e7f2f8
ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      
      /* Set text color */
      body, .main-panel, .sidebar, .tab-content { 
        color: #333333; 
      }
      
      /* Set navbar color */
      .navbar { 
        background-color: #17627F; 
      }
      
      /* Change color of navbar text */
      .navbar-default .navbar-nav > li > a {
        color: white; 
        font-weight: bold;
      }
      
      /* Change color of navbar text on hover */
      .navbar-default .navbar-nav > li > a:hover {
        color: #228B22; /* This is a darker shade of green */
        font-weight: bold;
      }
      
      /* Change color of the navbar brand text */
      .navbar-default .navbar-brand {
        color: white; 
        font-weight: bold;
      }
      
      /* Change navbar brand text on hover */
      .navbar-default .navbar-brand:hover {
        color: #228B22; /* This is a darker shade of green */
        font-weight: bold;
      }
    "))
  ),
  navbarPage("INFO 201 Final Project",
             overview_tab,
             viz_1_tab,
             viz_2_tab,
             viz_3_tab,
             conclusion_tab
  )
)
