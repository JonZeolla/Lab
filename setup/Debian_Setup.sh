#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-05-11
# File Type:       Bash Script
# Version:         1.2
# Repository:      https://github.com/JonZeolla/Lab
# Description:     This is a bash script to set up various Debian-based systems for the Steel City InfoSec AutomotiveSecurity Lab on 2016-05-12.
#
# Notes
# - Please feel free to test on other OSs, and create a pull request modifying the OS version check to allow for OSs that this script works on.
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

function update_terminal() {
  ## Clear the screen
  clear
  
  ## Set the status for the current stage appropriately
  if [[ ${exitstatus} == 0 && ${1} == 'step' ]]; then
    status+=('0')
  elif [[ ${1} == 'step' ]]; then
    status+=('1')
    somethingfailed=1
  fi
  
  echo -e "\n\n${scriptName}\n"
  
  ## Provide the user with the status of all completed steps until this point
  for x in ${status[@]}; do
    if [[ ${x} == 'Start' ]]; then
      # Check for the carhax user and watermark
      if [ ${usrCurrent} == 'carhax' ] && [ -f /tmp/scis ] && grep -q W8wnTFMhhU7RHHAnLIPJdWPKdbySMgIpnh3qwf4uEKnSlytbbB1EWKAEvkTHLAX7uE51T2BDkQqMmttziyErC0kmQLiUeScEmYWo /tmp/scis; then
        echo -e 'It appears that you are using the Steel City InfoSec Automotive Security lab machine.  This may already be setup, but there is no harm in running it multiple times\n'
      fi
    elif [[ ${x} == 0 ]]; then
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
    1)
      echo -e 'Updating apt package index files and all currently installed packages...\n\n'
      ;;
    2)
      echo -e '\nInstalling some Automotive Security lab package requirements...\n\n'
      ;;
    3)
      echo -e '\nSetting up the lab environment...\n\n'
      ;;
    4)
      # Give a summary update and cleanup messages
      if [[ ${somethingfailed} != 0 ]]; then
        if [[ ${wrongruby} != 0 ]]; then echo -e 'WARNING:\tRuby is the incorrect version.  vircar-fuzzer may not function properly'; fi
        echo -e '\nERROR:\tSomething went wrong during the installation process'
        exit 1
      else
        if [[ ${wrongruby} != 0 ]]; then echo -e 'WARNING:\tRuby is the incorrect version.  vircar-fuzzer may not function properly'; fi
        if [[ ${kayakmvn} != 0 ]]; then echo -e 'WARNING:\tThere are some known issues with the Kayak setup.\nWARNING:\tThere is no need to re-run the setup scripts, however please run `cd ${HOME}/Desktop/Lab/external/Kayak;mvn clean install` until it reports success'; fi
        echo -e '\nINFO:\tSuccessfully configured the AutomotiveSecurity lab'
        exit 0
      fi
      ;;
    *)
      echo -e 'ERROR:\tUnknown error'
      exit 1
      ;;
  esac
  
  ## Reset the exit status variables
  exitstatus=0
  tmpexitstatus=0
}

## Set up arrays
declare -a status=('Start')
declare -a success=('INFO:\tSuccessfully updated apt package index files and all currently installed packages' 'INFO:\tSuccessfully installed AutomotiveSecurity lab requirements' 'INFO:\tSuccessfully setup the lab environment' 'INFO:\tSuccessfully set up the SCIS AutomotiveSecurity Lab')
declare -a failure=('ERROR:\tIssue updating apt package index files and all currently installed packages' 'ERROR:\tIssue installing AutomotiveSecurity lab requirements' 'ERROR:\tIssue setting up the lab environment' 'ERROR:\tIssue setting up the SCIS AutomotiveSecurity Lab')

## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osDistro="$(cat /etc/issue | awk '{print $1}')"
declare -r osVersion="$(lsb_release -r | awk '{print $3}')"
declare -r scriptName="$(basename $0)"

## Initialize variables
i=0
somethingfailed=0
exitstatus=0
tmpexitstatus=0
wrongruby=0

## Check the OS version
# Testing Kali Rolling
if [[ ${osDistro} != 'Kali' && ${osVersion} != 'Rolling' ]]; then
  echo -e 'ERROR:\tYour OS has not been tested with this script'
  exit 1
fi

## Check Network Connection
wget -q --spider 'www.github.com'
if [[ $? != 0 ]]; then
  echo -e 'ERROR:\tUnable to contact github.com'
  exit 1
fi

## Check the version of ruby
ruby -v | awk '{print $2}' | grep 2\.2\.3
if [[ $? != 0 ]]; then
  wrongruby=1
fi

## Clear the screen
clear

## Check if the user running this is root
if [[ ${usrCurrent} == "root" ]]; then
  clear
  echo -e "ERROR:\tIt's a bad idea to run scripts when logged in as root - please login with a less privileged account that has sudo access"
  exit 1
fi

## Start up the main part of the script
update_terminal

## Re-synchronize the package index files, then install the newest versions of all packages currently installed
# In cases where apt-get update does not succeed perfectly, it will often only create a warning, which means the exit status will still be 0
sudo apt-get -y -qq update
exitstatus=$?
sudo apt-get -y -qq upgrade
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
update_terminal step

## Install dependancies
# For details regarding can-utils, see https://github.com/linux-can
sudo apt-get -y -qq install git libtool can-utils dh-autoreconf bison flex wireshark libsdl2-dev libsdl2-image-dev maven libconfig-dev gcc autoconf
exitstatus=$?
update_terminal step

## Setup the lab
while [ -z "${prompt}" ]; do
  read -r -p "Do you plan to use hardware? (y/n)" prompt
  case ${prompt} in
    [yY]|[yY][eE][sS]|[sS][uU][rR][eE]|[yY][uU][pP]|[yY][eE][pP]|[yY][eE][aA][hH]|[yY][aA]|[iI][nN][dD][eE][eE][dD]|[aA][bB][ss][oO][lL][uU][tT][eE][lL][yY]|[aA][fF][fF][iI][rR][mM][aA][tT][iI][vV][eE])
      hw=true
      read -rsp $'Please plug in your hardware device now, and then press any key to continue...\n' -n1 key
      ;;
    [nN]|[nN][oO]|[nN][oO][pP][e}|[nN][aA][wW]|[nN][eE][gG][aA][tT][iI][vV][eE])
      hw=false
      ;;
    *)
      echo -e "I did not understand your response.  Please try again"
      ;;
  esac
done

# Pre-requisites to the labs
sudo /sbin/modprobe can
exitstatus=$?
sudo /sbin/modprobe vcan
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
sudo /sbin/modprobe can_raw
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
cd ${HOME}/Desktop/Lab/external/Kayak
mvn clean install
kayakmvn=$?
cd ${HOME}/Desktop/Lab/external/socketcand
autoconf
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
./configure
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
make
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
sudo make install
tmpexitstatus=$?
if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi

# Attempt to setup the hardware lab
if [ ${hw} = true ]; then
  if [[ -L /dev/serial/by-id/*CANtact*-if00 ]]; then
    # Setup the CANtact as a can0 interface at 500k baud.  You may need to tweak your baud rate, depending on the vehicle.
    sudo slcand -o -S 500000 -c /dev/serial/by-id/*CANtact*-if00 can0
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
    sudo ip link set up can0
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
  else
    echo -e "The only currently supported hardware device is the CANtact.  "
    echo -e "Either you don't have a CANtact, it isn't plugged in, or there was an issue with it.  Reverting to the virtual lab..."
    hw=false
  fi
fi

# Attempt to setup the virtual lab
if [ ${hw} = false ]; then
  # There is a good writeup for how to use this code at http://dn5.ljuska.org/cyber-attacks-on-vehicles-2.html
  cd ${HOME}/Desktop/Lab/external/vircar
  sudo make
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
  sudo chmod 777 vircar
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
  sudo ip link add dev vcan0 type vcan
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
  sudo ip link set up vcan0
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
fi

## Setup is complete!
update_terminal step

