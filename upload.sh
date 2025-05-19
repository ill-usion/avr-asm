avrdude -v -p atmega328p -c arduino -P /dev/ttyUSB0 -b 115200 -D -U flash:w:/home/ahmed/code/arduino/avr-asm/main.hex:i 
