library(tidyr)
library(dplyr)
library(stringr)
#Loading all initial CSV files before cleaning them

# World Bank's country climate change characteristics from 1990-2011
wb_df <- read.csv("Initial CSV Files/World Bank Climate Change.csv")
#Berkeley Earth's country surface monthly average temperature from 1743 to 2013
berk_df <- read.csv("Initial CSV Files/GlobalLandTemperaturesByCountry.csv")
#Economic Dataset from WEO sorted by country from 1990 to 2020
weo_country_df <- read.csv("Initial CSV Files/WEO by country.csv")


#Summarizing the World Bank's Climate Change table to get CO2 Emissions Value

#converting all the year values to be rows and not columns
wb_df <- wb_df %>%
  pivot_longer(
    cols = starts_with("X"), #Selects all columns that start with X
    names_to = "Year", # This is the new column that will contain the year values
    values_to = "Value",
    names_prefix = "X" # This removes the 'X' prefix from the year column names
  ) %>%
  mutate(
    Year = as.integer(gsub("X", "", Year)) # Convert the year to an integer and remove the 'X' prefix
  ) %>% select(Country.name,Series.name,Year,Value)
#filtering to only keep the CO2 Emissions part of the dataframe
wb_df <- wb_df %>% filter(Series.name == "CO2 emissions per capita (metric tons)")
#converting all the CO2 Emissions from being rows to being columns
wb_df <- wb_df %>%
  pivot_wider(
    names_from = "Series.name",
    values_from = "Value"
  )

#Summarizing the berk dataset to get the Average Temperature and Average Uncertainty of each year for each country from 1990 to 2010.

# filering to keep only the years 1990 to 2010 as that is kept consistent with the WEO dataset
berk_df <- berk_df %>% mutate(dt = as.integer(str_sub(dt,1,4)))
berk_df <- berk_df %>% filter((str_starts(dt, "199") | str_starts(dt, "20")) & !str_starts(dt, "2011") & !str_starts(dt, "2012") & !str_starts(dt, "2013"))
# creating a new column "Group" that will indicate which year group and country group a the averaged volumn will belong to. (Since we know there is 12 months a year)
berk_df <- berk_df %>% mutate(Groups = ceiling(row_number()/12)) 
#calculating the average temperature based on the groups
average_temp <- berk_df %>% group_by(Groups) %>% summarize(Average_temp = mean(AverageTemperature,na.rm = TRUE),Average_tempunct = mean(AverageTemperatureUncertainty,na.rm = TRUE)) 
#joining the two tables together
berk_df <- berk_df %>% left_join(average_temp,by=c("Groups"="Groups"))
#choosing only the first row of every group so get 1 value each year for each country
berk_df <- berk_df %>% group_by(Groups) %>% slice(1) %>% select(Groups,dt,Country,Average_temp,Average_tempunct)


#Summarizing the WEO dataset for GDP, Population, and total Investment

#change the years from being columns to rows and selecting only important columns that we will need
weo_country_df <- weo_country_df %>%
  pivot_longer(
    cols = starts_with("X"), #Selects all columns that start with X
    names_to = "Year", # This is the new column that will contain the year values
    values_to = "Value",
    names_prefix = "X" # This removes the 'X' prefix from the year column names
  ) %>%
  mutate(
    Year = as.integer(gsub("X", "", Year)) # Convert the year to an integer and remove the 'X' prefix
  ) %>% select(Country,Subject.Descriptor,Units,Scale,Year,Value)
#keep only the characteristics that we want to analyze by itself so we can change them to columns later
GDP <- weo_country_df %>% filter(Subject.Descriptor == "Gross domestic product, current prices")
Population <- weo_country_df %>% filter(Subject.Descriptor == "Population")
Investment <- weo_country_df %>% filter(Subject.Descriptor == "Total investment")
#changing each characteristics into columns and not rows
GDP <- GDP %>% 
  pivot_wider(
    names_from = "Subject.Descriptor",
    values_from = "Value"
  ) %>% rename("gdp"="Gross domestic product, current prices")
Population <- Population %>% 
  pivot_wider(
    names_from = "Subject.Descriptor",
    values_from = "Value"
  )
Investment <- Investment %>% 
  pivot_wider(
    names_from = "Subject.Descriptor",
    values_from = "Value"
  )
#joining the tables together
weo_country_df <- left_join(GDP,Population,by=c("Country" = "Country","Year"="Year"))
weo_country_df <- left_join(weo_country_df,Investment,by=c("Country" = "Country","Year"="Year"))

#joining all of the tables together to be one final dataset


#Creating the new column GDP per Capita
#weo_country_df <- weo_country_df %>% filter(gdp != na) %>% mutate(GDP_per_Capita = (gdp*100000000)/ Population)
#Checking the GDP to create catagorical Data Developing or Non Developing Country
#weo_country_df <- weo_country_df %>% mutate(Is_Develop = if_else(GDP_per_Capita >= 15,000,na_rm = TRUE), TRUE, FALSE)


