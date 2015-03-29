; Call a function in any bank from any bank.
; UNTESTED SO FAR
.MACRO CallAcrossBank
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

.MACRO 3BytePointer
    .db :\1
    .dw \1
.ENDM
