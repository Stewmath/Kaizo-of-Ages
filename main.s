.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

.BACKGROUND "../Ages_Hack.gbc"

.INCLUDE "scripts.s"
.INCLUDE "textcode.s"


.BANK $60 SLOT 1
.ORGA $4135

; VRAM TRANSFER FIX
; ===================================
; Zole's hack for using uncompressed tilesets is broken.
; It only works on VBA and other inaccurate emulators.
; This new code should work on anything, including real hardware.
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


.BANK $02 SLOT 1
.ORGA $56dd

; RING COLOR MOD
; ===================================
; Function executed when a ring is selected
	ld a,($cbd1)				; $16dd: $fa $d1 $cb
	sub $10						; $16e0: $d6 $10
	ret c						; $16e2: $d8
	ld hl,$c6cb					; $16e3: $21 $cb $c6
	ld c,(hl)					; $16e6: $4e
	ld l,$c6					; $16e7: $2e $c6
	rst $10						; $16e9: $d7
	ld a,(hl)					; $16ea: $7e
	cp c						; $16eb: $b9
	jr nz,+         			; $16ec: $20 $05
	cp $ff						; $16ee: $fe $ff
	ret z						; $16f0: $c8
	ld a,$ff					; $16f1: $3e $ff
+
	ld (activeRing),a			; $16f3: $ea $cb $c6
	ld a,$56					; $16f6: $3e $56
;	jp $0c98					; $16f8: $c3 $98 $0c
    jp ringEquipHook

.ORGA $7e95

; RING COLOR MOD
; ===================================
ringEquipHook:
    push af
    push bc
    ldh a,(R_SVBK)
    push af

    xor a
    ldh (R_SVBK),a

    ld b,8
    ld a,(activeRing)
    cp RING_RED
    jr nz,+
    ld b,$0a
    jr ++
+
    cp RING_BLUE
    jr nz,++
    ld b,$09
++
    ld a,b

    ; The 2 key bytes determining link's palette
    ld ($d01b),a
    ld ($d01c),a

    pop af
    ldh (R_SVBK),a
    pop bc
    pop af
	jp $0c98					; $16f8: $c3 $98 $0c



.BANK $05 SLOT 1

; RING COLOR MOD
; ===================================
.ORGA $41f7
; Function related to link's attributes / palettes
	ld e,$32					; $01f7: $1e $32
	ld a,$ff					; $01f9: $3e $ff
	ld (de),a					; $01fb: $12
	ld e,$01					; $01fc: $1e $01
	ld a,(de)					; $01fe: $1a
	ld hl,$420d					; $01ff: $21 $0d $42
	rst $18						; $0202: $df
	ld e,$1d					; $0203: $1e $1d
	ldi a,(hl)					; $0205: $2a
	ld (de),a					; $0206: $12
	dec e						; $0207: $1d
	ldi a,(hl)					; $0208: $2a
;	ld (de),a					; $0209: $12
;	dec e						; $020a: $1d
;	ld (de),a					; $020b: $12
    call linkPaletteHook
	ret							; $020c: $c9


; ROCS FEATHER MOD
; ===================================
.ORGA $5b4a
; Snippet of function related to jumping

;	bit 5,(hl)					; $1b4a: $cb $6e
;	ld c,$20					; $1b4c: $0e $20

    nop
    call featherRingHook

	jr z,label_05.185			; $1b4e: $28 $02

	ld c,$0a					; $1b50: $0e $0a
label_05.185:
	call $1f46					; $1b52: $cd $46 $1f
	ld l,$15					; $1b55: $2e $15
	jr z,label_05.186			; $1b57: $28 $0d
	ld a,(hl)					; $1b59: $7e
	bit 7,a						; $1b5a: $cb $7f
	ret nz						; $1b5c: $c0
	cp $03						; $1b5d: $fe $03
	ret c						; $1b5f: $d8
	ld (hl),$03					; $1b60: $36 $03
	dec l						; $1b62: $2d
	ld (hl),$00					; $1b63: $36 $00
	ret							; $1b65: $c9
label_05.186:
	xor a						; $1b66: $af
; ...


.ORGA $7d9d ; Freespace start

; RING COLOR MOD
; ===================================
linkPaletteHook:
    push bc
    ld b,a
    ld a,(activeRing)
    cp RING_RED
    jr nz,+
    inc b
    inc b
    jr ++
+
    cp RING_BLUE
    jr nz,++
    inc b
++
    ld a,b
    pop bc

	ld (de),a					; $0209: $12
	dec e						; $020a: $1d
	ld (de),a					; $020b: $12
    ret


; ROCS FEATHER MOD
; ===================================
featherRingHook:
    push af
    ld a,(activeRing)
    cp RING_FEATHER
    ld c,$20
    jr nz,+
	ld c,$16        ; Modify this value for different results
+

    pop af
	bit 5,(hl)					; $1b4a: $cb $6e
    ret
