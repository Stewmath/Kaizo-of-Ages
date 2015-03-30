.INCLUDE "include/script_commands.s"

; I use bank FE for my custom scripts.
.BANK $FE SLOT 1
.ORGA $4000

; First impa meeting
Script0:
    fixnpchitbox
    jumproomflag $02 Script0_notFirstMeeting

Script0_firstMeeting:
    disableinput
    setinteractionword INTERAC_ANIM_MODE 1
    movenpcup $0
    setdelay 9
    showtext $7c00  ; Who's there

    setdelay 5
    movenpcdown $0
    setdelay 6

    setinteractionword INTERAC_SPEED_Z DEFAULT_JUMP_SPEED
    playsound $53
    setdelay 7
    showtext $7c01  ; Oh!

    setdelay 6
    setinteractionbyte $50 $28
    movenpcleft $29

    setdelay 3
    movenpcdown $40

    setdelay 7
    showtext $7c02

    setdelay 6
    giveitem $1500  ; Get shovel

    setroomflag $02

    enableinput

    setinteractionbyte INTERAC_ANIM_MODE 0
    jump3byte +

Script0_notFirstMeeting
    setcoords $28 $68
+
-
    checkabutton
    showtext $7c03
    jump3byte -
    

interac1_00:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    ld a,1
    ld (de),a
    SetInteractionScript Script0
    ld hl,$3100
    call setInteractionFakeID
    call initNPC
+
    ; Main loop stuff
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret

interac1_01:
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
    ld e,INTERAC_ANIM_MODE
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


interac1_02:
interac1_03:
interac1_04:
interac1_05:
interac1_06:
interac1_07:
interac1_08:
interac1_09:
interac1_0a:
interac1_0b:
interac1_0c:
interac1_0d:
interac1_0e:
interac1_0f:
interac1_10:
interac1_11:
interac1_12:
interac1_13:
interac1_14:
interac1_15:
interac1_16:
interac1_17:
interac1_18:
interac1_19:
interac1_1a:
interac1_1b:
interac1_1c:
interac1_1d:
interac1_1e:
interac1_1f:
interac1_20:
    ret

; Assembly code can be run from bank 15 via scripts.
.BANK $15
.ORGA $7bfb ; freespace start
    test:
        ld bc,$fe40
        call setInteractionSpeedZ
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

    ; Only do this for my custom interactions. I dunno if some interactions use these bytes.
    ld e,$41
    ld a,(de)
    cp $1
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


; Patch to make interaction 1 read from bank $ff

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

    cp $1
    jr z,++

    cp $3e
    ret
++
    ; Custom interactions read from bank $ff
    ld b,$ff
    scf
    ret

.ORGA $3b8d
; Interaction pointer table, starting at index 1
    .dw interaction1Code
    


; Bank FF contains the jump tables for Interaction 00 and 72 scripts.
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


; Interaction 1 table
; Can either point to a script or asm code.
; Use 3ByteScriptPointer macro to point to a script.
interaction0Table:
    3BytePointer interac1_00
    3BytePointer interac1_01
    3BytePointer interac1_02
    3BytePointer interac1_03
    3BytePointer interac1_04
    3BytePointer interac1_05
    3BytePointer interac1_06
    3BytePointer interac1_07
    3BytePointer interac1_08
    3BytePointer interac1_09
    3BytePointer interac1_0a
    3BytePointer interac1_0b
    3BytePointer interac1_0c
    3BytePointer interac1_0d
    3BytePointer interac1_0e
    3BytePointer interac1_0f
    3BytePointer interac1_10
    3BytePointer interac1_11
    3BytePointer interac1_12
    3BytePointer interac1_13
    3BytePointer interac1_14
    3BytePointer interac1_15
    3BytePointer interac1_16
    3BytePointer interac1_17
    3BytePointer interac1_18
    3BytePointer interac1_19
    3BytePointer interac1_1a
    3BytePointer interac1_1b
    3BytePointer interac1_1c
    3BytePointer interac1_1d
    3BytePointer interac1_1e
    3BytePointer interac1_1f
    3BytePointer interac1_20



; Interaction 1 code

interaction1Code:
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
