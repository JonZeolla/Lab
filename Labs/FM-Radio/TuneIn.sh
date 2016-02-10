#!/bin/bash
shopt -s nocasematch
if [ $# -eq 0 ]; then
  echo -e "Usage: $0 (TuneIn|Recording)"
  exit 1
fi

if [[ (${1} == "TuneIn") || (${1} == "Tune" && ${2} == "In") ]]; then
  gqrx
elif [[ ${1} == "Recording" ]]
  aplay -r 48k -f S16_LE -t raw -c 1 ${HOME}/Desktop/Lab/Labs/FM-Radio/gqrx_20160210_001957_105900000.wav
else
  echo -e "Usage: $0 (TuneIn|Recording)"
fi
shopt -u nocasematch
