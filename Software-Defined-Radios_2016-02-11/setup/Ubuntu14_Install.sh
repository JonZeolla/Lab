#!/bin/bash
# Tested on Ubuntu 14.04 as of 2016-01-23

sudo apt-get install git python-scipy swig libboost-all-dev qtdeclarative5-dev

git clone --recursive https://github.com/pybombs/pybombs.git
cd pybombs
./pybombs install gqrx
