.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"


; Bank C, the scripting bank.
; Mostly here are the same patches Lin made, in assembler-friendly form.


.BANK $0c SLOT 1

.ORGA $4103
    ; Index FD of jump table for script opcodes
    .dw scriptOpcodeFD


.ORGA $7f94 ; Freespace start

; 3 byte jump

op_fd00:
	pop hl						; $3f94: $e1
label_0c.203:
	ld b,$03					; $3f95: $06 $03
	ld e,$7d					; $3f97: $1e $7d
label_0c.204:
	ldi a,(hl)					; $3f99: $2a
	ld (de),a					; $3f9a: $12
	inc de						; $3f9b: $13
	dec b						; $3f9c: $05
	jr nz,label_0c.204			; $3f9d: $20 $fa

    jp reloadInteractionScript

op_fd01:
	pop hl						; $3fa3: $e1
	ldi a,(hl)					; $3fa4: $2a
	ld b,a						; $3fa5: $47
	push hl						; $3fa6: $e5
	call $197d					; $3fa7: $cd $7d $19
	pop hl						; $3faa: $e1
	and b						; $3fab: $a0
	jr nz,label_0c.203			; $3fac: $20 $e7
	inc hl						; $3fae: $23
	inc hl						; $3faf: $23
	inc hl						; $3fb0: $23
	ret							; $3fb1: $c9

op_fd02:
	pop hl						; $3fb2: $e1
	ldi a,(hl)					; $3fb3: $2a
	ld b,(hl)					; $3fb4: $46
	ld c,a						; $3fb5: $4f
	ld a,(bc)					; $3fb6: $0a
	inc hl						; $3fb7: $23
	ld b,a						; $3fb8: $47
	ldi a,(hl)					; $3fb9: $2a
	cp b						; $3fba: $b8
	jr z,label_0c.205			; $3fbb: $28 $04
	inc hl						; $3fbd: $23
	inc hl						; $3fbe: $23
	inc hl						; $3fbf: $23
	ret							; $3fc0: $c9
label_0c.205:
	call label_0c.203			; $3fc2: $cd $95 $7f
	ret							; $3fc6: $c9


op_fd03:
	pop hl						; $3fc7: $e1
	ldi a,(hl)					; $3fc8: $2a
	ld b,a						; $3fc9: $47
	ldi a,(hl)					; $3fca: $2a
	push hl						; $3fcb: $e5
	call $198a					; $3fcc: $cd $8a $19
	pop hl						; $3fcf: $e1
	ld b,a						; $3fd0: $47
	ldi a,(hl)					; $3fd1: $2a
	and b						; $3fd2: $a0
	jr nz,label_0c.203			; $3fd3: $20 $c0
	inc hl						; $3fd5: $23
	inc hl						; $3fd6: $23
	inc hl						; $3fd7: $23
	ret							; $3fd8: $c9

; Run arbitrary ASM
op_fd04:
    pop hl
    ldh a,(z_activeBank)
    push af
    ld bc,$0098
    push bc
    ldi a,(hl)
    ld e,a
    ldi a,(hl)
    ld c,a
    ldi a,(hl)
    ld b,a
    push bc
    ld a,e
    jp $0099
    ; Creative way to call a function between banks while preserving hl
    ; I wanna preserve hl for more "custom opcodes".


; Create a new interaction at this interaction's coords
op_fd05:
    pop hl
    ldi a,(hl)
    ld c,a
    ldi a,(hl)
    ld b,a
    push hl
    call createInteraction
    pop hl
    ret

scriptOpcodeFDTable:
    .dw op_fd00
    .dw op_fd01
    .dw op_fd02
    .dw op_fd03
    .dw op_fd04
    .dw op_fd05
