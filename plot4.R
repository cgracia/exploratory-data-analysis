## Script for the fourth plot

# Instructions:
# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

# Load the needed data
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# In order to find the coal related sources we look into the "EI.Sector"
# variable for the word "Coal"
library(dplyr)
SCC_coal <- SCC %>%
        select(SCC, EI.Sector) %>% # Only keep the columns we will use
        filter(grepl("Coal", EI.Sector))
        
# Merge the data with NEI keeping only the rows related with coal
NEI_coal <- merge(NEI, SCC_coal)

# Group and summarize
NEI_coal_year <- NEI_coal %>%
        group_by(year) %>%
        summarise(total_emissions = sum(Emissions))
        
# Finally the result is plotted
library(ggplot2)
g <- ggplot(NEI_coal_year, aes(x = year, y = total_emissions))
g + geom_line(color = "red", size = 1.5) +
        labs(title = "Coal emissions in the United States (1999-2008)") +
        labs(x = "Year", y = "Coal PM2.5 emissions (tons)") +
ggsave('plot4.png')