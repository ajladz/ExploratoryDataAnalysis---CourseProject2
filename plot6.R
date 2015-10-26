# Downloading the data and loading it into R

if(!file.exists('data')){
        dir.create('data')
}

fileUrl <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip'
download.file(fileUrl, destfile = './data/EmissionData.zip')
unzip('./data/EmissionData.zip')

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
# in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in 
# motor vehicle emissions?

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
B_LA <- motor_v[motor_v$fips == '24510'|motor_v$fips == '06037',]
b_la <- aggregate(Emissions ~ year + fips, data = B_LA, sum)

b_la$fips <- factor(b_la$fips)
levels(b_la$fips)
levels(b_la$fips) <- c('Los Angeles County', 'Baltimore City')

png(filename = 'plot6.png', , width = 768, height = 480)
ggplot(b_la, aes(x = year, y = Emissions, group = fips)) + geom_line(aes(colour = fips)) + 
        labs(title = 'Emissions From Motor Vehicles in Baltimore City and Los Angeles County (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')
dev.off()
