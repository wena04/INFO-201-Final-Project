library(tidyr)
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

str(weo_country_df)

#changing the years to be rows instead of columns for all datasets
weo_data_long <- weo_country_df %>%
  pivot_longer(
    cols = starts_with("X"), #Selects all columns that start with X
    names_to = "Year", # This is the new column that will contain the year values
    values_to = "Value",
    names_prefix = "X" # This removes the 'X' prefix from the year column names
  ) %>%
  mutate(
    Year = as.integer(gsub("X", "", Year)) # Convert the year to an integer and remove the 'X' prefix
  ) %>% select(Country,Subject.Descriptor,Units,Scale,Year,Value)

wb_long <- wb_df %>%
  pivot_longer(
    cols = starts_with("X"), #Selects all columns that start with X
    names_to = "Year", # This is the new column that will contain the year values
    values_to = "Value",
    names_prefix = "X" # This removes the 'X' prefix from the year column names
  ) %>%
  mutate(
    Year = as.integer(gsub("X", "", Year)) # Convert the year to an integer and remove the 'X' prefix
  ) %>% select(Country.name,Series.name,SCALE,Year,Value)


#Example Cleaning up 
#rural_county_max_fd_df <- rural_df %>% 
#  filter(fd_percent == max_rural) %>% 
#  arrange(desc(Population)) %>% 
#  select(County, State, Population, fd_percent)



