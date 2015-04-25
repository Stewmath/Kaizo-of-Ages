.include "include/rominfo.s"
.include "include/macros.s"
.include "include/textDirectives.s"

.BANK $c0 SLOT 1

; Custom text table
.ORGA $4000

customTextTable:
    3BytePointer tx_7c00
    3BytePointer tx_7c01
    3BytePointer tx_7c02
    3BytePointer tx_7c03
    3BytePointer tx_7c04
    3BytePointer tx_7c05
    3BytePointer tx_7c06
    3BytePointer tx_7c07
    3BytePointer tx_7c08
    3BytePointer tx_7c09
    3BytePointer tx_7c0a
    3BytePointer tx_7c0b
    3BytePointer tx_7c0c
    3BytePointer tx_7c0d
    3BytePointer tx_7c0e
    3BytePointer tx_7c0f
    3BytePointer tx_7c10
    3BytePointer tx_7c11
    3BytePointer tx_7c12
    3BytePointer tx_7c13
    3BytePointer tx_7c14
    3BytePointer tx_7c15
    3BytePointer tx_7c16
    3BytePointer tx_7c17
    3BytePointer tx_7c18
    3BytePointer tx_7c19
    3BytePointer tx_7c1a
    3BytePointer tx_7c1b
    3BytePointer tx_7c1c
    3BytePointer tx_7c1d
    3BytePointer tx_7c1e
    3BytePointer tx_7c1f
    3BytePointer tx_7c20
    3BytePointer tx_7c21
    3BytePointer tx_7c22
    3BytePointer tx_7c23

; Indices used for custom signs
.ORGA $4300

    3BytePointer tx_7d00
    3BytePointer tx_7d01
    3BytePointer tx_7d02
    3BytePointer tx_7d03
    3BytePointer tx_7d04
    3BytePointer tx_7d05
    3BytePointer tx_7d06
    3BytePointer tx_7d07
    3BytePointer tx_7d08
    3BytePointer tx_7d09
    3BytePointer tx_7d0a

; Custom text start
tx_7c00:
    ln "No More!"
    ln "NO MORE!!!"
    fn "Nope nope nope"

tx_7c01:
    ln "Who're you?"
    ln "An adventurer..?"
    ln "You don't wanna"
    ln "go in there,"
    ln "man. Trust me."
    ln "I'll be having"
    ln "nightmares over"
    fn "this..."
tx_7c02:
    ln "Heheh... you"
    ln "won't be needing"
    fn "that sword."
tx_7c03:
tx_7c04:
tx_7c05:
tx_7c06:
tx_7c07:
tx_7c08:
tx_7c09:
tx_7c0a:
tx_7c0b:
tx_7c0c:
tx_7c0d:
tx_7c0e:
tx_7c0f:
tx_7c10:
tx_7c11:
tx_7c12:
tx_7c13:
tx_7c14:
tx_7c15:
tx_7c16:
tx_7c17:
tx_7c18:
tx_7c19:
tx_7c1a:
tx_7c1b:
tx_7c1c:
tx_7c1d:
tx_7c1e:
tx_7c1f:
tx_7c20:
tx_7c21:
tx_7c22:
tx_7c23:

    end


tx_7d00:
    ln "You can't read"
    fn "it from here!"
tx_7d01:
    ln "Hello there!"
    ln "Before starting"
    ln "to play this"
    ln "hack, here's a"
    ln "few things you"
    ln "should know."
    ln "#1: For the most"
    ln "part, only the"
    ln "dungeon and"
    ln "indoor layouts"
    ln "are modified in"
    ln "this hack."
    ln "It's like a"
    ln "Master Quest"
    ln "kind of thing."
    ln "#2: This is a"
    ln "demo going up"
    ln "only to the end"
    ln "of the first"
    ln "dungeon."
    fn "Lastly..."
tx_7d02:
    ln "Welcome to"
    fn "Kaizo of Ages."

tx_7d03:
    ln "If I may offer"
    ln "some advice,"
    ln "approaching from"
    ln "up and to the"
    ln "side will get"
    ln "you closer."
    ln "Remember this"
    fn "quirk."
tx_7d04:
    ln "It's a shame you"
    ln "don't have the"
    ln "cane of somaria"
    ln "yet. But you can"
    ln "make do with"
    fn "what you have."
tx_7d05:
tx_7d06:
tx_7d07:
tx_7d08:
tx_7d09:
tx_7d0a:
    end
