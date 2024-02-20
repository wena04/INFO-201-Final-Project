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

#Changing the country codes to their country names and renaming the column to country
wb_df3$ISO_3DIGIT <- countrycode(wb_df3$ISO_3DIGIT,"iso3c","country.name",custom_match = c(KSV = "Kosovo"))
wb_df3 <- rename(wb_df3,"Country"="ISO_3DIGIT")

#creating a new df with the average earth surface temperature by country
AverageTemp_df <- berk_df %>% group_by(Country) %>% summarize(Average_Temperature = mean(AverageTemperature,na.rm = TRUE), Average_Temperature_Uncertainty = mean(AverageTemperatureUncertainty,na.rm = TRUE))

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

#joining tables together by year and country
final_df <- inner_join(wb_long,weo_data_long,by = c("Country.name" = "Country","Year"="Year"),relationship = "many-to-many")
final_df <- inner_join(final_df,wb_df3,by = c("Country.name" = "Country"))
final_df <- inner_join(final_df,AverageTemp_df,by=c("Country.name" = "Country"))

#renaming the columns to the correct names
final_df <- rename(final_df,"Country"="Country.name","Climate_Characteristic"="Series.name","Scale_Climate"="SCALE","Climate_Values"="Value.x","Economy_Characteristic"="Subject.Descriptor","Units_Economy"="Units","Scale_Economy"="Scale","Economy_Values"="Value.y","Feb_Temp"="Feb_temp","Mar_Temp"="Mar_temp","May_Temp"="May_temp","Sept_Temp"="Sept_temp","Oct_Temp"="Oct_temp","Dec_Temp"="Dec_temp","Annual_Temp"="Annual_temp")


