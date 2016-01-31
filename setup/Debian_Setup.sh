#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-01-31
# File Type:       Bash Script
# Version:         1.4
# Repository:      https://github.com/JonZeolla/Presentation_Materials
# Description:     This is a bash script to set up Debian-based systems for the Steel City InfoSec SDR Lab on 2016-02-11.
#
# Notes
# - Please feel free to test on other OSs, and create a pull request modifying the OS version check to allow for OSs that this script works on.
# - This script is configured to use pybombs v2.0.0.
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

function update_terminal() {
  ## Clear the screen
  clear
  
  ## Set the status for the current stage appropriately
  if [[ ${exitstatus} == 0 && $1 == 'step' ]]; then
    status+=('1')
  elif [[ $1 == 'step' ]]; then
    status+=('0')
    somethingfailed=1
  fi
  
  ## Provide the user with the status of all completed steps until this point
  for x in ${status[@]}; do
    if [[ ${x} == 'Start' ]]; then
      # Prepare the user
      echo -e '\nBeware, this script takes a long time to run\nPlease do not start this unless you have sufficient time to finish it\nIt could take anywhere from 30 minutes to multiple hours, depending on your machine\n\n'

      # Check for the SDR user and watermark
      if [ $usrCurrent == 'sdr' ] && [ -f /tmp/scis ] && grep -q AUbL1QqtNdKKuwr8mqdCPITq20tqsyeSRf19A7o6MHijlD1rXPcXwoAVWV9wHeaNgNr9pTVhFXiHcBuUOXlsXAU8wNAzx9X8LDd9 /tmp/scis; then
        echo -e 'It appears that you are using the SDR lab machine.  This may already be setup, but there is no harm in running it multiple times\n'
      fi
    elif [[ ${x} == 1 ]]; then
      # Echo the correct success message
      echo -e ${success[${i}]}
      # Increment i
      ((i++))
    elif [[ ${x} == 0 ]]; then
      # Echo the correct failure message
      echo -e ${failure[${i}]}
      # Increment i
      ((i++))
    else
      # Echo that there was an unknown error
      echo -e "\nERROR:\tUnknown error evaluating ${x} in the status array"
      exit 1
    fi
  done

  ## Reset i
  i=0

  ## Update the user with a quick description of the next step
  case ${#status[@]} in
    1)
      echo -e 'Updating apt package index files and all currently installed packages...\n\n'
      ;;
    2)
      echo -e '\nInstalling some SDR lab package requirements...\n\n'
      ;;
    3)
      echo -e '\nInstalling pybombs...\n\n'
      ;;
    4)
      echo -e '\nInstalling the SDR lab packages...\n\n'
      ;;
    5)
      echo -e '\nSetting up the environment...\n\n'
      ;;
    6)
      # Give a summary update
      if [[ $somethingfailed != 0 ]]; then
        echo -e '\nERROR:\tSomething went wrong during the installation process'
        exit 1
      else
        echo -e '\nINFO:\tSuccessfully configured the SDR lab'
        exit 0
      fi
      ;;
    *)
      echo -e 'ERROR:\tUnknown error'
      exit 1
      ;;
  esac
  
  ## Reset the exit status
  exitstatus=0
}

function setup_pybombs() {
  ## Setup pybombs
  pybombs recipes add gr-recipes git+https://github.com/gnuradio/gr-recipes.git
  pybombs recipes add gr-etcetera git+https://github.com/gnuradio/gr-etcetera.git
  pybombs prefix init /home/${usrCurrent}/pybombs/prefix -a sdrprefix
  pybombs config default_prefix sdrprefix
}

## Check the OS version
if [[ $(lsb_release -r | awk '{print $2}') != '14.04' ]]; then
  echo -e 'ERROR:\tYour OS has not been tested with this script'
  exit 1
fi

## Check Network Connection
wget -q --spider 'www.github.com'
if [[ $? != 0 ]]; then
  echo -e 'ERROR:\tUnable to contact github.com'
  exit 1
fi

## Clear the screen
clear

## Set up arrays
declare -a status=('Start')
declare -a success=('INFO:\tSuccessfully updated apt package index files and all currently installed packages' 'INFO:\tSuccessfully installed SDR lab package requirements' 'INFO:\tSuccessfully installed pybombs' 'INFO:\tSuccessfully installed the SDR lab packages' 'INFO:\tSuccessfully set up the environment' 'INFO:\tSuccessfully retrieved the SCIS SDR Lab branch')
declare -a failure=('ERROR:\tIssue updating apt package index files and all currently installed packages' 'ERROR:\tIssue installing SDR lab package requirements' 'ERROR:\tIssue installing pybombs' 'ERROR:\tIssue installing the SDR lab packages' 'ERROR:\tIssue setting up the environment' 'ERROR:\tIssue retrieving the SCIS SDR Lab branch')

## Gather the current user
declare -r usrCurrent="${SUDO_USER:-$USER}"

## Initialize variables
i=0
somethingfailed=0
declare -r version="2.0.0"

## Display the initial warning
update_terminal

## Re-synchronize the package index files, then install the newest versions of all packages currently installed
# In cases where apt-get update does not succeed perfectly, it will often only create a warning, which means the exit status will still be 0
sudo apt-get -y -qq update
exitstatus=$?
sudo apt-get -y -qq upgrade
if [[ exitstatus == 0 ]]; then exitstatus=$?; fi
update_terminal step

## Install dependancies for pybombs packages
sudo apt-get -y -qq install git cmake libboost-all-dev gnuradio-dev
exitstatus=$?
update_terminal step

## Pull down pybombs
if [[ ${status[2]} == 1 ]]; then
  cd /home/${usrCurrent}
  git clone --recursive --branch v${version} https://github.com/gnuradio/pybombs -q
  cd pybombs
  sudo python setup.py install
  exitstatus=$?
  update_terminal step
else
  exitstatus=1
  update_terminal step
fi

## Configure pybombs if pybombs was pulled down successfully, then start installing things
if [[ ${status[3]} == 1 ]]; then
  setup_pybombs

  # Install gqrx and its dependancies
  pybombs install gqrx
  exitstatus=$?
  update_terminal step
else
  # If pybombs wasn't successfully pulled down, check to see if the correct version of pybombs is already installed
  # Checking the pybombs version requires 2>&1 because of https://github.com/gnuradio/pybombs/issues/242
  if [[ $(pybombs --version 2>&1) == ${version} ]]; then
    # The right version of pybombs is installed - continue setting up the environment
    setup_pybombs

    # Install gqrx and its dependancies
    pybombs install gqrx
    exitstatus=$?
    update_terminal step
  else
    # The right version of pybombs isn't installed - fail
    exitstatus=1
    update_terminal step
  fi
fi

## Configure your environment, if necessary
if ! grep -q "source /home/${usrCurrent}/pybombs/prefix/setup_env.sh" "/home/${usrCurrent}/.bashrc"; then
  echo "source /home/${usrCurrent}/pybombs/prefix/setup_env.sh" >> /home/${usrCurrent}/.bashrc
  exitstatus=$?
  update_terminal step
fi

