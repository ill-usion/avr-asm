    .include "m328pdef.inc"

    .cseg
    .org    0x00

    .def mask       = r16
    .def ledReg     = r17
    .def btnReg     = r18
    
    .equ ledPin     = PINB5         ; Digital pin 13
    .equ btnPin     = PIND7         ; Digital pin 7

    ldi     mask, 0b00000000        
    out     DDRD, mask              ; Set all PORTD pins as input
    
    ldi     mask, 0b11111111
    out     PORTD, mask             ; Enable pullup resistors

    ldi     mask, (1 << ledPin)
    out     DDRB, mask              ; Set pin 13 as output

    ldi     mask, (1 << btnPin)     ; Load the button mask for later use 

start:
    in      btnReg, PIND            ; Read PIND
    and     btnReg, mask            ; Get the button state. 0 for pressed, and 1 for not pressed
    breq    switch_on               ; Turn on the LED if the Zero flag is set 
    
    clr     ledReg
    out     PORTB, ledReg           ; Clear all pins in PORTB

    rjmp start

switch_on:
    ldi     ledReg, (1 << ledPin)
    out     PORTB, ledReg           ; Set the LED bit in PORTB
    rjmp start                      ; Jump back to the start of the loop
