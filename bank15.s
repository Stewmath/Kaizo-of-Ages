.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

; Contains a patch to load interactions from another bank

.BANK $15 SLOT 1

.ORGA $4315

b15_getInteractionDataAddr:
	ld a,(activeGroup)			; $0315: $fa $2d $cc
	ld hl,$432b					; $0318: $21 $2b $43
	rst $18						; $031b: $df
	ldi a,(hl)					; $031c: $2a
	ld h,(hl)					; $031d: $66
	ld l,a						; $031e: $6f
	ld a,(activeMap)			; $031f: $fa $30 $cc
	ld e,a						; $0322: $5f
	ld d,$00					; $0323: $16 $00
	add hl,de					; $0325: $19
	add hl,de					; $0326: $19
	ldi a,(hl)					; $0327: $2a
	jp getInteractionDataAddrHook


.ORGA $7bfc ; Freespace start

getInteractionDataAddrHook:
	ld d,(hl)					; $0328: $56
	ld e,a						; $0329: $5f

    bit 7,d
    ret z
    ; Bit 7 set: load from bank c6
    res 7,d
    ld h,d
    ld l,e
    ld c,8
    ld de,$c300
-
    ld b,$c6
    call copy20BytesFromBank
    dec c
    jr nz,-

    ld de,$c300
    ret
