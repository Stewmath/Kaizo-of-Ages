.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

.BANK $60 SLOT 1
.ORGA $4135

; VRAM TRANSFER FIX
; ===================================
; Zole's hack for using uncompressed tilesets is broken.
; It only works on VBA and other inaccurate emulators.
; This new code should work on anything, including real hardware.

; Now that I've updated ZOLE with this patch, I should be wary of editing it.
vramPatch:
    ld a,($ff00+$8d)    ; Tileset?
    ld c,a
    ld b,0
    ld hl,$4000
    add hl,bc
    add hl,bc
    add hl,bc
    ldi a,(hl)
    ld c,a
    ldi a,(hl)
    ld h,(hl)
    ld l,a
    ld de,$8801

    ldh a,[R_LCDC]
    and $80
    jr nz,++

; Screen is off, easy
    ld b,$7f
    push bc
    push hl
    call $058a

    pop hl
    ld bc,$0800
    add hl,bc
    pop bc
    ld de,$9001
    call $058a

    jp _end
++
; Screen is on, need some shenanigans to get graphics transferred properly
    ld b,$54
    push bc
    push hl
    ; This function call will safely handle VRAM transfers using DMA hardware.
    call $058a

-
    call waitForVBlank_bank60

    ; Do next tiles
    pop hl
    ld bc,$550
    add hl,bc
    pop bc
    ld de,$8801+$550
    push bc
    push hl
    call $058a

    call waitForVBlank_bank60

    ; Last set of tiles
    pop hl
    ld bc,$550
    add hl,bc
    pop bc
    ld b,$55
    ld de,$8801+$550*2
    call $058a

_end
    ; Will restore previous rom bank and return.
    jp $0098

waitForVBlank_bank60:
-
    ld hl,$c49d
    ld (hl),$ff
    halt
    nop
    bit 7,(hl)
    jr nz,-
    ret


