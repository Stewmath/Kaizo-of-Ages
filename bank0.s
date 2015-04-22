.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

; Some of lin's patches recreated here.

; The kaizo base ROM isn't using his exact script patch since I want to
; preserve the original content.

; - Some original patch addresses: (they may be different after being reassembled)
;  - Code at 3ef8 to 3f2c (related to getting tile data bank)
;  - 3f39-3f41 (reloadInteractionScript)
;  - Seemingly garbage at 3f42 to 3f43
;  - 3f44-3f63 - interaction loader hooks
;  - 3f78-3f95 - vram-related (not used anymore)
;  - 3f96-3fb0 - unknown
;  - 3fb1-3fae - checkLoadScriptToRam
;  - 3fe8-3fe9 - unused?
;  - 3fea-3fe7 - unesed?
; - Also some patches at 38a8 which aren't code, aren't included here yet

.BANK 0 SLOT 0

; Patch to make scripts runnable from any bank
.ORGA $251a
; Function for running scripts
	push af						; $251a: $f5

;	ld a,$0c					; $251b: $3e $0c
;	ld ($ff00+$97),a			; $251d: $e0 $97
;	ld ($2222),a				; $251f: $ea $22 $22
    call scriptRunnerHook
    call scriptRunnerHook2
    nop
label_00.284:
	ld a,(hl)					; $2522: $7e
	or a						; $2523: $b7
    ; ...

; One of lin's patches here, unknown purpose.
.ORGA $372b
	call $373b					; $372b: $cd $3b $37
	ld hl,$6e63					; $372e: $21 $63 $6e
	ld e,$04					; $3731: $1e $04
	jp $008a					; $3733: $c3 $8a $00
	ld e,$04					; $3736: $1e $04
	jp $008a					; $3738: $c3 $8a $00
; $373b
	ld a,$80					; $373b: $3e $80
	ld ($ff00+$97),a			; $373d: $e0 $97
	ld ($2222),a				; $373f: $ea $22 $22
	ld hl,$4000					; $3742: $21 $00 $40
	ld a,($cd23)				; $3745: $fa $23 $cd
	ld c,a						; $3748: $4f
	ld b,$00					; $3749: $06 $00
	add hl,bc					; $374b: $09
	add hl,bc					; $374c: $09
	add hl,bc					; $374d: $09
	ldi a,(hl)					; $374e: $2a
	push af						; $374f: $f5
	ldi a,(hl)					; $3750: $2a
	ld h,(hl)					; $3751: $66
	ld l,a						; $3752: $6f
	pop af						; $3753: $f1
	ld ($ff00+$97),a			; $3754: $e0 $97
	ld ($2222),a				; $3756: $ea $22 $22
	ld bc,$0800					; $3759: $01 $00 $08
	ld de,$d000					; $375c: $11 $00 $d0
	ld a,$03					; $375f: $3e $03
	ld ($ff00+$70),a			; $3761: $e0 $70
label_00.383:
	ldi a,(hl)					; $3763: $2a
	ld (de),a					; $3764: $12
	inc de						; $3765: $13
	dec bc						; $3766: $0b
	ld a,c						; $3767: $79
	or b						; $3768: $b0
	jr nz,label_00.383			; $3769: $20 $f8
	ret							; $376b: $c9

; Another patch I don't know about
.ORGA $3796
	ld a,($ff00+$97)			; $3796: $f0 $97
	push af						; $3798: $f5
	call unknownPatch1			; $3799: $cd $96 $3f
	ld a,($cd22)				; $379c: $fa $22 $cd
	call $050b					; $379f: $cd $0b $05
	jr label_00.384				; $37a2: $18 $04
	dec b						; $37a4: $05
	call $3828					; $37a5: $cd $28 $38
label_00.384:
	ld a,$04					; $37a8: $3e $04
	ld ($ff00+$97),a			; $37aa: $e0 $97
	ld ($2222),a				; $37ac: $ea $22 $22

; Another patch I don't know about
.ORGA $37db
	ld a,$04					; $37db: $3e $04
	ld ($ff00+$97),a			; $37dd: $e0 $97
	ld ($2222),a				; $37df: $ea $22 $22
	ld a,($ff00+$8d)			; $37e2: $f0 $8d
	push af						; $37e4: $f5
	call $7ee2					; $37e5: $cd $e2 $7e
	and $7f						; $37e8: $e6 $7f
	ld ($ff00+$8d),a			; $37ea: $e0 $8d
	call unknownPatch1			; $37ec: $cd $96 $3f
	ld a,$01					; $37ef: $3e $01
	ld ($ff00+$97),a			; $37f1: $e0 $97
	ld ($2222),a				; $37f3: $ea $22 $22
	pop af						; $37f6: $f1
	ld ($ff00+$8d),a			; $37f7: $e0 $8d
	cp $00						; $37f9: $fe $00
	ret							; $37fb: $c9

; Another patch I don't know about
.ORGA $394c
--
	ldi a,(hl)					; $394c: $2a
	ld (de),a					; $394d: $12
	inc e						; $394e: $1c
label_00.388:
	ld a,e						; $394f: $7b
	cp $ff						; $3950: $fe $ff
	ret z						; $3952: $c8
	jp --					    ; $3953: $c3 $4c $39

; One of Lin's patches related to reading tile data
.ORGA $3a27
label_00.399:
	push de						; $3a27: $d5
	ld a,$54					; $3a28: $3e $54
	call tileDataLoaderHook
	jr z,label_00.403			; $3a2d: $28 $07
	ld a,h						; $3a2f: $7c
	sub $40						; $3a30: $d6 $40
	ld h,a						; $3a32: $67
	inc e						; $3a33: $1c
	jr -$0b						; $3a34: $18 $f5
label_00.403:
	ld a,e						; $3a36: $7b
	ld ($ff00+$97),a			; $3a37: $e0 $97
	ld ($2222),a				; $3a39: $ea $22 $22
	ld b,$b0					; $3a3c: $06 $b0
	ld de,$ce00					; $3a3e: $11 $00 $ce
label_00.404:
	call $0788					; $3a41: $cd $88 $07
	ld (de),a					; $3a44: $12
	inc e						; $3a45: $1c
	dec b						; $3a46: $05
	jr nz,label_00.404			; $3a47: $20 $f8
	ld hl,$ce00					; $3a49: $21 $00 $ce
	pop de						; $3a4c: $d1
	ret							; $3a4d: $c9



; Patch to make interaction 1 read from bank $ff

.ORGA $3b62
; Function to load ASM for a given interaction
	ld e,$41					; $3b62: $1e $41
	ld a,(de)					; $3b64: $1a

;	ld b,$08					; $3b65: $06 $08
;	cp $3e						; $3b67: $fe $3e
    call interactionLoaderHook
    nop

	jr c,label_00.414			; $3b69: $38 $11
	inc b						; $3b6b: $04
	cp $67						; $3b6c: $fe $67
	jr c,label_00.414			; $3b6e: $38 $0c
	inc b						; $3b70: $04
	cp $98						; $3b71: $fe $98
	jr c,label_00.414			; $3b73: $38 $07
	inc b						; $3b75: $04
	cp $dc						; $3b76: $fe $dc
	jr c,label_00.414			; $3b78: $38 $02
	ld b,$10					; $3b7a: $06 $10
label_00.414:
	ld a,b						; $3b7c: $78
	ld ($ff00+$97),a			; $3b7d: $e0 $97
	ld ($2222),a				; $3b7f: $ea $22 $22
	ld a,(de)					; $3b82: $1a
	ld hl,$3b8b					; $3b83: $21 $8b $3b
	rst $18						; $3b86: $df
	ldi a,(hl)					; $3b87: $2a
	ld h,(hl)					; $3b88: $66
	ld l,a						; $3b89: $6f
	jp hl						; $3b8a: $e9

.ORGA $3b8d
; Interaction pointer table, starting at index 1
    .dw interaction1Code
    

.ORGA $3ef8 ; Freespace start

tileDataLoaderHook:
	push de						; $3ef8: $d5
	push hl						; $3ef9: $e5
	push bc						; $3efa: $c5
	ld ($ff00+$97),a			; $3efb: $e0 $97
	ld ($2222),a				; $3efd: $ea $22 $22
	ld hl,$4000					; $3f00: $21 $00 $40
	call $4630					; $3f03: $cd $30 $46
	cp $06						; $3f06: $fe $06
	jr nz,label_00.425			; $3f08: $20 $02
	ld a,$04					; $3f0a: $3e $04
label_00.425:
	cp $07						; $3f0c: $fe $07
	jr nz,label_00.426			; $3f0e: $20 $02
	ld a,$05					; $3f10: $3e $05
label_00.426:
	rst $18						; $3f12: $df
	ldi a,(hl)					; $3f13: $2a
	ld h,(hl)					; $3f14: $66
	ld l,a						; $3f15: $6f
	ld a,($cc2f)				; $3f16: $fa $2f $cc
	ld b,$00					; $3f19: $06 $00
	ld c,a						; $3f1b: $4f
	add hl,bc					; $3f1c: $09
	ld a,(hl)					; $3f1d: $7e
	pop bc						; $3f1e: $c1
	pop hl						; $3f1f: $e1
	pop de						; $3f20: $d1
	ld e,a						; $3f21: $5f
	xor a						; $3f22: $af
	ld a,h						; $3f23: $7c
	and $80						; $3f24: $e6 $80
	ret z						; $3f26: $c8
	ld a,h						; $3f27: $7c
	sub $40						; $3f28: $d6 $40
	ld h,a						; $3f2a: $67
	xor a						; $3f2b: $af
	ret							; $3f2c: $c9

; Code for extra scripting opcodes
; Not enough space in bank C to put it there
scriptOpcodeFD:
	pop hl						; $3f2d: $e1
	inc hl						; $3f2e: $23
	ldi a,(hl)					; $3f2f: $2a
	push hl						; $3f30: $e5
	ld hl,scriptOpcodeFDTable	; $3f31: $21 $f3 $7f
	rst $18						; $3f34: $df
	ldi a,(hl)					; $3f35: $2a
	ld h,(hl)					; $3f36: $66
	ld l,a						; $3f37: $6f
	jp hl						; $3f38: $e9


scriptRunnerHook:
    ; I only apply this "check bank" hack to my custom interactions.
    ld e,INTERAC_HACKED
    ld a,(de)
    cp $de
    jr nz,+

    ld e,$7d
    ld a,(de)
    and a
    jr z,+
    call checkLoadScriptToRam
+
    ld a,$0c
    ldh (z_activeBank),a
    ld ($2222),a
    ret
scriptRunnerHook2:
    ld e, INTERAC_SCRIPTPTR
    ld a,(de)
    ld l,a
    inc e
    ld a,(de)
    ld h,a
    ret


interactionLoaderHook:
    ld b,$08

    cp $1
    jr z,++

    cp $3e
    ret
++
    ; Custom interactions read from bank $ff
    ld b,$ff
    scf
    ret

unknownPatch1:
	ld a,($ff00+$97)			; $3f96: $f0 $97
	push af						; $3f98: $f5
	ld a,$04					; $3f99: $3e $04
	ld ($ff00+$97),a			; $3f9b: $e0 $97
	ld ($2222),a				; $3f9d: $ea $22 $22
	call $7ee2					; $3fa0: $cd $e2 $7e
	and $7f						; $3fa3: $e6 $7f
	ld ($ff00+$8d),a			; $3fa5: $e0 $8d
	ld a,$60					; $3fa7: $3e $60
	ld ($ff00+$97),a			; $3fa9: $e0 $97
	ld ($2222),a				; $3fab: $ea $22 $22
	jp vramPatch				; $3fae: $c3 $35 $41


checkLoadScriptToRam:
    ldh a,(z_activeBank)
    push af
    ld e,$7d
    ld a,(de)
    or a
    jr z,++
    cp $ff    ; Not sure what this check & jump is for
    jr z,+
    ld h,d
    ld l,e
+
    ld a,(de)
    ldh (z_activeBank),a
    ld ($2222),a
    ldi a,(hl)
    ld b,a
    ldi a,(hl)
    ld h,(hl)
    ld l,a
    ld a,b
    ldh (z_activeBank),a
    ld ($2222),a
    push de
    ld de,$c300
-
    ldi a,(hl)
    ld (de),a
    inc e
    jr nz,-
    pop de
++
    pop af
    ldh (z_activeBank),a
    ld ($2222),a
    ret

; Code for reloading a script after a "jump" opcode

reloadInteractionScript:
	ld hl,$c300					; $3f39: $21 $00 $c3
	push hl						; $3f3c: $e5
	call $2544					; $3f3d: $cd $44 $25
	pop hl						; $3f40: $e1
	ret							; $3f41: $c9
