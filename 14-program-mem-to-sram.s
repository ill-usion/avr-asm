    .include "m328pdef.inc"
    
    .equ    ARR_LEN = 45
    
    .def    copyCount   = r16
    .def    copyReg     = r17

    .dseg
    .org    SRAM_START
    sArr:   .byte   ARR_LEN     ; Allocate bytes for SRAM array

    .cseg
    .org    0x00

    ldi     XL, LOW(sArr)
    ldi     XH, HIGH(sArr)      ; Load the address of sArr into X pointer

    ldi     ZL, LOW(2*pArr)
    ldi     ZH, HIGH(2*pArr)    ; Load the address of pARr into Z pointer
    
    ldi     copyCount, ARR_LEN  ; Initialize counter

copyLoop:
    lpm     copyReg, Z+         ; Load program mem into copyReg and increment Z pointer
    st      X+, copyReg         ; Store into pArr and increment X pointer
    dec     copyCount           ; Decrement the number of bytes to be copied
    brne    copyLoop            ; Keep repeating the loop until copyCount = 0

loop:
    rjmp    loop

    pArr:   .db "The quick brown fox jumped over the lazy dog."
