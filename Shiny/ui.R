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
  #TODO: Put inputs for modifying graph here
  column(12, sliderInput("Heat_slider", label = h2("Select Date"), min = 1990, 
                        max = 2010, value = 2000)),
  hr(),
)

viz_1_main_panel <- mainPanel(
  tabsetPanel(
    tabPanel("Average Temperature",plotlyOutput("World_map")),
    tabPanel("Carbon Dioxide Emissions",plotlyOutput("CO2_map")),
    tabPanel("Country Development Levels",plotlyOutput("Develop_map"))
  )
)

viz_1_tab <- tabPanel("Heat Map",
  h2("Heat Map for Average Temperature & CO2 Emissions",align = "center"),
  p("Just going to put some random text here but this is supposed to be like a short introduction of some sort... asdfjas;lkdjfl;kasjdf;lkasjdf;lksajdl;kfjas;lkdfj;lskadjf;lksajd;lfkjas;ldfjas;lkdjf;laskjdf;oai whsepfoiawhje sd;flkasj dfoi;qu2h3jw e;lksjha zelfkiuh qj2;woelifj aw;sdklfh q;woaiejr ;alskdjf ;aslkdfj q[2woi34tj a'slkdfj [q2i9ej as;lkdjf ;slkdfj a;owieh kjshdfjkhkhh']asdlf;kjq;lsdhjfaspdeirhqlkawndfa;sldkfj2o4iansld;fkanwerioasjkdfhase;lrkjqwpe9fuhas;ldkfjas;lkdjf apw9eiotrh a;lskdfj asp9deifh ;awlkej pas9difhj as;lkdfj apw9er8th a;soidfj apwse98th ;oasiej ;oawiejf o;aksjdf;o sajf o;ijwaef;o jaweo"),
  sidebarLayout(
    viz_1_sidebar,
    viz_1_main_panel 
  ),
  p("Just going to put some random text here but this is supposed to be like a short introduction of some sort... asdfjas;lkdjfl;kasjdf;lkasjdf;lksajdl;kfjas;lkdfj;lskadjf;lksajd;lfkjas;ldfjas;lkdjf;laskjdf;oai whsepfoiawhje sd;flkasj dfoi;qu2h3jw e;lksjha zelfkiuh qj2;woelifj aw;sdklfh q;woaiejr ;alskdjf ;aslkdfj q[2woi34tj a'slkdfj [q2i9ej as;lkdjf ;slkdfj a;owieh kjshdfjkhkhh']asdlf;kjq;lsdhjfaspdeirhqlkawndfa;sldkfj2o4iansld;fkanwerioasjkdfhase;lrkjqwpe9fuhas;ldkfjas;lkdjf apw9eiotrh a;lskdfj asp9deifh ;awlkej pas9difhj as;lkdfj apw9er8th a;soidfj apwse98th ;oasiej ;oawiejf o;aksjdf;o sajf o;ijwaef;o jaweo")
)

## INDIVIDUAL COUNTRY ANALYSIS TAB INFO

viz_2_sidebar <- sidebarPanel(
  #TODO: Put inputs for modifying graph here
  selectInput("char_country_input", label = h3("Select Country"), choices = NULL, multiple = TRUE),
  selectInput("char_input", label = h3("Select Characteristics"), choices = NULL, multiple = TRUE),
  width = 3
)

viz_2_main_panel <- mainPanel(
  uiOutput("dynamic_plots"),
  width = 9
)

viz_2_tab <- tabPanel("Climate and Economy Characteristics",
  h2("Analyzing By Characteristics",align = "center"),
  p("Just going to put some random text here but this is supposed to be like a short introduction of some sort... asdfjas;lkdjfl;kasjdf;lkasjdf;lksajdl;kfjas;lkdfj;lskadjf;lksajd;lfkjas;ldfjas;lkdjf;laskjdf;oai whsepfoiawhje sd;flkasj dfoi;qu2h3jw e;lksjha zelfkiuh qj2;woelifj aw;sdklfh q;woaiejr ;alskdjf ;aslkdfj q[2woi34tj a'slkdfj [q2i9ej as;lkdjf ;slkdfj a;owieh kjshdfjkhkhh']asdlf;kjq;lsdhjfaspdeirhqlkawndfa;sldkfj2o4iansld;fkanwerioasjkdfhase;lrkjqwpe9fuhas;ldkfjas;lkdjf apw9eiotrh a;lskdfj asp9deifh ;awlkej pas9difhj as;lkdfj apw9er8th a;soidfj apwse98th ;oasiej ;oawiejf o;aksjdf;o sajf o;ijwaef;o jaweo"),
  fluidRow(viz_2_sidebar,viz_2_main_panel),
  p("Just going to put some random text here but this is supposed to be like a short introduction of some sort... asdfjas;lkdjfl;kasjdf;lkasjdf;lksajdl;kfjas;lkdfj;lskadjf;lksajd;lfkjas;ldfjas;lkdjf;laskjdf;oai whsepfoiawhje sd;flkasj dfoi;qu2h3jw e;lksjha zelfkiuh qj2;woelifj aw;sdklfh q;woaiejr ;alskdjf ;aslkdfj q[2woi34tj a'slkdfj [q2i9ej as;lkdjf ;slkdfj a;owieh kjshdfjkhkhh']asdlf;kjq;lsdhjfaspdeirhqlkawndfa;sldkfj2o4iansld;fkanwerioasjkdfhase;lrkjqwpe9fuhas;ldkfjas;lkdjf apw9eiotrh a;lskdfj asp9deifh ;awlkej pas9difhj as;lkdfj apw9er8th a;soidfj apwse98th ;oasiej ;oawiejf o;aksjdf;o sajf o;ijwaef;o jaweo")
)

## VIZ 3 TAB INFO

viz_3_sidebar <- sidebarPanel(
  h2("Select a country"),
  selectInput("CountryName", 
              label = "select country",
              choices = NULL,
              multiple = FALSE, selected = "United States")
  
)

viz_3_main_panel <- mainPanel(
  tabsetPanel(
    tabPanel("CO2 Emission & Average Temperature", plotlyOutput("CO2_Tem")),
    tabPanel("Average Temperature & Cereal Yield" , plotlyOutput("Tem_AG")),
    tabPanel("Cereal Yield & Economy", plotlyOutput("Cereal_GDP"))
  )
)

viz_3_tab <- tabPanel("Exploring how globol warming impact world economy",
                      h2("Analyzing the relation between each characteristics", align = "center"),
                      p("On this page we will explore how  CO2 Emssion impact Globle Economy"),
                      sidebarLayout(
                        viz_3_sidebar,
                        viz_3_main_panel
                      ),
                      p("Just going to put some random text here but this is supposed to be like a short introduction of some sort... asdfjas;lkdjfl;kasjdf;lkasjdf;lksajdl;kfjas;lkdfj;lskadjf;lksajd;lfkjas;ldfjas;lkdjf;laskjdf;oai whsepfoiawhje sd;flkasj dfoi;qu2h3jw e;lksjha zelfkiuh qj2;woelifj aw;sdklfh q;woaiejr ;alskdjf ;aslkdfj q[2woi34tj a'slkdfj [q2i9ej as;lkdjf ;slkdfj a;owieh kjshdfjkhkhh']asdlf;kjq;lsdhjfaspdeirhqlkawndfa;sldkfj2o4iansld;fkanwerioasjkdfhase;lrkjqwpe9fuhas;ldkfjas;lkdjf apw9eiotrh a;lskdfj asp9deifh ;awlkej pas9difhj as;lkdfj apw9er8th a;soidfj apwse98th ;oasiej ;oawiejf o;aksjdf;o sajf o;ijwaef;o jaweo")
)

## CONCLUSIONS TAB INFO

conclusion_tab <- tabPanel("Conclusion",
 h1("Some title"),
 p("some conclusions"),
 includeMarkdown("Intro Text.md")
)

# Original: #E8F2F9
#CFF09E
#C6DAF2

ui <- navbarPage("INFO 201 Final Project",
theme = bs_theme(background = "#C6DAF2",foreground = "#959BA2",primary = "#E46410",success = "#34A853"),
  overview_tab,
  viz_1_tab,
  viz_2_tab,
  viz_3_tab,
  conclusion_tab)
  