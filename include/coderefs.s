; ========================================
.BANK 0 SLOT 0
; ========================================

; Calls function at hl in bank e.
.ORGA $008a
interBankCall:

; Parameters:
; hl = source
; de = destination, bit 0 = vram bank
; b = tiles to copy - 1
; c = src bank
.ORGA $058a
dmaTransfer:

; Needs studying.
; hl appears to be destination, de is destination.
; b is the number of tiles to copy minus one.
; Lower 6 bits of c are the bank number.
; Upper 2 bits of c are something else, perhaps some kind of copy mode?
; Lower nibble of e determines vram bank or wram bank.
; Something also goes into ff90-ff91, possibly extra parameters?
.ORGA $0672
copyGraphics:

; Plays sound A
.ORGA $0c98
playSound:

; Stuff to be called from interactions

; Returns the value of the tile, also sets hl to the address.
.ORGA $1444
getTileAtObject:

; Loads graphics
.ORGA $15fb
initNPC:

; Shows text bc
.ORGA $1872
showText:

; Reads a byte from bank [d0f2]:hl, and writes it into hl. Increments hl.
; Typically it's from wram bank 7.
; Also it can seamlessly read data continuing from one bank to another.
.ORGA $195d
readByteFromBank:

; Returns room flag byte in a
.ORGA $197d
getRoomFlags:


.ORGA $1e7b
setObjectInvisible:
; Makes enemies visible by setting $9a to 83.
; Works with other interactions too.
.ORGA $1e84
setObjectVisible:

; Decelerates object's speed and updates position.
; Probably works with interactions as well as enemies etc.
; Decelerates with speed given in A.
; Sets zero flag when the object hits the ground.
.ORGA $1f45
updateObjectSpeedZ:

; 1fee: get object distance from link or something

; Returns yyxx in bc
.ORGA $208a
getFullObjectPos:
; Returns yx position in a
.ORGA $2096
getObjectPos:

.ORGA $20f7
; Checks to see if B enemy slots are available. Sets z if so.
checkXEnemySlotsAvailable:

; Returns the address of a related object in hl. Adds A to the base address.
; Related object base addresses are stored at xx+16 and xx+18, respectively.
.ORGA $2160
getRelatedObject1Var:
.ORGA $2164
getRelatedObject2Var:

; Copies the xyz position of object d to h.
.ORGA $2242
copyObjectPosition:

; Set vertical speed
.ORGA $239d
setInteractionSpeedZ:
.ORGA $23cc
decInteractionCounter46:
.ORGA $23d1
decInteractionCounter47:
.ORGA $23e0
setInteractionInitialized:
.ORGA $23e5
incInteractionCounter45:
.ORGA $23fe
checkInteractionInitialized:

; Sets screen shake X and Y counters to the value of a.
.ORGA $24bb
setScreenShakeCounter:

; Creates a puff at the position of the interaction called from
.ORGA $24c1
createPuff:

; Creates interaction bc
; Copies position of the interaction copied from
.ORGA $24c5
createInteraction:

.ORGA $2552
runInteractionScript:

; This does more than just decrement, not sure what its purpose is
.ORGA $261b
decInteractionCounter60:

.ORGA $26a9
animateNPC_followLink:
.ORGA $26db
animateNPC_staticDirection:
; Sets the interaction's position to bc (yx).
.ORGA $2773
setInteractionPos:

; Appears to take an 'animation index' in a, and display that.
.ORGA $282b
setEnemyAnimation:

; Does some funky stuff, but seems to be the deleteEnemy function.
.ORGA $2e47
deleteEnemy:

; Gets a free item slot (dx00-dx3f) from d700-db00
; Sets z if successful.
; Does not set the "occupied" bit when successful like other functions...
.ORGA $2cf9
getFreeItemSlot:

; Sets z if successful.
.ORGA $2e27
getFreeEnemySlot:
; Doesn't increment totalEnemies
.ORGA $2e34
getFreeEnemySlot_noIncrement:

; Sets the tile at position 'c' to the value of 'a'.
.ORGA $3a9c
setTile:

.ORGA $3aef
getFreeInteractionSlot:

.ORGA $3b05
deleteInteraction:

; A "part" is a type 8 interaction, occupies space from c0-ff.
; Returns address of free part slot in hl (hl = dxc1 on return)
; Sets z if successful.
.ORGA $3e8e
getFreePartSlot:

.ORGA $3ea1
deletePart:


; ========================================
.BANK $0d SLOT 1
; ========================================

.ORGA $4b64
; D:4b64 = place to call to update enemy facing direction?
lynel_updateFacingDirection:


; ========================================
.BANK $0f SLOT 1
; Contains boss AI, perhaps other things
; ========================================

.ORGA $4534
; Creates a shadow of size bc? Links the shadow to the current enemy,
; by setting the "related object" variable (dxd6-dxd7).
b0f_createShadow:

.ORGA $4446
; Appears to set Z position based on Y position to put him just above the screen
b0f_setZAboveScreen


; ========================================
.BANK $16 SLOT 1
; ========================================

.ORGA $451e
; Seems to make at item appear depending on ID1.
; Needs testing.
makeItemAtInteraction:

