.INCLUDE "include/script_commands.s"


; I use bank FE for my custom scripts.
.BANK $FE SLOT 1
.ORGA $4000

Script0:
    fixnpchitbox
    asm15 setup
point:
    asm15 test
    jump3byte point
    forceend


; Assembly code can be run from bank 15 via scripts.
.BANK $15
.ORGA $7bfb ; freespace start

test:
    ld e,$41
    ld a,$3b
    ld (de),a
    ld e,$42
    ld a,$05
    ld (de),a

    call $26a9     ; This is the part that makes his collisions and animations go

    ld e,$41
    ld a,$72
    ld (de),a
    ld e,$42
    ld a,$00
    ld (de),a
    ret
    
setup:
    ld e,$41
    ld a,$3b
    ld (de),a
    ld e,$42
    ld a,$05
    ld (de),a

    call $15fb

    ld e,$44
    ld a,1
    ld (de),a

    ld e,$41
    ld a,$72
    ld (de),a
    ld e,$42
    ld a,$00
    ld (de),a
    ret


; Bank FF contains the jump table for Interaction 72 scripts.
.BANK $FF SLOT 1
.ORGA $4000

; 00
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
; 04
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
; 08
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
; 0c
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
; 10
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
; 14
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
    3BytePointer Script0
