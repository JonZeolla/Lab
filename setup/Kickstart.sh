#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-02-11
# File Type:       Bash Script
# Version:         2.0
# Repository:      https://github.com/JonZeolla/Lab
# Description:     This is a bash script to kickstart the setup of the Steel City InfoSec SDR Lab on 2016-02-11.
#
# Notes
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

function update_terminal() {
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
    # Clear the screen the first time it hits the loop, and if we didn't just finish the appropriate lab setup script
    if [[ ${i} == 0 && ${#status[@]} != 4 ]]; then
      clear
      echo -e "${scriptName}\n"
    fi
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
      # Clear the screen only if nothing has been done yet - otherwise it will clear via the above for loop
      clear
      echo -e "${scriptName}\n"
      echo -e 'Re-synchronizing the package index files...\n\n'
      ;;
    1)
      echo -e '\nInstalling some SCIS SDR lab package requirements...\n\n'
      ;;
    2)
      echo -e "\nRetrieving the SCIS ${githubTag} branch...\n\n"
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
      echo -e "${scriptName}\n"
      if [[ $somethingfailed != 0 ]]; then
        if [[ ${resetlab} != 0 ]]; then echo -e '\nINFO:\tThis script reset your existing clone of lab to the ${githubTag} tag of the SoftwareDefinedRadio branch'; fi
        echo -e '\nERROR:\tSomething went wrong during the SDR lab installation process'
        exit 1
      else
        if [[ ${resetlab} != 0 ]]; then echo -e '\nINFO:\tThis script reset your existing clone of lab to the ${githubTag} tag of the SoftwareDefinedRadio branch'; fi
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

confirmNoOVA () {
  read -r -p "Are you sure that you want to configure this system instead of downloading the VM? (y/n)" response
  case $response in
    [yY]|[yY][eE][sS]|[sS][uU][rR][eE]|[yY][uU][pP]|[yY][eE][pP]|[yY][eE][aA][hH]|[yY][aA]|[iI][nN][dD][eE][eE][dD]|[aA][bB][ss][oO][lL][uU][tT][eE][lL][yY]|[aA][fF][fF][iI][rR][mM][aA][tT][iI][vV][eE])
      true
      ;;
    *)
      echo -e "Did not receive an affirmative response, exiting..."
      exit 1
      ;;
  esac
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

## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osVersion="$(lsb_release -r | awk '{print $2}')"
declare -r scriptName="$(basename $0)"
declare -r githubTag="2016-02-11_SCIS_SoftwareDefinedRadio"

## Initialize variables
somethingfailed=0
resetlab=0

## Check if the user running this is root
if [[ ${usrCurrent} == "root" ]]; then
  clear
  echo -e "ERROR:\tIt's a bad idea to run any script when logged in as root - please login with a less privileged account that has sudo access"
  exit 1
fi

echo -e "Did you know that there is an OVA which already has all of this configured?\nSee the README.md in this folder for the link."
confirmNoOVA

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
if [[ ! -d ${HOME}/Desktop/Lab ]]; then
  cd ${HOME}/Desktop
  git clone -b ${githubTag} --single-branch https://github.com/JonZeolla/Lab -q
  exitstatus=$?
elif [[ -d ${HOME}/Desktop/Lab ]]; then
  cd ${HOME}/Desktop/Lab
  isgit=$(git rev-parse --is-inside-work-tree || echo false)
  curBranch=$(git branch | grep \* | awk '{print $2}')
  if [[ ${isgit} == "true" && (${curBranch} == "SoftwareDefinedRadio" || ${curBranch} == "(no branch)") ]]; then
    git reset --hard ${githubTag}
    exitstatus=$?
    if [[ ${exitstatus} == 0 ]]; then resetlab=1; fi
  elif [[ ${isgit} == "false" || (${curBranch} != "SoftwareDefinedRadio" && ${curBranch} != "(no branch)") ]]; then
    echo -e 'ERROR:\t${HOME}/Desktop/Lab exists, but is not a functional git working tree or is pointing to the wrong branch.'
    exitstatus=1
  else
    echo -e "ERROR:\tUnknown error"
    exitstatus=1
  fi
else
  echo -e "ERROR:\tUnknown error"
  exitstatus=1
fi
chmod -R 755 ${HOME}/Desktop/Lab/setup/*.sh
update_terminal step

## Kick off the appropriate lab setup script
if [[ ${osVersion} == '14.04' || ${osVersion} == '15.10' ]]; then
  ${HOME}/Desktop/Lab/setup/Debian_Setup.sh
  exitstatus=$?
  update_terminal step
else
  echo -e 'ERROR:\tYour OS has not been tested with this script'
  exit 1
fi
