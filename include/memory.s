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

; Creates interaction bc
; Copies position of the interaction copied from
.define createInteraction       $24c5

.define runInteractionScript    $2573
; This does more than just decrement, not sure what its purpose is
.define decInteractionCounter60 $261b

.define animateNPC_followLink   $26a9
.define animateNPC_staticDirection  $26db
; Sets the interaction's position to bc (yx).
.define setInteractionPos       $2773

.define deleteInteraction       $3b05


.BANK $16 SLOT 1

.ORGA $451e
; Seems to make at item appear depending on ID1.
; Needs testing.
makeItemAtInteraction:


; Global flags (like for ricky sidequest) around $c640
; At least I know $c646 is a global flag


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
.define INTERAC_ANIM_MODE   $7a ; Animation mode: $00 = follow link, $01 = static direction


; Rings

.define RING_RED    $07
.define RING_BLUE   $08
.define RING_GREEN  $09

.define RING_GBA_NATURE $33
.define RING_FEATHER    $33 ; Custom ring


; Sound effects
.define MUS_FOREST      $30
.define SND_GETITEM     $4c
.define SND_SOLVEPUZZLE $4d
.define SND_DAMAGE_ENEMY $4e
.define SND_CHARGE_SWORD $4f
.define SND_CLINK       $50
.define SND_THROW       $51
.define SND_BOMB_LAND   $52
.define SND_JUMP        $53
.define SND_OPENMENU    $54
.define SND_CLOSEMENU   $55
.define SND_SELECTITEM  $56
.define SND_UNKNOWN1    $57
.define SND_CLINK2      $58 ; When you clink and a wall is bombable
.define SND_FALLINHOLE  $59
.define SND_ERROR       $5a
.define SND_SOLVEPUZZLE_2   $5b
.define SND_ENERGYTHING $5c ; Like when nayru brings you to the present
.define SND_SWORDBEAM   $5d
.define SND_GETSEED     $5e
.define SND_UNKNOWN2    $5f
.define SND_HEARTBEEP   $60
.define SND_RUPEE       $61
.define SND_HEART_LADX  $62 ; Definitely sounds like the LADX sound effect
.define SND_BOSS_DAMAGE $63 ; When a boss takes damage
.define SND_LINK_DEAD   $64
.define SND_LINK_FALL   $65
.define SND_TEXT        $66
.define SND_BOSS_DEAD   $67
.define SND_UNKNOWN3    $68 ; I can't remember what this is but it sounds familiar
.define SND_UNKNOWN4    $69
.define SND_SLASH       $6a ; Not a sword slash, idk really
.define SND_SWORDSPIN   $6b
.define SND_OPENCHEST   $6c
.define SND_CUTGRASS    $6d
.define SND_ENTERCAVE   $6e
.define SND_EXPLOSION   $6f
.define SND_DOORCLOSE   $70
.define SND_MOVEBLOCK   $71
.define SND_LIGHTTORCH  $72
.define SND_KILLENEMY   $73
.define SND_SWORDSLASH  $74
.define SND_UNKNOWN5    $75
.define SND_SWITCHHOOK  $76
.define SND_DROPESSENCE $77
.define SND_UNKNOWN6    $78
.define SND_BIG_EXPLOSION $79

.define SND_MYSTERY_SEED    $7b
.define SND_AQUAMENTUS_HOVER $7c
.define SND_OPEN_SOMETHING $7d
.define SND_SWITCH      $7e
.define SND_MOVE_BLOCK_2 $7f
.define SND_MINECART    $80
.define SND_STRONG_POUND $81 ; Not really sure how to describe this, similar to explosions
; Part of the moving roller thing?
.define SND_MAGIC_POWDER $83 ; Like from LADX
.define SND_MENU_MOVE   $84
.define SND_SCENT_SEED  $85

.define SND_SPLASH      $87
.define SND_LINK_SWIM   $88
.define SND_TEXT_2      $89
.define SND_POP         $8a ; Again no PoP in this game, but a similar sound
.define SND_CRANEGAME   $8b ; SAME SOUND AS IN CRANE GAME
.define SND_UNKNOWN7    $8c
.define SND_TELEPORT    $8d
.define SND_SWITCH      $8e
.define SND_ENEMY_JUMP  $8f
.define SND_GALE_SEED   $90
.define SND_FAIRYCUTSCENE $91 ; When the diseased waters go away in the fairy cutscene

.define SND_WARP_START  $95
.define SND_GHOST       $96 ; LADX HYPE

.define SND_POOF        $98
.define SND_BASEBALL    $99
.define SND_BECOME_BABY $9a
.define SND_JINGLE      $9b ; I'm 99% sure this is unused
.define SND_PICKUP      $9c
.define SND_FLUTE_RICKY $9d
.define SND_FLUTE_DIMITRI $9e
.define SND_FLUTE_MOOSH $9f
.define SND_CHICKEN     $a0
.define SND_MONKEY      $a1 ; LADX HYPE
.define SND_COMPASS     $a2
.define SND_LAND        $a3 ; Probably used for PEGASUS SEEDS
.define SND_BEAM        $a4
.define SND_BREAK_ROCK  $a5
.define SND_STRIKE      $a6 ; Might be wrong here
.define SND_SWITCH_HOOK_2 $a7 ; IDK
.define SND_VERAN_FAIRY_ATTACK $a8
.define SND_DIG         $a9
.define SND_WAVE        $aa
.define SND_DING        $ab ; Like when you get your sword
.define SND_SHOCK       $ac
.define SND_ECHO        $ad ; Tune of echos
.define SND_CURRENT     $ae
.define SND_AGES        $af
.define SND_OPENING     $b0 ; Used in d8 when opening those thingies
.define SND_BIGSWORD    $b1 ; Biggoron's sword
.define SND_MAKUDISAPPEAR $b2
.define SND_RUMBLE      $b3 ; Like a short version of MAKUDISAPPEAR
.define SND_FADEOUT     $b4
; More to be documented probably
