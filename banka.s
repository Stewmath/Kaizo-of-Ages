; Dunno what this is for, really. One of lin's patches.

	ld e,$46					; $3e09: $1e $46
	ld a,(de)					; $3e0b: $1a
	cp $00						; $3e0c: $fe $00
	jr nz,label_0a.317			; $3e0e: $20 $35
	ld e,$42					; $3e10: $1e $42
	ld a,(de)					; $3e12: $1a
	ld hl,$4000					; $3e13: $21 $00 $40
	ld a,(de)					; $3e16: $1a
	ld b,$00					; $3e17: $06 $00
	ld c,a						; $3e19: $4f
	add hl,bc					; $3e1a: $09
	add hl,bc					; $3e1b: $09
	add hl,bc					; $3e1c: $09
	ld e,$44					; $3e1d: $1e $44
	ld a,(de)					; $3e1f: $1a
	cp $00						; $3e20: $fe $00
	jr nz,label_0a.316			; $3e22: $20 $14
	inc a						; $3e24: $3c
	ld e,$44					; $3e25: $1e $44
	ld (de),a					; $3e27: $12
	ld e,$7d					; $3e28: $1e $7d
	ld a,$ff					; $3e2a: $3e $ff
	ld (de),a					; $3e2c: $12
	push hl						; $3e2d: $e5
	call $2680					; $3e2e: $cd $80 $26
	ld hl,$c300					; $3e31: $21 $00 $c3
	call $2544					; $3e34: $cd $44 $25
	pop hl						; $3e37: $e1
label_0a.316:
	call checkLoadScriptToRam	; $3e38: $cd $b1 $3f
	ld e,$58					; $3e3b: $1e $58
	ld a,(de)					; $3e3d: $1a
	ld l,a						; $3e3e: $6f
	inc e						; $3e3f: $1c
	ld a,(de)					; $3e40: $1a
	ld h,a						; $3e41: $67
	jp $2579					; $3e42: $c3 $79 $25
label_0a.317:
	dec a						; $3e45: $3d
	ld (de),a					; $3e46: $12
	ret							; $3e47: $c9
