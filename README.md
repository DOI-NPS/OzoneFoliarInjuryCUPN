# Ozone Foliar Injury Monitoring at the Cumberland Piedmont Network
This repository contains code to perform analysis and generate figures related to ozone foliar injury monitoring at parks in the Cumberland Piedmont Network.


## Notes:
### To generate a figure showing change in ozone concentration at a point location over a given year, follow these steps: 
1. Ensure this repository is downloaded on your computer, either by cloning this repository or downloading it manually from GitHub. 
2. Put the .csv file with the ozone concentration data you wish to plot inside the "Data/" folder in this repository. 
3. Make sure that the character string in line 23 of the R script "Figures/OzoneConcentrationTimeSeriesFigure.R" reflects the name of the data file you updated in step 2. 
4. Run the R script "Figures/OzoneConcentrationTimeSeriesFigure.R"
5. A figure will be generated and stored inside the "Figures/" folder in this repository. This file will be called "ozoneConcnetrationFigXXXX_YEAR.pdf", where XXXX corresponds to the abbreviated park name (defined in line 34 of the R script from step 4), and YEAR corresponds to the year in the ozone dataset. 


## Additional Information

## Contact information
For questions about the contents of this repository, reach out to Alice Stears at alice_stears@partner.nps.gov
