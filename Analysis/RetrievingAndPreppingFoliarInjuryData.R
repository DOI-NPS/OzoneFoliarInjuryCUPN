# Retrieving ozone foliar injury data for all CUPN parks
# Data Store Project Code: 2312827
# Data Store Code for data package reference: 2315044
# Author: Alice Stears, alice.e.stears@gmail.com; alice.stears@colostate.edu; alice_stears@partner.nps.gov
# Date: September 2026


# Load packages -----------------------------------------------------------
# names of packages to load from CRAN
packageNames <- c(  "lubridate", "stringr", "dplyr", "here", "remotes")

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

#referenceInfo <- NPSdatastore::search_references_by_id_basic(reference_id)

# get the data store package 
NPSutils::get_data_package(reference_id = reference_id)
# now load the data package
ozoneDatPkg <- NPSutils::load_data_package(reference_id = reference_id, 
                            directory = paste0(here(), "/Data/"))



# Map of plot locations ---------------------------------------------------


