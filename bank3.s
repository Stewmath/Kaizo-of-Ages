.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

.BANK $03 SLOT 1

; Code for different titlescreen graphics is here.

.ORGA $4dc1 ; Snippet of function which loads titlescreen graphics
	ld a,$02					; $0dc1: $3e $02
;	call $0626					; $0dc3: $cd $26 $06
    call titleScreenLoaderHook

.ORGA $7ebd ; Freespace start

titleScreenLoaderHook:
    call $0626 ; Loads the normal graphics for titlescreen

    ; Now replace some of it with my stuff
    ld hl,titleScreenGfx
    ld c,:titleScreenGfx
    ld de,$8800
    ld b,$7f
    call dmaTransfer

    ld hl,titleScreenGfx+$800
    ld c,:titleScreenGfx
    ld de,$9000
    ld b,$7f
    call dmaTransfer
    ret
