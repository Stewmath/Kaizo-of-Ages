
.BANK $3f SLOT 1
; Function called whenever text is to be loaded.
; NOTE: Addresses in comments are wrong for some reason. :/
.ORGA $4ff5
	push de						; $0feb: $d5
;	call $4f59					; $0fec: $cd $59 $4f
    call textLoaderHook
	call $1949					; $0fef: $cd $49 $19
;   ...

.ORGA $7d0a ; freespace start
    
; This hook's responsibilities are to return in hl the address of the text,
; and write to d0d4 the corresponding bank.
; Normally function 4f59 does this, but I want to have some text farther back in the ROM.
textLoaderHook:
    ld a,(textIndex_h)
    cp $80
    jr nc,++

    ; Indices below $80 are handled normally
	call $4f59
    ret
++
    ; Indices above $80 have special handling
    ld a,:customTextTable
    ld ($d0f2),a    ; This determines which bank function 195d will read from
    ld hl,customTextTable
    ld a,(textIndex_h)
    sub $80
    ld b,a
    ld a,(textIndex_l)
    ld c,a
    add hl,bc
    add hl,bc
    add hl,bc

    call $195d      ; Read a byte from [$d0f2]:hl into a and increment hl
    ld b,a
    call $195d
    ld c,a
    call $195d
    ld h,a
    ld l,c

    ld a,b
    ld ($d0d4),a
    ret
