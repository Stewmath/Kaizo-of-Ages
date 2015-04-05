.INCLUDE "include/rominfo.s"
.INCLUDE "include/macros.s"
.INCLUDE "include/defines.s"
.INCLUDE "include/memory.s"

.BANK $c5 SLOT 1

.ORGA $4000

.SECTION "GFX" OVERWRITE

titleScreenGfx:
.incbin "gfx/titlescreen1.bin"

.ENDS
