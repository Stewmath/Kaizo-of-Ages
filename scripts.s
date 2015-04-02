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
    spawninteraction $1e08

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

; Script for 3rd maku path room
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
    bit 1,a
    ld b,$7c
    jr nz,++

    ld hl,$d0c6
    ld (hl),b
++
    bit 2,a
    jr nz,++
    ld hl,$d1c6
    ld (hl),b
++
    ld b,a
    cpl
    and $06
    ld a,b
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


; Script in 3rd room of spirit's grave, makes error sound for wrong color flames
interac1_08:
    asm interac1_08_asm
    ; Holds until torches are lit

    jump3bytemc rotatingCubeColor $80 noScript
    playsound SND_ERROR
    forceend

interac1_08_asm:
    ld a,(rotatingCubeColor)
    bit 7,a
    ret nz
    jp decHl5


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
interac1_fc:
interac1_fd:
interac1_fe:
    forceend


; GENERAL-PURPOSE SCRIPTS


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
