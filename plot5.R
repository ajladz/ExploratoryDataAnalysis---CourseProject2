# Downloading the data and loading it into R

if(!file.exists('data')){
        dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/EmissionData.zip')
unzip('./data/EmissionData.zip')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

unique(SCC$EI.Sector)
mobile <- grepl('mobile', SCC$EI.Sector, ignore.case = TRUE)
m <- SCC[mobile, ]
unique(SCC[mobile, 'SCC.Level.Two'])

# After looking through the levels of SCC.Level.Two and considering the definition of 'motor vehicle': 
#'For legal purposes motor vehicles are often identified within a number of vehicle classes including 
# cars, buses, motorcycles, off-road vehicles, light trucks and regular trucks' - Wikiedia
# I decided to drop out airplanes, marine vessels, pleasure craft, raiload equipment and the like. 

vehicle <- grepl('vehicle', m$SCC.Level.Two, ignore.case = TRUE)
v <- m[vehicle,]

motor_v <- merge(NEI, v, by = 'SCC')
m_Baltimore <- motor_v[motor_v$fips == "24510",]
motorBaltimore <- aggregate(m_Baltimore$Emissions, by = list(m_Baltimore$year), sum)
names(motorBaltimore) <- c('Year', 'Emissions')

png(filename = 'plot5.png', width = 768, height = 480)
ggplot(motorBaltimore, aes(x = Year, y = Emissions)) + geom_line() + 
        labs(title = 'Emissions From Motor Vehicle Sources in Baltimore (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')
dev.off()

