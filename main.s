    .include "m328pdef.inc"

    .cseg
    .org    0x00

varBytes:   .db     0x00, 0x01, 0x02, 0x03
varChars:   .db     'H', 'e', 'l', 'l', 'o', '!'
varString:  .db     "Hello!"
varWords:   .dw     0x0000, 0x0001, 0x0002, 0x0003
varPadded:  .db     1, 2, 3     ; The assembler will warn us and automatically pad it with a zero
