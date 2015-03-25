; Call a function in any bank from any bank.
; It does stack weirdness and uses bytes just after "rst 28" as the destination.
.MACRO callAcrossBank
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
