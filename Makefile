default: build

build:
	avra main.s -o main.hex -D F_CPU=16000000

upload:
	avrdude -v -p atmega328p -c arduino -P /dev/ttyUSB0 -b 115200 -D -U flash:w:main.hex:i 

clean:
	rm -f main.hex
	rm -f main.s.*
