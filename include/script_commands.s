.MACRO jump2byte
    .db \1>>8
    .db \1&$ff
.ENDM

.MACRO setvisible
    .db $80 \1
.ENDM

.MACRO set45
    .db $81 \2
.ENDM

; Parameters: BANK, SRC
; Bytes are copied to c300
.MACRO loadscript
    .db $83 \1
    .dw \2
.ENDM

.MACRO spawncommon
    .db $84
    .db \1>>8 \1&$ff
    .db \2 \3
.ENDM

.MACRO spawnenemy
    .db $85
    .db \1>>8 \1&$ff
    .db \2 \3
.ENDM

.MACRO showpasswordscreen
    .db $86
    .db \1
.ENDM

.MACRO setcoords
    .db $88 \1 \2
.ENDM

.MACRO set49
    .db $89 \1
.ENDM

.MACRO set50
    .db $8b \1
.ENDM

.MACRO loadd6677
    .db $8d \1 \2
.ENDM

.MACRO setinteractionbyte
    .db $8e \1 \2
.ENDM

.MACRO loadsprite
    .db $8f \1
.ENDM

.MACRO checklinkxtoma
    .db $90 \1
.ENDM

.MACRO setmemory
    .db $91
    .dw \1
    .db \2
.ENDM

.MACRO ormemory
    .db $92
    .dw \1
    .db \2
.ENDM

.MACRO addinteractionbyte
    .db $94
    .db \1 \2
.ENDM

.MACRO set49extra
    .db $96
    .db \1
.ENDM

.MACRO settextidjp
    .db $97
    .db \1>>8 \1&$ff
.ENDM

; Sometimes only takes 1 argument ??
.MACRO showtext
    .db $98
    .db \1>>8 \1&$ff
.ENDM


.MACRO checktext
    .db $99
.ENDM

.MACRO settextid
    .db $9c
    .db \1>>8 \1&$ff
.ENDM

.MACRO showloadedtext
    .db $9d
.ENDM

.MACRO checkabutton
    .db $9e
.ENDM

; If the room flag AND arg1 is nonzero, it jumps to the specified relative address.
; I don't think this will work if the address in question is not loaded into the
; $100 bytes at c300 (but if it's in bank C, go nuts).
.MACRO checkroomflag
    .db $b0 \1
.ENDM

.MACRO orroomflag
    .db $b1 \1
.ENDM

.MACRO setglobalflag
    .db $b6 \1
.ENDM

.MACRO disableinput
    .db $bd
.ENDM

.MACRO enableinput
    .db $be
.ENDM

.MACRO callscript
    .db $c0
    .dw \1
.ENDM

.MACRO checkitemflag
    .db $cd
.ENDM

.MACRO checkspecialflag
    .db $cf
.ENDM

.MACRO checkenemycount
    .db $d2
.ENDM

.MACRO checkmemorybit
    .db $d3
    .db \1
    .dw \2
.ENDM

.MACRO checkmemory
    .db $d5
    .dw \1
    .db \2
.ENDM

.MACRO spawnnpc
    .db $de
.ENDM

.MACRO spawnitem
    .db $dd
    .db \1>>8 \1&$ff
.ENDM

.MACRO giveitem
    .db $de
    .db \1>>8 \1&$ff
.ENDM

.MACRO asm15
    .db $e0
    .dw \1
.ENDM

.MACRO createpuff
    .db $e2
.ENDM

.MACRO playsound
    .db $e3
    .db \1
.ENDM

.MACRO setmusic
    .db $e4
    .db \1
.ENDM

.MACRO setcc8a
    .db $e5
    .db \1
.ENDM

.MACRO spawnenemyhere
    .db $e6
    .db \1>>8 \1&$ff
.ENDM

.MACRO settile
    .db $e7
    .db \1 \2
.ENDM

.MACRO settilehere
    .db $e8
    .db \1
.ENDM

.MACRO shakescreen
    .db $ea
    .db \1
.ENDM

; $eb relates to npc collisions, & allows you to talk to them? Perhaps allows checkabutton to work?
.MACRO fixnpchitbox
    .db $eb
.ENDM

; Moves an npc a set distance.
; Arg determines length of time.
; Dx50 determines speed.
; $21 and $14, respectively, will move an npc one tile.
; Some values:
; 14 - forward
; 15 - right
; 16 - backward
; 17 - left
; 1c - back fast
; 1d - left fast
; 1e - forward fast
; 1f - right fast
; 28 - forward faster
.MACRO movenpcup
    .db $ec \1
.ENDM
.MACRO movenpcright
    .db $ed \1
.ENDM
.MACRO movenpcdown
    .db $ee \1
.ENDM
.MACRO movenpcleft
    .db $ef \1
.ENDM

.MACRO setdelay
    .db $f0 + \1
.ENDM

.MACRO jump3byte
    .db $fd $00
    .db :\1
    .dw \1
.ENDM

.MACRO jumproomflag
    .db $fd $01
    .db \1
    .db :\2
    .dw \2
.ENDM

.MACRO jump3bytemc
    .db $fd $02
    .dw \1
    .db \2
    .db :\3
    .dw \3
.ENDM

.MACRO jumproomflago
    .db $fd $03
    .db \1 \2 \3
    .db :\4
    .dw \4
.ENDM

.MACRO unsetroomflag
    .db $fd $04
    .db \1 \2 \3
.ENDM

.MACRO forceend
    .db $00
.ENDM

; arg1 is a byte for the interaction, ex. d3xx
; Uses this byte as an index for a jump table immediately proceeding the opcode.
; Only works in bank $c.
.MACRO jumptable
    .db $c6 \1
    .dw \2 \3
    .IF NARGS >= 4
    .dw \4
    .ENDIF
.ENDM

; This holds while [c4ab] is non-zero, and stops script execution for this frame.
; Could be useful for starting a script only when the transition finishes?
.MACRO unknownd1
    .db $d1
.ENDM


; pseudo-ops

.MACRO checktile
    .if nargs == 3
        .db $ff $02 \1 \2 \3
    .else
        checkmemory $cf00+\1 \2
        .db $d5 \1 $cf \2
    .endif
.ENDM

.MACRO maketorcheslightable
    asm15 $4f4b
.ENDM

.MACRO createpuffnodelay
    asm15 $24c1
.ENDM

.MACRO setinteractionword
    setinteractionbyte \1 \2&$ff
    setinteractionbyte \1+1 \2>>$8
.ENDM



; Other macros, not used directly in scripting

.MACRO SetInteractionScript
    ld hl,\1
    ld c,:\1
    call setInteractionScript
.ENDM
