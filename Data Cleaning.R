#Loading all initial CSV files before cleaning them

# World Bank's country climate change characteristics from 1990-2011
wb_df <- read.csv("Initial CSV Files/World Bank Climate Change.csv")
#Berkeley Earth's country surface monthly average temperature from 1743 to 2013
berk_df <- read.csv("Initial CSV Files/GlobalLandTemperaturesByCountry.csv")
#Average Temperature by month for each country from 1961 to 1999 in Celcius
wb_df3 <- read.csv("Initial CSV Files/historical-data country temperature.csv")
#Economic Dataset from WEO sorted by counrty
weo_country_df <- read.csv("Initial CSV Files/WEO by country.csv")
#Economic Dataset from WEO sorted by characteristics
weo_data_df <- read.csv("Initial CSV Files/WEO by Data.csv")



