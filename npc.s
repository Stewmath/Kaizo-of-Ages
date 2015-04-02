
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
