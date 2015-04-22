; Maku path block script
interac1_02:
    asm interac1_02_asm

    setdelay 0
    checkenemycount
    ; When block is pushed it will set "enemy count" to zero
    setmusic MUS_MINIBOSS

    setcoords $78 $18
    createpuff
    spawnenemyhere $3101
    setcoords $68 $38
    createpuff
    spawnenemyhere $3102
    setcoords $88 $38
    createpuff
    spawnenemyhere $3102

    setcoords $66 $66
    createpuff
    spawnenemyhere $4900
    setcoords $86 $66
    spawnenemyhere $4900

    ; Spawn the door opening interaction (I removed it in zole)
    setcoords $00 $07
    createinteraction $1e08

    checkenemycount
    setmusic MUS_CAVE
    forceend

interac1_02_asm:
    ; Do nothing if the door is open (entered from the top)
    ld a,($cf07)
    cp $a0
    ret nz
    ; Will force the script to not proceed
    dec hl
    dec hl
    dec hl
    dec hl
    dec hl
    ret

; Script for 3rd maku path room (pushable block)
; Opted to use ASM for the base of this
interac1_03:
    ; Check either side of the pushable block
    ld hl,$cf76
    ldi a,(hl)
    cp $1d
    jr z,++
    inc hl
    ld a,(hl)
    cp $1d
    jr z,++
    ld hl,$cf67
    ld a,(hl)
    cp $1d
    jr z,++
    cp $f3
    jr z,++
    ret
++  ; One of the tiles is set, activate the trap
    ld e, INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+
    inc a
    ld (de),a
    SetInteractionScript interac1_03_script
+
    jp runInteractionScript

interac1_03_script:
    ; Create pits
    setcoords $78 $58
    createpuffnodelay
    settile $57 $f3
    setcoords $78 $68
    createpuffnodelay
    settile $67 $f3
    setcoords $78 $78
    createpuffnodelay
    settile $77 $f3
    forceend

; Script to decrease "total enemy" count for room in maku path
interac1_04:
    asm interac1_04_asm
    forceend

interac1_04_asm:
    push hl
    ld hl,totalEnemies
    dec (hl)
    dec (hl)
    pop hl
    ret

; Script for block room in maku path, with 2 switches
; Sets trigger 0 if triggers 1 and 2 are set
interac1_05:
    ld a,(activeTriggers)
    ld e,a
    bit 1,e
    jr nz,++

    ld bc,$0981
    xor a
    call findPartOfType
    ld l,$c6
    ld (hl),$7c
++
    bit 2,e
    jr nz,++

    ld bc,$0982
    xor a
    call findPartOfType
    ld l,$c6
    ld (hl),$7c
++
    ld a,e
    cpl
    and $06
    ld a,e
    jr nz,+
    or $01
+
    ld (activeTriggers),a
    ret
    

; Script for 2nd last room of maku road
; Makes bridge appear after defeating enemies
interac1_06:
    checkenemycount
    setcoords $88 $78
    createpuff
    settile $78 $6d

    forceend
    

; Script for last room of maku road
interac1_07:
    jumproomflag $02 noScript

    asm interac1_07_asm
    createpuff
    settile $17 $a0

    setmusic MUS_MINIBOSS

    setcoords $58 $1c
    createpuff
    spawnenemyhere $4a00

    setcoords $98 $18
    createpuff
    spawnenemyhere $4a00

    setcoords $78 $38
    createpuff
    spawnenemyhere $4a00

    checkenemycount

    setroomflag $02
    setmusic MUS_CAVE
    setcoords $78 $18
    createpuff
    playsound SND_SOLVEPUZZLE
    settile $17 $44
    forceend

interac1_07_asm:
    ; Checks if link is close enough to the staircase
    ld a,($d00b) ; Link Y
    cp $1d
    jr nc,++
    ld a,($d00d) ; Link X
    cp $6e
    jr c,++
    cp $81
    jr nc,++
    ret
++
    jp decHl5


; Script in 3rd room of spirit's grave, makes error sound for wrong color flames,
; Creates bridges for correct color flames
interac1_08:
    createinteraction $109 ; Accompanying script

    asm interac1_08_asm
    ; Holds until torches are lit

    jump3bytemc rotatingCubeColor $80 ++
    ; Wrong color
    playsound SND_ERROR
    forceend
++  ; Correct color
    setcoords $78 $18
    createpuff
    setdelay 5
    playsound SND_SOLVEPUZZLE
    settilehere $5f
    setcoords $d8 $38
    settilehere $5f
    forceend


interac1_08_asm:
    ld a,(rotatingCubeColor)
    bit 7,a
    ret nz
    jp decHl5


; Accompanying script for $0108.
; Makes bridge disappear after link passes it.
interac1_09:
    checklinkyge $7b
    checklinkylt $7b
    setcoords $a8 $88
    createpuff
    settilehere $f7
    forceend
    

; Makes invisible path appear when switch is pressed
interac1_0a:
    createinteraction $010b ; Start partner script
--
    checkmemory activeTriggers $01

    asm interac1_0a_asm
    writememory paletteFadeBG1 $20
    writememory paletteFadeBG2 $20
    writememory paletteFadeCounter $20
    writememory paletteFadeSpeed $01
    writememory paletteFadeMode $02

    checkmemory activeTriggers $00

    writememory paletteFadeBG1 $20
    writememory paletteFadeBG2 $20
    writememory paletteFadeCounter $00
    writememory paletteFadeSpeed $01
    writememory paletteFadeMode $03

    checkmemory paletteFadeMode $00
    asm interac1_0a_asm2

    setdelay 1

    writememory paletteFadeBG1 $20
    writememory paletteFadeBG2 $20
    writememory paletteFadeCounter $01
    writememory paletteFadeMode $02

    jump3byte --

; Convert all invisible tiles to blue, visible tiles
interac1_0a_asm:
    push hl
    ld h,$cf
    ld l,0
    ld b,0
-
    ld a,(hl)
    cp $c5
    jr z,+
    cp $9d
    jr z,+
    jr ++
+
    ld c,l
    ld a,$a5
    push hl
    call setTile
    pop hl
++
    inc hl
    dec b
    jr nz,-

    pop hl
    ret

; Convert visible tiles back to invisible tiles
interac1_0a_asm2:
    push hl
    ld h,$cf
    ld l,0
    ld b,0
-
    ld a,(hl)
    cp $a5
    jr nz,+
    ld c,l
    ld a,$c5
    push hl
    call setTile
    pop hl
+
    inc hl
    dec b
    jr nz,-

    pop hl
    ret

interac1_0b:
    ; Lights up the tile link is standing on
    ld h,d
    ld l,INTERAC_INITIALIZED
    ld a,(hl)
    jr nz,+
    inc a
    ld (hl),a
+
    ld l,$70
    ld b,(hl)
    ld a,(activeTilePos)
    cp b
    jr z,++

    ; Link's on a different tile this frame
    ld c,a
    ld a,(activeTileIndex)
    cp $c5
    jr nz,+
    push hl
    ld a,$9d
    call setTile
    pop hl
+
    ld a,(hl)
    ld l,a
    ld h,$cf
    ld a,(hl)
    cp $9d
    jr nz,+
    ld c,l
    ld a,$c5
    call setTile
+
    ld a,(activeTilePos)
    ld e,$70
    ld (de),a
++
    ret


; The room which used to be the ghini room
interac1_0c:
    asm interac1_0c_asm
    writememory $d3b0 $a4 ; The tile the armos statue will replace with
    checkenemycount
    createpuff
    settilehere $6d
    forceend

; Decreases the total enemy count, and jumps to bridge making part if link is on the left
interac1_0c_asm:
    ld a,(totalEnemies)
    or a
    jr z,+
    dec a
    ld (totalEnemies),a

    ld a,($d00d)
    cp $ea
    jr nc,+
    ret
+
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    ret


interac1_0d:
    maketorcheslightable
    forceend

; Boomerang room with falling floor
interac1_0f:
    checkmemory activeTriggers $01
    jumproomflag $20 ++
    createpuff
    spawnitem $0600
++
    shakescreen $c0
    playsound SND_RUMBLE2
    setdelay 8
    setdelay 1
    playsound SND_RUMBLE2
    setdelay 8
    setdelay 5
--
    asm interac1_0f_asm
    setdelay 0
    jump3byte --

; Search for next tile to destroy
interac1_0f_asm:
    push hl
    ld h,$cf
    ld l,$d
-
    ld a,(hl)
    cp $a0
    jr z,++
    ld a,$10
    add l
    ld l,a
    jr nc,-
    dec l
    ld a,$ff
    cp l
    jr z,+++
    jr -
++  ; Found the next tile to destroy
    ld c,l
    ld a,$f4
    call setTile

    ld h,d
    ld l,$70
    ld a,(hl)
    or a
    jr nz,+
    ld (hl),15
    ld a,SND_RUMBLE2
    call playSound
+
    dec (hl)
+++ ; No tile found
    pop hl
    ret


; Intro screen script
interac1_10:
    setdelay 0
    asm interac1_10_asm
    createpuffnodelay
    settilehere $f3
    checkmemory linkHealth 2
    setdelay 7
    showtext $7d02
    forceend

; Holds until sign (id 01fd) is read
interac1_10_asm:
    push hl
    ld bc,$01fd
    xor a
    call findInteractionOfType
    jr c,++
    ld l,$70
    ld a,(hl)
    or a
    jr z,++
    pop hl
    ret

++  ; Not found
    pop hl
    jp decHl5



; Bridge extending 3 tiles to the right
interac1_11:
    setdelay 0
    addinteractionbyte INTERAC_POS_X+1 $f0

----; Extension code
    addinteractionbyte INTERAC_POS_X+1 $10
    setinteractionbyte $71 0
    checkmemorybit 0 switchState
    setdelay 2
--  ; Start extending
    settilehere $6d
    playsound SND_DOORCLOSE
    addinteractionbyte INTERAC_POS_X+1 $10
    addinteractionbyte $71 1
    jumpinteractionbyte $71 $03 ++
    setdelay 2
    jump3byte --

++  ; Retraction code
    addinteractionbyte INTERAC_POS_X+1 $f0
    setinteractionbyte $71 0
    checkmemorybitunset 0 switchState
    setdelay 2
--  ; Start retracting
    settilehere $f4
    playsound SND_DOORCLOSE
    addinteractionbyte INTERAC_POS_X+1 $f0
    addinteractionbyte $71 1
    jumpinteractionbyte $71 $03 ----
    setdelay 2
    jump3byte --
    

; Make filler floor appear when switch 2 is activated
interac1_12:
    checkmemorybit 1 switchState
    setdelay 2
    settilehere $5f
    playsound SND_SOLVEPUZZLE
    forceend

; Another floor filler thing
interac1_13:
    jumproomflag $80 noScript

    checkmemorybit 2 switchState
    setroomflag $80
    createpuff
    setdelay 2
    settilehere $a0
    playsound SND_SOLVEPUZZLE
    forceend


; Enemies before miniboss room
interac1_14:
    jumproomflag $20 noScript

    setcoords $10 $78
    checklinkontile
    setcoords $0c $78
    createpuff
    settilehere $94
    setmusic 0
    setdelay 8

    setcoords $61
    createpuffnodelay
    spawnenemyhere $3102
    setcoords $72
    createpuffnodelay
    spawnenemyhere $3102
    setcoords $81
    createpuffnodelay
    spawnenemyhere $3102

    checkenemycount

    playsound SND_SOLVEPUZZLE
    setcoords $0c $78
    createpuff
    settilehere $a0
    setroomflag $20
    forceend

; Pre-miniboss room
interac1_15:
    maketorcheslightable
    jumproomflag $02 ++
    checkmemory totalTorchesLit 2
    createpuff
    setdelay 5
    playsound SND_SOLVEPUZZLE
    settilehere $a0
    setroomflag $02
    forceend
++  ; Entering room after puzzle has been solved
    createpuff
    setdelay 5
    settilehere $a0
    forceend

; Alternate room map X appears when link is close enough
; Variables:
; 70+ = alternate addr
; 74 = last pos
interac1_16:
    push hl
    
    ; Get custom map address
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ld hl,customMapTable
    rst_addDoubleIndex
    ldi a,(hl)
    ld h,(hl)
    ld l,a
    ld e,$70
    ld a,l
    ld (de),a
    inc e
    ld a,h
    ld (de),a

    push de
    push hl

    ld e,$74
    ld a,(de)
    ld b,a
    ld a,(activeTilePos)
    cp b
    jr z,++++
    ld (de),a

    ld d,$cf
    ld e,0

--  ; Loop through all tiles
    ld a,e
    call interac1_16_getTileDistance
    cp $4
    jr nc,++

    ; Show alternate tile
    ld a,(de)
    ld b,a

    pop hl
    push hl
    ld a,e
    rst_addAToHl
    ld a,(hl)
    cp b
    jr z,+++
;    ld a,$db
    ld c,e
    push de
    call setTile
    pop de
    jr +++
++  ; Show original tiles
    ld a,7
    ldh (R_SVBK),a

    ld a,$54
    push de
;    CallAcrossBank getMapDataAddr
    pop de
    ld a,e
    rst_addAToHl
    ld a,e
    ld ($d0f2),a

    ld a,(de)
    ld b,a
    call readByteFromBank
    ld c,a

    ld a,1
    ldh (R_SVBK),a

    ld a,c
    cp b
    jr z,+++
    ld c,e
    push de
;    call setTile
    pop de
+++
    inc e
    ld a,e
    cp $b0
    jr nz,--

++++
    pop hl
    pop de
    pop hl
    ret

interac1_16_getTileDistance:
    push bc
    push hl
    ld b,a
    ; Check X
    and $0f
    ld c,a
    ld a,(activeTilePos)
    and $0f
    sub c
    jr nc,+
    cpl
    inc a
+
    ld h,a
    ; Check Y
    ld a,b
    swap a
    and $0f
    ld c,a
    ld a,(activeTilePos)
    swap a
    and $0f
    sub c
    jr nc,+
    cpl
    inc a
+
    add h
    pop hl
    pop bc
    ret


customMapTable:
    .dw customMap00

customMap00:
    .incbin "custommaps/00-d1-miniboss.MDF" SKIP 1

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
interac1_21:
interac1_22:
interac1_23:
interac1_24:
interac1_25:
interac1_26:
interac1_27:
interac1_28:
interac1_29:
interac1_2a:
interac1_2b:
interac1_2c:
interac1_2d:
interac1_2e:
interac1_2f:
interac1_30:
interac1_31:
interac1_32:
interac1_33:
interac1_34:
interac1_35:
interac1_36:
interac1_37:
interac1_38:
interac1_39:
interac1_3a:
interac1_3b:
interac1_3c:
interac1_3d:
interac1_3e:
interac1_3f:
interac1_40:
interac1_41:
interac1_42:
interac1_43:
interac1_44:
interac1_45:
interac1_46:
interac1_47:
interac1_48:
interac1_49:
interac1_4a:
interac1_4b:
interac1_4c:
interac1_4d:
interac1_4e:
interac1_4f:
interac1_50:
interac1_51:
interac1_52:
interac1_53:
interac1_54:
interac1_55:
interac1_56:
interac1_57:
interac1_58:
interac1_59:
interac1_5a:
interac1_5b:
interac1_5c:
interac1_5d:
interac1_5e:
interac1_5f:
interac1_60:
interac1_61:
interac1_62:
interac1_63:
interac1_64:
interac1_65:
interac1_66:
interac1_67:
interac1_68:
interac1_69:
interac1_6a:
interac1_6b:
interac1_6c:
interac1_6d:
interac1_6e:
interac1_6f:
interac1_70:
interac1_71:
interac1_72:
interac1_73:
interac1_74:
interac1_75:
interac1_76:
interac1_77:
interac1_78:
interac1_79:
interac1_7a:
interac1_7b:
interac1_7c:
interac1_7d:
interac1_7e:
interac1_7f:
interac1_80:
interac1_81:
interac1_82:
interac1_83:
interac1_84:
interac1_85:
interac1_86:
interac1_87:
interac1_88:
interac1_89:
interac1_8a:
interac1_8b:
interac1_8c:
interac1_8d:
interac1_8e:
interac1_8f:
interac1_90:
interac1_91:
interac1_92:
interac1_93:
interac1_94:
interac1_95:
interac1_96:
interac1_97:
interac1_98:
interac1_99:
interac1_9a:
interac1_9b:
interac1_9c:
interac1_9d:
interac1_9e:
interac1_9f:
interac1_a0:
interac1_a1:
interac1_a2:
interac1_a3:
interac1_a4:
interac1_a5:
interac1_a6:
interac1_a7:
interac1_a8:
interac1_a9:
interac1_aa:
interac1_ab:
interac1_ac:
interac1_ad:
interac1_ae:
interac1_af:
interac1_b0:
interac1_b1:
interac1_b2:
interac1_b3:
interac1_b4:
interac1_b5:
interac1_b6:
interac1_b7:
interac1_b8:
interac1_b9:
interac1_ba:
interac1_bb:
interac1_bc:
interac1_bd:
interac1_be:
interac1_bf:
interac1_c0:
interac1_c1:
interac1_c2:
interac1_c3:
interac1_c4:
interac1_c5:
interac1_c6:
interac1_c7:
interac1_c8:
interac1_c9:
interac1_ca:
interac1_cb:
interac1_cc:
interac1_cd:
interac1_ce:
interac1_cf:
interac1_d0:
interac1_d1:
interac1_d2:
interac1_d3:
interac1_d4:
interac1_d5:
interac1_d6:
interac1_d7:
interac1_d8:
interac1_d9:
interac1_da:
interac1_db:
interac1_dc:
interac1_dd:
interac1_de:
interac1_df:
interac1_e0:
interac1_e1:
interac1_e2:
interac1_e3:
interac1_e4:
interac1_e5:
interac1_e6:
interac1_e7:
interac1_e8:
interac1_e9:
interac1_ea:
interac1_eb:
interac1_ec:
interac1_ed:
interac1_ee:
interac1_ef:
interac1_f0:
interac1_f1:
interac1_f2:
interac1_f3:
interac1_f4:
interac1_f5:
interac1_f6:
interac1_f7:
interac1_f8:
interac1_f9:
interac1_fa:
interac1_fb:
    forceend

; Tile at Y turns into X when it's changed
interac1_fc:
    ld e,$71
    ld a,(de)
    or a
    jr nz,+++ ; Check for if the tile has changed already

    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr z,++
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld l,a
    ld h,$cf
    ld a,(hl)
    ld b,a
    ld e,$70
    ld a,(de)
    cp b
    jr z,++
    ; Tile changed
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ld b,a
    push bc
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    and $f0
    or 8
    ld b,a
    ld a,(de)
    swap a
    and $f0
    or 8
    ld c,a
    call setInteractionPos
    call getObjectPos
    pop bc
    ld c,a
    ld a,b
    call setTile
    ld e,$71
    ld a,1
    ld (de),a
++
    ld e,INTERAC_INITIALIZED
    ld a,1
    ld (de),a
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld l,a
    ld h,$cf
    ld a,(hl)
    ld e,$70
    ld (de),a
+++
    ret


; GENERAL-PURPOSE SCRIPTS

; Makes a ghetto sign at Y with text 7DXX.

interac1_fd:
    asm interac1_fd_init
    fixnpchitbox
--
    checkabutton
    asm interac1_fd_showtext
    jump3byte --

interac1_fd_showtext:
    push hl
    ld a,(linkFacingDir)
    or a
    jr z,+
    ; Not facing up
    ld bc,$7d00
    jr ++
+   ; Facing up
    ld b,$7d
    ld e,INTERAC_TEXTID
    ld a,(de)
    ld c,a
    ; Mark that text has been shown (for more of my scripts)
    ld e,$70
    ld a,1
    ld (de),a
++
    call showText
    pop hl
    ret

interac1_fd_init:
    ; Fix position
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld b,a
    and $f0
    or 8
    ld (de),a
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ld c,a
    ld a,b
    swap a
    and $f0
    or 8
    ld (de),a

    ; Set text id
    ld e,INTERAC_TEXTID
    ld a,c
    ld (de),a
    inc e
    ld a,$7d
    ld (de),a
    ret


; Drops item X when tile at Y changes.
interac1_fe:
    ld e,$71
    ld a,(de)
    or a
    jr nz,+++ ; Check for if the tile has changed already

    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr z,++
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld l,a
    ld h,$cf
    ld a,(hl)
    ld b,a
    ld e,$70
    ld a,(de)
    cp b
    jr z,++
    ; Tile changed
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ld c,a
    ld b,$01
    push bc
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    and $f0
    or 8
    ld b,a
    ld a,(de)
    swap a
    and $f0
    or 8
    ld c,a
    call setInteractionPos
    pop bc
    CallAcrossBank createPart
    ld e,$71
    ld a,1
    ld (de),a
++
    ld e,INTERAC_INITIALIZED
    ld a,1
    ld (de),a
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld l,a
    ld h,$cf
    ld a,(hl)
    ld e,$70
    ld (de),a
+++
    ret

; Chest appears here when all enemies are dead
interac1_ff:
    ; Check if chest opened
    jumproomflag $20 noScript

    checkenemycount
    createpuff
    setdelay 5
    settilehere $f1
    forceend



script72_0x00:

script72_0x01:
script72_0x02:
script72_0x03:
script72_0x04:
script72_0x05:
script72_0x06:
script72_0x07:
script72_0x08:
script72_0x09:
script72_0x0a:
script72_0x0b:
script72_0x0c:
script72_0x0d:
script72_0x0e:
script72_0x0f:
script72_0x10:
script72_0x11:
script72_0x12:
script72_0x13:
script72_0x14:
script72_0x15:
script72_0x16:
script72_0x17:
    forceend

noScript:
    forceend
