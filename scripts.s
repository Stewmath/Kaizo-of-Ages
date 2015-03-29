.INCLUDE "include/script_commands.s"

; I use bank FE for my custom scripts.
.BANK $FE SLOT 1
.ORGA $4000

Script0:
    fixnpchitbox
    movenpcdown $0
point:
    setinteractionbyte INTERAC_ANIMMODE 0
    checkabutton
    setinteractionbyte $50 $14
    setinteractionbyte INTERAC_ANIMMODE 1
    asm15 test
    jump3byte point
    forceend

interac0_00:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    ld a,1
    ld (de),a
    SetInteractionScript Script0
    ld hl,$3b01
    call setInteractionFakeID
    call initNPC
+
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret
;    jp runInteractionScript

interac0_01:
    ld hl,$3b01
    call setInteractionFakeID
    call animateNPCAndImitate
    ret

; Sets a "Fake" ID in bytes 78-79 to use for graphics and such,
; Because normally, graphics & animations are determined by the ID of the interaction.
; I like doing things this way for more flexibility.
setInteractionFakeID:
    ld e,$78
    ld a,h
    ld (de),a
    inc e
    ld a,l
    ld (de),a
    ret


; Animates an NPC, while using the interaction's "Fake" ID to provide a certain animation.
animateNPCAndImitate:
    ; Get the fake ID in hl
    ld e,$78
    ld a,(de)
    ld h,a
    inc e
    ld a,(de)
    ld l,a

    ; Get the old ID, push it, and write the fake ID.
    ld e,$41
    ld a,(de)
    ld b,a
    ld a,h
    ld (de),a
    inc e
    ld a,(de)
    ld c,a
    ld a,l
    ld (de),a
    push bc

    ; Choose which animation function to use
    ld e,INTERAC_ANIMMODE
    ld a,(de)
    or a
    jr nz,+
    call animateNPC_followLink
    jr ++
+
    call animateNPC_staticDirection
++
    ; More logic which allows for NPC movement ?
    ; Replaces runInteractionScript?
    call $2552

    ; Restore the old ID
    pop bc
    ld e,$41
    ld a,b
    ld (de),a
    inc e
    ld a,c
    ld (de),a
    ret
    

setInteractionScript:
    ; Script will run in RAM at c300
    ld e,INTERAC_SCRIPTPTR
    xor a
    ld (de),a
    inc de
    ld a,$c3
    ld (de),a

    ; Script will be loaded from memory corresponding to these variables
    ld e,$7d
    ld a,c
    ld (de),a
    inc e
    ld a,l
    ld (de),a
    inc e
    ld a,h
    ld (de),a

    ret


interac0_02:
interac0_03:
interac0_04:
interac0_05:
interac0_06:
interac0_07:
interac0_08:
interac0_09:
interac0_0a:
interac0_0b:
interac0_0c:
interac0_0d:
interac0_0e:
interac0_0f:
interac0_10:
interac0_11:
interac0_12:
interac0_13:
interac0_14:
interac0_15:
interac0_16:
interac0_17:
interac0_18:
interac0_19:
interac0_1a:
interac0_1b:
interac0_1c:
interac0_1d:
interac0_1e:
interac0_1f:
interac0_20:
    ret

; Assembly code can be run from bank 15 via scripts.
.BANK $15
.ORGA $7bfb ; freespace start
    test:
        ld bc,$fe40
        call setInteractionSpeedZ
        ld a,$53
        call playSound
        ret



.BANK $3f SLOT 1
    
; Patch to allow any interaction to use any npc sprite.
; Put the "fake ID" into Dx48-Dx49 to use that ID's sprite.

.ORGA $4437
; Function called whenever an npc's graphics are to be loaded
	ld h,d						; $042d: $62
	ld l,$41					; $042e: $2e $41
	ldi a,(hl)					; $0430: $2a
	ld e,(hl)					; $0431: $5e
	ld c,a						; $0432: $4f
	ld b,$00					; $0433: $06 $00
;	ld hl,$6427					; $0435: $21 $27 $64
    call npcGraphicsLoaderHook
	add hl,bc					; $0438: $09
	add hl,bc					; $0439: $09
	add hl,bc					; $043a: $09
	ldd a,(hl)					; $043b: $3a
	rlca						; $043c: $07
	ret nc						; $043d: $d0
	ldi a,(hl)					; $043e: $2a
	inc hl						; $043f: $23
	ld h,(hl)					; $0440: $66
	ld l,a						; $0441: $6f
	ld c,$03					; $0442: $0e $03
	ld a,e						; $0444: $7b
	or a						; $0445: $b7
	ret z						; $0446: $c8
label_3f.041:
	inc hl						; $0447: $23
	bit 7,(hl)					; $0448: $cb $7e
	dec hl						; $044a: $2b
	ret nz						; $044b: $c0
	add hl,bc					; $044c: $09
	dec a						; $044d: $3d
	jr nz,label_3f.041			; $044e: $20 $f7
	ret							; $0450: $c9

.ORGA $7d3c
; Freespace start
npcGraphicsLoaderHook:
    push de

    ; Only do this for interaction 0. I dunno if some interactions use these bytes.
    ld e,$41
    ld a,(de)
    or a
    jr nz,++

    ; If the 2 bytes are non-zero, use the provided ID.
    ld e,$78
    ld a,(de)
    inc e
    ld h,a
    ld a,(de)
    ld l,a
    or h
    jr z,++

    pop de
    ld c,h
    ld e,l
    ld hl,$6427
    ret
++
    pop de
    ld hl,$6427
    ret


; Patch to make interaction 0 read from bank $ff

.BANK 0 SLOT 0
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

.ORGA $3f64 ; Some freespace here
; Be careful this doesn't go past $3f95 (it'll clash with some of lin's code)
interactionLoaderHook:
    ld b,$08

    or a
    jr z,++
    cp $3e
    ret
++
    ; Interaction 0 reads from bank $ff
    ld b,$ff
    scf
    ret

.ORGA $3b8b
; Interaction pointer table
    .dw interaction0Code
    


; Bank FF contains the jump table for Interaction 00 and 72 scripts.
.BANK $FF SLOT 1
.ORGA $4000

; Interaction 72 pointers

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


.macro 3ByteScriptPointer
    .db :\1
    .dw \1 | $8000
.endm


; Interaction 0 table
; Can either point to a script or asm code.
; Use 3ByteScriptPointer macro to point to a script.
interaction0Table:
    3BytePointer interac0_00
    3BytePointer interac0_01
    3BytePointer interac0_02
    3BytePointer interac0_03
    3BytePointer interac0_04
    3BytePointer interac0_05
    3BytePointer interac0_06
    3BytePointer interac0_07
    3BytePointer interac0_08
    3BytePointer interac0_09
    3BytePointer interac0_0a
    3BytePointer interac0_0b
    3BytePointer interac0_0c
    3BytePointer interac0_0d
    3BytePointer interac0_0e
    3BytePointer interac0_0f
    3BytePointer interac0_10
    3BytePointer interac0_11
    3BytePointer interac0_12
    3BytePointer interac0_13
    3BytePointer interac0_14
    3BytePointer interac0_15
    3BytePointer interac0_16
    3BytePointer interac0_17
    3BytePointer interac0_18
    3BytePointer interac0_19
    3BytePointer interac0_1a
    3BytePointer interac0_1b
    3BytePointer interac0_1c
    3BytePointer interac0_1d
    3BytePointer interac0_1e
    3BytePointer interac0_1f
    3BytePointer interac0_20



; Interaction 0 code

interaction0Code:
    ld e,$42 ; 2nd byte of ID
    ld a,(de)
    ld c,a
    ld b,0
    ld hl,interaction0Table
    add hl,bc
    add hl,bc
    add hl,bc

    ldi a,(hl)
    ld c,a
    ldi a,(hl)
    ld h,(hl)
    ld l,a

    bit 7,h
    jr nz,++

    ld e,c
    jp interBankCall

++  ; Bit 7 is set; script pointer
    res 7,h
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization stuff here
    ld a,1
    ld (de),a
    ld e,$7d
    ld a,c
    ld (de),a   ; Bank number
    ld e,INTERAC_SCRIPTPTR
    ld a,0
    ld (de),a
    inc de
    ld a,$c3
    ld (de),a
    
    ld e,$7e
    ld a,l
    ld (de),a
    inc de
    ld a,h
    ld (de),a
+
    call runInteractionScript
    ret
