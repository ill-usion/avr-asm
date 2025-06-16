; Subroutine: delay10ms
; Inputs: 
;   r18: Sets the multiple for 10ms delay
; 
; Registers Modified: r18, r24 and r25

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


; delay1Us - Wait 1 microsecond r25:r24 times 
; Assumes 16 MHz clock
; Registers Modified: r23, r24 and r25

.equ        nIter           = 3
.def        nIterReg        = r23
.def        delayUsL        = r24 
.def        delayUsH        = r25

delay1Us:
    ldi     nIterReg, nIter
delayUsLoop:
    ; 3 cycles * 3 (nIter) + 1 (ldi nIterReg) = 10 cycles
    dec     nIterReg
    brne    delayUsLoop
    nop                 ; +1 cycles to account for brne not branching
    
    ; 6 cycles
    nop
    nop
    sbiw    delayUsL, 1
    brne    delay1Us
    
    ; Total: 16 cycles = 1us
    nop
    ret
