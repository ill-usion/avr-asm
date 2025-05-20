    .include "m328pdef.inc"
    
    .def mask       = r16       ; Mask register
    .def ledReg     = r17       ; LED register
    .def outLoopReg = r18       ; Outer loop register
    .def inLoopRegL = r24       ; Inner loop register low
    .def inLoopRegH = r25       ; Inner loop reigster high

    .equ outVal     = 250       ; Outer loop value
    .equ inVal      = 16000     ; Inner loop value

    .cseg
    .org    0x00

    clr     ledReg              ; Clear LED register
    ldi     mask, (1 << PINB5)  ; Load 0b00100000 into mask register
    out     DDRB, mask          ; Set PINB5 to output

start:
    eor     ledReg, mask        ; Toggle PINB5. On/Off
    out     PORTB, ledReg       ; Switch on or off depending on ledReg

    ldi     outLoopReg, outVal  ; Initialize outer loop count

outLoop:
    ldi     inLoopRegL, LOW(inVal)  ; Grab the lower bits of inVal
    ldi     inLoopRegH, HIGH(inVal) ; Grab the upper bits of inVal

inLoop:
    sbiw    inLoopRegL, 1       ; Decrement inner loop register
    brne    inLoop              ; Branch to inLoop if inLoopReg != 0

    dec     outLoopReg          ; Decrement outer loop register
    brne    outLoop             ; Branch to outLoop if outLoopReg != 0

    rjmp    start
