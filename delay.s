; Subroutine: delay10ms
; Inputs: 
;   r18: Sets the multiple for 10ms delay
; 
; Registers Modified: r18, r24, r25

.def        numDelayIterReg = r18   ; Number of iterations for 10ms delay
.def        delayLoopRegL   = r24   ; Delay loop counter low
.def        delayLoopRegH   = r25   ; Delay loop counter high

.equ        delayLoopVal    = 39998


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

