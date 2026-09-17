# Figure of Ozone Concentration across time for the Cumberland Piedmont Network
# written for Mammoth Cave ozone data from 2021
# Data Store Project Code: 2312827
# Author: Alice Stears, alice.e.stears@gmail.com; alice.stears@colostate.edu
# Date: August 2026


# Load packages -----------------------------------------------------------
# names of packages to laod 
packageNames <- c("ggplot2", "lubridate", "stringr", "ggpubr", "dplyr")

# get names of packages that still need to be installed and install them 
install.packages(packageNames[!(packageNames %in% (installed.packages() |> rownames()))])

# now, load all packages
lapply(X = packageNames, FUN = function(x) require(package = x, character.only = TRUE))

# User Inputs -------------------------------------------------------------
## Change the arguments below when running this script on a new computer or with a new data file

# The character string stored in the object "folderPath" is the file path for the 
# folder that contains the ozone data .csv file
# CHANGE THIS PATH to correspond to the location of the data on your computer. 
# The figures will also be written out to this location. Make sure to use forward slashes
folderPath <- "~/Dropbox/Work/CSU_NPS_dataScience/CUPN/OzoneMonitoringFigures/"

# The character string stored in the object "dataName" is the name of the ozone data .csv file
# CHANGE THIS NAME to correspond to the name of the data file the data on your computer.
dataName <- "2021MACA_8HrAveOzone.csv"

# the object skipNumber stores an integer that corresponds to the number of rows 
# of descriptive information at the top of the data file that we want to remove 
# when creating the figure (i.e. the number of rows *above* the row with the column titles)
skipNumber <- 9

# the object samplingLocation contains a character string with the name of the 
# sampling location (likely won't change, but included here as an option just in case)
samplingLocation <- "Mammoth Cave National Park - Houchin Meadow"
# abbreviation of the sampling location
samplingLoc_Short <- "MACA"

# load data ---------------------------------------------------------------
# set working directory to the folder
setwd(folderPath)

# read in ozone monitoring data 
ozoneDat <- read.csv(file = dataName,
                     skip = skipNumber
                     ) 
# remove 'X' column that contains only NAs (likely a byproduct of data entry in excel)
ozoneDat$X <- NULL 

# format the dateTime column as a date time
# time zone is Central Standard Time
ozoneDat$DATE_TIME <- 
lubridate::as_datetime(ozoneDat$DATE_TIME, tz = "US/Central",
                       format = "%m/%d/%Y %I:%M:%S %p")  
# returns a warning saying that one date failed to parse, but we know that because 
# of the issue detailed below. As such, this warning can be ignored

# the ozone concentration data provides the 8 hour running average of ozone concentration 
# in ppb (in column "MACA.HM_O38HR_PPB")
# NOTE - there is an ozone concentration value for the date/time 3/14/2021 2AM, but 
# that date/time combination did not exist (daylight savings time was on 3/14 that year, 
# and 2am did not exist). I've removed the value for that time 
ozoneDat <- ozoneDat[!is.na(ozoneDat$DATE_TIME),]

#changed -999 to NA 
# get the name of the column w/ ozone data
ozoneColName <- names(ozoneDat)[str_detect(names(ozoneDat), pattern = "_PPB")]
# replace -999 w/ NA
ozoneDat <- ozoneDat |> 
  dplyr::mutate("{ozoneColName}" := .data[[ozoneColName]] |> 
                  replace_values(from = -999, to = NA)
  )

#test with data above the 70 ppb
#ozoneDat[[ozoneColName]] <- ozoneDat[[ozoneColName]]  + 10

# identify the location on the y-axis where the primary standard label should be 
# if the max values is below 70, then the value should be 75; if the max value is 
# above 70, then the value should be +5 from the max value
labelMaxY <-ifelse(max(ozoneDat[[ozoneColName]], na.rm = TRUE) > 70, 
                    yes = max(ozoneDat[[ozoneColName]], na.rm = TRUE) + 5, 
                   no = 75)
# Make Figure -------------------------------------------------------------
# NOTE that this function will return an error if there are any observations with 
# NA for ozone concentration. However, this will not interfere with the figure being rendered. 
(ozoneFig <- ggplot(data = ozoneDat) + 
  geom_line(aes(x = DATE_TIME, y = .data[[ozoneColName]]), lwd = .5) + 
  geom_hline(aes(yintercept = 70), linetype = 2) + # add horizontal line at 70ppb
  labs(y = "Ozone concentration (ppb) \nRunning 8-Hour Average",
       x = "Date", 
      title = samplingLocation, 
      subtitle = lubridate::year(ozoneDat[["DATE_TIME"]])  ) + 
  scale_x_datetime(date_labels= "%m/%d/%Y", 
               breaks = "1 month") +
  scale_y_continuous(limits = ~range(.x, 0), breaks = get_breaks(by = 10, from = 0)) + # make sure the y axis always includes zero
  theme_pubr() + 
  theme(axis.text.x = element_text(angle = 45,hjust = 1), # rotate x axis labels 
        axis.title.x = element_text(size = 11), 
        axis.text.y = element_text(margin = margin(0,3,0,0)), # make more room between axis labels and axis line
        axis.title.y = element_text(margin = margin(0,7,0,5),# make more room between axis title and axis line
                                    size = 12# make label text slightly larger
                                    ), 
        plot.subtitle = element_text(size = 14, hjust = 0.5), # make subtitle slightly larger
        plot.title = element_text(hjust = 0.5)# make plot title and subtitle centered
        ) + 
annotate(geom = "label", x =  as_datetime(paste0(lubridate::year(ozoneDat$DATE_TIME)[1],"-03-15 07:00:00 CDT")), # CHANGE the dates here and below to move the label and arrow on the x axis if the date range is different
         y = labelMaxY, 
         label = "EPA Primary Standard for ozone concentration (70 ppb)",
         border.color = NA, 
        hjust = "left") + 
  annotate(geom = "curve", x =as_datetime(paste0(lubridate::year(ozoneDat$DATE_TIME)[1],"-03-15 07:00:00 CDT")), 
           y =  labelMaxY,
           xend = as_datetime(paste0(lubridate::year(ozoneDat$DATE_TIME)[1],"-03-01 07:00:00 CDT")),
           yend = 71,
           arrow = arrow(length = unit(0.3, "cm"), type = "open"),
           curvature = 0.3)
)
 
# save figure -------------------------------------------------------------
# NOTE that the figures will be saved in the same folder as the data file (this location is set in line 21 of this script)
# save as PDF
pdf(file = paste0("./ozoneConcentrationFig", samplingLoc_Short, "_",lubridate::year(ozoneDat$DATE_TIME[1]),".pdf"), width = 8, height = 6)
ozoneFig
dev.off()

# save as PNG
png( paste0("./ozoneConcentrationFig", samplingLoc_Short, "_",lubridate::year(ozoneDat$DATE_TIME[1]),".png"), res = 175, width = 1200, height =1000)
ozoneFig
dev.off()
