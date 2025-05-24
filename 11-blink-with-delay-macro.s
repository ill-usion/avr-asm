.include "m328pdef.inc"
.include "delay.inc"

.def mask   = r16
.def ledReg = r17

.cseg
.org    0x00

start:
    ldi     ledReg, (1 << PINB5)
    out     DDRB, ledReg            ; Set digital pin 13 as output

    clr     mask

loop:
    eor     mask, ledReg            ; Toggle LED state
    out     PORTB, mask
    
    delayMs 500                     ; Wait for 500ms

    rjmp    loop

.include "delay.s"
