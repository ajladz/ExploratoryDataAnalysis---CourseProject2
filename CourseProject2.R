
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

# As we can see from the graph, total emission of PM2.5 has significantly decreased in years from 1999 to 2008.
# From more than 7 million tons, which was total amount of emitted PM2.5 in 1999 it decreased to less than 
# 4 million tons in 2008.

# The difference between the amount of PM2.5 emitted in 1999 and the amount emitted in 2008 (in tons) :
year_em[year_em$Year == 1999, 2] - year_em[year_em$Year == 2008, 2]



# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 
# 2008? Use the base plotting system to make a plot answering this question.

Baltimore <- NEI[NEI$fips == '24510', ]
Baltimore <- tbl_df(Baltimore)
baltimore <- aggregate(Baltimore$Emission, by = list(Baltimore$year), FUN = sum)
names(baltimore) <- c('Year', 'Emission')

png(filename = 'plot2.png')
plot(x = baltimore$Year, y = baltimore$Emission, type = 'b', main = 'M2.5 Emission in Baltimore (1999 - 2008)', xlab = 'Year', ylab = 'Total Emission [tons]')
dev.off()

# As we can see from the graph, total emission of PM2.5 in Baltimore had decreased significantly. 
# To be precise, the difference between the amount of PM2.5 emitted in 1999 and the amount emitted in 2008 (in tons) :
baltimore[baltimore$Year == 1999, 2] - baltimore[baltimore$Year == 2008, 2]

# From the graph we can also see that the amount of PM2.5 emitted in 2005 was greater than the amount emitted in 2002.
# In 2005 the amount of PM2.5 emitted in Baltimore was almost as high as in 1999.
# PM2.5 in 1999 (in tons):
baltimore[baltimore$Year == 1999, 2] 
# PM2.5 in 2005 (in  tons):
baltimore[baltimore$Year == 2005, 2]

# But in 2008 we can see that the amount is significantly smaller than in 1999 or in 2005:
baltimore[baltimore$Year == 2008, 2]



# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot 
# answer this question.
library(ggplot2)
baltimore <- aggregate(Emissions ~ year + type, Baltimore, sum)

png(filename = 'plot3.png', width = 480, height = 480)
ggplot(baltimore, aes(x = year, y = Emissions, group = type)) + geom_line(aes(color = type)) + 
        labs(title = 'Emission of PM2.5 in Baltimore grouped by source (1999 - 2008)', x = 'Year', y = 'Emission of PM2.5 (in tons)')

dev.off()

# From the graph we can see that the emission of PM2.5 in Baltimore, for years 1999 - 2008, had decreased 
# for NONPOINT, NON-ROAD and ON-ROAD sources. From the graph it's also noticable that the emission of PM2.5 
# had actually slightly increased for POINT sources.

# Emission of PM2.5 in 1999 (in tons):
baltimore[baltimore$year == 1999 & baltimore$type == 'POINT', 3]
# Emission of PM2.5 in 2008 (in tons):
baltimore[baltimore$year == 2008 & baltimore$type == 'POINT', 3]



# Question 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?

scc <- SCC[grepl('coal', SCC$EI.Sector, ignore.case = TRUE), ]

nei_scc <- merge(NEI, scc, by = 'SCC')

neiScc <- aggregate(nei_scc$Emissions, by = list(nei_scc$year), sum)
names(neiScc) <- c('Year', 'Emissions')

neiSCC <- aggregate(Emissions ~ year + EI.Sector, data = nei_scc, sum)

ggplot(neiSCC, aes(x = year, y = Emissions, fill = EI.Sector)) + geom_bar(stat = 'identity', position = 'dodge') + 
        labs(title = 'Emissions From Coal Combustion-Related Sources (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')

ggplot(neiSCC, aes(x = year, y = Emissions, group = EI.Sector)) + geom_line(aes(color = EI.Sector)) + 
        labs(title = 'Emissions From Coal Combustion-Related Sources (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')
        
ggplot(neiScc, aes(x = Year, y = Emissions)) + geom_line() + labs(title = 'Emissions From Coal Combustion-Related Sources (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')


# Question 5
# How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?

unique(SCC$EI.Sector)

mobile <- grepl('mobile', SCC$EI.Sector, ignore.case = TRUE)
m <- SCC[mobile, ]

unique(SCC[mobile, 'SCC.Level.Two'])

# After looking through the levels of SCC.Level.Two and considering the definition of 'motor vehicle': 
# 'For legal purposes motor vehicles are often identified within a number of vehicle classes including 
#  cars, buses, motorcycles, off-road vehicles, light trucks and regular trucks' - wiki
# I decided to drop out airplanes, marine vessels, leasure craft, raiload equipment and the like.

vehicle <- grepl('vehicle', m$SCC.Level.Two, ignore.case = TRUE)
v <- m[vehicle,]

motor_v <- merge(NEI, v, by = 'SCC')
m_Baltimore <- motor_v[motor_v$fips == "24510",]
motorBaltimore <- aggregate(m_Baltimore$Emissions, by = list(m_Baltimore$year), sum)
names(motorBaltimore) <- c('Year', 'Emissions')


ggplot(motorBaltimore, aes(x = Year, y = Emissions)) + geom_line() + 
        labs(title = 'Emissions From Motor Vehicle Sources in Baltimore (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')


# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
# in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in 
# motor vehicle emissions?

B_LA <- motor_v[motor_v$fips == '24510'|motor_v$fips == '06037',]
b_la <- aggregate(Emissions ~ year + fips, data = B_LA, sum)

b_la$fips <- factor(b_la$fips)
levels(b_la$fips)
levels(b_la$fips) <- c('Los Angeles County', 'Baltimore City')

ggplot(b_la, aes(x = year, y = Emissions, group = fips)) + geom_line(aes(colour = fips)) + 
        labs(title = 'Emissions From Motor Vehicles in Baltimore City and Los Angeles County (1999 - 2008)', x = 'Year', y = 'Emissions (in tons)')






