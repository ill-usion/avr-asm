    .include "m328pdef.inc"
    .include "delay.inc"
    
    ; Wiring:
    ; Rs    ->      PB0
    ; RW    ->      GND
    ; E     ->      PB1
    ; D0..D3->      Unused
    ; D4    ->      PD0
    ; D5    ->      PD1
    ; D6    ->      PD2
    ; D7    ->      PD3

    .cseg
    .org    0x00

    .equ    RS = PB0
    .equ    EN = PB1
    .equ    D4 = PD0
    .equ    D5 = PD1
    .equ    D6 = PD2
    .equ    D7 = PD3

init:
    ldi     r16, (1 << RS) | (1 << EN)
    out     DDRB, r16       ; Set pins as output

    ldi     r16, (1 << D4) | (1 << D5) | (1 << D6) | (1 << D7)
    out     DDRD, r16       ; Same goes for the pins above
    
    ldi     r16, 0x33
    rcall   lcdCommand      ; Init LCD

    ldi     r16, 0x32
    rcall   lcdCommand      ; Set to 4-bit mode
    
    ldi     r16, 0x28
    rcall   lcdCommand      ; 2 lines, 5x8 matrix in 4-bit mode
    
    ldi     r16, 0x0C
    rcall   lcdCommand      ; Display on, cursor off
    
    ldi     r16, 0x06
    rcall   lcdCommand      ; Entry mode
    
    ldi     r16, 0x01
    rcall   lcdCommand      ; Clear display
    delayMs 10              ; Necessary delay after clearing/home
    
    ldi     r16, 0xC0
    rcall   lcdCommand      ; Set cursor to 2nd line
        
    ldi     ZL, LOW(2*message)
    ldi     ZH, HIGH(2*message)

print_loop:
    lpm     r16, Z+         ; Load next char of message
    cpi     r16, 0x00       ; Check for null terminator
    breq    loop            ; Jump to loop if we reached end of message
    
    rcall   lcdPrintChar    ; Print character to LCD
    
    delayMs 1000            ; Wait 1s

    rjmp print_loop         ; Print next char

loop:
    rjmp    loop

; Sends an LCD command
; Input Registers:
;   r16 Command byte
lcdCommand:
    cbi     PORTB, RS
    rcall   lcdSendByte
    ret

; Prints a character to the LCD
; Input registers:
;   r16 Character to be sent
lcdPrintChar:
    sbi     PORTB, RS 
    rcall   lcdSendByte
    ret

; Sends a byte via nibbles of 4 bits
; Input registers:
;   r16 Byte to be sent
lcdSendByte:
    mov r19, r16

    ; Send high nibble
    mov r18, r19
    andi r18, 0xF0
    lsr r18
    lsr r18
    lsr r18
    lsr r18
    rcall lcdSendNibble
    rcall lcdPulseEnable

    ; Send low nibble
    mov r18, r19
    andi r18, 0x0F
    rcall lcdSendNibble
    rcall lcdPulseEnable

    ret


; Sends the first 4 bits of a byte to the LCD
; Input Registers:
;   r18 Bits to be sent
lcdSendNibble:
    push    r16
    push    r17    
    
    mov     r16, r18
        
    in      r17, PORTD
    andi    r17, 0xF0
    andi    r16, 0x0F
    or      r16, r17
    out     PORTD, r16

    pop     r17
    pop     r16

    ret


; Pulse enable pin on the LCD
lcdPulseEnable:
    sbi     PORTB, EN
    delayUs 1

    cbi     PORTB, EN
    delayUs 100

    ret


    message: .db    "Hello, World!", 0x00
    .include "delay.s"
