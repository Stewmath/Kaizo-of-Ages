.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

; Bank 16 contains chest ID information.
; Chest ID information works as follows:
; Byte 0 - upper nibble is "effect", lower nibble unknown (typically 8 or 9?)
;   effect 0 - nothing
;   effect 1 - poof in
;   effect 2 - fall in
;   effect 3 - get from chest
;   effect 4 - doesn't appear
; Byte 1 - ??? (ZOCF lists it as "gfx")
; Byte 2 - text (low byte; high byte is zero)
; Byte 3 - item gfx

.BANK $16 SLOT 1

.ORGA $56ee
; 3102 - Boss key, no special effect
.db $09 $00 $1b $43
