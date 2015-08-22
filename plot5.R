## Script for the fifth plot

# Instructions:
# How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?

# Load the needed data
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Inspecting the names of the EI.Sector in SCC, the word "Mobile" indicates
# motor vehicles, we filter the rows that contain it
# This will include both road and non-road vehicles. It will also contain some
# mobile source like lawn mowers, which are not motor vehicles. However, their
# contribution is minimal and the influence in the exploratory graph is
# negligible
library(dplyr)
SCC_mobile <- SCC %>%
        select(SCC, EI.Sector) %>% # Only keep the columns we will use
        filter(grepl("Mobile", EI.Sector))

# Extract the data from Baltimore
NEI_Baltimore <- filter(NEI, fips == "24510")

# Merge the data with NEI keeping only the rows related with motor vehicles
NEI_mobile <- merge(NEI_Baltimore, SCC_mobile)

# Group and summarize
NEI_mobile_year <- NEI_mobile %>%
        group_by(year) %>%
        summarise(total_emissions = sum(Emissions))

library(ggplot2)
g <- ggplot(NEI_mobile_year, aes(x = year, y = total_emissions))
g + geom_line(color = "red", size = 1.5) +
        labs(title = "Motor vehicle emissions in Baltimore City (1999-2008)") +
        labs(x = "Year", y = "Motor vehicle PM2.5 emissions (tons)") +
ggsave('plot5.png')