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
    rcall delay10ms
    
    ; Restore the values
    pop     r25
    pop     r24
    pop     r18
.endmacro
