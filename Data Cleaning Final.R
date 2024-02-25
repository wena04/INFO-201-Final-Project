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
weo_country_df <- inner_join(GDP,Population,by=c("Country" = "Country","Year"="Year"))
weo_country_df <- inner_join(weo_country_df,Investment,by=c("Country" = "Country","Year"="Year"))
#Changing the Characteristics to contain units and scale by adding the scale and units column to the characterisitcs
weo_country_df <- weo_country_df %>% mutate(Units.x = paste(Units.x," (Billions)"),Units.y = paste(Units.y," (Millions)"))
weo_country_df <- weo_country_df %>% select(Country,Year,gdp,Units.x,Population,Units.y,`Total investment`,Units)
weo_country_df <- weo_country_df %>% rename("Gdp_units" = "Units.x", "Population_units" = "Units.y","
                                            Total_invest_units"="Units","Gdp" = "gdp")
#Creating the new column GDP per Capita
weo_country_df <- weo_country_df %>% mutate(Gdp = gsub("[^0-9\\.]", "", Gdp), Gdp = as.numeric(Gdp), Population = gsub("[^0-9]", "", Population), Population = as.numeric(Population)) %>% mutate(Gdp_per_cap = if_else(is.na(Gdp) | is.na(Population), NA_real_, (Gdp * 1000) / Population))
weo_country_df <- weo_country_df %>% mutate(Gdp = if_else(is.na(Gdp), 0, Gdp),Population = if_else(is.na(Population), 0, Population),Gdp_per_cap = (Gdp * 1000) / Population) 
weo_country_df <- weo_country_df %>% filter(!str_starts(Year,"198"))

#joining all of the tables together to be one final dataset
final_df <- left_join(berk_df,wb_df,by=c("Country"="Country.name","dt"="Year"))
final_df <- inner_join(weo_country_df,final_df,by=c("Country"="Country","Year"="dt"))

#Classifying countries and years based on average temperature
final_df <- final_df %>% mutate(climate_zone = case_when(Average_temp > 18 ~ "Tropical", Average_temp <= 18 & Average_temp > 10 ~ "Temperate", Average_temp<= 10 ~ "Cold", TRUE ~ "Not Classified"))
#Classifying countries based on their income level
final_df <- final_df %>% mutate(economic_status = case_when(Gdp < 10 ~ "Low-income",Gdp >= 10 & Gdp < 50 ~ "Lower-middle-income",Gdp >= 50 & Gdp < 200 ~ "Upper-middle-income",Gdp >= 200 ~ "High-income",TRUE ~ NA_character_))
# Classifying Development level based on GDP per capita and total investment percent
final_df <- final_df %>% mutate(development_status = case_when(Gdp_per_cap > 20 & `Total investment` > 20 ~ "Developed", Gdp_per_cap >= 5 & Gdp_per_cap <= 20 & `Total investment` >= 15 & `Total investment` <= 20 ~ "Developing",TRUE ~ "Developing" ))
#Classifying countries based on their CO2 emissions rate
final_df <- final_df %>% mutate(co2_category = case_when(`CO2 emissions per capita (metric tons)` < 2 ~ "Low emissions",`CO2 emissions per capita (metric tons)` >= 2 & `CO2 emissions per capita (metric tons)` < 10 ~ "Medium emissions",`CO2 emissions per capita (metric tons)` >= 10 & `CO2 emissions per capita (metric tons)` < 20 ~ "High emissions",`CO2 emissions per capita (metric tons)` >= 20 ~ "Very high emissions",TRUE ~ "Not Classified"))
#Classifying countries based on their population
final_df <- final_df %>% mutate(population_category = case_when(Population < 5 ~ "Small population",Population >= 5 & Population < 50 ~ "Medium population",Population >= 50 ~ "Large population",TRUE ~ "Not Classified"))

#renaming the columns in the dataframe
final_df <- final_df %>% rename("CO2_emissions"=`CO2 emissions per capita (metric tons)`,"Total_investment" = `Total investment`)

#reording the columns to look neater
#final_df <- final_df %>% select(Country,Year,CO2_emissions,co2_category)
