library(dplyr)
library(stringr)
library(countrycode)
#Loading all initial CSV files before cleaning them

# World Bank's country climate change characteristics from 1990-2011
wb_df <- read.csv("Initial CSV Files/World Bank Climate Change.csv")
#Berkeley Earth's country surface monthly average temperature from 1743 to 2013
berk_df <- read.csv("Initial CSV Files/GlobalLandTemperaturesByCountry.csv")
#Average Temperature by month for each country from 1961 to 1999 in Celcius
wb_df3 <- read.csv("Initial CSV Files/historical-data country temperature.csv")
#Economic Dataset from WEO sorted by country from 1990 to 2020
weo_country_df <- read.csv("Initial CSV Files/WEO by country.csv")
#Economic Dataset from WEO sorted by characteristics from 1990 to 2020
weo_data_df <- read.csv("Initial CSV Files/WEO by Data.csv")

#Changing the country codes to their country names and renaming the column to country
wb_df3$ISO_3DIGIT <- countrycode(wb_df3$ISO_3DIGIT,"iso3c","country.name",custom_match = c(KSV = "Kosovo"))
wb_df3 <- rename(wb_df3,"Country"="ISO_3DIGIT")

#creating a new df with the average earth surface temperature by country
AverageTemp_df <- berk_df %>% group_by(Country) %>% summarize(AverageTemperature = mean(AverageTemperature,na.rm = TRUE), AverageTemperatureUncertainty = mean(AverageTemperatureUncertainty,na.rm = TRUE))


#Example Cleaning up 
#rural_county_max_fd_df <- rural_df %>% 
#  filter(fd_percent == max_rural) %>% 
#  arrange(desc(Population)) %>% 
#  select(County, State, Population, fd_percent)



