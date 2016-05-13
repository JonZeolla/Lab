#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-05-13
# File Type:       Bash Script
# Version:         1.3
# Repository:      https://github.com/JonZeolla/Lab
# Description:     This is a bash script to setup various Debian-based systems for the Steel City InfoSec Automotive Security Lab.
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
  if [[ ${exitstatus} == 0 && ${1} == 'fullstep' ]]; then
    status+=('0')
  if [[ ${exitstatus} == 0 && ${1} == 'minstep' ]]; then
    status+=('0')
  elif [[ ${1} == 'fullstep' || ${1} == 'minstep' ]]; then
    status+=('1')
    somethingfailed=1
  fi
  
  echo -e "\n\n${scriptName}\n"
  
  ## Provide the user with the status of all completed steps until this point
  for x in ${status[@]}; do
    if [[ ${x} == 'Start' ]]; then
      # Check for the carhax user and watermark
      if [ ${usrCurrent} == 'carhax' ] && [ -f /etc/scis.conf ] && grep -q W8wnTFMhhU7RHHAnLIPJdWPKdbySMgIpnh3qwf4uEKnSlytbbB1EWKAEvkTHLAX7uE51T2BDkQqMmttziyErC0kmQLiUeScEmYWo /etc/scis.conf; then
        echo -e 'It appears that you are using the Steel City InfoSec Automotive Security lab machine.  This may already be setup, but there is no harm in running it multiple times\n'
      fi
    elif [[ ${x} == 0 ]]; then
      # Echo the correct success message
      if [[ ${1} == 'fullstep' ]]; then
        echo -e ${successfull[${i}]}
      elif [[ ${1} == 'minstep' ]]; then
        echo -e ${successmin[${i}]}
      fi
      # Increment i
      ((i++))
    elif [[ ${x} == 1 ]]; then
      # Echo the correct failure message
      if [[ ${1} == 'fullstep' ]]; then
        echo -e ${failurefull[${i}]}
      elif [[ ${1} == 'minstep' ]]; then
        echo -e ${failuremin[${i}]}
      fi
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
      if [[ "${1}" == 'fullstep' ]]; then
        echo -e 'Updating apt package index files and all currently installed packages...\n\n'
      elif [[ "${1}" == 'minstep' ]]; then
        echo -e 'Updating apt package index files...\n\n'
      fi
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
        if [[ ${revert} != 0 ]]; then echo -e 'WARNING:\tYou selected to use the hardware lab, but a supported hardware device was not detected, so the script reverted to setting up the virtual lab'; fi
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
declare -a successfull=('INFO:\tSuccessfully updated apt package index files and all currently installed packages' 'INFO:\tSuccessfully installed AutomotiveSecurity lab requirements' 'INFO:\tSuccessfully setup the lab environment' 'INFO:\tSuccessfully set up the SCIS AutomotiveSecurity Lab')
declare -a successmin=('INFO:\tSuccessfully updated apt package index files' 'INFO:\tSuccessfully installed AutomotiveSecurity lab requirements' 'INFO:\tSuccessfully setup the lab environment' 'INFO:\tSuccessfully set up the SCIS AutomotiveSecurity Lab')
declare -a failurefull=('ERROR:\tIssue updating apt package index files and all currently installed packages' 'ERROR:\tIssue installing AutomotiveSecurity lab requirements' 'ERROR:\tIssue setting up the lab environment' 'ERROR:\tIssue setting up the SCIS AutomotiveSecurity Lab')
declare -a failuremin=('ERROR:\tIssue updating apt package index files' 'ERROR:\tIssue installing AutomotiveSecurity lab requirements' 'ERROR:\tIssue setting up the lab environment' 'ERROR:\tIssue setting up the SCIS AutomotiveSecurity Lab')

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
kayakmvn=0
revert=0

## Check the OS version
# Testing Kali Rolling
if [[ "${osDistro}" != 'Kali' && "${osVersion}" != 'Rolling' ]]; then
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
if [[ "${usrCurrent}" == "root" ]]; then
  clear
  echo -e "ERROR:\tIt's a bad idea to run scripts when logged in as root - please login with a less privileged account that has sudo access"
  exit 1
fi

## Check input
if [ $# -eq 0 ]; then
  while [ -z "${prompt}" ]; do
    read -r -p "Do you want to do the full or minimum configuration?  The minimum install will _not_ automatically build or configure the external materials." prompt
    case ${prompt} in
      [fF]|[uU][lL][lL])
        option=full
        ;;
      [mM][iI][nN][iI][mM][uU][mM])
        option=minimum
        ;;
      *)
        echo -e "Please enter either full or minimum"
        ;;
    esac
  done
elif [[ "${1,,}" == 'full' ]]; then
  if [ $# -ne 1 ]; then echo "This script only takes one argument.  Ignoring all other arguments..."; fi
  # Check if the input, converted to lowercase, is equal to full.  If so, do the full install
  option=full
elif [[ "${1,,}" == 'minimum' ]]; then
  if [ $# -ne 1 ]; then echo "This script only takes one argument.  Ignoring all other arguments..."; fi
  # Check if the option, converted to lowercase, is equal to minimum.  If so, do the minimum install
  option=minimum
else
  if [ $# -ne 1 ]; then echo "This script only takes one argument.  Ignoring all other arguments..."; fi
  option=full
  read -rsp $'Input was neither full nor minimum.  Assuming full, please press any key to continue or ctrl+c to stop the script...\n' -n1 key
fi

## Start up the main part of the script
update_terminal

## Re-synchronize the package index files, then install the newest versions of all packages currently installed
if [[ "${option}" == 'full' ]]; then
  sudo apt-get -y -qq upgrade
  exitstatus=$?
  update_terminal fullstep
else
  update_terminal minstep
fi

## Install dependancies
# For details regarding can-utils, see https://github.com/linux-can
sudo apt-get -y -qq install git libtool can-utils dh-autoreconf bison flex wireshark libsdl2-dev libsdl2-image-dev maven libconfig-dev gcc autoconf
exitstatus=$?
update_terminal fullstep

## Setup the lab
while [ -z "${prompt}" ]; do
  read -r -p "Do you plan to use hardware? (y/N)" prompt
  case ${prompt} in
    [yY]|[yY][eE][sS]|[sS][uU][rR][eE]|[yY][uU][pP]|[yY][eE][pP]|[yY][eE][aA][hH]|[yY][aA]|[iI][nN][dD][eE][eE][dD]|[aA][bB][ss][oO][lL][uU][tT][eE][lL][yY]|[aA][fF][fF][iI][rR][mM][aA][tT][iI][vV][eE])
      hw=1
      read -rsp $'Please plug in your hardware device now, and then press any key to continue...\n' -n1 key
      ;;
    [nN]|[nN][oO]|[nN][oO][pP][e}|[nN][aA][wW]|[nN][eE][gG][aA][tT][iI][vV][eE])
      hw=0
      ;;
    *)
      hw=0
      echo -e "INFO:\tUnable to parse your response.  Assuming that you do not plan to use hardware..."
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

if [[ "${option}" == 'full' ]]; then
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
fi

# Attempt to setup the hardware lab
if [ "${hw}" == '1' ]; then
  if [[ -L /dev/serial/by-id/*CANtact*-if00 ]]; then
    # Setup the CANtact as a can0 interface at 500k baud.  You may need to tweak your baud rate, depending on the vehicle.
    sudo slcand -o -S 500000 -c /dev/serial/by-id/*CANtact*-if00 can0
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
    sudo ip link set up can0
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
    cat > ${HOME}/Desktop/start_can.sh << ENDSTARTCAN
#!/bin/bash
sudo /sbin/modprobe can
sudo slcand -o -S 500000 -c /dev/serial/by-id/*CANtact*-if00 can0
sudo ip link set up can0

ENDSTARTCAN 
    sudo chmod 755 ${HOME}/Desktop/start_can.sh
  else
    echo -e "The only currently supported hardware device is the CANtact.  "
    echo -e "Either you don't have a CANtact, it isn't plugged in, or there was an issue with it.  Reverting to the virtual lab..."
    hw=0
    revert=1
  fi
fi

# Attempt to setup the virtual lab
if [ "${hw}" == '0' ]; then
  if [[ "${option}" == 'full' ]]; then
    # There is a good writeup for how to use this code at http://dn5.ljuska.org/cyber-attacks-on-vehicles-2.html
    cd ${HOME}/Desktop/Lab/external/vircar
    sudo make
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
    sudo chmod 777 vircar
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
  fi

  sudo ip link add dev vcan0 type vcan
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
  sudo ip link set up vcan0
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi

  cat > ${HOME}/Desktop/start_vcan.sh << ENDSTARTVCAN
#!/bin/bash
sudo /sbin/modprobe vcan
sudo ip link add dev vcan0 type vcan
sudo ip link set up vcan0

ENDSTARTVCAN 
  sudo chmod 755 ${HOME}/Desktop/start_vcan.sh
fi

## Setup is complete!
update_terminal fullstep

