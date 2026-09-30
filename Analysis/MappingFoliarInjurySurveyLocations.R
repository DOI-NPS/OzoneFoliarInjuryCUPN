# Mapping sampling locations ozone foliar injury data for all CUPN parks
# Data Store Project Code: 2312827
# Data Store Code for data package reference: 2315044
# Author: Alice Stears, alice.e.stears@gmail.com; alice.stears@colostate.edu; alice_stears@partner.nps.gov
# Date: September 2026


# Load packages -----------------------------------------------------------
# names of packages to load from CRAN
packageNames <- c(  "lubridate", "stringr", "dplyr", "here", "remotes", "sf", "tmap")

# get names of packages that still need to be installed and install them 
install.packages(packageNames[!(packageNames %in% (installed.packages() |> rownames()))])

# now, load all packages
lapply(X = packageNames, FUN = function(x) require(package = x, character.only = TRUE))

# now, use the remotes package to install the NPSdatastore package
# see if the package is installed
if (sum("NPSdataverse" == rownames(installed.packages())) == 1) {
  # if the package is already installed, then load it
  require("NPSdataverse")
} else {
  # download the package from GitHub
  remotes::install_github("doi-nps/NPSdataverse")
  # load the package
  require("NPSdataverse")
}


# Set working directory ---------------------------------------------------

here::i_am("Analysis/RetrievingAndPreppingFoliarInjuryData.R")

# Retrieve ozone foliar injury data ---------------------------------------
# Data Store Code for data package reference: 2315044
reference_id <- c(2315044)


# now load the data package
ozoneDatPkg <- NPSutils::load_data_package(reference_id = reference_id, 
                                           directory = paste0(here(), "/Data/"))


# Map of plot locations ---------------------------------------------------
eventDat <- ozoneDatPkg$pkg_2315044.CUPN_OzoneFoliarInjury_Event


# there are a couple of errors in the location information (i.e. )
## row 4: Abraham Lincoln Birthplace National Historic Site	ABLI	Birthplace	ABLI-001	2020-08-24	ozone standard	31.53061	75.51362 (is in the ocean)
eventDat[eventDat$unitCode == "ABLI"  & 
eventDat$siteName == "Birthplace" & 
  eventDat$decimalLongitude == 75.51362 & !is.na(eventDat$decimalLongitude),
c("decimalLongitude", "decimalLatitude")] <- NA
## row 8: Abraham Lincoln Birthplace National Historic Site	ABLI	Knob Creek Low	ABLI-002	2020-08-24	ozone standard	37.61140	85.63861	NAD83
eventDat[eventDat$unitCode == "ABLI"  & 
           eventDat$siteName == "Knob Creek Low" & 
           eventDat$decimalLongitude == 85.63861 & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -85.63861
## row 11: Abraham Lincoln Birthplace National Historic Site	ABLI	Knob Creek High	ABLI-003	2020-08-24	ozone standard	37.60889	85.64436
eventDat[eventDat$unitCode == "ABLI"  & 
           eventDat$siteName == "Knob Creek High" & 
           eventDat$decimalLongitude > 0 & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -85.64436
## row 15: Chickamauga & Chattanooga National Military Park	CHCH	Lookout Mountain	CHCH-001	2016-08-19	ozone standard	38.21560	36.68277	NAD83
eventDat[eventDat$unitCode == "CHCH"  & 
           eventDat$siteName == "Lookout Mountain" & 
           eventDat$decimalLongitude > 0 & !is.na(eventDat$decimalLongitude),
         c("decimalLongitude", "decimalLatitude")] <- NA
## row 45: Little River Canyon National Preserve	LIRI	LIRI-Feed Plot	LIRI-001	2017-08-16	ozone standard	34.46011	85.597590	NAD83
eventDat[eventDat$unitCode == "LIRI"  & 
           eventDat$siteName == "LIRI-Feed Plot" & 
           eventDat$decimalLongitude == 85.597590 & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -85.597590
## row 48:  Little River Canyon National Preserve	LIRI	Road 02 Food Plot	LIRI-002	2017-08-16	ozone standard	34.41033	85.593630
eventDat[eventDat$unitCode == "LIRI"  & 
           eventDat$siteName == "Road 02 Food Plot" & 
           eventDat$decimalLongitude == 85.593630 & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -85.593630
## row 58:  Mammoth Cave National Park	MACA	Job Corps	MACA-001	2016-07-25	ozone standard	47.57410	8.509965	NAD83
eventDat[eventDat$unitCode == "MACA"  & 
           eventDat$siteName == "Job Corps" & 
           eventDat$decimalLongitude == 8.509965 & !is.na(eventDat$decimalLongitude),
         c("decimalLongitude", "decimalLatitude")] <- NA
## row 59: Mammoth Cave National Park	MACA	Job Corps	MACA-001	2017-08-22	ozone standard	37.24613	86.23602 
eventDat[eventDat$unitCode == "MACA"  & 
           eventDat$siteName == "Job Corps" & 
           eventDat$decimalLongitude == 86.23602  & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -86.23602

## rows 65 and 66: Two MACA sites have a longitude of 86.235630 when it should be -86.235630
eventDat[eventDat$unitCode == "MACA"  & 
           eventDat$siteName == "Job Corps" & 
           eventDat$decimalLongitude == 86.235630 & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -86.235630
# row 78: Russell Cave National Monument	RUCA	Visitor Center	RUCA-001	2017-08-17	ozone standard	34.97947	85.81019	NAD83
eventDat[eventDat$unitCode == "RUCA"  & 
           eventDat$siteName == "Visitor Center" & 
           eventDat$decimalLongitude == 85.81019 & !is.na(eventDat$decimalLongitude),
         "decimalLongitude"] <- -85.81019
## row 90: Stones River National Battlefield	STRI	Beasley Field	STRI-001	2016-08-04	ozone standard	50.96782	17.401445 (location is in rural Poland)
eventDat[eventDat$unitCode == "STRI"  & 
           eventDat$siteName == "Beasley Field" &
           eventDat$decimalLongitude > 0
          # eventDat$decimalLongitude == 86.235630 & !is.na(eventDat$decimalLongitude)
         , c("decimalLatitude", "decimalLongitude")] <- NA

# make into an sf data.frame, dropping rows w/ no location
eventDat_sf <- eventDat |> 
  filter(!is.na(decimalLongitude)) |> 
  st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = "EPSG:4269")
  
# Make a map  -------------------------------------------------------------

tmap::tm_shape(eventDat_sf) + 
  tm_symbols(fill = "unitCode") + 
  tm_basemap("Esri.WorldTopoMap")

