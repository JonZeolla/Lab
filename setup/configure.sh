#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-05-18
# File Type:       Bash Script
# Version:         1.12
# Repository:      https://github.com/JonZeolla/lab
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
      echo -e "\n${txtRED}ERROR:\tUnknown error evaluating ${x} in the status array${txtDEFAULT}"
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
      echo -e 'Re-synchronizing the package index files...\n\n'
      ;;
    1)
      echo -e '\nInstalling some AutomotiveSecurity lab package requirements...\n\n'
      ;;
    2)
      echo -e "\nRetrieving the ${githubTag} branch...\n\n"
      ;;
    3)
      if [[ $somethingfailed != 0 ]]; then
        echo -e "\n${txtRED}ERROR:\tSomething went wrong during the setup process${txtDEFAULT}"
        exit 1
      else
        echo -e '\nKicking off the lab setup script...\n\n'
      fi
      ;;
    4)
      # Give a summary update
      if [[ $somethingfailed != 0 ]]; then
        if [[ ${notGitUTD} != "false" ]]; then echo -e "${txtORANGE}WARN:\tYour local git instance of the lab is not considered up to date with master.${txtDEFAULT}"; fi
        if [[ ${notOptimalGit} != "false" ]]; then echo -e "${txtORANGE}WARN:\t\tYour local git instance of the lab is non-optimal.  Please review ${HOME}/Desktop/lab manually.${txtDEFAULT}"; fi
        echo -e "${txtRED}ERROR:\tSomething went wrong during the AutomotiveSecurity lab ${option} installation${txtDEFAULT}"
        exit 1
      else
        if [[ ${notGitUTD} != "false" ]]; then echo -e "${txtORANGE}WARN:\tYour local git instance of the lab is not considered up to date with master.${txtDEFAULT}"; fi
        if [[ ${notOptimalGit} != "false" ]]; then echo -e "${txtORANGE}WARN:\t\tYour local git instance of the lab is non-optimal.  Please review ${HOME}/Desktop/lab manually.${txtDEFAULT}"; fi
        echo -e "INFO:\tSuccessfully configured the AutomotiveSecurity lab ${option} install\n\nYou can now go to ${HOME}/Desktop/lab/tutorials and work on the tutorials"
        exit 0
      fi
      ;;
    *)
      echo -e "${txtRED}ERROR:\tUnknown error${txtDEFAULT}"
      exit 1
      ;;
  esac
  
  ## Reset the exit status
  exitstatus=0
}

## Check Network Connection
wget -q --spider 'www.github.com'
if [[ $? != 0 ]]; then
  echo -e "${txtRED}ERROR:\tUnable to contact github.com${txtDEFAULT}"
  exit 1
fi

## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osDistro="$(cat /etc/issue | awk '{print $1}')"
declare -r osVersion="$(cat /etc/issue | awk '{print $3}')"
declare -r githubTag="AutomotiveSecurity"
declare -r txtRED='\033[0;31m'
declare -r txtORANGE='\033[0;33m'
declare -r txtDEFAULT='\033[0m'

## Initialize variables
somethingfailed=0
notOptimalGit="false"
tmpexitstatus=0

## Set up arrays
declare -a status=()
declare -a success=('INFO:\tSuccessfully updated apt package index files' 'INFO:\tSuccessfully installed AutomotiveSecurity lab package requirements' 'INFO:\tSuccessfully preparing the AutomotiveSecurity lab branch' 'INFO:\tSuccessfully ran the lab setup script')
declare -a failure=("${txtRED}ERROR:\tIssue updating apt package index files${txtDEFAULT}" "${txtRED}ERROR:\tIssue installing AutomotiveSecurity lab package requirements${txtDEFAULT}" "${txtRED}ERROR:\tIssue preparing the AutomotiveSecurity lab branch${txtDEFAULT}" "${txtRED}ERROR:\tIssue running the lab setup script${txtDEFAULT}")

## Check if the user running this is root
if [[ "${usrCurrent}" == "root" ]]; then
  clear
  echo -e "${txtRED}ERROR:\tIt's a bad idea to run any script when logged in as root - please login with a less privileged account that has sudo access${txtDEFAULT}"
  exit 1
fi

## Check input
if [ $# -eq 0 ]; then
  while [ -z "${prompt}" ]; do
    read -p "Do you want to do the full or minimum configuration?  " prompt
    case ${prompt} in
      [fF][uU][lL][lL])
        option=full
        ;;
      [mM][iI][nN][iI][mM][uU][mM])
        option=minimum
        ;;
      *)
        prompt=""
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
sudo apt-get -y update
exitstatus=$?
update_terminal step

## Install the AutomotiveSecurity lab package requirements
# Install git
sudo apt-get -y install git
exitstatus=$?
update_terminal step

## Prepare the Automotive Security Lab
# Setup open-vm-tools if this is a VM
if sudo dmidecode -s system-product-name | egrep -i 'vmware|virtual machine|qemu|kvm|hvm domu|bochs'; then
  sudo apt-get -y install open-vm-tools-desktop fuse
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
fi

# Setup the AutomotiveSecurity Lab github repo
if [[ ! -d ${HOME}/Desktop/lab ]]; then
  cd ${HOME}/Desktop
  git clone -b ${githubTag} --single-branch --recursive https://github.com/JonZeolla/lab
  exitstatus=$?
  notGitUTD="false"
elif [[ -d ${HOME}/Desktop/lab ]]; then
  cd ${HOME}/Desktop/lab
  isgit=$(git rev-parse --is-inside-work-tree || echo false)
  curBranch=$(git branch | grep \* | awk '{print $2}')
  if git status -uno | grep "up-to-date"; then notGitUTD="false"; else notGitUTD="true"; fi
  if [[ ${isgit} == "true" && (${curBranch} == "AutomotiveSecurity" || ${curBranch} == "(no branch)") && ${notGitUTD} == "false" ]]; then
    notOptimalGit="false"
  elif [[ ${isgit} == "true" && (${curBranch} == "AutomotiveSecurity" || ${curBranch} == "(no branch)") && ${notGitUTD} == "true" ]]; then
    notOptimalGit="true"
  elif [[ ${isgit} == "false" || (${curBranch} != "AutomotiveSecurity" && ${curBranch} != "(no branch)") ]]; then
    echo -e "${txtRED}ERROR:\t${HOME}/Desktop/lab exists, but is not a functional git working tree or is pointing to the wrong branch.${txtDEFAULT}"
    notOptimalGit="true"
    exitstatus=1
  else
    echo -e "${txtRED}ERROR:\tUnknown error${txtDEFAULT}"
    notOptimalGit="true"
    exitstatus=1
  fi
else
  echo -e "${txtRED}ERROR:\tUnknown error${txtDEFAULT}"
  exitstatus=1
fi
update_terminal step

## Kick off the appropriate lab setup script
if [[ "${osDistro}" == 'Kali' && "${osVersion}" == 'Rolling' ]]; then
  ${HOME}/Desktop/lab/setup/setup.sh ${option}
  exitstatus=$?
  update_terminal step
else
  echo -e "${txtRED}ERROR:\tYour OS has not been tested with this script${txtDEFAULT}"
  exit 1
fi

