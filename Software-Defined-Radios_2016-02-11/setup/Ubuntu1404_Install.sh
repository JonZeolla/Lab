#!/bin/bash
# Tested on Ubuntu 14.04 as of 2016-01-23

clear
echo -e "Beware, this script takes a long time to run\n\n"
sleep 2s
echo -e "Updating apt and all currently installed packages..."
sleep 2s
sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade
if [[ $? == 0 ]]; then clear; echo -e "Successfully updated apt and all currently installed packages"; else echo -e "ERROR updating apt and all currently installed packages"; err=1; fi
echo -e "\nInstalling some SDR lab package requirements"
sleep 2s
sudo apt-get -y -qq install git libboost-all-dev qtdeclarative5-dev libqt5svg5-dev swig python-scipy
if [[ $? == 0 ]]; then clear; echo -e "Successfully installed SDR lab package requirements"; else echo -e "ERROR installing SDR lab package requirements"; err=2; fi
echo -e "\nInstalling pybombs"
sleep 2s
git clone -q --recursive https://github.com/pybombs/pybombs.git
sleep 2s
if [[ $? == 0 ]]; then clear; echo -e "Successfully installed pybombs"; else echo -e "ERROR installing pybombs"; err=3; fi
echo -e "\nInstalling the SDR lab packages"
cd pybombs
cat > /home/sdr/pybombs/config.dat <<EOL
[config]
gituser = sdr
gitcache = 
gitoptions = 
prefix = /home/sdr/target
satisfy_order = deb,src
forcepkgs = 
forcebuild = gnuradio,uhd,gr-air-modes,gr-osmosdr,gr-iqbal,gr-fcdproplus,uhd,rtl-sdr,osmo-sdr,hackrf,gqrx,bladeRF,airspy
timeout = 30
cmakebuildtype = RelWithDebInfo
builddocs = OFF
cc = gcc
cxx = g++
makewidth = 4
EOL
./pybombs install gqrx
if [[ $? == 0 ]]; then clear; echo -e "Successfully installed gqrx"; else echo -e "ERROR installing gqrx"; err=4; fi
if [[ $err != 1 ]]; then echo -e "Succesfully set up machine for the SDR lab"; else echo -e "ERROR while setting up the machine for the SDR lab"; fi
