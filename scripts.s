.INCLUDE "include/script_commands.s"


; I use bank FE for my custom scripts.
.BANK $FE
.ORGA $4000

Script0:
    asm15 test
    setdelay 12
    createpuff
    spawnenemyhere $0900
    jump3byte Script0
    forceend


; Assembly code can be run from bank 15.
.BANK $15
.ORGA $7bfb ; freespace start

test:
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
