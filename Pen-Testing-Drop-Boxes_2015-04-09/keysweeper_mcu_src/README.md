
Initial Code (poorly 'forked') from Sammy Kamkar - https://github.com/samyk/keysweeper

Library sources included in this directory for lab distribution purposes.

adafruit TinyFlash: https://github.com/adafruit/Adafruit_TinyFlash/

https://github.com/adafruit/Adafruit_TinyFlash/blob/master/Adafruit_TinyFlash.h
https://github.com/adafruit/Adafruit_TinyFlash/blob/master/Adafruit_TinyFlash.cpp

maniacbug / f24 library : https://github.com/maniacbug/RF24

https://github.com/maniacbug/RF24/blob/master/nRF24L01.h
https://github.com/maniacbug/RF24/blob/master/RF24_config.h
https://github.com/maniacbug/RF24/blob/master/RF24.h
https://github.com/maniacbug/RF24/blob/master/RF24.cpp


Resource Links: [Section to be improved - BWG]

Unofficial download for Arduino SDK - [should be faster than from arduino.cc]
http://ctrlu.net/hackpgh/keysweeper/


Standard Pinout for Nrf24L01+
http://arduino-info.wikispaces.com/Nrf24L01-2.4GHz-HowTo

Keyboard locking issue: https://www.youtube.com/all_comments?v=WqkmGG0biXc
`if (p[4] == 0xCD)` to `if (1)`

"each keyboard seems to only use 4 frequencies in one of these sets: {3, 19, 78, 78}, {29, 50, 70, 80}, {21, 31, 72, 54}, {5, 25, 44, 52}, {23, 46, 56, 74}, {17, 27, 48, 76}"


-- Uploading code to the pro mini --

If you're using the "ADAFRUIT INDUSTRIES 954 USB-TO-TTL SERIAL CABLE, RASPBERRY PI" provided with the kit the pins are as follow:
http://www.amazon.com/gp/product/B00DJUHGHI/ref=oh_aui_detailpage_o09_s00?ie=UTF8&psc=1

The red lead is 5V so if you intend to use it as power you’ll need to route it to the raw input on the mini which can support up to +9V. (don't apply this if you are already supplying power) 
The black lead to GND, 
The white lead to TXD.
The green lead to RXD.



