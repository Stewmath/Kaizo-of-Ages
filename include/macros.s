.MACRO rst_jumpTable
    rst $00
.ENDM
.MACRO rst_addAToHl
    rst $10
.ENDM
.MACRO rst_addDoubleIndex
    rst $18
.ENDM

; Call a function in any bank from any bank.
; UNTESTED SO FAR
.MACRO CallAcrossBank
    callAcrossBank\@:
	.IF NARGS == 2-1
        ld e,:\1
        ld hl, \1
        call $008a
	.ELSE
		.IF NARGS == 2
            ld e,\1
            ld hl,\2
            call $008a
		.ELSE
			.FAIL
		.ENDIF
	.ENDIF
.ENDM

.MACRO Call
    .IF NARGS == 1
        CallAcrossBank \1
    .ELSE
        CallAcrossBank \1 \2
    .ENDIF
.ENDM

.MACRO 3BytePointer
    .db :\1
    .dw \1
.ENDM
