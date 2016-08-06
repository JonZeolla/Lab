#!/bin/bash
# To enable and disable tracing use:  set -x (On) set +x (Off)
# To terminate the script immediately after any non-zero exit status use:  set -e

# =========================
# Author:	Jon Zeolla (JZeolla, JonZeolla)
# Last update:	2016-08-05
# File Type:	Bash Script
# Version:	1.1
# Repository:	https://github.com/JonZeolla/lab
# Description:	This is a general purpose bash script to set up my labs.
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
}

update_terminal() {
	## Set the status for the current stage appropriately
	if [[ ${1} == 'start' ]]; then
		:
	elif [[ ${exitstatus} == 0 && ${1} == 'nextstep' ]]; then
		status+=('0')

		## Clear the screen
		clear
	elif [[ ${exitstatus} != 0 && ${1} == 'nextstep' ]]; then
		status+=('1')
		somethingfailed=1

		## Clear the screen
		clear
	else
		feedback ABORT "Unknown error"
	fi
	
	## Provide the user with the status of all completed steps until this point
	for x in ${status[@]}; do
		if [[ ${x} == 'start' ]]; then
			:
		elif [[ ${x} == 0 ]]; then
			# Echo the success message
			feedback INFO "${success[${i}]}"
		elif [[ ${x} == 1 ]]; then
			# Echo the failure message
			feedback ERROR "${failure[${i}]}"
		else
			feedback ABORT "Unknown error evaluating ${x} in the status array"
		fi
		# Increment i
		((i++))
	done

	## Reset i
	i=0

	## Update the user with a quick description of the next step
	case ${#status[@]} in
		1)
			echo -e 'Updating apt package index files and all currently installed packages (this may take a while)...\n\n'
			;;
		2)
			echo -e "\nInstalling some ${githubTag} lab package requirements...\n\n"
			;;
		3)
			echo -e '\nSetting up the lab environment...\n\n'
			;;
		4)
			# Give a summary update and cleanup messages
			if [[ ${notOptimalGit} != 0 ]]; then feedback WARN "Your local git instance of the lab is non-optimal. Please review ${HOME}/Desktop/lab manually."; fi
			if [[ ${notGitUTD} != 0 ]]; then feedback WARN "Your local git instance of the lab is not considered up to date with master."; fi

			if [[ ${somethingfailed} != 0 ]]; then
				feedback ABORT "Something went wrong during the installation process"
			else
				exit ${exitstatus}
			fi
			;;
		*)
			feedback ABORT "Unknown error"
			;;
	esac
	
	## Reset the exit status variables
	exitstatus=0
	tmpexitstatus=0
}


## Set static variables
declare -r usrCurrent="${SUDO_USER:-$USER}"
declare -r osDistro="$(cat /etc/issue 2>/dev/null | awk '{print $1}')"
declare -r osVersion="$(cat /etc/issue 2>/dev/null | awk '{print $3}')"
declare -r githubTag='ProximityAttacks'
declare -r UUID='pXloRpmKEasnWPCUihcQcx1WeUo9fo2hQJAXh1uoAOQ1ooz3xLUCbPYDItfeULA9zItnZaQqfell0LLBzSuQhxl98dyP8y7DY1hE'
declare -r txtDEFAULT='\033[0;30m'
declare -r txtDEBUG='\033[33;34m'
declare -r txtINFO='\033[0;30m'
declare -r txtWARN='\033[0;33m'
declare -r txtERROR='\033[0;31m'
declare -r txtABORT='\033[1;31m'

## Initialize variables
somethingfailed=0
i=0
notOptimalGit=0
internalcall=0
declare -a allfeedback

## Set up arrays
declare -a status=('start')
declare -a success=('Successfully updated apt package index files and all currently installed packages' "Successfully installed the ${githubTag} lab requirements" "Successfully set up the ${githubTag} lab environment" "Successfully set up the ${githubTag} lab")
declare -a failure=('Issue updating apt package index files and all currently installed packages' "Issue installing the ${githubTag} lab requirements" "Issue setting up the ${githubTag} lab environment" "Issue setting up the ${githubTag} lab")

## Check the OS version
# Testing Kali Rolling
if [[ "${osDistro}" != 'Kali' && "${osVersion}" != 'Rolling' ]]; then
	feedback ABORT "Your OS has not been tested with this script"
fi

## Install requirements
sudo apt-get -y install git imvirt wget

## Check virtualization
if ! imvirt | grep -i vmware; then
	feedback ABORT "Unsupported hypervisor"
fi

## Check Network Connection
wget -q --spider 'www.github.com'
if [[ $? != 0 ]]; then
	feedback ABORT "Unable to contact github.com"
fi

## Clear the screen
clear

## Check if the user running this is root
if [[ "${usrCurrent}" == "root" ]]; then
	clear
	feedback ABORT "It's a bad idea to run scripts when logged in as root - please login with a less privileged account that has sudo access"
fi

## Start up the main part of the script
update_terminal start

## Re-synchronize the package index files, then install the newest versions of all packages currently installed
sudo apt-get -y update
checkexitstatus
sudo apt-get -y upgrade
checkexitstatus
update_terminal nextstep

# Setup the lab github repo
if [[ ! -d ${HOME}/Desktop/lab ]]; then
	cd ${HOME}/Desktop
	git clone -b ${githubTag} --single-branch --recursive https://github.com/JonZeolla/lab
	checkexitstatus
	notGitUTD=0
elif [[ -d ${HOME}/Desktop/lab ]]; then
	cd ${HOME}/Desktop/lab
	isgit=$(git rev-parse --is-inside-work-tree > /dev/null 2>&1 && echo 1 || echo 0)
	curBranch=$(git branch | grep \* | awk '{print $2}')
	if git status -uno | grep "up-to-date"; then notGitUTD=0; else notGitUTD=1; fi
	if [[ ${isgit} == 1 && (${curBranch} == "${githubTag}" || ${curBranch} == "(no branch)") && ${notGitUTD} == 0 ]]; then
		notOptimalGit=0
	elif [[ ${isgit} == 1 && (${curBranch} == "${githubTag}" || ${curBranch} == "(no branch)") && ${notGitUTD} == 1 ]]; then
		notOptimalGit=1
	elif [[ ${isgit} == 0 || (${curBranch} != "${githubTag}" && ${curBranch} != "(no branch)") ]]; then
		feedback ERROR "${HOME}/Desktop/lab exists, but is not a functional git working tree or is pointing to the wrong branch."
		notOptimalGit=1
		exitstatus=1
	else
		feedback ERROR "Unknown error"
		notOptimalGit=1
		exitstatus=1
	fi
else
	feedback ERROR "Unknown error"
	exitstatus=1
fi
update_terminal nextstep

## Kick off the lab configuration script
${HOME}/Desktop/lab/configure.sh
checkexitstatus
update_terminal nextstep

