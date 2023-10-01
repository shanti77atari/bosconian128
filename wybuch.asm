maxWybuchow 	equ 32
		
wybuchyX0	org *+maxWybuchow		;:maxWybuchow dta b(0)
wybuchyY0	org *+maxWybuchow		;:maxWybuchow dta b(0)
wybuchyStart	org *+1				;dta b(0)
wybuchyStop	org *+1				;dta b(0)
wybuchyX		org *+maxWybuchow		;:maxWybuchow dta b(0)
wybuchyY		org *+maxWybuchow		;:maxWybuchow dta b(0)
wybuchyLicznik	org *+maxWybuchow		;:maxWybuchow dta b(0)


mwyb			equ 8
mwybuchyStart	org *+1	;dta b(0)
mwybuchyStop	org *+1	;dta b(0)
mwybuchyX		org *+mwyb	;:mwyb dta b(0)
mwybuchyY		org *+mwyb	;:mwyb dta b(0)
mwybuchyLicznik	org *+mwyb	;:mwyb dta b(0)
mwybuchyTyp		org *+mwyb	;:mwyb dta b(0)


dodajMalyWybuch	equ *
		sty pom0g	;zapamietaj Y
		ldy mwybuchyStop
		
		lda rakietyX,x
		sta mwybuchyX,y
		lda rakietyY,x
		sta mwybuchyY,y
		mva #6 mwybuchyLicznik,y	
		lda rakietyTyp,x
		lsr ;podziel przez 2
		sta mwybuchyTyp,y
		iny
		tya
		and #%111		;max 16 wybuchy
		sta mwybuchyStop
		
		ldy pom0g
		rts
		
rysujmWybuchy	equ *
		lda mwybuchyStart
		and #%111
		tax
		cmp mwybuchyStop
		bne mrwy1
		rts
		
mrwy1	lda mwybuchyX,x
		sec
		sbc posX
		tay
		lda tabX,y
		clc
		adc #1
		cmp #34
		bcs mrwy2
		
		adc #7
		sta pom0
		
		sec
		lda mwybuchyY,x
		sbc posY
		clc
		adc #1
		cmp #lenDlist+1
		bcs mrwy2
		
		tay
		
		lda ramka
		bne @+
		
		clc
		lda obraz1La+7,y
		adc pom0
		sta pom
		lda obraz1Ha+7,y
		adc #0
		sta pom+1
		bne @+1	;skok bezwarunkowy
@		clc
		lda obraz2La+7,y
		adc pom0
		sta pom
		lda obraz2Ha+7,y
		adc #0
		sta pom+1
		
@		lda mwybuchyTyp,x
		bne @+
		
		ldy #0
		lda #firstMalyWybuchChar
		sta (pom),y
		ldy #48
		sta (pom),y
		bne mrwy2
		
@		ldy #0
		lda #firstMalyWybuchChar+1
		sta (pom),y
		iny
		sta (pom),y
		
mrwy2	dec mwybuchyLicznik,x
		bne @+
		inc mwybuchyStart	
		
@		inx
		txa 
		and #%111
		tax
		cpx mwybuchyStop
		jne mrwy1
		
		rts

;dodaje wybuch
dodajWybuch		equ *		;X w Aku , Y w y
		stx bufwyb+1
		
		ldx wybuchyStop
		sta wybuchyX,x
		tya
		sta wybuchyY,x
		mva #0 wybuchyLicznik,x
		inx
		txa
		and #%11111		;max 32 wybuchy
		sta wybuchyStop
bufwyb	equ *		
		ldx #0
		rts
		
		
;rysuje duze wybuchy		
rysujWybuchy	equ *
		lda wybuchyStart
		and #%11111
		tax
		cmp wybuchyStop
		bne rwy1
		rts

rwy1	lda wybuchyX,x
		sec
		sbc posX
		tay
		lda tabX,y
		sta wybuchyX0,x
		clc
		adc #1
		cmp #34
		bcs rwy2
		
		adc #7
		sta pom0		;pozycja X
		
		sec
		lda wybuchyY,x
		sbc posY
		sta wybuchyY0,x
		clc
		adc #1
		cmp #lenDlist+1
		bcs rwy2
		
		tay
		
		lda ramka
		bne @+
		
		clc
		lda obraz1La+7,y
		adc pom0
		sta pom
		lda obraz1Ha+7,y
		adc #0
		sta pom+1
		bne @+1	;skok bezwarunkowy
@		clc
		lda obraz2La+7,y
		adc pom0
		sta pom
		lda obraz2Ha+7,y
		adc #0
		sta pom+1
		
@		lda wybuchyLicznik,x
		and #%11111100
		
		clc
		adc #firstWybuchChar+128
		
		ldy #0
		sta (pom),y
		ldy #48
		adc #1
		sta (pom),y
		ldy #1
		adc #1
		sta (pom),y
		ldy #49
		adc #1
		sta (pom),y
		
rwy2	lda wybuchyLicznik,x
		clc
		adc #2		;3
		cmp #15		;20
		bcc @+
		inc wybuchyStart
		
@		sta wybuchyLicznik,x
		inx
		txa
		and #%11111
		tax
		cpx wybuchyStop		;czykoniec?
		jne rwy1
		
		rts
		

		
		
		