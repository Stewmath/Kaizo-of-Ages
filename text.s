.include "include/rominfo.s"
.include "include/macros.s"
.include "include/textDirectives.s"

.BANK $c0 SLOT 1

; Custom text table
.ORGA $4000

customTextTable:
    3BytePointer walrusText

; Custom text start
walrusText:
    ln "Walrus Wal" diamond up down
    tx "Yo Yo" end
