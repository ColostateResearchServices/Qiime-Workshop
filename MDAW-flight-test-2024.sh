#!/bin/bash

#SBATCH --job-name=MDAW-flight-test-2024
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --partition=amilan
#SBATCH --time=00:10:00
#SBATCH --mail-type=ALL
# Removed --mail-user for default behavior

# Description: This script is designed for conducting flight tests for qiime-workshop-2024.
# Author: 
# Date: 


##################################
##### How to Use this Script #####
## Run it in the background and look at the output file
# sbatch MDAW-flight-test-2024.sh
# ls -alt | head -n 3

## Run it interactively and watch output in the terminal

# give permission to execute file
# chmod 755 MDAW-flight-test-2024.sh
# acompile
# ./MDAW-flight-test-2024.sh

## another way to run interactively with more granular control
# sinteractive  --reservation=microbiome --time=1:00:00 --partition=amilan -N 1 -n 1
##################################

# Initialize Debug Mode to false
debug_mode=false

# Function Definitions

print_help() {
    echo "Usage: $0 [options]"
    echo "-h, --help            Show this help message"
    echo "-d, --debug           Enable debug mode"
    # ... [other options] ...
    echo
    echo "This script is designed for conducting flight tests for qiime-workshop-2024."
    echo "  
    ---- How to Use this Script ----
    ## Run it in the background and look at the output file
    #  sbatch MDAW-flight-test-2024.sh
    #  ls -alt | head -n 3

    ## Run it interactively and watch output in the terminal

    # give permission to execute file
    # chmod 755 MDAW-flight-test-2024.sh
    # acompile
    # ./MDAW-flight-test-2024.sh"
    echo 
}

# Check for flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--debug) debug_mode=true ;;
        -h|--help) print_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

########
## Verify and Explain Alpine Directories
###########
# Verifying Alpine Directories
echo "-------------------------"
echo "Learn more about directories and their paths"
echo "-------------------------"
echo "Your HOME directory ($HOME) has 2GB in capacity."
echo "Your PROJECT directory (/project/$USER) has 250GB in capacity."
echo "Your SCRATCH directory (/scratch/alpine/$USER) has 10TB in capacity. **Files are purged after 90-days of inactivity!**"
echo "Your temp (TMPDIR) directory ($TMPDIR) is a staging ground for package files and libraries when installing new software."

# Get the available space on /tmp in gigabytes
available_space_gb=$(df -h /tmp | awk 'NR==2 {print $4}' | tr -d 'G')

# Set a threshold for available space (adjust as needed)
threshold_gb=4  # This is 4 GB, you can adjust it based on your requirements

# Check if available space is below the threshold
if (( $(echo "$available_space_gb < $threshold_gb" | bc -l) )); then
  echo "Your /tmp directory is almost full. Available space: $available_space_gb G"

  # Set TMP to a new directory
  new_tmp_directory="/scratch/alpine/$USER"
  export TMP="$new_tmp_directory"

  echo "TMP environment variable set to: $new_tmp_directory"
else
  echo "Your /tmp directory has sufficient space. Available space: $available_space_gb G"
fi

echo "Your Workshop directory: /pl/active/courses/2024_summer/maw_2024"

DIR="/pl/active/courses/2024_summer/maw_2024"

if [ -r "$DIR" ]; then
    echo "You have access to the directory $DIR"
else
    echo "You do not have access to the directory $DIR"
fi

echo "#########################"

if [[ "$debug_mode" = true ]]; then
    echo "#########################"
    echo "Debug Mode: Displaying .bashrc contents:"
    echo "Your bashrc file contains default scripts and paths information on login. This can be helpful for troubleshooting. The output of this file is here: "
    echo "#########################"
    cat ~/.bashrc
    echo "#########################"
fi

echo ""
echo "#########################"
echo "Check if on a login node"
echo "#########################"
echo ""

####
# Check if on a login node
####
if [[ "$(hostname)" =~ ^login ]]; then
  echo "You are on a login node, the following script module load test will likely fail."
  echo "please type 'acompile' to switch to another node type"
  # code block to execute if string matches regex pattern
else
  # code block to execute if string does not match regex pattern
  echo "You are not on a login node. Great choice! Now you can run different software modules."


  # Begin testing software for the class
  echo ""
  echo "#########################"
  echo "Check QIIME2 software"
  echo "#########################"
  echo "Now let's check on the software you will later be using for your class"
  echo "This might take 3-5 minutes."
  echo "If you see a message about qiime2 caching, this is a good sign!"
  echo "#########################"
  echo ""

  # clean up any loaded modules
  module purge
  # load software module
  module load qiime2/2024.2_amplicon

  ############
  # run a simple command to see if software loaded
  ############

  qiime_help_output=$(qiime --help 2>&1) # Captures both stdout and stderr
  qiime_version_output=$(qiime --version 2>&1)
  exit_status=$?

  if [ $exit_status -eq 0 ]; then

      # Check if the version output includes "2024"
      if [[ "$qiime_version_output" == *"2024"* ]]; then
          echo "QIIME version : $qiime_version_output"
          echo "Qiime2 is functioning correctly."
          # You can process $qiime_help_output here if needed
          echo "***********************************************************"
          echo "Success!! Celebrate and drink coffee (or tea)."
          echo "***********************************************************"
      else
          echo "QIIME version is not latest"
      fi
  else
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      echo "Qiime seems unable to print help... Check script file for any possible devilry (?????????????????????)"
      echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
      echo "Error: Qiime2 cannot be loaded correctly. Please check the script."
      echo "Error Details: $qiime_help_output"
  fi
  echo ""
  echo ""

fi

echo ""
echo "#########################"
echo "Check FEAST software"
echo "#########################"
echo "This is to check if FEAST software is installed"
echo "#########################"
echo ""

echo "Check FEAST software is installed."
Rscript -e 'if ("FEAST" %in% installed.packages()) { print("FEAST is installed.") } else { print("FEAST is not installed.") }'

# echo "The FEAST verison is: "
# Rscript -e 'packageVersion("FEAST")'

echo ""
echo "#########################"
echo "Check SparCC3 software"
echo "#########################"
echo "This will check if you have the directory we created in the setup script."
echo "#########################"


# Set the SPARCC_DIR variable to the path of the newly copied SparCC3 directory
SPARCC_DIR="/projects/$USER/SparCC3"

# Check if the directory exists
if [ -d "$SPARCC_DIR" ]; then
    echo "The SPARCC directory exists!" 
    if [ -f "$SPARCC_DIR/SparCC.py" ]; then
        # Make SparCC.py executable
        chmod +x "$SPARCC_DIR/SparCC.py"
        echo "The SPARCC.py file exists!" 

           # Add the directory to the PATH in .bashrc if not already added
         if ! grep -qxF "export PATH=\$PATH:$SPARCC_DIR" ~/.bashrc; then
         echo "export PATH=\$PATH:$SPARCC_DIR" >> ~/.bashrc
         # Reload the .bashrc file to apply the changes to the current session
         source ~/.bashrc
         # Inform the user that the directory has been added to the PATH
         echo "The directory $SPARCC_DIR has been added to your PATH."
         else
         echo "The directory $SPARCC_DIR is already in your PATH."
         fi

     # Validate that SparCC.py can be run from any directory
      if command -v SparCC.py &> /dev/null; then
        echo "Validation successful: SparCC.py is working from any directory."
        echo "To use this, simply type \"SparCC.py\" "
     else
        echo "Validation failed: SparCC.py is not accessible from any directory. Please check the PATH configuration."
     fi

     else
        echo "SparCC.py not found in $SPARCC_DIR. Please check the directory content."
        exit 1
    fi
else
    # If the directory does not exist, print an error message
    echo "The directory $SPARCC_DIR does not exist. Please check the path and try again. Or run the setup script."
fi


    

 

echo "#########################"
echo "This is the end of the flight-test script."
echo "For further support please send your output file to rc2-request@colostate.edu."
echo "#########################"
echo ""
echo ""
