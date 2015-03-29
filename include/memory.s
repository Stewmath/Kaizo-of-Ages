; Calls function at hl in bank e.
.define interBankCall           $008a
; Plays sound A
.define playSound               $0c98

; Stuff to be called from interactions

; Loads graphics
.define initNPC                 $15fb
; Decelerates object's speed and updates position.
; Probably works with interactions as well as enemies etc.
; Decelerates with speed given in A.
.define updateObjectSpeedZ      $1f45
; Set vertical speed
.define setInteractionSpeedZ    $239d
.define decInteractionCounter46 $23cc
.define decInteractionCounter47 $23d1
.define setInteractionInitialized   $23e0
.define incInteractionCounter45 $23e5
.define runInteractionScript    $2573
; This does more than just decrement, not sure what its purpose is
.define decInteractionCounter60 $261b

.define animateNPC_followLink   $26a9
.define animateNPC_staticDirection  $26db
; Sets the interaction's position to bc (yx).
.define setInteractionPos       $2773



.define activeRing $c6cb

.define textIndex   $cba2
.define textIndex_l $cba2
.define textIndex_h $cba3

.define activeBank  $ff00+$97


; Interaction variables
.define INTERAC_TYPE        $40
.define INTERAC_ID          $41
.define INTERAC_INITIALIZED $44
.define INTERAC_POS_Z       $4e
.define INTERAC_SPEED       $50
.define INTERAC_SPEED_Z     $54
.define INTERAC_SCRIPTPTR   $58
; Custom stuff
.define INTERAC_FAKEID      $78 ; Fake ID for using whatever sprite we want
.define INTERAC_ANIMMODE    $7a ; Animation mode: $00 = follow link, $01 = static direction


; Rings

.define RING_RED    $07
.define RING_BLUE   $08
.define RING_GREEN  $09

.define RING_GBA_NATURE $33
.define RING_FEATHER    $33 ; Custom ring
