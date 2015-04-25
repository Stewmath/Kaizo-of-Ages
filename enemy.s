.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

; Stuff relating to enemy hacks are here.

.BANK $0f SLOT 1



; PUMPKIN HEAD

; Pumpkin head AI code starts at f:6192
;   7801: Body AI at 626c

; Code ran when state < 8
; This is "common code" among all components of pumpkin head
.ORGA $61ad
    JpAcrossBank pumpkinParentMain


.ORGA $626c
; Start of pumpkin body AI's code
; Replacing this with bank transfer code
    JpAcrossBank pumpkinBodyMain

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
    

; PUMPKIN HEAD

; object 7800
pumpkinParentMain:
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
    ld b,$03
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
    ld l,ENEMY_STATE
    inc (hl)
    ld l,$9c
    ld a,$01
    ldd (hl),a
    ld (hl),a
    ld l, ENEMY_DIRECTION
    ld (hl),$10
    ; Set byte 9a to 83
    call $1e72
    ld c,$0c
    CallAcrossBank b0f_setZAboveScreen
    ld a,$0d
    jp setEnemyAnimation

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
    ld (hl),$1e
    ld a,$1e
    call setScreenShakeCounter
    ld a,SND_DOORCLOSE
    jp playSound

; Standing still after falling
pumpkinBodyA:
;    JpAcrossBank_pv $0f $62c0
    call bfc_decEnemyCounter1
    ret nz
    ; Start custom state for splitting pumpkin head
    ld l,ENEMY_STATE
    ld (hl),$14
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
pumpkinBody10:
    JpAcrossBank_pv $0f $63bf
pumpkinBody11:
    JpAcrossBank_pv $0f $63c0
pumpkinBody12:
    JpAcrossBank_pv $0f $63ce
pumpkinBody13:
    JpAcrossBank_pv $0f $63de


pumpkinBody14:
    ; Set state 0b
    CallAcrossBank_pv $0f $670f
    JpAcrossBank_pv $0f $630b
pumpkinBody15:
pumpkinBody16:
pumpkinBody17:
pumpkinBody18:
