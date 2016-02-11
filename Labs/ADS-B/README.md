# gr-air-modes  
gr-air-modes is a Mode S/ADS-B decoder.  

1. Shorten your antenna a bit. About 5.15 inches is the right length for 1090 MHz (on a telescopic antenna).  
2. In a terminal, run 'modes_gui'.  
3. Check your settings:  
  * Source: Osmocom  
  * Rate: 2.400 Msps  
  * Threshold: 9 dB (I've had good luck with 7-9 dB)  
  * Gain: 44 dB (our antennas aren't the best, so up the gain)  
  * Use Pulse Matched Filtering: checked  
  * Use DC blocking filter:checked  
  * Latitude: 40.4397  
  * Longitude: -79.9764  
4. Press the 'Start' button. You should get > 0 Reports/second. Switch over to the Map tab to see the planes on Google Maps. The Live  data tab shows you the Mode S messages being decoded.  
