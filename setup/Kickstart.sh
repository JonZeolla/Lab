#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-01-31
# File Type:       Bash Script
# Version:         1.1
# Repository:      https://github.com/JonZeolla/Presentation_Materials
# Description:     This is a bash script to kickstart the setup of the Steel City InfoSec SDR Lab on 2016-02-11.
#
# Notes
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

function update_terminal() {
  ## Clear the screen
  clear

  ## Set the status for the current stage appropriately
  if [[ ${exitstatus} == 0 && $1 == 'step' ]]; then
    status+=('0')
  elif [[ $1 == 'step' ]]; then
    status+=('1')
    somethingfailed=1
  fi

  ## Provide the user with the status of all completed steps until this point
  # if ${status[@]} is empty, this will get skipped entirely, which is intended
  for x in ${status[@]}; do
    if [[ ${x} == 0 ]]; then
      # Echo the correct success message
      echo -e ${success[${i}]}
      # Increment i
      ((i++))
    elif [[ ${x} == 1 ]]; then
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
    0)
      echo -e 'Re-synchronizing the package index files...\n\n'
      ;;
    1)
      echo -e '\nInstalling some SCIS SDR lab package requirements...\n\n'
      ;;
    2)
      echo -e '\nRetrieving the SCIS SDR lab branch...\n\n'
      ;;
    3)
      if [[ $somethingfailed != 0 ]]; then
        echo -e '\nERROR:\tSomething went wrong during the setup process'
        exit 1
      else
        echo -e '\nKicking off the lab setup script...\n\n'
      fi
      ;;
    4)
      # Give a summary update
      if [[ $somethingfailed != 0 ]]; then
        echo -e '\nERROR:\tSomething went wrong during the SDR lab installation process'
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

## Check Network Connection
wget -q --spider 'www.github.com'
if [[ $? != 0 ]]; then
  echo -e 'ERROR:\tUnable to contact github.com'
  exit 1
fi

## Set up arrays
declare -a status=()
declare -a success=('INFO:\tSuccessfully updated apt package index files' 'INFO:\tSuccessfully installed SCIS SDR lab package requirements' 'INFO:\tSuccessfully retrieved the SCIS SDR lab branch' 'INFO:\tSuccessfully ran the lab setup script')
declare -a failure=('ERROR:\tIssue updating apt package index files' 'ERROR:\tIssue installing SCIS SDR lab package requirements' 'ERROR:\tIssue retrieving the SCIS SDR lab branch' 'ERROR:\tIssue running the lab setup script')

## Gather the current user
declare -r usrCurrent="${SUDO_USER:-$USER}"

## Initialize variables
somethingfailed=0

## Check if the user running this is root
if [[ ${usrCurrent} == "root" ]]; then
  clear
  echo -e "ERROR:\tIt's a bad idea to run this script when logged in as root - please login with a less privileged account that has sudo access"
  exit 1
fi

## Update the terminal
update_terminal

## Re-synchronize the package index files
# In cases where apt-get update does not succeed perfectly, it will often only create a warning, which means the exit status will still be 0
sudo apt-get -y -qq update
exitstatus=$?
update_terminal step

## Install the SCIS SDR lab package requirements
sudo apt-get -y -qq install git
exitstatus=$?
update_terminal step

## Clone the SCIS SDR Lab github repo
cd /home/${usrCurrent}/Desktop
git clone -b Software-Defined-Radios_2016-02-11 --single-branch https://github.com/JonZeolla/Presentation_Materials
exitstatus=$?
update_terminal step
cd /home/${usrCurrent}/Desktop/Presentation_Materials/
chmod -R 755 /home/${usrCurrent}/Desktop/Presentation_Materials/setup/*

## Kick off the appropriate lab setup script
if [[ $(lsb_release -r | awk '{print $2}') == '14.04' ]]; then
  setup/Debian_Setup.sh
  exitstatus=$?
  update_terminal step
else
  echo -e 'ERROR:\tYour OS has not been tested with this script'
  exit 1
fi

