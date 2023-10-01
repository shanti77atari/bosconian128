;	MODE 9++

	org $2000	
	
	
run		equ *
/*		lda #0
		tax
@		sta obraz,x
		sta obraz+$100,x
		sta obraz+$200,x
		dex
		bne @-*/
		
		mva #57 559
		
		mwa #dlist 560
		;mva #%01000001 623
		
		mva #$34 708
		mva #$b4 709
		mva #$84 710
		mva #0 712
		
		
	
		jmp *
		
		org $4000
obraz	dta b(%01010101,%01010101,0,0,%10101010,%10101010,0,0,%11111111,%11111111,0,0,0,0,0,0)
		:16 dta b(0)
		dta b(%00000001,%00100011,0,0,%01000110,%01010111,0,0,%10101101,%1111,%1101,0,0,0,0,0,0)
		:16 dta b(0)
		:576 dta b(0)
		
	
		org $600
	
dlist	dta b($70,$70)
		:4 dta b($4e),a(obraz),b($0e)
		;:4 dta b($4e),a(obraz+$40),b($0f)
		;:4 dta b($4e),a(obraz+$80),b($0f)
		;:4 dta b($4e),a(obraz+$c0),b($0f)
		;:4 dta b($4e),a(obraz+$100),b($0f)
		;:4 dta b($4e),a(obraz+$140),b($0f)
		;:4 dta b($4e),a(obraz+$180),b($0f)
		;:4 dta b($4e),a(obraz+$1c0),b($0f)
		;:4 dta b($4e),a(obraz+$200),b($0f)
		;:4 dta b($4e),a(obraz+$240),b($0f)
		dta b(65),a(dlist)
		
	run run