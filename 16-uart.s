    .include "m328pdef.inc"
    .include "delay.inc"
    .include "uart.inc"

    .cseg
    .org 0x00

    .equ baud       = 9600      ; Baud rate

init:
    ; See uart.s for more details
    initSerial  baud            ; Initialize serial
    
    ldi         ZL, LOW(2*msgStr)
    ldi         ZH, HIGH(2*msgStr)
    rcall       puts            ; Send string message

    ldi         ZL, LOW(2*msgStr2)
    ldi         ZH, HIGH(2*msgStr2)
    rcall       puts            ; Send string message 2

    ldi         r16, 'A'

loop:
    rcall       putc            ; Send byte through serial
    inc         r16             ; Proceed to next char
    
    cpi         r16, 'Z' + 1    ; Compare current character with 'Z'
    brlo        noReset         ; Proceed without resetting
    
    ldi         r16, 'A'        ; Reset character
    
    noReset:
    delayMs     230             ; Wait 230ms
    rjmp        loop
    
    msgStr: .db    'H', 'e', 'l', 'l', 'o', 0x0D, 0x0A, 0x00               ; Make sure to null terminate the string
    msgStr2: .db   "The quick brown fox jumped over the lazy dog.", 0x0D, 0x0A, 0x00
