#!/bin/bash
if [ $# -eq 0 ]; then
  echo -e "Usage: $0 (TuneIn|Recording)"
  exit 1
fi

if [[ $(shopt | grep nocasematch | awk '{print $2}') == off ]]; then
  wasoff=1
  shopt -s nocasematch
fi

if [[ (${1} == "TuneIn") || (${1} == "Tune" && ${2} == "In") ]]; then
  echo -e "INFO:\tIf you need to unplug your RTL-SDR, be sure to safely disconnect it.\nINFO:\tIf you are having issues only hearing static but you are seeing the correct signal pattern in gqrx, please safely disconnect the RTL-SDR from VMWare, remove it from your computer, then re-attach and re-associate it."
  echo -e "INFO:\tOpening gqrx..."
  sleep 2s
  gqrx &
elif [[ ${1} == "Recording" ]]; then
  echo -e "INFO:\tOpening the recording..."
  aplay -r 48k -f S16_LE -t raw -c 1 ${HOME}/Desktop/Lab/Labs/FM-Radio/gqrx_20160210_001957_105900000.wav &
else
  echo -e "Usage: $0 (TuneIn|Recording)"
fi

if [[ $wasoff == 1 ]]; then
  shopt -u nocasematch
fi

exit 0
