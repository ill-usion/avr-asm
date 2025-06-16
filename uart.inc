
; Macro: initSerial
;     Initializes UART with 8 data bits, no parity, and 1 stop bit
; Parameters:
;     @0 - Baud rate
.macro initSerial
    push        r16
    push        r17
    
    ldi         r16, LOW((F_CPU / 16 / @0) - 1)
    ldi         r17, HIGH((F_CPU / 16 / @0) - 1)

    rcall       initUART 

    pop         r17
    pop         r16
.endmacro
