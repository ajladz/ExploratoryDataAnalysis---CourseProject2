# Downloading the data and loading it into R

if(!file.exists('data')){
        dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/EmissionData.zip')
unzip('./data/EmissionData.zip')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

scc <- SCC[grepl('coal', SCC$EI.Sector, ignore.case = TRUE), ]
nei_scc <- merge(NEI, scc, by = 'SCC')
neiSCC <- aggregate(Emissions ~ year + EI.Sector, data = nei_scc, sum)

png(filename = 'plot4.png', width = 768, height = 480)
ggplot(neiSCC, aes(x = year, y = Emissions, group = EI.Sector)) + geom_line(aes(color = EI.Sector)) + 
        labs(title = 'Emissions From Coal Combustion-Related Sources (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')
dev.off()

