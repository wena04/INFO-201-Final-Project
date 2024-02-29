library(plotly)
library(ggplot2)
library(maps)

final_df <- read.csv("final_df.csv")

# Load world map data
world_map <- map_data("world")

# Merge your data with the world map data
world_with_temp <- world_map %>% left_join(final_df, by = c("region" = "Country")) # Make sure the column names match

# Plot the map
wm <- ggplot(data = world_with_temp, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = Average_temp)) + # Fill color based on Average_temp
  scale_fill_viridis_c(name = "Temperature (C)") + # Use a color scale that represents temperature
  coord_fixed(1.3) + # Fix the aspect ratio
  labs(title = "Average Temperature by Country") +
  theme_gray() 
ggplotly(wm)
