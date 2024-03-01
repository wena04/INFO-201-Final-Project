library(plotly)
library(ggplot2)
library(maps)
library(dplyr)
library(stringr)
library(bslib)
library(shiny)
library(markdown)
library(gridExtra)
## OVERVIEW TAB INFO

overview_tab <- tabPanel("Introduction",
   h1("Global Economy and Climate Change",align = "center"),
   HTML('<center><img src="Photo 1.jpg"></center>'),
   includeMarkdown("Intro Text.md")
)

## HEAT MAP TAB INFO

viz_1_sidebar <- sidebarPanel(
  #TODO: Put inputs for modifying graph here
  column(12, sliderInput("Heat_slider", label = h2("Select Date"), min = 1990, 
                        max = 2010, value = 2000)),
  hr(),
)

viz_1_main_panel <- mainPanel(
  h2("Heat Map for Average Temperature & CO2 Emissions",align = "center"),
  tabsetPanel(
    tabPanel("Plot",plotlyOutput(outputId = "World_map")),
    tabPanel("Summary",plotlyOutput(outputId = "CO2_map"))
  )
)

viz_1_tab <- tabPanel("Heat Map",
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel 
  )
)

## INDIVIDUAL COUNTRY ANALYSIS TAB INFO

viz_2_sidebar <- sidebarPanel(
  #TODO: Put inputs for modifying graph here
  column(12, selectInput("char_country_input", label = h3("Select Country"), choices = NULL, multiple = TRUE)),
  column(12, selectInput("char_input", label = h3("Select Characteristics"), choices = NULL, multiple = TRUE))
)

viz_2_main_panel <- mainPanel(
  # First row of graphs
  fluidRow(
    column(4, plotlyOutput("plot1")),
    column(4, plotlyOutput("plot2")),
    column(4, plotlyOutput("plot3"))
  ),
  # Second row of graphs
  fluidRow(
    column(4, plotlyOutput("plot4")),
    column(4, plotlyOutput("plot5")),
    column(4, plotlyOutput("plot6"))
  )
)

viz_2_tab <- tabPanel("Climate and Economy Characteristics",
  h2("Analyzing By Characteristics",align = "center"),
  fluidRow(viz_2_sidebar),
  viz_2_main_panel
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Options for graph"),
  #TODO: Put inputs for modifying graph here
)

viz_3_main_panel <- mainPanel(
  h2("Vizualization 3 Title"),
  # plotlyOutput(outputId = "your_viz_1_output_id")
)

viz_3_tab <- tabPanel("Viz 3 tab title",
  sidebarLayout(
    viz_3_sidebar,
    viz_3_main_panel
  )
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Some title"),
 p("some conclusions")
)



ui <- navbarPage("INFO 201 Final Project",
  theme = bs_theme(background = "#E8F2F9", foreground = "#959BA2",primary = "#E46410",success = "#34A853"),
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab
)