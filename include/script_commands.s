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

