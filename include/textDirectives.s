.macro nl
.db $01
.endm

.macro circle
.db $10
.endm

.macro club
.db $11
.endm

.macro diamond
.db $12
.endm

.macro spade
.db $13
.endm

.macro heart
.db $14
.endm

.macro up
.db $15
.endm

.macro down
.db $16
.endm

.macro left
.db $17
.endm

.macro right
.db $18
.endm

.macro x
.db $19
.endm

.macro doublequote
.db $1a
.endm

.macro topleftbox
.db $1b
.endm

.macro bottomrightbox
.db $1c
.endm

.macro backquote
.db $1e
.endm

.macro circlesymbol
.db $1f
.endm


; Other directives
; 05 - INSANE SCREWYNESS
; 06 - takes 1 param? special characters?
; 07 - instacrash?
; 08 - repeat?
; 09 - some kind of specially formatted text?
; 0a - crash?
; 0b - sound effect?
; 0c - INSANE SCREWYNESS
; 0d - takes 1 parameter ?
; 0e - sound effect?
; 0f - crash?






.macro ln
    .ASC \1
    .IF NARGS >= 2
    \2
    .ENDIF
    .IF NARGS >= 3
    \3
    .ENDIF
    .IF NARGS >= 4
    \4
    .ENDIF
    .IF NARGS >= 5
    \5
    .ENDIF
    .IF NARGS >= 6
    \6
    .ENDIF

    nl
.endm

.macro tx
    .ASC \1
    .IF NARGS >= 2
    \2
    .ENDIF
    .IF NARGS >= 3
    \3
    .ENDIF
    .IF NARGS >= 4
    \4
    .ENDIF
    .IF NARGS >= 5
    \5
    .ENDIF
    .IF NARGS >= 6
    \6
    .ENDIF
.endm


.macro end
    .db 0
.endm
