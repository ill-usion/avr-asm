.include "m328pdef.inc"

.cseg
.org 0x00

; Load a value into register r16
ldi r16, (1 << PINB0)

; Set PINB0 to output
out DDRB, r16
; Set PORTB to high
out PORTB, r16

loop:
    rjmp loop
