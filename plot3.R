## Script for the third plot

# Instructions:
# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in 
# emissions from 1999–2008 for Baltimore City? Which have seen increases in 
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

# Load the needed data
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# The data about the type of source is in the SCC file, we need to match it
# using the SCC columns
library(dplyr)
SCC_category <- select(SCC, SCC, Data.Category) # We only need two columns
NEI_Baltimore <- filter(NEI, fips == "24510") # Smaller data set is faster
NEI_merged <- merge(NEI_Baltimore, SCC_category)

# Group the variables by type and year
NEI_type_year <- NEI_merged %>%
        group_by(Data.Category, year) %>%
        summarise(total_emissions = sum(Emissions)) %>%
        filter(Data.Category != "Event") # Filter out the Event type

# Plot the evolution with different colors for the different types using ggplot
# from ggplot2
library(ggplot2)
g <- ggplot(NEI_type_year, aes(x = year, y = total_emissions))
g + geom_line(aes(color = Data.Category)) +
    labs(title = "Emissions in Baltimore City by type (1999-2008)") +
    labs(x = "Year", y = "PM2.5 emissions (tons)") +
    labs(color = "Type")
ggsave('plot3.png')
