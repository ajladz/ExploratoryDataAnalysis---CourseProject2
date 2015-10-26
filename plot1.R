# Downloading the data and loading it into R

if(!file.exists('data')){
        dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/EmissionData.zip')
unzip('./data/EmissionData.zip')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each 
# of the years 1999, 2002, 2005, and 2008.

year_em <- aggregate(NEI$Emissions, list(NEI$year), FUN = sum)
names(year_em) <- c('Year', 'Emission')

png(filename = 'plot1.png')
plot(x = year_em$Year, y = year_em$Emission, type = 'b', main = 'PM2.5 Emission (1999 - 2008)', xlab = 'Year', ylab = 'Total Emission [tons]')
dev.off()

