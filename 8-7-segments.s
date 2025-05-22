.include "m328pdef.inc"

.cseg
.org        0x00

.def        mask            = r16
.def        numDelayIterReg = r17   ; Number of iterations for 10ms delay
.def        delayLoopRegL   = r24   ; Delay loop counter low
.def        delayLoopRegH   = r25   ; Delay loop counter high

.equ        delayLoopVal    = 39998
.equ        delay           = 25    ; 10ms x 25 = 250ms

                            ;   gfedcba
.equ        segments1       = 0b00001100
.equ        segments2       = 0b10110110
.equ        segments3       = 0b10011110
.equ        segments4       = 0b11001100
.equ        segments5       = 0b11011010
.equ        segments6       = 0b11111010
.equ        segments7       = 0b00001110
.equ        segments8       = 0b11111110
.equ        segments9       = 0b11011110
.equ        segments0       = 0b01111110

ldi         mask, (1 << PD7) | (1 << PD6) | (1 << PD5) | (1 << PD4) | (1 << PD3) | (1 << PD2) | (1 << PD1) 
out         DDRD, mask              ; Set digital pins 1 through 7 as output

clr         mask
out         PORTD, mask             ; Switch off all pins 1 thorugh 7

clr         mask
start:
    ldi         mask, segments1             ; Load the segment bits
    out         PORTD, mask                 ; Toggle segment bits
    ldi         numDelayIterReg, delay
    rcall       delay10ms

    ldi         mask, segments2
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms

    ldi         mask, segments3
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments4
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments5
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments6
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments7
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments8
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments9
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    ldi         mask, segments0
    out         PORTD, mask
    ldi         numDelayIterReg, delay
    rcall       delay10ms 

    rjmp start


delay10ms:
    ; Initialize delay loop
    ldi         delayLoopRegL, LOW(delayLoopVal)
    ldi         delayLoopRegH, HIGH(delayLoopVal)
delayLoop:
    sbiw        delayLoopRegL, 1            ; Decrement 1 from loop counter
    brne        delayLoop                   ; Keep decrementing until counter == 0

    dec         numDelayIterReg             ; Decrement the number of times we delayed for 10ms
    brne        delay10ms                   ; Keep repeating 10ms delay until the number of iterations left == 0
    nop
    ret
