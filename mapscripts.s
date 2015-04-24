.include "include/rominfo.s"
.include "include/macros.s"

; This file contains both map script and single-tile change information.


.BANK $04 SLOT 1

; Each entry is for a group
.ORGA $632e
.dw $633e
.dw $636c
.dw $63a2
.dw $63a8
;.dw $63ba
.dw dungeonTileChanges
.dw $63d0
.dw $6426
.dw $642a


; SINGLE-TILE CHANGE:
; format: map bitmask position newvalue


; MAP SCRIPTS: used for big changes

.ORGA $6437

; Table of primary map scripts



.ORGA $7ef2 ; freespace start

dungeonTileChanges:
    .db $56 $20 $44 $a0
    .db $59 $80 $a3 $a0
    .db $4b $80 $54 $a0
    .db $4b $80 $55 $1d
    .db $c5 $20 $57 $52

    ; Start of custom stuff
    .db $15 $80 $3e $a0
    .db $1f $02 $73 $f0

    .db $00 $00
