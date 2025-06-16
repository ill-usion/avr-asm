; Macro: delayMs
;     Waits for the specified number of milliseconds
; Parameters:
;     @0 - Number of milliseconds

.macro delayMs
    ; Save the values of registers r18, r24, r25
    push    r18
    push    r24
    push    r25
    
    ; Load immediate + delay10ms will modify the registers above
    ldi     r18, @0/10
    rcall   delay10ms
    
    ; Restore the values
    pop     r25
    pop     r24
    pop     r18
.endmacro

; Macro: delayUs
;     Waits for the specified number of microseconds
; Parameters:
;     @0 - Number of microseconds
.macro delayUs
    push    r23
    push    r24
    push    r25

    ldi     r24, LOW(@0)
    ldi     r25, HIGH(@0)

    rcall   delay1Us

    pop     r25
    pop     r24
    pop     r23
.endmacro
