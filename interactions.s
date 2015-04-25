.INCLUDE "include/script_commands.s"

; I use bank FE for my custom scripts.
.BANK $FE SLOT 1
.ORGA $4000

.INCLUDE "npc.s"
.INCLUDE "scripts.s"

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

; Sets loaded text ID (dx72-dx73) to hl.
setInteractionText:
    ld e, INTERAC_TEXTID
    ld a,l
    ld (de),a
    inc e
    ld a,h
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
    cp 1
    jr nz,+
    call animateNPC_staticDirection
    jr ++
+
    ; Same as staticDirection, but not solid
	call $261b					; $26db: $cd $1b $26
	call $22e0					; $26e1: $c3 $e0 $22
++
    call runInteractionScript

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

    ; Set "hacked" byte for some of my asm hacks
    ; Probably redundant
    ld e,INTERAC_HACKED
    ld a,$de
    ld (de),a
    ret


; Some of my scripts use this function to revert a "call arbitrary ASM" call.
decHl5:
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ret

; Shortens a position 'bc' into a shorter form 'a'
getShortenedPosition:
    push de
    ld a,b
    and $f0
    ld d,a
    ld a,c
    and $f0
    swap a
    or d
    pop de
    ret
; Expands a position 'bc' into a short-form 'a'.
getExpandedPos:
    ld c,a
    and $f0
    or 8
    ld b,a
    ld a,c
    swap a
    and $f0
    or 8
    ld c,a
    ret

; Finds the a'th interaction of type bc, and sets hl accordingly.
; Sets carry if not found.
findInteractionOfType:
    ld h,$d1
    inc a
    push af
--
    inc h
    ld a,$e0
    cp h
    scf
    jr z,++
    ld l,INTERAC_ID
    ld a,(hl)
    cp b
    jr nz,--
    inc l
    ld a,(hl)
    cp c
    jr nz,--

    ; Match found
    pop af
    dec a
    push af
    jr nz,--
    pop af
    or a
    ret
++
    pop af
    scf
    ret

; Finds the a'th part of type bc, and sets hl accordingly.
; Sets carry if not found.
; A "part" is an object stored in dxc0-dxff.
findPartOfType:
    ld h,$cf
    inc a
    push af
--
    inc h
    ld a,$e0
    cp h
    scf
    jr z,++
    ld l,PART_ID
    ld a,(hl)
    cp b
    jr nz,--
    inc l
    ld a,(hl)
    cp c
    jr nz,--

    ; Match found
    pop af
    dec a
    push af
    jr nz,--
    pop af
    or a
    ret
++
    pop af
    scf
    ret

interac_getPositionFromY:
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld c,a
    and $f0
    or 8
    ld (de),a
    ld a,c
    swap a
    and $f0
    or 8
    ld c,a
    inc e
    inc e
    ld (de),a
    ret

; Creates part bc at position of current interaction.
interac_createPart:
    call getFreePartSlot
    ld (hl),b
    inc hl
    ld (hl),c

    ld l,$ca
    ld e,$4a
    ld b,4
-
    ld a,(de)
    ldi (hl),a
    inc de
    dec b
    jr nz,-
    
    ret


; Assembly code can be run from bank 15 via scripts.
.BANK $15
.ORGA $7bfb ; freespace start
test:
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



; Bank FF contains the jump tables for Interaction 00 and 72 scripts.
.BANK $FF SLOT 1
.ORGA $4000

; Interaction 72 pointers

    3BytePointer script72_0x00
    3BytePointer script72_0x01
    3BytePointer script72_0x02
    3BytePointer script72_0x03
    3BytePointer script72_0x04
    3BytePointer script72_0x05
    3BytePointer script72_0x06
    3BytePointer script72_0x07
    3BytePointer script72_0x08
    3BytePointer script72_0x09
    3BytePointer script72_0x0a
    3BytePointer script72_0x0b
    3BytePointer script72_0x0c
    3BytePointer script72_0x0d
    3BytePointer script72_0x0e
    3BytePointer script72_0x0f
    3BytePointer script72_0x10
    3BytePointer script72_0x11
    3BytePointer script72_0x12
    3BytePointer script72_0x13
    3BytePointer script72_0x14
    3BytePointer script72_0x15
    3BytePointer script72_0x16
    3BytePointer script72_0x17


.macro 3ByteScriptPointer
    .db :\1
    .dw \1 | $8000
.endm


; Interaction 1 table
; Can either point to a script or asm code.
; Use 3ByteScriptPointer macro to point to a script.
interaction1Table:
    3BytePointer interac1_00
    3BytePointer interac1_01
    3ByteScriptPointer interac1_02
    3BytePointer interac1_03
    3ByteScriptPointer interac1_04
    3BytePointer interac1_05
    3ByteScriptPointer interac1_06
    3ByteScriptPointer interac1_07
    3ByteScriptPointer interac1_08
    3ByteScriptPointer interac1_09
    3ByteScriptPointer interac1_0a
    3BytePointer interac1_0b
    3ByteScriptPointer interac1_0c
    3ByteScriptPointer interac1_0d
    3BytePointer interac1_0e
    3ByteScriptPointer interac1_0f
    3ByteScriptPointer interac1_10
    3ByteScriptPointer interac1_11
    3ByteScriptPointer interac1_12
    3ByteScriptPointer interac1_13
    3ByteScriptPointer interac1_14
    3ByteScriptPointer interac1_15
    3BytePointer interac1_16
    3BytePointer interac1_17
    3ByteScriptPointer interac1_18
    3ByteScriptPointer interac1_19
    3ByteScriptPointer interac1_1a
    3ByteScriptPointer interac1_1b
    3ByteScriptPointer interac1_1c
    3BytePointer interac1_1d
    3ByteScriptPointer interac1_1e
    3ByteScriptPointer interac1_1f
    3ByteScriptPointer interac1_20
    3ByteScriptPointer interac1_21
    3ByteScriptPointer interac1_22
    3ByteScriptPointer interac1_23
    3ByteScriptPointer interac1_24
    3ByteScriptPointer interac1_25
    3ByteScriptPointer interac1_26
    3ByteScriptPointer interac1_27
    3ByteScriptPointer interac1_28
    3ByteScriptPointer interac1_29
    3ByteScriptPointer interac1_2a
    3ByteScriptPointer interac1_2b
    3ByteScriptPointer interac1_2c
    3ByteScriptPointer interac1_2d
    3ByteScriptPointer interac1_2e
    3ByteScriptPointer interac1_2f
    3ByteScriptPointer interac1_30
    3ByteScriptPointer interac1_31
    3ByteScriptPointer interac1_32
    3ByteScriptPointer interac1_33
    3ByteScriptPointer interac1_34
    3ByteScriptPointer interac1_35
    3ByteScriptPointer interac1_36
    3ByteScriptPointer interac1_37
    3ByteScriptPointer interac1_38
    3ByteScriptPointer interac1_39
    3ByteScriptPointer interac1_3a
    3ByteScriptPointer interac1_3b
    3ByteScriptPointer interac1_3c
    3ByteScriptPointer interac1_3d
    3ByteScriptPointer interac1_3e
    3ByteScriptPointer interac1_3f
    3ByteScriptPointer interac1_40
    3ByteScriptPointer interac1_41
    3ByteScriptPointer interac1_42
    3ByteScriptPointer interac1_43
    3ByteScriptPointer interac1_44
    3ByteScriptPointer interac1_45
    3ByteScriptPointer interac1_46
    3ByteScriptPointer interac1_47
    3ByteScriptPointer interac1_48
    3ByteScriptPointer interac1_49
    3ByteScriptPointer interac1_4a
    3ByteScriptPointer interac1_4b
    3ByteScriptPointer interac1_4c
    3ByteScriptPointer interac1_4d
    3ByteScriptPointer interac1_4e
    3ByteScriptPointer interac1_4f
    3ByteScriptPointer interac1_50
    3ByteScriptPointer interac1_51
    3ByteScriptPointer interac1_52
    3ByteScriptPointer interac1_53
    3ByteScriptPointer interac1_54
    3ByteScriptPointer interac1_55
    3ByteScriptPointer interac1_56
    3ByteScriptPointer interac1_57
    3ByteScriptPointer interac1_58
    3ByteScriptPointer interac1_59
    3ByteScriptPointer interac1_5a
    3ByteScriptPointer interac1_5b
    3ByteScriptPointer interac1_5c
    3ByteScriptPointer interac1_5d
    3ByteScriptPointer interac1_5e
    3ByteScriptPointer interac1_5f
    3ByteScriptPointer interac1_60
    3ByteScriptPointer interac1_61
    3ByteScriptPointer interac1_62
    3ByteScriptPointer interac1_63
    3ByteScriptPointer interac1_64
    3ByteScriptPointer interac1_65
    3ByteScriptPointer interac1_66
    3ByteScriptPointer interac1_67
    3ByteScriptPointer interac1_68
    3ByteScriptPointer interac1_69
    3ByteScriptPointer interac1_6a
    3ByteScriptPointer interac1_6b
    3ByteScriptPointer interac1_6c
    3ByteScriptPointer interac1_6d
    3ByteScriptPointer interac1_6e
    3ByteScriptPointer interac1_6f
    3ByteScriptPointer interac1_70
    3ByteScriptPointer interac1_71
    3ByteScriptPointer interac1_72
    3ByteScriptPointer interac1_73
    3ByteScriptPointer interac1_74
    3ByteScriptPointer interac1_75
    3ByteScriptPointer interac1_76
    3ByteScriptPointer interac1_77
    3ByteScriptPointer interac1_78
    3ByteScriptPointer interac1_79
    3ByteScriptPointer interac1_7a
    3ByteScriptPointer interac1_7b
    3ByteScriptPointer interac1_7c
    3ByteScriptPointer interac1_7d
    3ByteScriptPointer interac1_7e
    3ByteScriptPointer interac1_7f
    3ByteScriptPointer interac1_80
    3ByteScriptPointer interac1_81
    3ByteScriptPointer interac1_82
    3ByteScriptPointer interac1_83
    3ByteScriptPointer interac1_84
    3ByteScriptPointer interac1_85
    3ByteScriptPointer interac1_86
    3ByteScriptPointer interac1_87
    3ByteScriptPointer interac1_88
    3ByteScriptPointer interac1_89
    3ByteScriptPointer interac1_8a
    3ByteScriptPointer interac1_8b
    3ByteScriptPointer interac1_8c
    3ByteScriptPointer interac1_8d
    3ByteScriptPointer interac1_8e
    3ByteScriptPointer interac1_8f
    3ByteScriptPointer interac1_90
    3ByteScriptPointer interac1_91
    3ByteScriptPointer interac1_92
    3ByteScriptPointer interac1_93
    3ByteScriptPointer interac1_94
    3ByteScriptPointer interac1_95
    3ByteScriptPointer interac1_96
    3ByteScriptPointer interac1_97
    3ByteScriptPointer interac1_98
    3ByteScriptPointer interac1_99
    3ByteScriptPointer interac1_9a
    3ByteScriptPointer interac1_9b
    3ByteScriptPointer interac1_9c
    3ByteScriptPointer interac1_9d
    3ByteScriptPointer interac1_9e
    3ByteScriptPointer interac1_9f
    3ByteScriptPointer interac1_a0
    3ByteScriptPointer interac1_a1
    3ByteScriptPointer interac1_a2
    3ByteScriptPointer interac1_a3
    3ByteScriptPointer interac1_a4
    3ByteScriptPointer interac1_a5
    3ByteScriptPointer interac1_a6
    3ByteScriptPointer interac1_a7
    3ByteScriptPointer interac1_a8
    3ByteScriptPointer interac1_a9
    3ByteScriptPointer interac1_aa
    3ByteScriptPointer interac1_ab
    3ByteScriptPointer interac1_ac
    3ByteScriptPointer interac1_ad
    3ByteScriptPointer interac1_ae
    3ByteScriptPointer interac1_af
    3ByteScriptPointer interac1_b0
    3ByteScriptPointer interac1_b1
    3ByteScriptPointer interac1_b2
    3ByteScriptPointer interac1_b3
    3ByteScriptPointer interac1_b4
    3ByteScriptPointer interac1_b5
    3ByteScriptPointer interac1_b6
    3ByteScriptPointer interac1_b7
    3ByteScriptPointer interac1_b8
    3ByteScriptPointer interac1_b9
    3ByteScriptPointer interac1_ba
    3ByteScriptPointer interac1_bb
    3ByteScriptPointer interac1_bc
    3ByteScriptPointer interac1_bd
    3ByteScriptPointer interac1_be
    3ByteScriptPointer interac1_bf
    3ByteScriptPointer interac1_c0
    3ByteScriptPointer interac1_c1
    3ByteScriptPointer interac1_c2
    3ByteScriptPointer interac1_c3
    3ByteScriptPointer interac1_c4
    3ByteScriptPointer interac1_c5
    3ByteScriptPointer interac1_c6
    3ByteScriptPointer interac1_c7
    3ByteScriptPointer interac1_c8
    3ByteScriptPointer interac1_c9
    3ByteScriptPointer interac1_ca
    3ByteScriptPointer interac1_cb
    3ByteScriptPointer interac1_cc
    3ByteScriptPointer interac1_cd
    3ByteScriptPointer interac1_ce
    3ByteScriptPointer interac1_cf
    3ByteScriptPointer interac1_d0
    3ByteScriptPointer interac1_d1
    3ByteScriptPointer interac1_d2
    3ByteScriptPointer interac1_d3
    3ByteScriptPointer interac1_d4
    3ByteScriptPointer interac1_d5
    3ByteScriptPointer interac1_d6
    3ByteScriptPointer interac1_d7
    3ByteScriptPointer interac1_d8
    3ByteScriptPointer interac1_d9
    3ByteScriptPointer interac1_da
    3ByteScriptPointer interac1_db
    3ByteScriptPointer interac1_dc
    3ByteScriptPointer interac1_dd
    3ByteScriptPointer interac1_de
    3ByteScriptPointer interac1_df
    3ByteScriptPointer interac1_e0
    3ByteScriptPointer interac1_e1
    3ByteScriptPointer interac1_e2
    3ByteScriptPointer interac1_e3
    3ByteScriptPointer interac1_e4
    3ByteScriptPointer interac1_e5
    3ByteScriptPointer interac1_e6
    3ByteScriptPointer interac1_e7
    3ByteScriptPointer interac1_e8
    3ByteScriptPointer interac1_e9
    3ByteScriptPointer interac1_ea
    3ByteScriptPointer interac1_eb
    3ByteScriptPointer interac1_ec
    3ByteScriptPointer interac1_ed
    3ByteScriptPointer interac1_ee
    3ByteScriptPointer interac1_ef
    3ByteScriptPointer interac1_f0
    3ByteScriptPointer interac1_f1
    3ByteScriptPointer interac1_f2
    3ByteScriptPointer interac1_f3
    3ByteScriptPointer interac1_f4
    3ByteScriptPointer interac1_f5
    3ByteScriptPointer interac1_f6
    3ByteScriptPointer interac1_f7
    3ByteScriptPointer interac1_f8
    3ByteScriptPointer interac1_f9
    3ByteScriptPointer interac1_fa
    3BytePointer interac1_fb
    3BytePointer interac1_fc
    3ByteScriptPointer interac1_fd
    3BytePointer interac1_fe
    3ByteScriptPointer interac1_ff


; "extra asm" table for asm accompanying scripts
interaction1ExtraAsmTable:
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 10
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    3BytePointer interac1_1e_asm
    .db 0 0 0
; 20
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 30
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 40
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 50
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 60
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 70
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 80
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; 90
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; a0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; b0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; c0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; d0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; e0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
; f0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0
    .db 0 0 0


; Interaction 1 code

interaction1Code:
    ld e,INTERAC_HACKED
    ld a,$de
    ld (de),a

    ld e,$42 ; 2nd byte of ID
    ld a,(de)
    ld c,a
    ld b,0

    ; Check the 'extra asm' table
    ld hl,interaction1ExtraAsmTable
    add hl,bc
    add hl,bc
    add hl,bc
    ldi a,(hl)
    or a
    jr z,+
    ld e,a
    ldi a,(hl)
    ld h,(hl)
    ld l,a
    push bc
    call interBankCall
    pop bc
+
    ld hl,interaction1Table
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



; "Script Helper" functions: can be in any bank, I use them to "extend" the scripting language.
; Putting them in bank $ff cause why not.

scripthlp_checkLinkYLt:
    ldi a,(hl)
    ld b,a
    ld a,(scrollMode)
    and $08
    jr nz,+
    ld a,($d00b)
    cp b
    ret c
+
    DecHl5
    dec hl
    ret

scripthlp_checkLinkYGe:
    ldi a,(hl)
    ld b,a
    ld a,(scrollMode)
    and $08
    jr nz,+
    ld a,($d00b)
    cp b
    ret nc
+
    DecHl5
    dec hl
    ret

scripthlp_checkLinkOnTile:
    ld a,(scrollMode)
    and $08
    jr nz,+

    ld e,INTERAC_POS_X + 1
    ld a,(de)
    and $f0
    ld b,a
    ld a,($d00d)
    cp b
    jr c,+
    ld c,a
    ld a,b
    add $10
    ld b,a
    ld a,c
    cp b
    jr nc,+

    ld e,INTERAC_POS_Y + 1
    ld a,(de)
    and $f0
    ld b,a
    ld a,($d00b)
    add $5
    cp b
    jr c,+
    ld c,a
    ld a,b
    add $10
    ld b,a
    ld a,c
    cp b
    jr nc,+

    ret
+
    DecHl5
    ret

scripthlp_createPart:
    ldi a,(hl)
    ld c,a
    ldi a,(hl)
    ld b,a
    push hl
    CallAcrossBank interac_createPart
    pop hl
    ret

scripthlp_jumpInteractionByte:
    ldi a,(hl)
    ld e,a
    ld a,(de)
    ld b,a
    ldi a,(hl)
    cp b
    jr nz,++
    jp scripthlp_setInteractionScriptAddr
++
    inc hl
    inc hl
    inc hl
    ret

scripthlp_setInteractionScriptAddr
	ld b,$03
	ld e,$7d
-
	ldi a,(hl)
	ld (de),a
	inc de
	dec b
	jr nz,-

    jp reloadInteractionScript

scripthlp_checkMemoryBitUnset
    ldi a,(hl)
    ld b,a
    ld a,$80
    inc b
-
    rlca
    dec b
    jr nz,-
    ld e,a
    ldi a,(hl)
    ld c,a
    ldi a,(hl)
    ld b,a
    ld a,(bc)
    and e
    ret z

    dec hl
    dec hl
    dec hl
    DecHl5
    ret
