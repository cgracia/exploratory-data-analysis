## Script for the first plot

# Instructions:
# Have total emissions from PM2.5 decreased in the United States from 1999 to 
# 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Load the needed data
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")

# The first step is to sum all the emissions from all sources for each year
library(dplyr)
NEI <- tbl_df(NEI)
yearly_PM25 <- NEI %>%
        group_by(year) %>%
        summarise(total_emissions = sum(Emissions))

# Next we use the plot function from the base plotting system to show the
# evolution of the total PM2.5 for each year.
png('plot1.png')
with(yearly_PM25, plot(year, total_emissions, 
                     type = "l",
                     lwd = "3",
                     col = "red",
                     xlab = "Year",
                     ylab = "Total PM2.5 emissions (tons)",
                     main = "PM2.5 emissions in the United States 1999-2008"))
dev.off()
