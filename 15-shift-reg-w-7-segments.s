; This program controls a shift register (SN74HC595N) wired to a 7-segments display
; Wiring:
;
; SN74HC595N | 7-segments
; =======================
; QA ---- 220ohm ---- A
; QB ---- 220ohm ---- B
; QC ---- 220ohm ---- C
; QD ---- 220ohm ---- D
; QE ---- 220ohm ---- E
; QF ---- 220ohm ---- F
; QG ---- 220ohm ---- G
;            | atmega328p
; SER ----------- D8
; SRCLK --------- D9
; RCLK ---------- D10
; SRCLR --------- Vcc
; OE ------------ Gnd
;

    .include "m328pdef.inc"
    .include "delay.inc"

    .cseg
    .org    0x00
                                ;   abcdefgh
    .equ        segments1       = 0b01100000
    .equ        segments2       = 0b11011010
    .equ        segments3       = 0b11110010
    .equ        segments4       = 0b01100110
    .equ        segments5       = 0b10110110
    .equ        segments6       = 0b10111110
    .equ        segments7       = 0b11100000
    .equ        segments8       = 0b11111110
    .equ        segments9       = 0b11110110
    .equ        segments0       = 0b11111100
    
    .equ        dataSetPin      = PB0           ; Digital pin 8  - Data Set
    .equ        srclkPin        = PB1           ; Digital pin 9  - Shift Register Clock
    .equ        rclkPin         = PB2           ; Digital pin 10 - Register Clock

    .def        mask            = r16
    .def        byteReg         = r17
    .def        bitCountReg     = r18

.macro pulsePin
    sbi         PORTB, @0       ; Set pin
    nop                         ; Do nothing
    cbi         PORTB, @0       ; Clear pin
.endmacro

init:
    ldi         mask, (1 << rclkPin) | (1 << srclkPin) | (1 << dataSetPin)
    out         DDRB, mask              ; Set pins to output

    clr         mask                    ; Clear for future use
    out         PORTB, mask             ; Turn off all pins in PORTB

loop:
    ldi         r20, segments1          ; Load segments into segments register
    rcall       displaySegments         ; Display the segments
    delayMs     230                     ; Wait 230ms

    ldi         r20, segments2
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments3
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments4
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments5
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments6
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments7
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments8
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments9
    rcall       displaySegments
    delayMs     230

    ldi         r20, segments0
    rcall       displaySegments
    delayMs     230

    rjmp loop


; Outputs a signal through the shift register according to segments
;
; Input Registers:
;   r20: Segments
displaySegments:
    mov         byteReg, r20            ; Initialize the segments
    ldi         bitCountReg, 8          ; Initialize counter

setBits:
    mov         mask, byteReg           ; Copy the remaining segment bytes to mask    
    andi        mask, 1                 ; Extract the current segment state

    out         PORTB, mask             ; Output the state to Data Set Pin in PORTB since it's conveniently at bit 0

    pulsePin    srclkPin                ; Shift the state into register
    lsr         byteReg                 ; Shift the segments to the right
    
    dec         bitCountReg             ; Decrement the number of bits to set
    brne        setBits                 ; Keep setting the bits until there is no more
    
    pulsePin    rclkPin                 ; Output register bits

    ret                                 ; Exit subroutine

    .include "delay.s"
