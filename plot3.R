# Downloading the data and loading it into R

if(!file.exists('data')){
        dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/EmissionData.zip')
unzip('./data/EmissionData.zip')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

library(ggplot2)
baltimore <- aggregate(Emissions ~ year + type, Baltimore, sum)

png(filename = 'plot3.png', width = 768, height = 480)
ggplot(baltimore, aes(x = year, y = Emissions, group = type)) + geom_line(aes(color = type)) + 
        labs(title = 'Emission of PM2.5 in Baltimore grouped by source (1999 - 2008)', x = 'Year', y = 'Emission of PM2.5 (in tons)')

dev.off()


