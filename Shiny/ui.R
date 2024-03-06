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
  p("Based on the features selected by the user, the page will generate corresponding line charts. Users can use these charts to explore the relationship between different variables. For example, if the user selects CO2 emissions as a feature, it can be observed that the CO2 emissions of some countries gradually increase over time, which may have a positive correlation with economic growth and industrialization. Additionally, if the user selects population as a feature, the relationship between population growth rate and economic development can be observed. Higher population growth rates may be associated with higher economic growth rates and vice versa.

In terms of correlation between variables, it can be observed that there is a positive correlation between some characteristics, such as population growth rate and GDP growth rate may be positively correlated, because population growth is usually accompanied by an increase in economic activity. On the other hand, CO2 emissions and average temperature may be positively correlated, meaning that an increase in CO2 emissions may lead to an increase in average temperature. But there may also be a negative correlation, for example, there may be a negative correlation between GDP per capita and carbon dioxide emissions, because some developed countries may take more environmental protection measures to reduce carbon dioxide emissions while maintaining economic growth. These charts allow users to better understand the relationships between different variables and their impact on the economy and climate.")
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
                      p("Through the three options provided on the page, users can view the relationship between carbon dioxide emissions and average temperature, average temperature and grain yield, and grain yield and economy. For example, we can observe that there is a positive correlation between carbon dioxide emissions and average temperature. As carbon dioxide emissions increase, the average temperature also shows an upward trend. On the contrary, there are a negative relationship between average temperature and grain yield, because as the average temperature increases, crop yields may decrease. There are positive correlation between grain production and the economy, because an increase in grain production may promote economic development, especially for the agricultural economy. By observing the relationship between these variables, we can gain a deeper understanding of the impact of global warming on the world economy and provide an important reference for formulating corresponding policies.
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
