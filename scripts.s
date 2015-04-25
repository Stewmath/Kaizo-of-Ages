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
    checkmemory numTorchesLit 2
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
; 75 = tile to fill in when further away
interac1_16:
    push hl
    
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+
    inc a
    ld (de),a
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

    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld e,$75
    ld (de),a
    ret
+
    ld e,$70
    ld a,(de)
    inc e
    ld l,a
    ld a,(de)
    ld h,a

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
    ld c,a
    cp $3
    jr nc,++

    ; Show alternate tile
    ld a,(de)
    ld b,a

    ; Now check if it needs to be set
    pop hl
    push hl
    ld a,e
    rst_addAToHl
    ld a,(hl)
    cp b
    jr z,+++
    and $f0
    cp $70
    jr z,+++

    call interac1_16_makePuff
    ld a,(hl)
    ld c,e
    push de
    call setTile
    pop de
    jr +++

++  ; Show original tiles
    ldh a,(z_activeInteraction)
    ld h,a
    ld l,$75
    ld a,(de)
    cp (hl)
    jr z,+++
    cp $a0
    jr z,+++
    and $f8
    cp $18
    jr z,+
    cp $a0
    jr z,+
    ld a,(de)
    cp $f3
    jr z,+
    jr +++
+
    call interac1_16_makePuff
    ldh a,(z_activeInteraction)
    ld h,a
    ld l,$75
    ld a,(hl)
    ld c,e
    push de
    call setTile
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

interac1_16_makePuff:
    ld a,e
    and $f0
    or 8
    ld b,a
    ld a,e
    swap a
    and $f0
    or 8
    ld c,a
    push de
    push hl
    ldh a,(z_activeInteraction)
    ld d,a
    call setInteractionPos
    ld bc,$0580
    call createInteraction
    pop hl
    pop de
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

; Another miniboss script
; Variables:
; 70 = mode (0 or 1, almost pointless but whatevs)
; 71 = counter
; 72 = position index (miniboss appears in 3 places)
; 73 = spawned enemy or not
; 74 = spawned enemy index
interac1_17:
    call checkInteractionInitialized
    jr nz,+
    inc a
    ld (de),a
    ld e,$72
    ld a,2
    ld (de),a
    ld bc,$0116
    call createInteraction
    ld l,INTERAC_POS_Y+1
    ld (hl),$a1
+
    ; Don't do anything if fight hasn't started
    ld a,($d084)
    cp $9
    ret c
    ; Don't do anything if he's dead
    ld a,($d000+ENEMY_HEALTH)
    or a
    ret z
    xor a
    ld ($d090),a
    ld a,9
    ld ($d084),a

    ld e,$70
    ld a,(de)
    rst_jumpTable
.dw interac1_17_normal
.dw interac1_17_moving

interac1_17_enemyTable:
; 00
    .db $31     ; Pos to trigger
    .db $00     ; Facing direction
    .db $51     ; Pos to appear
    .dw $000d   ; ID (backward byte order)
; 01
    .db $56     ; Pos to trigger
    .db $18     ; Facing direction
    .db $58     ; Pos to appear
    .dw $000d   ; ID (backward byte order)
; 02
    .db $5d     ; Pos to trigger
    .db $08     ; Facing direction
    .db $5a     ; Pos to appear
    .dw $000d   ; ID (backward byte order)

interac1_17_normal:
    ; Check to spawn enemy
    ld e,$72
    ld a,(de)
    ld b,a
    add a
    add a
    add b
    ld hl,interac1_17_enemyTable
    rst_addAToHl
    ldi a,(hl)
    ld b,a
    ld a,(activeTilePos)
    cp b
    jr nz,+
    ; Check if enemy has spawned already
    ld e,$73
    ld a,(de)
    cp 2
    jr z,+
    or a
    jr z,++
    ; Make him face left 1 frame after creating him
    ldi a,(hl)
    ld b,a
    ld e,$74
    ld a,(de)
    ld h,a
    ld l,ENEMY_DIRECTION
    ld (hl),b
    push de
    ld d,h
    ld a,$80
    ldh (z_activeInteractionType),a
    ld a,h
    ldh (z_activeInteraction),a
    CallAcrossBank lynel_updateFacingDirection
    ld a,$40
    ldh (z_activeInteractionType),a
    pop de
    ld a,d
    ldh (z_activeInteraction),a
    ld e,$73
    ld a,(de)
    inc a
    ld (de),a
    jr +
++
    inc hl
    ; Spawn enemy
    ld b,h
    ld c,l
    call getFreeEnemySlot
    ld l,ENEMY_POS_Y+1
    ld e,INTERAC_POS_Y+1
    ld a,(bc)
    and $f0
    or 8
    ldi (hl),a
    ld (de),a
    inc hl
    inc de
    inc de
    ld a,(bc)
    swap a
    and $f0
    or 8
    ld (hl),a
    ld (de),a
    push bc
    push hl
    call createPuff
    pop hl
    pop bc
    ld l,ENEMY_ID
    inc bc
    ld a,(bc)
    ldi (hl),a
    inc bc
    ld a,(bc)
    ld (hl),a
    
    ; Mark enemy as spawned
    ld e,$73
    ld a,1
    ld (de),a
    inc e
    ld a,h
    ld (de),a
+   ; Check whether to move the ghost
    ld h,$d0
    ; Check damage invincibility
    ld l,$ab
    ld a,(hl)
    or a
    ret z
    cp 1
    jr z,+
    ; Flash visible & invisible
    ld l,$9a
    ld a,$80
    xor (hl)
    ld (hl),a
    ret
+
    ; If almost done with damage invincibility, teleport
    ld e,$70
    ld a,1
    ld (de),a
    inc e
    ld a,40
    ld (de),a
    ld e,$72
    ld a,(de)
    inc a
    cp 3
    jr nz,+
    xor a
+
    ld (de),a
    rst_jumpTable
.dw interac1_17_pos0
.dw interac1_17_pos1
.dw interac1_17_pos2

interac1_17_pos0:
    ld hl,$d000 + ENEMY_POS_Y+1
    ld (hl),$90
    ld l, ENEMY_POS_X+1
    ld (hl),$28
    ret

interac1_17_pos1:
    ld hl,$d000 + ENEMY_POS_Y+1
    ld (hl),$90
    ld l, ENEMY_POS_X+1
    ld (hl),$70
    ret
interac1_17_pos2:
    ld hl,$d000 + ENEMY_POS_Y+1
    ld (hl),$90
    ld l, ENEMY_POS_X+1
    ld (hl),$c0
    ret

interac1_17_moving:
    ld h,$d0
    ld e,$71
    ld a,(de)
    dec a
    ld (de),a
    jr z,+
    ; Flash between visible & invisible
    ld l,$9a
    ld a,$80
    xor (hl)
    ld (hl),a
    ret
+
    ld l,$9a
    ld a,$80
    ld (hl),a
    ld e,$70
    xor a
    ld (de),a
    ; Reset enemy spawned variable
    ld e,$73
    ld (de),a
    ret


interac1_18:
    setcoords $38 $38
    spawnitem $0300

; Chest with a bomb in it
interac1_19:
    jumproomflag $02 noScript
    fixnpchitbox
--
    checkabutton
    writememory linkInvincibilityCounter 0
    jump3bytemc linkFacingDir $00 ++
    jump3byte --
++
    playsound SND_OPENCHEST
    settilehere $f0
    setroomflag $02
    asm interac1_19_asm
    asm interac1_19_asm2
    asm interac1_19_asm3
    forceend

; asm to spawn the bomb
interac1_19_asm:
    push hl
    ; Reserve spot, get ID
    call getFreeItemSlot
    jr nz,+++
    ld e,$70
    ld a,h
    ld (de),a
    ld (hl),$01
    inc hl
    ld (hl),$03
    inc hl
    ld (hl),$00
    ; Set X,Y,Z
    ld l,$0b
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    add $8
    ldi (hl),a
    inc hl
    inc de
    inc de
    ld a,(de)
    ldi (hl),a
    inc hl
    ld bc,-$14
    ld (hl),c
    inc hl
    ld (hl),b
    ; Save number of bombs
    ld a,(numBombs)
    ld e,$71
    ld (de),a
+++
    pop hl
    ret

; Code to be run after initialization
interac1_19_asm2:
    push hl
    ld e,$70
    ld a,(de)
    ld h,a
    ld l,$05
    ld (hl),$03 ; Allows the bomb to fall

    ; Set fuse
    ld l,$20
    ld (hl),1

    ; Restore number of bombs (just creating this object makes it decrement your bomb count)
    ld e,$71
    ld a,(de)
    ld (numBombs),a

    pop hl
    ret

; Yet another frame later, reset vertical speed to 0
interac1_19_asm3:
    push hl
    ld e,$70
    ld a,(de)
    ld h,a
    ld l,$14
    xor a
    ldi (hl),a
    ldi (hl),a
    pop hl
    ret


; Battlefield kind of thing before getting the bracelet
; Variables:
; 70 = delta X of enclosing wall
; 71 = delta Y of enclosing wall
; 72 = tile to put up
interac1_1a:
    jumproomflago $23 $04 $20 ++
    jump3byte +++
++  ; Already completed fight
    ormemory activeTriggers $01
    jump3byte noScript
+++
    checkmemorybit 1 activeTriggers
    ; Create barrier
    setinteractionbyte $71 $2
    setinteractionbyte $72 $ed
--
    asm interac1_1a_asm
    setdelay 0
    jumpinteractionbyte $71 $ff ++
    jump3byte --
++
    setdelay 4
    setmusic MUS_MINIBOSS
    ; Round 1
    setcoords $68 $58
    createpuff
    spawnenemyhere $4e00
    setcoords $a8 $58
    createpuff
    spawnenemyhere $4e00
    setcoords $88 $38
    spawnenemyhere $4a01
    setcoords $88 $78
    spawnenemyhere $4a01
    checkenemycount
    ; Round 2
    setcoords $68 $38
    createpuff
    spawnenemyhere $4900
    setcoords $a8 $38
    createpuff
    spawnenemyhere $4900
    setcoords $68 $78
    createpuff
    spawnenemyhere $4900
    setcoords $a8 $78
    createpuff
    spawnenemyhere $4900
    checkenemycount
    ; Round 3
    setcoords $68 $78
    createpuff
    spawnenemyhere $5500
    setcoords $a8 $38
    createpuff
    spawnenemyhere $5500
    setcoords $68 $38
    spawnenemyhere $1400
    createpuff
    setcoords $a8 $78
    createpuff
    spawnenemyhere $1400
    checkenemycount

    setmusic MUS_LEVEL1
    ; Put down barrier
    setinteractionbyte $70 $0
    setinteractionbyte $71 $2
    setinteractionbyte $72 $a3
--
    asm interac1_1a_asm
    setdelay 0
    jumpinteractionbyte $71 $ff ++
    jump3byte --
++
    ormemory activeTriggers $01
    forceend

interac1_1a_asm:
    push hl

    ld e,$70
    ld a,(de)
    ld b,a
    cp 4
    jr z,++
    or a
    jr z,+
    ld a,8
    add b
    or $20
    call interac1_1a_setTile
    ld a,8
    add b
    or $80
    call interac1_1a_setTile
+
    ld a,8
    sub b
    or $20
    call interac1_1a_setTile
    ld a,8
    sub b
    or $80
    call interac1_1a_setTile

    ld e,$70
    ld a,(de)
    inc a
    ld (de),a
    jr +++
++
    ld h,d
    ld l,$71
    ld a,(hl)
    dec (hl)
    swap a
    ld b,a

    or a
    jr z,+

    add $50
    or $05
    call interac1_1a_setTile
    ld a,$50
    add b
    or $0b
    call interac1_1a_setTile
+
    ld a,$50
    sub b
    or $05
    call interac1_1a_setTile
    ld a,$50
    sub b
    or $0b
    call interac1_1a_setTile

+++
    pop hl
    ret

interac1_1a_setTile:
    ld c,a
    push bc
    call getExpandedPos
    call setInteractionPos
    call createPuff
    pop bc
    ld e,$72
    ld a,(de)
    push bc
    call setTile
    pop bc
    ret

; Script just before stairs for nightmare key.
; A silly sequence of events to make the stairs appear
interac1_1b:
    maketorcheslightable
    checkmemory numTorchesLit 2
    setcoords $98 $38
    createpuff
    settilehere $0c
    createpart $0900
    checkmemorybit 0 activeTriggers
    setcoords $d8 $38
    createpuff
    settilehere $0c
    createpart $0901
    checkmemorybit 1 activeTriggers
    setcoords $b8 $18
    createpuff
    settilehere $0a
    asm interac1_1b_asm
    createpart $0580
    checkmemorybit 7 switchState
    setcoords $b8 $58
    createpuff
    settilehere $1c
    createinteraction $1301
    setdelay 0
    checkenemycount
    ; Make some enemies appear
    setcoords $b8 $58
    createpuff
    spawnenemyhere $4e00
    setcoords $98 $38
    createpuff
    spawnenemyhere $1200
    setcoords $d8 $38
    createpuff
    spawnenemyhere $0d01
    checkenemycount
    ; Finally make stairs appear
    setcoords $d8 $68
    createpuff
    setdelay 3
    settilehere $50
    playsound SND_SOLVEPUZZLE
    forceend

; Unsets switch trigger 7
interac1_1b_asm:
    push hl
    ld hl,switchState
    ld a,$7f
    and (hl)
    ld (hl),a
    pop hl
    ret

; Boss key in sidescrolling area
interac1_1c:
    checkitemflag
    spawnitem $3102
    forceend

; Spits out fire
; Variables:
; 70 = counter until next spit
interac1_1d:
    push hl
    call checkInteractionInitialized
    jr nz,+
    inc a
    ld (de),a
    ; Correct position
    call interac_getPositionFromY
+
    ld h,d
    ld l,$70
    ld a,(hl)
    or a
    jr z,+
    dec (hl)
    jr nz,++
+
    ; Spit
    ld a,38
    ld (hl),a
    ld bc,$4c01
    call interac_createPart
    ld l,PART_DIRECTION
    ld (hl),$08
++
    pop hl
    ret

    
; Script in bracelet room
; Variables:
; 70 = which row to fire (bit 7 = enable)
interac1_1e:
    jumproomflag $20 noScript
    checkmemory activeTilePos $27

    setcoords $78 $18
    createpuffnodelay
    settilehere $a3
    setcoords $78 $48
    createpuffnodelay
    settilehere $ed
    setdelay 5

    ; Spawn enemies
    setcoords $68 $18
    createpuff
    spawnenemyhere $1600
    setcoords $68 $28
    createpuff
    spawnenemyhere $1600
    setcoords $68 $38
    createpuff
    spawnenemyhere $1600

    setcoords $88 $18
    createpuff
    spawnenemyhere $1600
    setcoords $88 $28
    createpuff
    spawnenemyhere $1600
    setcoords $88 $38
    createpuff
    spawnenemyhere $1600

    ; Fire a specific battern of blasts
    setdelay 8
    setinteractionbyte $70 $81
    setdelay 7
    setinteractionbyte $70 $80
    setdelay 7
    setinteractionbyte $70 $82
    setdelay 7
    setinteractionbyte $70 $80
    setdelay 7
    setinteractionbyte $70 $81
    setdelay 7
    setinteractionbyte $70 $80
    setdelay 7
    setinteractionbyte $70 $82
    setdelay 7
    setinteractionbyte $70 $81
    setdelay 7

    setdelay 8

    ; Delete enemies
    setcoords $68 $18
    createpuff
    writememory $d080 $00
    setcoords $68 $28
    createpuff
    writememory $d180 $00
    setcoords $68 $38
    createpuff
    writememory $d280 $00

    setcoords $88 $18
    createpuff
    writememory $d380 $00
    setcoords $88 $28
    createpuff
    writememory $d480 $00
    setcoords $88 $38
    createpuff
    writememory $d580 $00

    ; Restore path
    setcoords $78 $48
    createpuff
    settilehere $a3

    setdelay 6
    ; Restore chest
    setcoords $78 $18
    createpuff
    setdelay 4
    settilehere $f1
    playsound SND_SOLVEPUZZLE

    forceend

; Asm that runs each frame before the script
interac1_1e_asm:
    ld h,$d0
-
    ld e,$70
    ld a,(de)
    bit 7,a
    ld b,3
    jr z,++
    and $7f
    ld c,a
    ld a,h
    and $f
    cp 3
    jr c,+
    sub 3
+
    cp c
    jr z,++
    ; Force them to fire
    ld l,$84
    ld (hl),9
    ld l,$86
    ld a,$14
    ld (hl),a
    ld l,$ab
    ld (hl),a
    ld b,0
++
    ld l,$87 ; Cooldown timer
    ld (hl),b
    inc h
    ld a,$d6
    cp h
    jr nz,-

    ; Set facing directions
    ld h,$d0
-
    ld l,ENEMY_DIRECTION
    ld (hl),$8
    inc h
    ld a,$d3
    cp h
    jr nz,-
-
    ld l,ENEMY_DIRECTION
    ld (hl),$18
    inc h
    ld a,$d6
    cp h
    jr nz,-

    ; Reset firing row
    ld e,$70
    xor a
    ld (de),a
    ret


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
    forceend

; GENERAL-PURPOSE SCRIPTS

; Ghetto chest: first chest tile it finds contains item XY.
; Variables:
; 78+ = chest contents
interac1_fa:
;    jumproomflag $20 noScript
    asm interac1_fa_init
    fixnpchitbox
--
    checkabutton
    writememory linkInvincibilityCounter 0
    jump3bytemc linkFacingDir 0 ++
    jump3byte --
++
    disableinput
    playsound SND_OPENCHEST
    settilehere $f0
    setroomflag $20
    asm interac1_fa_open
    setdelay 7
    enableinput
    forceend

interac1_fa_init:
    push hl
    ; Copy XY to 70
    ld h,d
    ld l,$78
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ldi (hl),a
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld a,3
    ld (hl),a

    ; Find a chest tile
    ld hl,$cf00
--
    ldi a,(hl)
    cp $f1
    jr z,++
    ld a,l
    and $0f
    cp $0f
    jr nz,+
    inc l
+
    ld a,$b0
    cp l
    jr nz,--
    ; Failure
    call deleteInteraction
    jr +++
++
    ; Found a tile
    ld a,l
    dec a
    call getExpandedPos
    ld a,b
    ld b,a
    call setInteractionPos
+++
    pop hl
    ret

interac1_fa_open:
    push hl
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    sub 8
    ld (de),a
    call getFreeInteractionSlot
    jr nz,++
    ld e,$78
    ld a,(de)
    ld b,a
    inc e
    ld a,(de)
    ld c,a
    ld (hl),$60
    inc l
    ld (hl),b
    inc l
    ld (hl),c
    call copyObjectPosition
++
    pop hl
    ret


; Any tile X turns into Y when it's changed
interac1_fb:
    call checkInteractionInitialized
    jr nz,++
    inc a
    ld (de),a
    ; Store the initial state of all tiles
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ld c,a
    ld hl,$cf00
    ld e,$60
    ld b,1
--
    ldi a,(hl)
    cp c
    jr nz,+
    ld a,(de)
    or b
    ld (de),a
+
    rlc b
    jr nc,--

    inc e
    ld a,$76
    cp e
    ld b,1
    jr nz,--
    ret
++
    ; Check if any tile's state has changed
    ld e,INTERAC_POS_X+1
    ld a,(de)
    ld c,a
    ld hl,$cf00
    ld e,$60
    ld b,1
--
    ld a,(de)
    and b
    ldi a,(hl)
    jr z,+
    ; A tile which must be checked
    cp c
    jr z,+
    ; Tile has been modified
    ld a,(de)
    xor b
    ld (de),a
    push bc
    push de
    push hl
    ld e,INTERAC_POS_Y+1
    ld a,(de)
    ld c,l
    dec c
    call setTile
    pop hl
    pop de
    pop bc
+
    rlc b
    jr nc,--

    inc e
    ld a,$76
    cp e
    ld b,1
    jr nz,--
    ret
    

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
    call interac_createPart
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
