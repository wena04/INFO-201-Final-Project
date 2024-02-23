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
#Average precipetation by month for each country from 1961 to 1999
wb_df4 <- read.csv("Initial CSV Files/Berk_Precip.csv")
#Economic Dataset from WEO sorted by country from 1990 to 2020
weo_country_df <- read.csv("Initial CSV Files/WEO by country.csv")

#Changing the country codes to their country names and renaming the column to country
wb_df3$ISO_3DIGIT <- countrycode(wb_df3$ISO_3DIGIT,"iso3c","country.name",custom_match = c(KSV = "Kosovo"))
wb_df3 <- rename(wb_df3,"Country"="ISO_3DIGIT")

wb_df4$ISO_3DIGIT <- countrycode(wb_df4$ISO_3DIGIT,"iso3c","country.name",custom_match = c(KSV = "Kosovo"))
wb_df4 <- rename(wb_df4,"Country"="ISO_3DIGIT")

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
final_df <- inner_join(final_df,wb_df4,by = c("Country.name" = "Country"))
final_df <- inner_join(final_df,AverageTemp_df,by=c("Country.name" = "Country"))

#renaming the columns to the correct names
final_df <- rename(final_df,"Country"="Country.name","Climate_Characteristic"="Series.name","Scale_Climate"="SCALE","Climate_Values"="Value.x","Economy_Characteristic"="Subject.Descriptor","Units_Economy"="Units","Scale_Economy"="Scale","Economy_Values"="Value.y","Feb_Temp"="Feb_temp","Mar_Temp"="Mar_temp","May_Temp"="May_temp","Sept_Temp"="Sept_temp","Oct_Temp"="Oct_temp","Dec_Temp"="Dec_temp","Annual_Temp"="Annual_temp")
#reordering the columns to make it nicer
final_df <- final_df %>% select(Country,Year,everything())

final_df$Climate_Characteristic
#removing rows with climax_characteristics that we are not looking for
final_df <- final_df %>% filter(!Climate_Characteristic %in% c("Land area below 5m (% of land area)","Agricultural land under irrigation (% of total ag. land)","Nitrous oxide (N2O) emissions, total (KtCO2e)","Other GHG emissions, total (KtCO2e)","Disaster risk reduction progress score (1-5 scale; 5=best)","GHG net emissions/removals by LUCF (MtCO2e)", "Hosted Joint Implementation (JI) projects","Access to improved water source (% of total pop.)", "Nurses and midwives (per 1,000 people)","Access to improved sanitation (% of total pop.)","Child malnutrition, underweight (% of under age 5)", "Population living below $1.25 a day (% of total)","Population growth (annual %)","Cereal yield (kg per hectare)","Physicians (per 1,000 people)", "Malaria incidence rate (per 100,000 people)", "Urban population growth (annual %)", "Urban population","Methane (CH4) emissions, total (KtCO2e)", "Annex-I emissions reduction target","Hosted Clean Development Mechanism (CDM) projects","Issued Certified Emission Reductions (CERs) from CDM (thousands)
","Droughts, floods, extreme temps (% pop. avg. 1990-2009)", "NAPA submission","Latest UNFCCC national communication","Renewable energy target", "Population in urban agglomerations >1million (%)","Ease of doing business (ranking 1-183; 1=best)","Invest. in energy w/ private participation ($)","Ratio of girls to boys in primary & secondary school (%)","Primary completion rate, total (% of relevant age group)","Under-five mortality rate (per 1,000)","Population
","GNI per capita (Atlas $)","Paved roads (% of total roads)","Public sector mgmt & institutions avg. (1-6 scale; 6=best)","Invest. in water/sanit. w/ private participation ($)","Annual freshwater withdrawals (% of internal resources)","Population below 5m (% of total)","Invest. in telecoms w/ private participation ($)","Projected change in annual hot days/warm nights","Access to electricity (% of total population)","Foreign direct investment, net inflows (% of GDP)","NAMA submission","Nationally terrestrial protected areas (% of total land area)","Invest. in transport w/ private participation ($)","GNI per capita (Atlas $)","Population","Energy use per units of GDP (kg oil eq./$1,000 of 2005 PPP $)","Energy use per capita (kilograms of oil equivalent)","CO2 emissions, total (KtCO2)","Average annual precipitation (1961-1990, mm)","Issued Certified Emission Reductions (CERs) from CDM (thousands)","Issued Certified Emission Reductions (CERs) from CDM (thousands)","Average daily min/max temperature (1961-1990, Celsius)","Projected annual temperature change (2045-2065, Celsius)","Projected change in annual cool days/cold nights","CO2 emissions per units of GDP (kg/$1,000 of 2005 PPP $)","Issued Emission Reduction Units (ERUs) from JI (thousands)","Projected annual precipitation change (2045-2065, mm)","GDP"))

#removing rows with Economy_characteristics that we are not looking for
final_df <- final_df %>% filter(!Economy_Characteristic %in% c("Gross domestic product corresponding to fiscal year, current prices","Total investment","Gross domestic product, current prices","Gross domestic product per capita, current prices"))

#removing rows with Countries lack of  useful information 
#final_df <- final_df %>% filter(!Country %in% c("Afghanistan","Belarus","Azerbaijan"))

#removing rows with years with 1 year time gap 
#final_df <- final_df %>% filter(!Year %in% c("1991","1993","1995","1997","1999","2001", "2003", "2005","2007","2009","2011"))

#make economic characteristics columns and not rows
final_df <- final_df %>% mutate

#test_df<-final_df %>% 
#  filter(Economy_Values == "n/a" & Economy_Characteristic=="Population")
  
nrow(final_df)


