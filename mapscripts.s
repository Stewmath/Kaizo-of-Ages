; This file contains both map script and single-tile change information.


.BANK $04 SLOT 1

; SINGLE-TILE CHANGE:
; format: map bitmask position newvalue


.ORGA $636c
; Single-tile change table for the past

; The 2 dirt tiles outside the village
.db $59 $02 $30 $3a
.db $59 $02 $31 $3a

.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db $00 $00 $00 $00
.db 0 0


; MAP SCRIPTS: used for big changes

.ORGA $6437

; Table of primary map scripts



.ORGA $7ef2 ; freespace start
