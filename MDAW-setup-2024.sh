#!/bin/bash

#SBATCH --job-name=MDAW-workshop-setup-2024
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --partition=amilan
#SBATCH --time=00:10:00
#SBATCH --mail-type=ALL
# Removed --mail-user for default behaviour

# Description: This script is designed to setup software, environment variables, and getting your setup ready for qiime-workshop-2024.
# Author: 
# Date: 


##################################
##### How to Use this Script #####
##Run it in the background and look at the output file
# sbatch MDAW-workshop-setup-2024.sh
# ls -alt | head -n 3

##Run it interactively and watch output in the terminal

#give permission to execute file
# chmod 755 MDAW-workshop-setup-2024.sh
# acompile
# ./MDAW-workshop-setup-2024.sh

##another way to run interactively with more granualar control
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
    echo " This script is designed for conducting flight tests for qiime-workshop-2024."
    echo "  
    ---- How to Use this Script ----
    ## Run it in the background and look at the output file
    #  sbatch qiime-workshop-steup-2024.sh
    #  ls -alt | head -n 3

    ## Run it interactively and watch output in the terminal

    # give permission to execute file
    # chmod 755 qiime-workshop-steup-2024.sh
    # acompile
    # ./qiime-workshop-steup-2024.sh"
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
threshold_gb=4  # This is 1 GB, you can adjust it based on your requirements

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

fi 

#clean up any loaded modules
module purge
#load software module


echo ""
echo "#########################"
echo "Setup SparCC3 software"
echo "#########################"
echo "#########################"
echo ""


SPARCC_DIR="/projects/$USER/SparCC3"
# Check if SparCC.py exists within the directory
if [ -f "$SPARCC_DIR/SparCC.py" ]; then
    # Make SparCC.py executable
    chmod +x "$SPARCC_DIR/SparCC.py"

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
    # Clone the SparCC3 directory to the user's projects directory
    if git clone https://github.com/JCSzamosi/SparCC3.git /projects/$USER/SparCC3; then
        echo "SparCC3 cloned successfully"
        chmod +x "$SPARCC_DIR/SparCC.py"

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
        echo "Failed to clone SparCC3 repository. Please make sure you have permission to clone repositories into /projects/$USER/."
    fi
    # echo "SparCC.py not found in $SPARCC_DIR. Please check the directory content."
    # exit 1
fi


echo "#########################"
echo "This is the end of the SETUP script."
echo "For further support please send your output file to rc2-request@colostate.edu."
echo "#########################"
echo ""
echo ""

