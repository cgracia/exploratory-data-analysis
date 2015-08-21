## Script for the second plot

# Instructions:
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.

# Load the needed data
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")

# Take all the emissions from Baltimore for each year
library(dplyr)
NEI <- tbl_df(NEI)
yearly_PM25_Baltimore <- NEI %>%
        group_by(year) %>%
        filter(fips == "24510") %>%
        summarise(total_emissions = sum(Emissions))

# Next we use the plot function from the base plotting system to show the
# evolution of the total PM2.5 for each year.
png('plot2.png')
with(yearly_PM25_Baltimore, plot(year, total_emissions, 
                       type = "l",
                       lwd = "3",
                       col = "red",
                       xlab = "Year",
                       ylab = "Total PM2.5 emissions (tons)",
                       main = "PM2.5 emissions in Baltimore City 1999-2008"))
dev.off()