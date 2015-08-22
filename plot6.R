## Script for the sixth plot

# Instructions:
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California 
# (fips == "06037"). Which city has seen greater changes over time in motor 
# vehicle emissions?

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

# Extract the data from Baltimore or Los Angeles
NEI_filtered <- filter(NEI, fips == "24510" | (fips == "06037"))

# Merge the data with NEI keeping only the rows related with motor vehicles
NEI_mobile <- merge(NEI_filtered, SCC_mobile)

# Group and summarize
NEI_summarized <- NEI_mobile %>%
        group_by(fips, year) %>%
        summarise(emissions = sum(Emissions))

# The scale of both cities is not good to compare. Besides, we are interested in
# the change over time, not in the absolute values. We will compute three points
# for each city with the difference between two years and divide it by the value
# of the first year in the interval. It will be multiplied by 100 to get a
# percentage of change in every interval.
emissions_change <- NEI_summarized %>%
        mutate(change = (diff(emissions)/emissions)*100) %>%
        filter(year != 2008) %>% # Value for last year is useless
        mutate(year = year + 3) %>% # We assign to each interval the final year
                                # instead of the initial one
        select(-emissions) %>%
        mutate(county = ifelse(fips == "24510", "Baltimore City",
               "Los Angeles")) # Column for county names


# We plot the data. It is important to remember that each point represents a
# percentual change in emissions in the previous three year period.
# Any point above the black line (x=0) is an increase.
library(ggplot2)
g <- ggplot(emissions_change, aes(x = year, y = change))
g + geom_line(aes(color = county)) +
        labs(title = "Change in motor vehicles PM2.5 emissions 
in three year intervals (1999-2008)") +
        labs(x = "Year", y = "Change in motor vehicles PM2.5 (%)") +
        labs(color = "County") +
        geom_hline()
ggsave('plot6.png')