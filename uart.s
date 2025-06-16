
; Initializes UART (aka. Serial) by enabling transmittion with 8 data bits, no parity, and 1 stop
; Input registers:
;   r17:r16 Baud rate prescale
initUART:
    sts         UBRR0L, r16
    sts         UBRR0H, r17
    
    ldi         r16, (1 << RXEN0) | (1 << TXEN0)
    sts         UCSR0B, r16             ; Enable rx and tx
    
    ret


; Waits for an empty transmit buffer
wait_for_serial:
    push        r17
wait_loop:
    lds         r17, UCSR0A
    sbrs        r17, UDRE0              ; Wait for empty transmit buffer
    rjmp        wait_loop
    
    pop         r17
    ret


; Sends a byte through UART
; Input registers:
;   r16 Byte to be sent
putc:
    rcall       wait_for_serial 
    sts         UDR0, r16               ; Transmit byte
    ret


; Sends a string through UART
; Input registers:
;   Z Pointer to a null terminated string
puts:
    push        r16
puts_start:
    lpm         r16, Z+                 ; Load a byte of payload buffer to r16
    cpi         r16, 0x00               ; Check if null
    breq        puts_end                ; Exit the subroutine
    
    rcall       putc                    ; Output character to Serial
    rjmp        puts_start              ; Repeat until we have outputted all characters
puts_end:
    pop         r16
    ret


; Sends a string stored in SRAM through UART
; Input registers:
;    X Pointer to a null terminated string
puts_sram:
    push        r16
puts_sram_start:
    ld          r16, X+                 ; Load byte
    cpi         r16, 0x00               ; Check for null termination
    breq        puts_sram_end           ; Exit the subroutine

    rcall       puts                    ; Output character to Serial
    rjmp        puts_sram_start         ; Repeat until we have outputted all characters
puts_sram_end:
    pop         r16
    ret


; Reads a byte from UART
; Output registers:
;   r16 Byte read
getc:
    rcall       wait_for_serial
    lds         r16, UDR0               ; Read byte
    ret


; Reads a CR-terminated string from UART
; Output registers:
;   X Read string
gets:
    push        r16
gets_start:
    rcall       getc                    ; Read character
    cpi         r16, 0x0D               ; Check if recieved character is carriage return '\r'
    breq        gets_end

    st          X+, r16                 ; Store character into X pointer
    rjmp        gets_start              ; Read next character

gets_end:
    ldi         r16, 0x00
    st          X+, r16                 ; Null terminate the string

    pop         r16
    ret
