.include "m328pdef.h"

.cseg
.org    0x00

ldi         r16, 0x01
ldi         r17, 0x02
cp          r16, r17        ; Compare by subtracting r17 from r16: 0x01 - 0x02. Carry flag will be set, indicating r17 > r16
brlo        label           ; Will branch since Carry flag is set. In other words, r16 is lower than r17


; In comparison, registers will not be modified, unlike for example sub
ldi         r17, 0x01
cp          r16, r17        ; 0x01 - 0x01 = 0. Zero flag will be set, indicating r16 = r17
brsh        label           ; Will branch since Carry flag is clear. In other words, r16 >= r17


; Comparing WORDs
ldi         r16, 0x01
ldi         r17, 0xAA       ; r17:r16 = 0xAA01
ldi         r18, 0x02
ldi         r19, 0xAA       ; r19:r18 = 0xAA02

cp          r16, r18        ; Compare lower bits of each WORD. In this case, Carry flag will be set
cpc         r17, r9         ; Compare upper bits with carry of each WORD. Carry flag will be set once again, since r19:r18 > r17:r16

ldi         r16, 0x10000000 ; 0x80
tst         r16             ; Sets both Sign and Negative flag since bit 7 is set. Additionally clears Twos' Compliment flag

; While loops
whileLoop:
    cpi     r16, 100        
    ; loop body
    brsh    next            ; Only exit the loop when r16 is higher than 100
    rjmp    whileLoop       ; Loop back. Equivalent to while(r16 < 100)

; For loops
clr         r16             ; Clear r16. r16 = 0
forLoop:
    cpi     r16, 11
    breq    next            ; Exit the loop if r16 = 11
    ; loop body
    inc     r16             ; Think of it as i++ in a traditional for loop
    rjmp    forLoop         ; Loop back. Equivalent to for(r16 = 0; r16 <= 10; r16++)

next:
    ; After exiting a loop
