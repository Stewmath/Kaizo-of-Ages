.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

; Some of lin's patches recreated here.

; The kaizo base ROM isn't using his exact script patch since I want to
; preserve the original content.

; Patches not accounted for here:
; - Lin's vram transfer code (not used anymore)
; - Some other code by Lin which I don't know its purpose
;  - Code at 3ef8 to 3f2c
;  - Code at 3f2d to 3f38 (accounted for, scriptOpcodeFD)
;  - Code at 3f39 to 3f41
;  - Seemingly garbage at 3f42 to 3f43
;  - Code at 3f78 to 3fb0

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
    

.ORGA $3f44

scriptRunnerHook:
    ld e,INTERAC_HACKED
    ld a,(de)
    or a
    ; I only apply this "check bank" hack to my custom interactions.
    jr z,+
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

; Some of Lin's stuff from 3f78-3fb0, not sure what it's for
.ORGA $3fb1

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


; Code for extra scripting opcodes

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

; Code for reloading a script after a "jump" opcode

reloadInteractionScript:
	ld hl,$c300					; $3f39: $21 $00 $c3
	push hl						; $3f3c: $e5
	call $2544					; $3f3d: $cd $44 $25
	pop hl						; $3f40: $e1
	ret							; $3f41: $c9
