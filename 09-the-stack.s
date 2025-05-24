.include "m328pdef.inc"

.cseg
.org    0x00

; Initialize the Stack Pointer
ldi     r16, LOW(RAMEND)
out     SPL, r16
ldi     r16, HIGH(RAMEND)
out     SPH, r16

; Pushing into the stack
ldi     r16, 0x01
ldi     r17, 0x02

push    r16
push    r17

; Popping
pop     r19         ; r19 = 0x02
pop     r18         ; r18 = 0x01

