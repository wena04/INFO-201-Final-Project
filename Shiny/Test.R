library(plotly)
library(ggplot2)
library(maps)

final_df <- read.csv("final_df.csv")

select_df <- final_df %>% filter(Country == "United States") %>% select(Country, Year, CO2_emissions,Average_temp)

