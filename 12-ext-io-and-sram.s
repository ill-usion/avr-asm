    .include "m328pdef.inc"

    .dseg
    .org    SRAM_START

    var1:   .byte   2       ; Allocate 2 bytes to var1
    var2:   .byte   1       ; Allocate 1 bytes to var2
    var3:   .byte   4       ; Allocate 4 bytes to var3
    var4:   .byte   8       ; Allocate 8 bytes to var4

    .cseg
    .org    0x00
        
    ; Direct storing
    ldi     r16, 0xAA
    ldi     r17, 0x55

    sts     var1, r16
    sts     var1+1, r17     ; Store 0x55AA into var1
    
    ; Direct loading
    lds     r0, var1
    lds     r1, var1+1      ; Load var1 into r1:r0

    
    ; Indirect storing
    ldi     r16, 0xFF

    ldi     XL, LOW(var2)
    ldi     XH, HIGH(var2)  ; Initialize X pointer to var2 address

    st      X, r16          ; Store the contents of r16 into var2
    
    ; Indirect loading
    ld      r0, X           ; Load into r0 the contents of var2


    ; Post-incrementing and Pre-decrementing
    ldi     r16, 0x01
    ldi     r17, 0x23
    ldi     r18, 0x45
    ldi     r19, 0x67

    ldi     YL, LOW(var3)
    ldi     YH, HIGH(var3)  ; Initialize Y pointer to var3 address
    
    ; Post-increment
    st      Y+, r16         ; Store r16 to var3+0 and incr pointer
    st      Y+, r17         ; Store r17 to var3+1 and incr pointer
    st      Y+, r18         ; Store r18 to var3+2 and incr pointer
    st      Y+, r19         ; Store r19 to var3+3 and incr pointer
    
    ; Pre-decrement
    ld      r3, -Y          ; Decr pointer and load var3+3 to r3
    ld      r2, -Y          ; Decr pointer and load var3+2 to r2
    ld      r1, -Y          ; Decr pointer and load var3+1 to r1
    ld      r0, -Y          ; Decr pointer and load var3+0 to r0


    ; Displacement
    ldi     r16, 0xAB
    ldi     r17, 0xCD
    ldi     r18, 0xEF

    ; Only pointers Y and Z support displacement
    ldi     ZL, LOW(var4)
    ldi     ZH, HIGH(var4)  ; Initialize Z pointer to var4 address

    ; Load with displacement (assuming var4 is zeroed)
    std     Z+1, r16        ; var4 = 0x00 0xAB 0x00 0x00 0x00 0x00 0x00 0x00
    std     Z+3, r17        ; var4 = 0x00 0xAB 0x00 0xCD 0x00 0x00 0x00 0x00
    std     Z+6, r18        ; var4 = 0x00 0xAB 0x00 0xCD 0x00 0x00 0xEF 0x00

    ; Store with displacement
    ldd     r0, Z+1         ; r0 = 0xAB
    ldd     r1, Z+3         ; r1 = 0xCD
    ldd     r2, Z+6         ; r2 = 0xEF

loop:
    rjmp loop

