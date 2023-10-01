		
hscore	dta b(0,$20,0)
score 	dta b(0,0,0)
flaghscore	dta b(0)
scoreZmiana	dta b(0)

;jesli gracz zarobil jakies punkty to sa dodawane do score i wyswietlane
sumaPunkty	equ	*
		lda plusScore
		ora plusScore+1
		bne @+
		rts
@		sed
		clc
		lda plusScore
		adc score
		sta score
		lda score+1
		pha
		and #$f0
		sta pom0
		pla
		adc plusScore+1
		sta score+1
		lda score+2
		adc #0
		sta score+2
		cld
		
		lda score+1
		and #$f0
		cmp #$20
		beq @+
		cmp #$70
		bne @+1
@		cmp pom0
		beq @+		;obecne=poprzedniemu
		
		inc lives
		jsr printLives
		
		mva #13*2 SFX_EXTRA		;extra life
		
@		mva #0 plusScore
		sta plusScore+1
		sta scoreZmiana
		rts
		
liczbyflaga	dta b(0)
;punkty
piszScore1	equ *
		inc scoreZmiana
		
		ldy #0
		lda score+2
		beq @+2		;score+2=0
		
		iny		;są już z przodu cyfry (wyswietlaj wszystkie 0)
		and #%1111		;tysiace
		:3 asl
		sta _poz5+1
		
		lda score+2
		and #%11110000
		lsr
		bne @+
		lda #10*8	;puste
@		sta _poz6+1		
		
		ldx #6
@		equ *
_poz5	lda cyfra1,x
_poz6	ora cyfra2,x
		sta sprites+$400+startWyniki+26,x
		dex
		bpl @-	
		
@		lda score+1
		bne @+
		cpy #0
		beq @+3		;rysuj wszystkie cyfry
		
@		and #%1111		;setki
		:3 asl
		sta _poz3+1
	
		lda score+1
		and #%11110000
		lsr
		bne @+		;nie zero
		cpy #0	
		bne @+
		lda #10*8		;pusty znak
@		sta _poz4+1	
		iny
		
		ldx #6
@		equ *
_poz3	lda cyfra1,x
_poz4	ora cyfra2,x
		sta sprites+$500+startWyniki+26,x
		dex
		bpl @-	
		
@		lda score
		bne @+
		cpy #0
		bne @+
		lda #10
		
@		and #%1111
		:3 asl
		sta _poz1+1
		
		lda score
		and #%11110000
		lsr
		
		
		bne @+		;nie zero
		cpy #0	
		bne @+
		lda #10*8		;pusty znak
@		sta _poz2+1	
		
		ldx #6
@		equ *
_poz1	lda cyfra1,x
_poz2	ora cyfra2,x
		sta sprites+$600+startWyniki+26,x
		dex
		bpl @-
		
		rts

;czysc setki i tysiace
czyscScore	equ *
		lda #0
		ldx #6
@		sta sprites+$400+startWyniki+26,x 
		sta sprites+$500+startWyniki+26,x
		dex
		bpl @-
		
		rts
		
czyHscore	equ *
		lda flagHscore
		bne czyH0		;score zliczamy razem z hscore

		lda score+2
		cmp hscore+2
		bcs *+3
		rts	;score<hscore
		
		bne czyH1		;score>hscore

;score=hscore
		lda score+1
		cmp hscore+1
		bcs *+3
		rts	;score<hscore
		
		bne czyH1	;score>hscore
		
		lda score
		cmp hscore
		bcs *+3
		rts
		
czyH1	mva #1 flagHscore
		
czyH0	equ *
		.rept 7, #
		lda sprites+$600+startWyniki+26+:1
		sta sprites+$600+startWyniki+9+:1
		lda sprites+$500+startWyniki+26+:1
		sta sprites+$500+startWyniki+9+:1
		lda sprites+$400+startWyniki+26+:1
		sta sprites+$400+startWyniki+9+:1
		.endr
		rts
	
;Wyswietla numer poziomu
piszPoziom	equ *
		ldy #0
		lda poziom
		cmp #100			;jesli poziom jest >= 100 to wyświetl 99
		bcc @+
		lda #99
		
@		cmp #10
		bcc @+
		iny
		sbc #10
		bcs @-
		
@		:3 asl
		sta _lev1+1
			
		cpy #0
		bne @+
		ldy #10
		
@		tya
		:3 asl
		sta _lev2+1
		
		ldx #6
@		equ *
_lev1	lda cyfra1,x
_lev2	ora cyfra2,x
		sta sprites+$600+startWyniki+217-3,x
		dex
		bpl @-

		rts
		
piszHscore1	equ *		
		ldy #0
		lda hscore+2
		beq @+2		;score+2=0
		
		iny		;są już z przodu cyfry (wyswietlaj wszystkie 0)
		and #%1111		;tysiace
		:3 asl
		sta _pozh5+1
	
		lda hscore+2
		and %11110000
		lsr
		bne @+
		lda #10*8
@		sta _pozh6+1
		
		ldx #6
@		equ *
_pozh5	lda cyfra1,x
_pozh6	ora cyfra2,x
		sta sprites+$400+startWyniki+9,x
		dex
		bpl @-	
		
@		lda hscore+1
		bne @+
		cpy #0
		beq @+3		;rysuj wszystkie cyfry
		
@		and #%1111		;setki
		:3 asl
		sta _pozh3+1

		lda hscore+1
		and #%11110000
		lsr
		bne @+
		cpy #0
		bne @+
		lda #10*8
@		sta _pozh4+1
		iny
		
		ldx #6
@		equ *
_pozh3	lda cyfra1,x
_pozh4	ora cyfra2,x
		sta sprites+$500+startWyniki+9,x
		dex
		bpl @-	
		
@		lda hscore
		bne @+
		cpy #0
		bne @+
		lda #10
		
@		and #%1111
		:3 asl
		sta _pozh1+1

		lda hscore
		and #%11110000
		lsr
		bne @+
		cpy #0
		bne @+
		lda #10*8
@		sta _pozh2+1
		

		ldx #6
@		equ *
_pozh1	lda cyfra1,x
_pozh2	ora cyfra2,x
		sta sprites+$600+startWyniki+9,x
		dex
		bpl @-
		
		rts

		
		

		