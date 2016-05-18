#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:          Jon Zeolla (JZeolla, JonZeolla)
# Last update:     2016-05-18
# File Type:       Bash Script
# Version:         1.16
# Repository:      https://github.com/JonZeolla/lab
# Description:     This is a bash script to setup various Debian-based systems for the Steel City InfoSec Automotive Security Lab.
#
# Notes
# - Please feel free to test on other OSs, and create a pull request modifying the OS version check to allow for OSs that this script works on.
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

function update_terminal() {
  ## Set the status for the current stage appropriately
  if [[ ${exitstatus} == 0 && ${1} == 'fullstep' ]]; then
    status+=('0')

    ## Clear the screen
    clear
  elif [[ ${exitstatus} == 0 && ${1} == 'minstep' ]]; then
    status+=('0')

    ## Clear the screen
    clear
  elif [[ ${1} == 'fullstep' || ${1} == 'minstep' ]]; then
    status+=('1')
    somethingfailed=1

    ## Clear the screen
    clear
  fi
  
  ## Provide the user with the status of all completed steps until this point
  for x in ${status[@]}; do
    if [[ ${x} == 'Start' ]]; then
      # Check for the carhax user and watermark
      if [ ${usrCurrent} == 'carhax' ] && [ -f /etc/scis.conf ] && grep -q ${UUID} /etc/scis.conf; then
        echo -e 'INFO:\tIt appears that you are using the Steel City InfoSec Automotive Security lab machine.  This may already be setup, but there is no harm in running it multiple times'
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
      echo -e "${txtRED}ERROR:\tUnknown error evaluating ${x} in the status array${txtDEFAULT}"
      exit 1
    fi
  done

  ## Reset i
  i=0

  ## Update the user with a quick description of the next step
  case ${#status[@]} in
    1)
      if [[ "${1}" == 'fullstep' ]]; then
        echo -e 'Updating apt package index files and all currently installed packages (this may take a while)...\n\n'
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
        if [[ ${wrongruby} != 0 ]]; then echo -e "${txtORANGE}WARN:\tRuby is the incorrect version.  vircar-fuzzer may not function properly${txtDEFAULT}"; fi
        if [[ ${kayakmvn} != 0 ]]; then echo -e "${txtORANGE}WARN:\tThere are some known issues with the Kayak setup.\nWARN:\tThere is no need to re-run the setup scripts, however please run `cd ${HOME}/Desktop/Lab/external/Kayak;mvn clean install` until it reports success${txtDEFAULT}"; fi
        if [[ ${timeout} != 0 ]]; then echo -e "${txtORANGE}WARN:\tOne or more of the prompts timed out after 30 seconds and used the default without user input.${txtDEFAULT}"; fi
        if [[ ${revert} != 0 ]]; then echo -e "${txtORANGE}WARN:\tYou selected to use the hardware lab, but a supported hardware device was not detected, so the script reverted to setting up the virtual lab${txtDEFAULT}"; fi
        if [[ ${rclocaloverwrite} != 0 ]]; then echo -e "${txtORANGE}WARN:\tYour /etc/rc.local file has been overwritten${txtDEFAULT}"; fi
        echo -e "${txtRED}ERROR:\tSomething went wrong during the installation process${txtDEFAULT}"
        exit 1
      else
        if [[ ${wrongruby} != 0 ]]; then echo -e "${txtORANGE}WARN:\tRuby is the incorrect version.  vircar-fuzzer may not function properly${txtDEFAULT}"; fi
        if [[ ${kayakmvn} != 0 ]]; then echo -e "${txtORANGE}WARN:\tThere are some known issues with the Kayak setup.\nWARN:\tThere is no need to re-run the setup scripts, however please run `cd ${HOME}/Desktop/Lab/external/Kayak;mvn clean install` until it reports success${txtDEFAULT}"; fi
        if [[ ${timeout} != 0 ]]; then echo -e "${txtORANGE}WARN:\tOne or more of the prompts timed out after 30 seconds and used the default without user input.${txtDEFAULT}"; fi
        if [[ ${revert} != 0 ]]; then echo -e "${txtORANGE}WARN:\tYou selected to use the hardware lab, but a supported hardware device was not detected, so the script reverted to setting up the virtual lab${txtDEFAULT}"; fi
        if [[ ${rclocaloverwrite} != 0 ]]; then echo -e "${txtORANGE}WARN:\tYour /etc/rc.local file has been overwritten${txtDEFAULT}"; fi
        echo -e 'INFO:\tSuccessfully configured the AutomotiveSecurity lab'
        exit 0
      fi
      ;;
    *)
      echo -e "${txtRED}ERROR:\tUnknown error${txtDEFAULT}"
      exit 1
      ;;
  esac
  
  ## Reset the exit status variables
  exitstatus=0
  tmpexitstatus=0
}

## Set up arrays
declare -a status=('Start')
declare -a successfull=('INFO:\tSuccessfully updated apt package index files and all currently installed packages' 'INFO:\tSuccessfully installed AutomotiveSecurity lab requirements' 'INFO:\tSuccessfully setup the lab environment' 'INFO:\tSuccessfully set up the AutomotiveSecurity Lab')
declare -a successmin=('INFO:\tSuccessfully updated apt package index files' 'INFO:\tSuccessfully installed AutomotiveSecurity lab requirements' 'INFO:\tSuccessfully setup the lab environment' 'INFO:\tSuccessfully set up the AutomotiveSecurity Lab')
declare -a failurefull=('${txtRED}ERROR:\tIssue updating apt package index files and all currently installed packages${txtDEFAULT}' '${txtRED}ERROR:\tIssue installing AutomotiveSecurity lab requirements${txtDEFAULT}' '${txtRED}ERROR:\tIssue setting up the lab environment${txtDEFAULT}' '${txtRED}ERROR:\tIssue setting up the AutomotiveSecurity Lab${txtDEFAULT}')
declare -a failuremin=('${txtRED}ERROR:\tIssue updating apt package index files${txtDEFAULT}' '${txtRED}ERROR:\tIssue installing AutomotiveSecurity lab requirements${txtDEFAULT}' '${txtRED}ERROR:\tIssue setting up the lab environment${txtDEFAULT}' '${txtRED}ERROR:\tIssue setting up the AutomotiveSecurity Lab${txtDEFAULT}')

## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osDistro="$(cat /etc/issue | awk '{print $1}')"
declare -r osVersion="$(lsb_release -r | awk '{print $3}')"
declare -r txtRED='\033[0;31m'
declare -r txtORANGE='\033[0;33m'
declare -r txtDEFAULT='\033[0m'
declare -r UUID='W8wnTFMhhU7RHHAnLIPJdWPKdbySMgIpnh3qwf4uEKnSlytbbB1EWKAEvkTHLAX7uE51T2BDkQqMmttziyErC0kmQLiUeScEmYWo'

## Initialize variables
i=0
somethingfailed=0
exitstatus=0
tmpexitstatus=0
wrongruby=0
kayakmvn=0
revert=0
timeout=0
rclocaloverwrite=0

## Check the OS version
# Testing Kali Rolling
if [[ "${osDistro}" != 'Kali' && "${osVersion}" != 'Rolling' ]]; then
  echo -e "${txtRED}ERROR:\tYour OS has not been tested with this script${txtDEFAULT}"
  exit 1
fi

## Check Network Connection
wget -q --spider 'www.github.com'
if [[ $? != 0 ]]; then
  echo -e "${txtRED}ERROR:\tUnable to contact github.com${txtDEFAULT}"
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
  echo -e "${txtRED}ERROR:\tIt's a bad idea to run scripts when logged in as root - please login with a less privileged account that has sudo access${txtDEFAULT}"
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

echo -en "${txtORANGE}"
read -t 30 -rsp $'WARN:\tThis script overwrites /etc/rc.local if it isn't properly configured for this lab.  You have 30 seconds to press any key to continue or ctrl+c to stop the script...\n' -n1 key
if [[ $? == 142 ]]; then echo -e "${txtORANGE}WARN:\tTimed out, continuing with the script...${txtDEFAULT}"; timeout=1; fi
echo -en "${txtDEFAULT}"

## Start up the main part of the script
update_terminal

## Re-synchronize the package index files, then install the newest versions of all packages currently installed
if [[ "${option}" == 'full' ]]; then
  sudo apt-get -y upgrade
  exitstatus=$?
  update_terminal fullstep
else
  update_terminal minstep
fi

## Install dependancies
# For details regarding can-utils, see https://github.com/linux-can
sudo apt-get -y install git libtool can-utils dh-autoreconf bison flex wireshark libsdl2-dev libsdl2-image-dev maven libconfig-dev gcc autoconf ant netbeans python3
exitstatus=$?
update_terminal fullstep

## Setup the lab
while [ -z "${prompt}" ]; do
  read -t 30 -p "Do you plan to use hardware? (y/N)  " prompt
  if [[ $? == 142 ]]; then echo -e "${txtORANGE}WARN:\tTimed out, continuing with the script...${txtDEFAULT}"; timeout=1; fi
  case ${prompt} in
    [yY]|[yY][eE][sS]|[sS][uU][rR][eE]|[yY][uU][pP]|[yY][eE][pP]|[yY][eE][aA][hH]|[yY][aA]|[iI][nN][dD][eE][eE][dD]|[aA][bB][ss][oO][lL][uU][tT][eE][lL][yY]|[aA][fF][fF][iI][rR][mM][aA][tT][iI][vV][eE])
      hw=1
      read -p "What baud rate would you like to use?  " baudrate

      # Check to make sure ${baudrate} is an integer (no strings, decimals, etc.).  If not, default to 500000
      [ "${baudrate}" -ne "${baudrate}" ] 2>/dev/null
      if [[ $? != 1 ]]; then baudrate=500000; echo -e "${txtORANGE}WARN:\tIssue with the input baud rate, defaulting to 500000${txtDEFAULT}"; fi

      read -rsp $'Please plug in your hardware device now, and then press any key to continue...\n' -n1 key
      ;;
    [nN]|[nN][oO]|[nN][oO][pP][e}|[nN][aA][wW]|[nN][eE][gG][aA][tT][iI][vV][eE])
      hw=0
      ;;
    *)
      prompt="N"
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
if ! grep -q "^can$" /etc/modules 2>/dev/null; then echo -e "can" | sudo tee -a /etc/modules 1>/dev/null; tmpexitstatus=$?; if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi; fi
if ! grep -q "^vcan$" /etc/modules 2>/dev/null; then echo -e "vcan" | sudo tee -a /etc/modules 1>/dev/null; tmpexitstatus=$?; if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi; fi
if ! grep -q "^can_raw$" /etc/modules 2>/dev/null; then echo -e "can_raw" | sudo tee -a /etc/modules 1>/dev/null; tmpexitstatus=$?; if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi; fi
if ! grep -q "${UUID}" /etc/rc.local 2>/dev/null; then
  rclocaloverwrite=1
  sudo tee /etc/rc.local 1>/dev/null << ENDSTARTUPSCRIPTS
#!/bin/bash
#
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# UUID:  ${UUID}
if [[ -L /dev/serial/by-id/*CANtact*-if00 ]]; then
  sudo slcand -o -S 500000 -c /dev/serial/by-id/*CANtact*-if00 can0
  sudo ip link set up can0
else
  sudo ip link add dev vcan0 type vcan
  sudo ip link set up vcan0
fi

ENDSTARTUPSCRIPTS
fi

if [[ "${option}" == 'full' ]]; then
  # Setup Kayak
  cd ${HOME}/Desktop/Lab/external/Kayak
  mvn clean install
  kayakmvn=$?

  # Setup socketcand
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

  # Setup cantact-app
  cd ${HOME}/Desktop/Lab/external/cantact-app
  export CLASSPATH=$CLASSPATH:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/resources.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/rt.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/sunrsasign.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/jsse.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/jce.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/charsets.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/jfr.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/classes:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/icedtea-sound.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/sunec.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/cldrdata.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/zipfs.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/nashorn.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/sunpkcs11.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/java-atk-wrapper.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/sunjce_provider.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/dnsns.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/localedata.jar:/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/ext/jaccess.jar
  ant build
fi

# Attempt to setup the hardware lab
if [ "${hw}" == '1' ]; then
  if [[ -L /dev/serial/by-id/*CANtact*-if00 ]]; then
    # Setup the CANtact as a can0 interface at 500k baud.  You may need to tweak your baud rate, depending on the vehicle.
    createinterface=$(sudo slcand -o -S ${baudrate} -c /dev/serial/by-id/*CANtact*-if00 can0 2>&1)
    tmpexitstatus=$?
    # TODO:  Catch when can0 already exists and don't count it as a failure - something like:
    #if [[ "${createinterface}" != "RTNETLINK answers: File exists" ]]; then if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi; fi
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
    sudo ip link set up can0
    tmpexitstatus=$?
    if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi
    cat > ${HOME}/Desktop/start_can.sh << ENDSTARTCAN
#!/bin/bash

declare -r txtRED='\033[0;31m'
declare -r txtORANGE='\033[0;33m'
declare -r txtDEFAULT='\033[0m'

read -p "What baud rate would you like to use?  " baudrate
# Check to make sure ${baudrate} is an integer (no strings, decimals, etc.).  If not, default to 500000
[ "${baudrate}" -ne "${baudrate}" ] 2>/dev/null
if [[ $? != 1 ]]; then baudrate=500000; echo -e "${txtORANGE}WARN:\tIssue with the input baud rate, defaulting to 500000${txtDEFAULT}"; fi
createinterface=\$(sudo slcand -o -S ${baudrate} -c /dev/serial/by-id/*CANtact*-if00 can0 2>&1)
tmpexitstatus=\$?
# TODO:  Catch when can0 already exists and don't count it as a failure - something like:
#if [[ "\${createinterface}" != "RTNETLINK answers: File exists" ]]; then if [[ \${tmpexitstatus} != 0 ]]; then echo -e "\${txtRED}ERROR:\\tIssue bringing up the can0 interface\${txtDEFAULT}"; fi; fi
if [[ \${tmpexitstatus} != 0 ]]; then exitstatus="\${tmpexitstatus}"; fi
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

  createinterface=$(sudo ip link add dev vcan0 type vcan 2>&1)
  tmpexitstatus=$?
  # Don't count it as an error if the interface already exists
  if [[ "${createinterface}" != "RTNETLINK answers: File exists" ]]; then if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi; fi
  sudo ip link set up vcan0
  tmpexitstatus=$?
  if [[ ${tmpexitstatus} != 0 ]]; then exitstatus="${tmpexitstatus}"; fi

  cat > ${HOME}/Desktop/start_vcan.sh << ENDSTARTVCAN
#!/bin/bash

declare -r txtRED='\033[0;31m'
declare -r txtDEFAULT='\033[0m'

createinterface=\$(sudo ip link add dev vcan0 type vcan 2>&1)
tmpexitstatus=\$?
if [[ "\${createinterface}" != "RTNETLINK answers: File exists" ]]; then if [[ \${tmpexitstatus} != 0 ]]; then echo -e "\${txtRED}ERROR:\\tIssue bringing up the vcan0 interface\${txtDEFAULT}"; fi; fi
sudo ip link set up vcan0

ENDSTARTVCAN
  sudo chmod 755 ${HOME}/Desktop/start_vcan.sh
fi

## Setup is complete!
update_terminal fullstep

