; Script to make the boomerang appear from the ground
script72_0x00:
    ; If you've talked to the guy in town, run the script
    jumproomflago $e1 3 $02 script7200_main
    jump3byte noScript

script7200_main:
    ; If already dug up, do nothing
    jumproomflag $02 noScript

    checktile $44 $1c
    spawnitem $0600
    setroomflag $02
    forceend

script72_0x01:
script72_0x02:
script72_0x03:
script72_0x04:
script72_0x05:
script72_0x06:
script72_0x07:
script72_0x08:
script72_0x09:
script72_0x0a:
script72_0x0b:
script72_0x0c:
script72_0x0d:
script72_0x0e:
script72_0x0f:
script72_0x10:
script72_0x11:
script72_0x12:
script72_0x13:
script72_0x14:
script72_0x15:
script72_0x16:
script72_0x17:
    forceend

noScript:
    forceend
