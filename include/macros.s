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
.MACRO JpAcrossBank
	.IF NARGS == 2-1
        ld e,:\1
        ld hl, \1
        jp $008a
	.ELSE
		.IF NARGS == 2
            ld e,\1
            ld hl,\2
            jp $008a
		.ELSE
			.FAIL
		.ENDIF
	.ENDIF
.ENDM

; 'preserve variables' variation uses more space but preserves de and hl.
.MACRO CallAcrossBank_pv
	.IF NARGS == 2-1
        ld bc,callAcrossBank_pv\@
        push bc
        ldh a,(z_activeBank)
        push af
        ld bc,$0098
        push bc
        ld a,:\1
        ld bc,\1
        push bc
        jp $0099
	.ELSE
		.IF NARGS == 2
            ld bc,callAcrossBank_pv\@
            push bc
            ldh a,(z_activeBank)
            push af
            ld bc,$0098
            push bc
            ld a,\1
            ld bc,\2
            push bc
            jp $0099
		.ELSE
			.FAIL
		.ENDIF
	.ENDIF
    callAcrossBank_pv\@:
.ENDM

.MACRO JpAcrossBank_pv
	.IF NARGS == 2-1
        ldh a,(z_activeBank)
        push af
        ld bc,$0098
        push bc
        ld a,:\1
        ld bc,\1
        push bc
        jp $0099
	.ELSE
		.IF NARGS == 2
            ldh a,(z_activeBank)
            push af
            ld bc,$0098
            push bc
            ld a,\1
            ld bc,\2
            push bc
            jp $0099
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
