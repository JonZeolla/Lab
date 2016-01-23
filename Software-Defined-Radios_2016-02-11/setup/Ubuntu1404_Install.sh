#!/bin/bash
# Tested on Ubuntu 14.04 as of 2016-01-23

clear
echo -e "Beware, this script takes a long time to run\n\n"
sleep 5s
echo -e "Updating apt and all currently installed packages..."
sleep 2s
sudo apt-get -y -qq update && sudo apt-get -y -qq upgrade
echo -e "Installing some SDR lab package requirements"
sleep 2s
sudo apt-get -y -qq install git libboost-all-dev qtdeclarative5-dev libqt5svg5-dev
echo -e "Installing pybombs"
sleep 2s
git clone -q --recursive https://github.com/pybombs/pybombs.git
sleep 2s
echo -e "Installing the SDR lab packages"
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
./pybombs -q install gqrx
