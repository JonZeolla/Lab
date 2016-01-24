#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-01-24
# File Type:       Bash Script
# Version:         0.3
# Repository:      https://github.com/JonZeolla/Development
# Description:     This is a bash script to set up Ubuntu 14.04 for the Steel City InfoSec SDR Lab
#
# Notes
# - This script has not been tested yet - focusing on Ubuntu 14.04 as of 2016-01-24
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

function update_terminal() {
  # Clear the screen
  clear
  
  # Set the status for the current stage appropriately
  if [[ ${exitstatus} == 0 && $1 == "step" ]]; then
    status+=('1')
  elif [[ $1 == "step" ]]
    status+=('0')
  fi
  
  # Provide the user with the status of all completed steps until this point
  for x in ${status[@]}; do
    if [[ ${x} == "Start" ]]; then
      # Prepare the user
      echo -e "\nBeware, this script takes a long time to run\nPlease do not start this unless you have sufficient time to finish it\nIt could take anywhere from 30 minutes to multiple hours, depending on your machine\n\n"
      sleep 2s
    elif [[ ${x} == 1 ]]; then
      # Echo the correct success message
      echo ${success[${i}]}
    elif [[ ${x} == 0 ]]; then
      # Echo the correct failure message
      echo ${failure[${i}]}
    else
      # Echo that there was an unknown error
      echo -e "ERROR:    Unknown error evaluating ${x} in the status array"
    fi
    
    # Increment i
    ((i++))
  done
  
  # Update the user with a quick description of the next step
  case ${#status[@]} in
    1)
      # Do nothing (bash equivalent of no-op)
      :
      ;;
    2)
      echo -e "Updating apt and all currently installed packages..."
      ;;
    3)
      echo -e "Installing some SDR lab package requirements"
      ;;
    4)
      echo -e "Installing pybombs"
      ;;
    5)
      echo -e "Installing the SDR lab packages"
      ;;
    *)
      echo -e "ERROR:    Unknown error"
      ;;
  esac
  
  # Reset the exit status
  exitstatus=0
}

# Check the OS version
if [[ $(lsb_release -r | awk '{print $2}') != "14.04" ]]; then
  echo -e "This script is intended only for Ubuntu 14.04"
  exit 1
fi

# Clear the screen
clear

# Set up arrays
status=("Start")
success=("INFO:     Successfully updated apt and all currently installed packages","INFO:     Successfully installed SDR lab package requirements","INFO:     Successfully installed pybombs","INFO:     Successfully installed gqrx","\nINFO:     Succesfully set up machine for the SDR lab")
failure=("ERROR:    Issue updating apt and all currently installed packages","ERROR:    Issue installing SDR lab package requirements","ERROR:    Issue installing pybombs","ERROR:    Issue installing gqrx","\nERROR:    Issue while setting up the machine for the SDR lab")

# Gather the current user
declare -r usrCurrent="${SUDO_USER:-$USER}"

# Set a counter variable
i=0

# Check for the SDR user (TODO: and a watermark)
if [[ $usrCurrent == "sdr" ]]; then
        echo "It appears that you're using the SDR lab machine.  This may already be setup, but there is no harm in running it a second time"
fi

# Display the initial warning
update_terminal

# Re-synchronize the package index files, then install the newest versions of all packages currently installed
sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade
exitstatus=$?
update_terminal step

# Install dependancies for pybombs packages
sudo apt-get -y -qq install git libboost-all-dev qtdeclarative5-dev libqt5svg5-dev swig python-scipy
exitstatus=$?
update_terminal step

# Pull down pybombs
git clone -q --recursive https://github.com/pybombs/pybombs.git
exitstatus=$?
update_terminal step

# Configure pybombs
cd pybombs
cat > /home/${usrCurrent}/pybombs/config.dat <<EOL
[config]
gituser = ${usrCurrent}
gitcache = 
gitoptions = 
prefix = /home/${usrCurrent}/target
satisfy_order = deb,src
forcepkgs = 
forcebuild = gnuradio,uhd,gr-air-modes,gr-osmosdr,gr-iqbal,gr-fcdproplus,uhd,rtl-sdr,osmo-sdr,hackrf,gqrx,bladeRF,airspy
timeout = 30
cmakebuildtype = RelWithDebInfo
builddocs = OFF
cc = gcc
cxx = g++
makewidth = 4
EOL

# Install gqrx and its dependancies
./pybombs install gqrx
exitstatus=$?
update_terminal step

# Add the pybombs-installed binaries to your path, if necessary
if ! grep -q /home/${usrCurrent}/target/bin "~${usrCurrent}/.bashrc";
  echo -e "\nPATH=\$PATH:/home/${usrCurrent}/target/bin" >> ~${usrCurrent}/.bashrc
  source ~${usrCurrent}/.bashrc
fi
update_terminal step

# End the script
exit
