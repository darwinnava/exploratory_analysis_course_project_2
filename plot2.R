---
title: "Exploratory Data Analysis Course Project"
author: "Darwin Nava"
date: "April 11, 2021"
file: "Total_emission_pm25_Baltimore_by_year.R"
---
#[Link to project on GitHUB](https://github.com/darwinnava/exploratory_analysis_course_project_2)
  
# Objective: 
# "The overall goal of this assignment is to explore the National Emissions Inventory database."
# "See what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008."
  
## 1. Required Libraries
## It is required: 
## Read files in the .rds format. / Data cleaning and manipulation / 
## Apply exploratory analysis to dilute the content of the data / Graphing making use of the different plotting systems.
library(dplyr)  # for manipulating, gruoping and chaining data
library(tidyr)  # for tidying data
library(plyr)   # for manipulating data
library(data.table) #  for manipulating data


## 2. Downloading data from the source supplied by coursera
## https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip

## Downloading and unzip data
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")  # Windows OS (method="curl" not required)
unzip("./data/dataset.zip")

## List of files to read
files <- list.files("./", pattern = "*.rds")
#files

## 3. Tidyng Data. 

# a: 'summarySCC_PM25.rds': PM2.5 Emissions data for 1999, 2002, 2005, and 2008, (dim=6497651X6).
# (specified by type of source)
# names: "fips"      "SCC"       "Pollutant" "Emissions" "type"      "year"  

# b: 'Source_Classification_Code.rds': Mapping from SCC digit strings in the Emission table, (dim=11717x15),
# to the actual name of the PM2.5 source. 
# names:    
# "SCC"                 "Data.Category"       "Short.Name"          "EI.Sector"          
# "Option.Group"        "Option.Set"          "SCC.Level.One"       "SCC.Level.Two"      
# "SCC.Level.Three"     "SCC.Level.Four"      "Map.To"              "Last.Inventory.Year"
# "Created_Date"        "Revised_Date"        "Usage.Notes" 

## Reading files (raw data). Manipulating data. Giving the columns appropriate names.
pm25 <- readRDS("./summarySCC_PM25.rds", refhook = NULL)
source_pm25 <- readRDS("./Source_Classification_Code.rds", refhook = NULL)

## Have total emissions from PM2.5 decreased in the  Baltimore City, Maryland
## (fips == 24510) from 1999 to 2008? Use the base plotting system to make a plot 
## answering this question.
pm25_baltimore <- subset(pm25, fips=="24510")
by_year <- group_by(pm25_baltimore, year)
#by_year
total_emissions <- summarize(by_year, Emissions=sum(Emissions))
plot(total_emissions$year, total_emissions$Emissions, 
     col="red", xlab = "Year", 
     ylab = "Total Emissions PM2.5, in tons", 
     main = "Total PM2.5 emission in Baltimore. Years 1999, 2002, 2005, 2008",
     col.axis = "blue", col.lab="red", ylim = c(1000, 5000),
     xlim= c(1999, 2010)
)
mtext("Conclusion: The total decrease in pm2.5 emissions in Baltimore is observed.")

## generating png file and closing device
# dev.copy(png, file="total_emissions_pm25_BALTIMORE_CITY.png", width=480, height=480)
dev.copy(png, file="plot2.png", width=480, height=480)

dev.off()