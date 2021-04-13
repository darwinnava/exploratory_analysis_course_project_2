---
title: "Exploratory Data Analysis Course Project"
author: "Darwin Nava"
date: "April 12, 2021"
file: "Emissions_from_motor_vehicles.Baltimore_vs_LA.R"
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
library(ggplot2) # for plotting

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

## Compare emissions from motor vehicle sources in Baltimore City with emissions from motor 
## vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater 
## changes over time in motor vehicle emissions?

## Merging related tables by SCC variable
## pm25_merged <- merge(pm25, source_pm25, by = "SCC") ## It does not work. Error: cannot allocate vector of size 24.8 Mb
## Find the SSC codes where "Vehicle" appears in the  Short.Name variable . 
## Previous review showed that they all contain "Vehicle" so it is inferred 
## by making this selection the requirement "motor vehicles sources or road vehicles sources" is covered.

scc_motor <- source_pm25[grep("Veh", source_pm25$Short.Name),1]
pm25_motor <- pm25[pm25$SCC %in% scc_motor,]

pm25_motor_baltimore_la <- subset(pm25_motor, fips=="24510"|fips=="06037")
by_type_year_fips <- group_by(pm25_motor_baltimore_la, type, year, fips)
motor_v_emissions <- summarize(by_type_year_fips, Emissions = sum(Emissions))
#road_vehicleemissions

g <- qplot(year, Emissions, data=motor_v_emissions, facets = fips~type)
g + labs(title = "Comparison Baltimore(24510)/LA(06037). PM25 from motor vehicles") + labs(x="Decrease in PM2.5 emissions is observed in Baltimore. LA has more pollution in 2008 than 1999", y=expression("Emission in tons of  "*PM[2.5]))     

## generating png file and closing device
#dev.copy(png, file="Emission_pm25_motor_vehicle_Baltimore_la_by_year_by_type.png", width=480, height=480)
dev.copy(png, file="plot6.png", width=480, height=480)
dev.off()