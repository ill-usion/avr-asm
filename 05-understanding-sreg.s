    .include "m328pdef.inc"

    .cseg
    .org    0x00

    ; Understanding the Status Register
    7 | 6 | 5 | 4 | 3 | 2 | 1 | 0
    I   T   H   S   V   N   Z   C

    ; Bit 0: Carry flag
    ldi     r16, 0xFF
    ldi     r17, 0xFF
    add     r16, r17        ; Carry flag will be set
    
    ldi     r16, 0b10000000
    lsl     r16             ; Left shift. Carry flag will be set

    ; Bit 1: Zero flag
    ldi     r16, 2
    dec     r16             ; r16 = 1
    dec     r16             ; r16 = 0; Zero flag will be set

    ; Bit 2: Negative flag
    sbi     r16, 1          ; Previously, r16 = 0. After subtraction = -1 or 255. Negative flag will be set

    ; Bit 3: Two's compliment overflow flag
    ldi     r16, -128
    dec     r16             ; Two's compliment overflow flag will be set

    ldi     r17, 127
    inc     r17             ; Two's compliment overflow flag will be set

    ; Bit 4: Sign bit
    ldi     r16, 0x88       ; -120
    ldi     r17, 0x0A       ; 10
    sub     r16, r17        ; Instinctively, we assume it's -130. In reality, result = 0x7E. Sign flag will be set

    ; Bit 5: Half carry flag
    ldi     r16, 0x0F
    inc     r16             ; Result = 0x10. Half carry flag is set when the lower bits overflow
    
    ; Bit 6: Bit copy storage
    set                     ; Set T flag
    clt                     ; Clear T flag
    
    ; Bit 7: Global interrupt enable
    sei                     ; Enable interrupts. Global interrupt flag will be set
    cli                     ; Disable interrupts. Global interrupt flag will be cleared

