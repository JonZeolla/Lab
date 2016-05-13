#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-05-11
# File Type:       Bash Script
# Version:         1.4
# Repository:      https://github.com/JonZeolla/Lab
# Description:     This is a bash script to configure the Steel City InfoSec Automotive Security Lab.
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
      echo -e '\nInstalling some SCIS AutomotiveSecurity lab package requirements...\n\n'
      ;;
    2)
      echo -e "\nRetrieving the ${githubTag} branch...\n\n"
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
        if [[ ${resetlab} != 0 ]]; then echo -e "\nINFO:\tThis script reset your existing clone of lab to the ${githubTag} tag of the AutomotiveSecurity branch"; fi
        echo -e "\nERROR:\tSomething went wrong during the AutomotiveSecurity lab ${option} installation"
        exit 1
      else
        if [[ ${resetlab} != 0 ]]; then echo -e "\nINFO:\tThis script reset your existing clone of lab to the ${githubTag} tag of the AutomotiveSecurity branch"; fi
        echo -e "\nINFO:\tSuccessfully configured the AutomotiveSecurity lab ${option} install\n\nYou can now go to ${HOME}/Desktop/Lab/tutorials and work on the tutorials"
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
declare -a success=('INFO:\tSuccessfully updated apt package index files' 'INFO:\tSuccessfully installed SCIS AutomotiveSecurity lab package requirements' 'INFO:\tSuccessfully retrieved the SCIS AutomotiveSecurity lab branch' 'INFO:\tSuccessfully ran the lab setup script')
declare -a failure=('ERROR:\tIssue updating apt package index files' 'ERROR:\tIssue installing SCIS AutomotiveSecurity lab package requirements' 'ERROR:\tIssue retrieving the SCIS AutomotiveSecurity lab branch' 'ERROR:\tIssue running the lab setup script')

## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osDistro="$(cat /etc/issue | awk '{print $1}')"
declare -r osVersion="$(cat /etc/issue | awk '{print $3}')"
declare -r scriptName="$(basename $0)"
declare -r githubTag="AutomotiveSecurity"

## Initialize variables
somethingfailed=0
resetlab=0

## Check if the user running this is root
if [[ "${usrCurrent}" == "root" ]]; then
  clear
  echo -e "ERROR:\tIt's a bad idea to run any script when logged in as root - please login with a less privileged account that has sudo access"
  exit 1
fi

## Check input
if [ $# -eq 0 ]; then
  while [ -z "${prompt}" ]; do
    read -r -p "Do you want to do the full or minimum configuration?  The minimum install will _not_ automatically build or configure the external materials.  " prompt
    case ${prompt} in
      [fF][uU][lL][lL])
        option=full
        ;;
      [mM][iI][nN][iI][mM][uU][mM])
        option=minimum
        ;;
      *)
        prompt=""
        echo -e "Please enter either full or minimum"
        ;;
    esac
  done
elif [[ "${1,,}" == 'full' ]]; then
  # Check if the input, converted to lowercase, is equal to full.  If so, do the full install
  option=full
elif [[ "${1,,}" == 'minimum' ]]; then
  # Check if the option, converted to lowercase, is equal to minimum.  If so, do the minimum install
  option=minimum
else
  option=full
  read -rsp $'Input was neither full nor minimum.  Assuming full, please press any key to continue or ctrl+c to stop the script...\n' -n1 key
fi

## Update the terminal
update_terminal

## Re-synchronize the package index files
# In cases where apt-get update does not succeed perfectly, it will often only create a warning, which means the exit status will still be 0
sudo apt-get -y -qq update
exitstatus=$?
update_terminal step

## Install the SCIS AutomotiveSecurity lab package requirements
sudo apt-get -y -qq install git
exitstatus=$?
update_terminal step

## Clone the SCIS AutomotiveSecurity Lab github repo
if [[ ! -d ${HOME}/Desktop/Lab ]]; then
  cd ${HOME}/Desktop
  git clone -b ${githubTag} --single-branch --recursive https://github.com/JonZeolla/Lab -q
  exitstatus=$?
elif [[ -d ${HOME}/Desktop/Lab ]]; then
  cd ${HOME}/Desktop/Lab
  isgit=$(git rev-parse --is-inside-work-tree || echo false)
  curBranch=$(git branch | grep \* | awk '{print $2}')
  if [[ ${isgit} == "true" && (${curBranch} == "AutomotiveSecurity" || ${curBranch} == "(no branch)") ]]; then
    git reset --hard ${githubTag}
    exitstatus=$?
    if [[ ${exitstatus} == 0 ]]; then resetlab=1; fi
  elif [[ ${isgit} == "false" || (${curBranch} != "AutomotiveSecurity" && ${curBranch} != "(no branch)") ]]; then
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
update_terminal step

## Kick off the appropriate lab setup script
if [[ "${osDistro}" == 'Kali' && "${osVersion}" == 'Rolling' ]]; then
  ${HOME}/Desktop/Lab/setup/debian_setup.sh ${option}
  exitstatus=$?
  update_terminal step
else
  echo -e 'ERROR:\tYour OS has not been tested with this script'
  exit 1
fi

