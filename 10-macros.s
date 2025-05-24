.include "m328pdef.inc"

.cseg
.org    0x00

.macro  setStack
    .if @0 > RAMEND
        .error "Value greater than RAMEND was used for setting the stack"
    .else
        ldi     @1, LOW(@0)
        out     SPL, @1
        ldi     @1, HIGH(@0)
        out     SPH, @1
    .endif
.endmacro

start:
    setStack    r16, RAMEND

loop:
    rjmp loop
