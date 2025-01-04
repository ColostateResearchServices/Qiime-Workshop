
#!/bin/bash

#SBATCH --job-name=aneq505-flight-test
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --partition=amilan
#SBATCH --time=00:10:00
#SBATCH --mail-type=ALL
# Removed --mail-user for default behaviour

# Description: This script is designed for conducting flight tests for aneq505.
# Author: [Your Name]
# Date: [Date of Creation]


##################################
##### How to Use this Script #####
##Run it in the background and look at the output file
# sbatch aneq505-flight-test.sh
# ls -alt | head -n 3

##Run it interactively and watch output in the terminal

#give permission to execute file
# chmod 755 aneq505-flight-test.sh
# acompile
# ./aneq505-flight-test.sh

##another way to run interactively with more granualar control
# sinteractive  --reservation=XYZ --time=1:00:00 --partition=amilan -N 1 -n 1
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
    echo " This script is designed for conducting flight tests for aneq505."
    echo "  
    ---- How to Use this Script ----
    ## Run it in the background and look at the output file
    #  sbatch aneq505-flight-test.sh
    #  ls -alt | head -n 3

    ## Run it interactively and watch output in the terminal

    # give permission to execute file
    # chmod 755 aneq505-flight-test.sh
    # acompile
    # ./aneq505-flight-test.sh"
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
##Verify and Explain Alpine Directories
###########
# Verifying Alpine Directories
echo "#########################"
echo "Learn more about directories and their paths"
echo "#########################"
echo "Your HOME directory ($HOME) has 2GB in capacity."
echo "Your PROJECT directory (/project/$USER) has 250GB in capacity."
echo "Your SCRATCH directory (/scratch/alpine/$USER) has 10TB in capacity. **Files are purged after 90-days of inactivity!**"
echo "Your temp (TMPDIR) directory ($TMPDIR) is a staging ground for package files and libraries when installing new software."
echo "#########################"

# Get the available space on /tmp in gigabytes
available_space_gb=$(df -h /tmp | awk 'NR==2 {print $4}' | tr -d 'G')

# Set a threshold for available space (adjust as needed)
threshold_gb=4  # This is 1 GB, you can adjust it based on your requirements

# Check if available space is below the threshold
if (( $(echo "$available_space_gb < $threshold_gb" | bc -l) )); then
  echo "/tmp directory is almost full. Available space: $available_space_gb G"

  # Set TMP to a new directory
  new_tmp_directory="/scratch/alpine/$USER"
  export TMP="$new_tmp_directory"

  echo "TMP environment variable set to: $new_tmp_directory"
else
  echo "/tmp directory has sufficient space. Available space: $available_space_gb G"
fi

# Class Directory Information
echo "Class directory: /pl/active/courses/2024_summer/maw_2024"
echo "#########################"

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
    echo "Your bashrc files contains default scripts and paths information on login. This can be helpful for troubleshooting. The output of this file is here: "
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
#Check if on a login node
####
if [[ "$(hostname)" =~ ^login ]]; then
  echo "You are on a login node, the following script module load test will likely fail."
  echo "please type 'acompile' to switch to another node type"
  # code block to execute if string matches regex pattern
else
  # code block to execute if string does not match regex pattern
echo "You are not on a login node. Great choice! Now you can run different software modules."
#Begin testing software for the class
echo ""
echo "#########################"
echo "Check software"
echo "#########################"
echo "Now let's check on the software you will later be using for your class"
echo "This might take a couple minutes."
echo "#########################"
echo ""

#clean up any loaded modules
module purge
#load software module
module load qiime2

############
#run a simple command to see if software loaded
############

qiime_help_output=$(qiime --help 2>&1) # Captures both stdout and stderr
exit_status=$?

if [ $exit_status -eq 0 ]; then
    echo "Qiime2 is functioning correctly."
    # You can process $qiime_help_output here if needed
    echo "***********************************************************"
    echo "Success!! Celebrate and drink coffee (or tea)."
    echo "***********************************************************"
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


echo "#########################"
echo "This is the end of the flight-test script."
echo "For further support please send your output file to rc2-request@colostate.edu."
echo "#########################"
echo ""
echo ""

