# Downloading the data and loading it into R

if(!file.exists('data')){
        dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/EmissionData.zip')
unzip('./data/EmissionData.zip')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 
# 2008? Use the base plotting system to make a plot answering this question.

Baltimore <- NEI[NEI$fips == '24510', ]
baltimore <- aggregate(Baltimore$Emission, by = list(Baltimore$year), FUN = sum)
names(baltimore) <- c('Year', 'Emission')

png(filename = 'plot2.png')
plot(x = baltimore$Year, y = baltimore$Emission, type = 'b', main = 'M2.5 Emission in Baltimore (1999 - 2008)', xlab = 'Year', ylab = 'Total Emission [tons]')
dev.off()

