
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

; ==========================
; Impa in her house

interac1_02:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    ld a,1
    ld (de),a
    SetInteractionScript Script0
    ld hl,$3100
    call setInteractionFakeID
    call initNPC
+
    ; Main loop stuff
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret

; First impa meeting
Script0:
    fixnpchitbox
    jumproomflag $02 Script0_notFirstMeeting

Script0_firstMeeting:
    disableinput
    setinteractionword INTERAC_ANIM_MODE 1
    movenpcup $0
    setdelay 9
    showtext $7c00  ; Who's there

    setdelay 5
    movenpcdown $0
    setdelay 6

    setinteractionword INTERAC_SPEED_Z DEFAULT_JUMP_SPEED
    playsound $53
    setdelay 7
    showtext $7c01  ; Oh!

    setdelay 6
    setinteractionbyte $50 $28
    movenpcleft $29

    setdelay 3
    movenpcdown $40

    setdelay 7
    showtext $7c02

    setdelay 6
    giveitem $1500  ; Get shovel

    setroomflag $02

    enableinput

    setinteractionbyte INTERAC_ANIM_MODE 0
    jump3byte +

Script0_notFirstMeeting:
    setcoords $28 $68
+
-
    checkabutton
    showtext $7c03
    jump3byte -
    

; ==========================
; Villager who tells you where boomerang is
interac1_03:
    ld e,INTERAC_INITIALIZED
    ld a,(de)
    or a
    jr nz,+

    ; Initialization
    inc a
    ld (de),a
    SetInteractionScript Script103
    ld hl,$bf06
    call setInteractionFakeID
    call initNPC
+
    ; Main loop stuff
    call animateNPCAndImitate
    ld a,$20
    call updateObjectSpeedZ
    ret

Script103:
    fixnpchitbox
    jumproomflago $55 1 $02 +++
    jumproomflag $02 ++

    checkabutton
    showtext $7c05
    setroomflag $02
    showtext $7c06
++   ; Talked to him first time already
    settextid $7c06
    jump3byte Script_standardNPC

+++  ; Obtained boomerang already
    settextid $7c07
    jump3byte Script_standardNPC
    
    

; ==========================
interac1_04:
interac1_05:
interac1_06:
interac1_07:
interac1_08:
interac1_09:
interac1_0a:
interac1_0b:
interac1_0c:
interac1_0d:
interac1_0e:
interac1_0f:
interac1_10:
interac1_11:
interac1_12:
interac1_13:
interac1_14:
interac1_15:
interac1_16:
interac1_17:
interac1_18:
interac1_19:
interac1_1a:
interac1_1b:
interac1_1c:
interac1_1d:
interac1_1e:
interac1_1f:
interac1_20:
    ret

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
