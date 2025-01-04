## SET THE WORKING DIRECTORY
# The first thing we need to do is set our working directory - change $USER to your own account, in my case marinanc@colostate.edu
setwd("/scratch/alpine/$USER")

# Check that we are in the appropriate working directory
getwd()
# The console (bottom left panel) should show the following directory "/scratch/alpine/$USER"

## INSTALLING PACKAGES NEEDED TO RUN FEAST
# Now that we're within the Scratch directory, we'll install and load all packages needed to run FEAST:
# To do so, first we have to create an object with the different packages that FEAST requires:
Packages <- c("Rcpp", "RcppArmadillo", "vegan", "dplyr", "reshape2", "gridExtra", "ggplot2", "ggthemes", "devtools", "tidyr", "tibble")
# NOTE: after running this command, you will see that this list shows under your "Environment" panel (top right panel)


# Install the packages. You will see a lot of red messages in the console (bottom left panel). 
# Don't panic, that's totally normal! It just means that R is installing the packages needed
# NOTE: this should take a few minutes
install.packages(Packages)
# Load the required packages we just installed
lapply(Packages, library, character.only = TRUE)
#Once done, the installed packages will show in the bottom right panel of the RScript interface, under the "Packages" tab, with a check mark

## Install the FEAST package from GitHub (you can see all the info here: https://github.com/cozygene/FEAST?tab=readme-ov-file)
# Note: this will take a few minutes!
devtools::install_github("cozygene/FEAST", force=TRUE)
# FEAST should now be listed under your installed packages (bottom right panel - Packages tab)

# Load the FEAST package so it's ready to use!
library(FEAST)