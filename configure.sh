#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:	Jon Zeolla (JZeolla, JonZeolla)
# Last update:	2016-08-05
# File Type:	Bash Script
# Version:	1.1
# Repository:	https://github.com/JonZeolla/lab
# Description:	This is a bash script to configure the Proximity Attacks lab.
#
# Notes
# - Anything that has a placeholder value is tagged with TODO.
#
# =========================

feedback() {
	color=txt${1:-DEFAULT}
	if [ $# -eq 0 ]; then
		clear
		for line in "${allfeedback[@]}"; do
			level=$(cut -f1 -d' ' <<< ${line})
			text=$(sed "s_^${level} __" <<< ${line})
			feedback "${level}" "${text}" "internal"
		done
	else
		if [[ ${1} == "ABORT" ]]; then
			echo -e "${!color}ERROR:\t${2}, aborting...${txtDEFAULT}"
			exit 1
		else
			echo -e "${!color}${1}:\t${2}${txtDEFAULT}"
		fi

		if [[ ${3} != "internal" ]]; then
			allfeedback+=("${1} ${2}")
		fi
	fi
}

checkexitstatus() {
	tmpexitstatus=$?
	if [[ ${tmpexitstatus} != 0 ]]; then
		exitstatus="${tmpexitstatus}"
	fi
	if [[ ${1} == "clear" ]]; then
		tmpexitstatus=0
	fi
}


## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osDistro="$(cat /etc/issue 2>/dev/null | awk '{print $1}')"
declare -r osVersion="$(cat /etc/issue 2>/dev/null | awk '{print $3}')"
declare -r githubTag='ProximityAttacks'
declare -r UUID='pXloRpmKEasnWPCUihcQcx1WeUo9fo2hQJAXh1uoAOQ1ooz3xLUCbPYDItfeULA9zItnZaQqfell0LLBzSuQhxl98dyP8y7DY1hE'
declare -r txtDEFAULT='\033[0m'
declare -r txtDEBUG='\033[33;34m'
declare -r txtINFO='\033[0;30m'
declare -r txtWARN='\033[0;33m'
declare -r txtERROR='\033[0;31m'
declare -r txtABORT='\033[1;31m'

## Initialize global variables
exitstatus=0
tmpexitstatus=0
declare -a allfeedback

## Check for the carhax user and watermark
if [ ${usrCurrent} == 'prox' ] && [ -f /etc/scis.conf ] && grep -q ${UUID} /etc/scis.conf; then
	feedback INFO "It appears that you are using the Steel City InfoSec Automotive Security lab machine.  This may already be setup, but there is no harm in running it multiple times"
fi

## Install the lab dependencies
# TODO:  bluez-firmware and systemd have no packages on the kali repos?  Also, rfcomm is missing on both.  Leaving all of them out.  
# TODO:  Also leaving out bluez, bluez-tools because I'm building from scratch
sudo apt-get -y install p7zip build-essential libreadline5 libreadline-dev gcc-arm-none-eabi libusb-0.1-4 libusb-dev libqt4-dev ncurses-dev perl pkg-config wget hwinfo libglib2.0-dev libdbus-1-dev libudev-dev libical-dev bluetooth rfkill
checkexitstatus clear

## Set up the lab environment
# Proxmark3
sudo mkdir -p /opt/devkitpro/
checkexitstatus
if [[ -e ${HOME}/Desktop/lab/.storage/devkitARM_r41-x86_64-linux.tar.bz2 ]]; then
	cd ${HOME}/Desktop/lab/.storage
	tar -jxvf ${HOME}/Desktop/lab/.storage/devkitARM_r41-x86_64-linux.tar.bz2
	checkexitstatus
fi
sudo mv ${HOME}/Desktop/lab/.storage/devkitARM /opt/devkitpro/
checkexitstatus
cd ${HOME}/Desktop/lab/external/proxmark3
checkexitstatus
make
checkexitstatus clear
# blekey
if [[ -e ${HOME}/Desktop/lab/.storage/gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2 ]]; then
        cd ${HOME}/Desktop/lab/.storage
        tar -jxvf ${HOME}/Desktop/lab/.storage/gcc-arm-none-eabi-5_4-2016q2-20160622-linux.tar.bz2
        checkexitstatus
fi
if [[ -e ${HOME}/Desktop/lab/.storage/bluez-5.41.tar.gz ]]; then
        cd ${HOME}/Desktop/lab/.storage
        tar -xvf ${HOME}/Desktop/lab/.storage/bluez-5.41.tar.gz
        checkexitstatus
fi
mkdir -p /opt/gcc-arm
# TODO: Update the src below
sudo mv ${HOME}/Desktop/lab/.storage/gcc-arm-none-eabi /opt/gcc-arm
checkexitstatus
# TODO:  Does this work?
sed -ie 's_\/home\/blark\/gcc-arm-none-eabi-4_9-2015q1_\/opt\/gcc-arm_' ${HOME}/Desktop/lab/external/BLEKey/nordic/nrf51822/Source/templates/gcc/Makefile.posix
checkexitstatus
cd ${HOME}/Desktop/lab/external/BLEKey/gcc
make
checkexitstatus clear


read -rsp $'Please plug in the proxmark and then press any key to continue.  If you are not prepared for this, press ctrl+c to kill the script...\n' -n1 key
lsusb -d 2d2d:504d >/dev/null 2>&1
if [[ $? != 0 ]]; then
	feedback ABORT "Not detecting the proxmark properly"
else
	# Check HID vs CDC
	if hwinfo --usb | sed -n "/Vendor: usb 0x2d2d/,/Attached to/p" | sed -n "/Device: usb 0x504d/,/Attached to/p" | grep -i cdc_acm >/dev/null 2>&1; then
		feedback INFO "Successfully detected the proxmark is using the cdc_acm driver"
	elif hwinfo --usb | sed -n "/Vendor: usb 0x2d2d/,/Attached to/p" | sed -n "/Device: usb 0x504d/,/Attached to/p" | grep -i hid >/dev/null 2>&1; then
		feedback ABORT "The proxmark appears to be using the hid driver.  Fixing this requires a reflashing of the proxmark, which no sane person would automate in a script like this"
	else
		feedback ABORT "Proxmark was plugged in, but there appears to be an unknown issue loading the driver"
	fi
fi

## Set up the lab-specific settings
feedback INFO "Nothing to do."
# TODO:  feedback INFO ""
# TODO:  feedback ERROR ""
checkexitstatus clear

feedback
exit ${exitstatus}
