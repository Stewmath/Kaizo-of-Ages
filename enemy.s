.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

; Stuff relating to enemy hacks are here.

.BANK $0f SLOT 1



; PUMPKIN HEAD

; Pumpkin head AI code starts at f:6192

.ORGA $6192
    JpAcrossBank pumpkinAI


.ORGA $7f90 ; Freespace start


; Bank FC holds custom enemy code.

.BANK $fc SLOT 1

.ORGA $4000

; General functions

bfc_decEnemyCounter1:
    ld h,d
    ld l, ENEMY_COUNTER1
    dec (hl)
    ret

bfc_wtf1:
	bit 7,a						; $0546: $cb $7f
	jr nz,label_0f.041			; $0548: $20 $03
	ld ($cc1d),a				; $054a: $ea $1d $cc
label_0f.041:
	ld a,b						; $054d: $78
	or a						; $054e: $b7
	call nz,$050b				; $054f: $c4 $0b $05
	ld a,$f0					; $0552: $3e $f0
	call playSound
	xor a						; $0557: $af
	ld ($cbca),a				; $0558: $ea $ca $cb
	dec a						; $055b: $3d
	ld ($cc35),a				; $055c: $ea $35 $cc
	ld hl,$cc93					; $055f: $21 $93 $cc
	set 7,(hl)					; $0562: $cb $fe
	ld a,($cd00)				; $0564: $fa $00 $cd
	and $01						; $0567: $e6 $01
	ret nz						; $0569: $c0
	ld a,$0b					; $056a: $3e $0b
	ld ($cc4f),a				; $056c: $ea $4f $cc
	ld a,$16					; $056f: $3e $16
	ld ($cc51),a				; $0571: $ea $51 $cc
	ld hl,$d008					; $0574: $21 $08 $d0
	ld a,($cd02)				; $0577: $fa $02 $cd
	ldi (hl),a					; $057a: $22
	swap a						; $057b: $cb $37
	rrca						; $057d: $0f
	ld (hl),a					; $057e: $77
	ret							; $057f: $c9

bfc_disableInput:
    ld a,$01
    ld ($cc8a),a
    ret
bfc_enableInput:
    xor a
    ld ($cc8a),a
    ld ($cc02),a
    ret
    

; PUMPKIN HEAD

pumpkinAI:
    ld a,c
    or a
    jr z,++
    sub 3
    ret c
    jr z,+
    jr ++
+
    call pumpkinHealthZero
    ret z
++  ; Normal handling
    ld e,ENEMY_SUBID
    ld a,(de)
    ld b,a
    ld e,ENEMY_STATE
    ld a,(de)
    cp 8
    jr c,+
; Part-specific code
    dec b
    ld a,b
    rst $00
.dw pumpkinBodyMain
.dw pumpkinGhostMain
.dw pumpkinHeadMain

; Common code
+
    ld e,ENEMY_STATE
    ld a,(de)
    rst $00
.dw pumpkinParent0
.dw pumpkinParent1
.dw pumpkinParent2
.dw pumpkinParent3
.dw pumpkinParent4
.dw pumpkinParent5
.dw pumpkinParent6
.dw pumpkinParent7

pumpkinParent0:
    ld e,ENEMY_SUBID
    ld a,(de)
    or a
    jr z,+
    JpAcrossBank $0f $4364
+
    ld h,d
    ld l,ENEMY_STATE
    inc (hl)
    call bfc_disableInput
    ld a,$78
    ld b,0
    jp bfc_wtf1

pumpkinParent1:
;    JpAcrossBank_pv $0f $61cc
    ; Something something
    ld a,($cc93)
    or a
    ret nz
    ; Check 3 enemy slots available
    ld b,$09
    call checkXEnemySlotsAvailable
    ret nz

    ; Create the body
    call getFreeEnemySlot_noIncrement
    ld b,$78
    ld (hl),b
    inc l
    inc (hl)
    call copyObjectPosition
    ld c,h
    ; Create the ghost
    call getFreeEnemySlot_noIncrement
    ld (hl),b
    inc l
    ld (hl),$02
    ld l,ENEMY_RELATEDOBJ1
    ld (hl),$80
    inc l
    ld (hl),c
    call copyObjectPosition
    ; Dunno what this is for
    ld l,$80
    ld e,l
    ld a,(de)
    ld (hl),a
    ld a,h
    ld h,c
    ; Referring to body again
    ld l,ENEMY_RELATEDOBJ1+1
    ldd (hl),a
    ld (hl),$80
    ; Create head
    call getFreeEnemySlot_noIncrement
    ld (hl),b
    inc l
    ld (hl),$03
    ld l,ENEMY_RELATEDOBJ1
    ld (hl),$80
    inc l
    ld (hl),c
    call copyObjectPosition
    ld a,h
    ld h,c
    ; Referring to body again
    ld l,ENEMY_RELATEDOBJ2+1
    ldd (hl),a
    ld (hl),$80

    jp deleteEnemy

    

; Appears to be used when the head is picked up
pumpkinParent2:
    JpAcrossBank_pv $0f $620d

pumpkinParent3:
pumpkinParent4:
pumpkinParent5:
pumpkinParent6:
pumpkinParent7:
    ret


; object 7801
; Some variables:
; 7a+ = custom variable; Y speed when splitting
; 7c = "visibility"; implemented by setting Y below the screen.
pumpkinBodyMain:
    ld e,$84
    ld a,(de)
    sub 8
    rst_jumpTable
.dw pumpkinBody8
.dw pumpkinBody9
.dw pumpkinBodyA
.dw pumpkinBodyB
.dw pumpkinBodyC
.dw pumpkinBodyD
.dw pumpkinBodyE
.dw pumpkinBodyF
.dw pumpkinBody10
.dw pumpkinBody11
.dw pumpkinBody12
.dw pumpkinBody13
.dw pumpkinBody14
.dw pumpkinBody15
.dw pumpkinBody16
.dw pumpkinBody17
.dw pumpkinBody18

; Initialization
pumpkinBody8:
;    JpAcrossBank_pv $0f $6288
    ld bc,$0106
    CallAcrossBank b0f_createShadow
    ld h,d
    ld l,$9c
    ld a,$01
    ldd (hl),a
    ld (hl),a
    ld l, ENEMY_DIRECTION
    ld (hl),$18
    ; Set byte 9a to 83
    call $1e72
    ld a,$0e
    call setEnemyAnimation

    ld h,d
    ld l,$b6
    ld a,(hl)
    or a
    jr nz,+
    ; Real pumpkin head
    ld c,$0c
    CallAcrossBank b0f_setZAboveScreen
    ld h,d
    ld l,ENEMY_STATE
    inc (hl)
    ret
+   ; Fake pumpkin head
    ld l,ENEMY_STATE
    ld (hl),$14
    ld l,ENEMY_COUNTER1
    ld (hl),1
    ret

; Falling
pumpkinBody9:
;    JpAcrossBank_pv $0f $62a5
    ld a,$10
    call updateObjectSpeedZ
    ret nz
    ; Done with state 8, setup for state 9
    ld h,d
    ld l,ENEMY_STATE
    inc (hl)
    ld l, ENEMY_COUNTER1
    ld (hl),$30
    ld a,$15
    call setScreenShakeCounter
    ld a,SND_DOORCLOSE
    jp playSound

; Standing still after falling
pumpkinBodyA:
;    JpAcrossBank_pv $0f $62c0
    call bfc_decEnemyCounter1
    ret nz

    ld l,ENEMY_STATE
    ld (hl),$14
    ld l,ENEMY_COUNTER1
    ld (hl),2

    call getRandomNumber
    cp $55
    jr nc,+
    xor a
    jr +++
+
    cp $55*2
    jr nc,+
    ld a,1
    jr +++
+
    ld a,2
+++
    ld e,$91
    ld (de),a
    ; Start making clones
    ld b,2
--
    ; Create the body
    call getFreeEnemySlot_noIncrement
    ld (hl),$78
    inc l
    inc (hl)
    call copyObjectPosition
    ld c,h
    ld (hl),$80
    ; Create head
    call getFreeEnemySlot_noIncrement
    ld (hl),$78
    inc l
    ld (hl),$03
    ld l,ENEMY_RELATEDOBJ1
    ld (hl),$80
    inc l
    ld (hl),c
    call copyObjectPosition
    ld a,h
    ld h,c
    ; Referring to body again
    ld l,ENEMY_RELATEDOBJ2+1
    ldd (hl),a
    ld (hl),$80

    ld e,$91
    ld a,(de)
    cp b
    jr nz,+
    ; Copy ghost to this pumpkin head
    ; First set the ghost's reference for the body
    ld c,h
    push hl
    ld a,OBJ_RELATEDOBJ1
    call getRelatedObject1Var
    ld (hl),$80
    inc l
    ld (hl),c
    pop hl
    ; Now set the body's reference for the ghost
    ld e,ENEMY_RELATEDOBJ1
    ld l,e
    ld a,(de)
    ldi (hl),a
    inc e
    ld a,(de)
    ld (hl),a
    xor a
    ld (de),a
    dec e
    ld (de),a
+

    ld a,b
    cp 2
    push bc
    jr z,+
    ld bc,$60
    jr ++
+
    ld bc,-$60
    ; Start invisible
    ld l,$b5
    ld (hl),1
    ld l,ENEMY_POS_Y+1
    ld a,$80
    add (hl)
    ld (hl),a
++
    ; Set vertical speed for clone pumpkin
    ld l,$b6
    ld (hl),c
    inc l
    ld (hl),b
    pop bc

    dec b
    jr nz,--
+
    ret

; Walking
pumpkinBodyB:
    JpAcrossBank_pv $0f $62d2

pumpkinBodyC:
    JpAcrossBank_pv $0f $6307
pumpkinBodyD:
    JpAcrossBank_pv $0f $634d
pumpkinBodyE:
    JpAcrossBank_pv $0f $6393
pumpkinBodyF:
    JpAcrossBank_pv $0f $63b3

; Body destroyed
pumpkinBody10:
;    JpAcrossBank_pv $0f $63bf
    ret

pumpkinBody11:
    JpAcrossBank_pv $0f $63c0
pumpkinBody12:
    JpAcrossBank_pv $0f $63ce
pumpkinBody13:
    JpAcrossBank_pv $0f $63de


; Preparation for state 15
pumpkinBody14:
    call bfc_decEnemyCounter1
    ret nz

    ld h,d
    ld l,e
    inc (hl)
    ld l,ENEMY_COUNTER1
    ld (hl),90

    ld l,ENEMY_RELATEDOBJ1
    ld a,(hl)
    or a
    ret z
    ld a,SND_TELEPORT
    call playSound
    ret

; Clones move up and down respectively
pumpkinBody15:
    call bfc_decEnemyCounter1
    jr z,+
    ; Pumpkin head clones move up or down, at the start of the fight
    ld h,d
    ld l,$b6
    ldi a,(hl)
    ld b,(hl)
    ld c,a
    ld l,ENEMY_POS_Y
    add (hl)
    ld (hl),a
    inc l
    ld a,b
    adc (hl)
    add $80
    ld (hl),a

    ld l,$b5
    ld a,1
    xor (hl)
    ld (hl),a
    ret
+
    ld (hl),60
    ld l,ENEMY_STATE
    inc (hl)

    ld h,d
    ld l,$b5
    ld a,(hl)
    or a
    jr z,+
    ld l,ENEMY_POS_Y+1
    ld a,$80
    add (hl)
    ld (hl),a
+

    ld l,ENEMY_RELATEDOBJ1
    ld a,(hl)
    or a
    jr nz,+
    ; Fake pumpkin head
    ld l,ENEMY_HEALTH
    ld (hl),6
    ret
+   ; Real pumpkin head
    ld l,ENEMY_HEALTH
    ld (hl),8
    ld a,SND_DING
    jp playSound


pumpkinBody16:
    call bfc_decEnemyCounter1
    ret nz
    ld l,ENEMY_RELATEDOBJ1
    ld a,(hl)
    or a
    jr z,+

    ; Only the main pumpkin will run this code
    ld a,MUS_BOSS
    ld (activeMusic),a
    call playSound
    call bfc_enableInput
    ; Make torches try to kill you
    ld bc,$5001
    call getFreeEnemySlot_noIncrement
    jr nz,+
    ld (hl),b
    inc l
    ld (hl),c
    ld l,ENEMY_POS_Y+1
    ld (hl),$09 ; Torch index

+
    ld h,d
    ; Not entirely sure what this does, but it prevents them from jumping after firing the beam
    CallAcrossBank_pv $0f $670f
    ; Set state 0c (fire a beam)
    ld h,d
    ld l,ENEMY_STATE
    ld (hl),$0c
    JpAcrossBank_pv $0f $62fb

pumpkinBody17:
pumpkinBody18:
    ret

pumpkinHeadMain:
    ld e,ENEMY_STATE
    ld a,(de)
    sub 8
    rst_jumpTable
.dw pumpkinHead8
.dw pumpkinHead9
.dw pumpkinHeadA
.dw pumpkinHeadB
.dw pumpkinHeadC
.dw pumpkinHeadD
.dw pumpkinHeadE
.dw pumpkinHeadF
.dw pumpkinHead10
.dw pumpkinHead11
.dw pumpkinHead12
.dw pumpkinHead13
.dw pumpkinHead14
.dw pumpkinHead15
.dw pumpkinHead16

; Initialization
pumpkinHead8:
    ld h,d
    ld l,e
    inc (hl) ; Increment state
    ld l,ENEMY_DIRECTION
    ld (hl),$ff
    ld l,$a5
    ld (hl),$5d
    ld l,$a6
    ld (hl),$06
    call $1e69  ; Sets visibility

    ld a,$36
    call getRelatedObject1Var
    ld a,(hl)
    or a
    jr nz,+
    ; Normal pumpkin head
    ld c,$30
    CallAcrossBank b0f_setZAboveScreen
    jr ++
+   ; Pumpkin head clone
    ld h,d
    ld l,ENEMY_POS_Z+1
    ld (hl),$f0
++
    ld a,4
    ld e,$88
    ld (de),a
    ; The following isn't quite the same as what was done originally
    ; It had some weird lookup table or something. *shrug*
    ; Had to modify it to make him face left though.
    ; The A7 variable appears to be 6 for horizontal directions, and 8 for vertical.
    ld a,$08
    ld e,$a7
    ld (de),a
    ld a,$06
    jp setEnemyAnimation


pumpkinHead9:
;    JpAcrossBank_pv $0f $65b8
    ld a,$10
    call updateObjectSpeedZ
    ld h,d
    ld l,ENEMY_POS_Z+1
    ld a,(hl)
    cp $f0
    ret c
    ld (hl),$f0
    ld l,ENEMY_STATE
    inc (hl)
    ret
    ; Normally would change music here

pumpkinHeadA:
    JpAcrossBank_pv $0f $65c4
pumpkinHeadB:
    JpAcrossBank_pv $0f $65f6
pumpkinHeadC:
    JpAcrossBank_pv $0f $660a
pumpkinHeadD:
    JpAcrossBank_pv $0f $6632
pumpkinHeadE:
    JpAcrossBank_pv $0f $663d
pumpkinHeadF:
    JpAcrossBank_pv $0f $6660

; Body just been destroyed
pumpkinHead10:
    JpAcrossBank_pv $0f $666f

pumpkinHead11:
    JpAcrossBank_pv $0f $667c
pumpkinHead12:
    JpAcrossBank_pv $0f $668a
pumpkinHead13:
    JpAcrossBank_pv $0f $669d
pumpkinHead14:
    JpAcrossBank_pv $0f $66ad
pumpkinHead15:
    JpAcrossBank_pv $0f $66c3
pumpkinHead16:
    JpAcrossBank_pv $0f $66f0



pumpkinGhostMain:
    JpAcrossBank_pv $0f $63ec


pumpkinHealthZero:
;    JpAcrossBank $0f $6757
    ld e,ENEMY_SUBID
    ld a,(de)
    dec a
    jr z,pumpkinBodyHealthZero
    dec a
    jr z,pumpkinGhostHealthZero
pumpkinHeadHealthZero:
    call createPuff
    ld h,d
    ld l,ENEMY_STATE
    ldi a,(hl)
    cp 2
    jr nz,+
    ld a,(hl)
    cp 2
    call c,$2c43
+
    jp deleteEnemy
pumpkinGhostHealthZero:
    ; Kill everything
    ld h,$d0
    ld l,ENEMY_HEALTH
--
    ld (hl),0
    inc h
    ld a,$e0
    cp h
    jr nz,--
    ; Normal code
    ld e,$a4
    ld a,(de)
    or a
    jr nz,+
    CallAcrossBank_pv $0f $446d
    ld l,ENEMY_RELATEDOBJ2+1
    ld h,(hl)
    CallAcrossBank_pv $0f $445e
+
    CallAcrossBank_pv $0f $44f0
    xor a
    ret

pumpkinBodyHealthZero:
    ld h,d
    ld l,ENEMY_RELATEDOBJ1
    ld a,(hl)
    or a
    jr z,++
; Main pumpkin head
    ld a,OBJ_HEALTH
    call getRelatedObject1Var
    ld a,(hl)
    or a
    jp z,deleteEnemy
    ld h,d
    ld l,ENEMY_HEALTH
    ld (hl),8
    ld l,ENEMY_STATE
    ld (hl),$10
    ld l,ENEMY_POS_Z+1
    ld (hl),0
    ld a,OBJ_STATE
    call getRelatedObject1Var
    ld (hl),$0f
    ld a,OBJ_STATE
    call getRelatedObject2Var
    ld (hl),$10
    call createPuff
    jp setObjectInvisible
++
; Fake pumpkin
    ; Delete head
    ld a,OBJ_HEALTH
    call getRelatedObject2Var
    ld (hl),0
    ld l,$a4
    res 7,(hl)
    ; Create explosion
    ld bc,$f010
    call pumpkinCreateExplosion
    ld l,ENEMY_VISIBLE
    res 7,(hl)
    ld bc,$1010
    call pumpkinCreateExplosion
    ld l,ENEMY_VISIBLE
    res 7,(hl)
    ld bc,$10f0
    call pumpkinCreateExplosion
    ld bc,$f0f0
    call pumpkinCreateExplosion

    jp deleteEnemy

pumpkinCreateExplosion:
    push bc

    call getFreePartSlot
    ld bc,$4700
    ld (hl),b
    inc l
    ld (hl),c
    ld l,PART_STATE
    ld (hl),2
    ld l,$e4
    ld (hl),$c7
    inc l
    ld (hl),4
    call copyObjectPosition

    ld l,$da
    ld (hl),$ff
    pop bc

    ld l,PART_POS_Y+1
    ld a,(hl)
    add b
    ld (hl),a
    ld l,PART_POS_X+1
    ld a,(hl)
    add c
    ld (hl),a

    ; 1 heart of damage
    ld l, PART_DAMAGE
    ld (hl), -8
    ret
