.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

.BACKGROUND "../Ages Clean.gbc"

; ===================================
; RING COLOR MOD
; ===================================


.BANK $02 SLOT 1
.ORGA $56dd

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
	ld (activeRing),a				; $16f3: $ea $cb $c6
	ld a,$56					; $16f6: $3e $56
;	jp $0c98					; $16f8: $c3 $98 $0c
    jp ringEquipHook

.ORGA $7e95
ringEquipHook:
    push af
    push bc
    ldh a,(R_SVBK)
    push af

    xor a
    ldh (R_SVBK),a

    ld b,8
    ld a,(activeRing)
    cp $07 ; red ring
    jr nz,+
    ld b,$0a
    jr ++
+
    cp $08 ; blue ring
    jr nz,++
    ld b,$09
++
    ld a,b
    ld ($d01b),a
    ld ($d01c),a

    pop af
    ldh (R_SVBK),a
    pop bc
    pop af
	jp $0c98					; $16f8: $c3 $98 $0c



.BANK $05 SLOT 1
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

.ORGA $7d9d ; Freespace start

linkPaletteHook:
    push bc
    ld b,a
    ld a,(activeRing)
    cp $07 ; red ring
    jr nz,+
    inc b
    inc b
    jr ++
+
    cp $08 ; blue ring
    jr nz,++
    inc b
++
    ld a,b
    pop bc
	ld (de),a					; $0209: $12
	dec e						; $020a: $1d
	ld (de),a					; $020b: $12
    ret
