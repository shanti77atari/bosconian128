		org $2150  ;+10
		
		:10 dta b(0)
		ins "logo.gr8"
		
		org $4000
		
dlist	equ *
		:3 dta b(112)
		dta b(79),a($2150)
		:93 dta b(15)
		dta b(79),a($2150+40*94)
		:97 dta b(15)
		dta b(65),a(dlist)
		
run		mva #0 710
		sta 709
		sta 712
		
		
		lda 20
@		cmp 20
		beq @-
		mwa #dlist 560
		
		ldx #0
@		lda 20
		clc
		adc #4
@		cmp 20
		bne @-
		stx 709
		inx
		cpx #15
		bne @-1
		
@		lda $D010
		and #1
		bne @-
@		lda $d010
		and #1
		beq @-
		
		lda 20
@		cmp 20
		beq @-
		
		ldx #15
@		lda 20
@		cmp 20
		beq @-
		stx 709
		dex
		bne @-1
		
		rts
		
		ini run