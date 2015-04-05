
; Blank object
interac1_00:
    ret

; Under Construction
interac1_01:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    ld a,1
    ld (de),a
    SetInteractionScript Script_UnderConstruction
    ld hl,$5802
    call setInteractionFakeID
    call initNPC
+
    ; Main loop stuff
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret

Script_UnderConstruction:
    fixnpchitbox
-
    checkabutton
    showtext $7c04
    jump3byte -


; Guy who comes from d1
interac1_0e:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    inc a
    ld (de),a
    SetInteractionScript Script_0e_OhGod
    ld hl,$3a08
    call setInteractionFakeID
    call initNPC
+
    ; Main loop stuff
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret

; Silly cutscene outside spirit's grave
Script_0e_OhGod:
    jumproomflag $02 noScript
    disableinput
    setinteractionbyte INTERAC_ANIM_MODE $02
    setdelay 6
    showtext $7c00
    setdelay 5
    setcoords $68 $28
    setdelay 3
    setinteractionbyte INTERAC_SPEED $3c
    setinteractionword INTERAC_SPEED_Z $fe40
    playsound SND_JUMP
    movenpcdown $20
    movenpcleft $20
    movenpcup $2c
    setdelay 6
    showtext $7c01
    setdelay 3
    movenpcup $20
    setdelay 5
    setroomflag $02
    enableinput
    forceend
    

; ==========================

npc_template:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    inc a
    ld (de),a
    SetInteractionScript Script_UnderConstruction
    ld hl,$5802
    call setInteractionFakeID
    call initNPC
+
    ; Main loop stuff
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret



Script_standardNPC:
    fixnpchitbox
-
    checkabutton
    showloadedtext
    jump3byte -
