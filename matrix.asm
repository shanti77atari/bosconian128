
			
textmatrix	dta c'http://atari.pl/hsc/?x=1070000000',b(255)
authormatrix1	dta c'SCORECAFE'*,b(128)


matrix_score	equ *
		lda score,y
		:4 lsr
		ora #$30
		sta textmatrix,x
		inx
		lda score,y
		and #$0F
		ora #$30
		sta textmatrix,x
		inx
		dey
		rts

;obsługa datamatrix
printDatamatrix	equ *
		ldx #26
		ldy #2
		jsr matrix_score
		jsr matrix_score
		jsr matrix_score

		lda score+2
		:4 lsr
		ora #$30
		sta textmatrix+26
		lda score+2
		and #$0f
		ora #$30
		sta textmatrix+27
		

		ldx #33
@		lda textmatrix,x			
		sta DataMatrix_data,x
		dex
		bpl @-
		
		
		
		jsr DataMatrix_code		;przygotuj obrazel
		
		lda #127			;wyczysc ekran
		ldx #0
@		sta obraz1,x
		sta obraz1+$100,x
		sta obraz1+$200,x
		sta obraz1+$300,x
		dex
		bne @-
		
		ldx #7
		lda #255				;pelny znak
@		sta znaki1+127*8,x
		dex
		bpl @-
		
		
		mva #'H'* obraz1+28
		mva #'I'* obraz1+28+1
		
		ldx #4
@		lda authormatrix1,x
		sta obraz1+30+40,x
		lda authormatrix1+5,x
		sta obraz1+30+80+5,x
		dex
		bpl @-
		
		
		mwa #DataMatrix_data+$100 pom
		mwa #obraz1+2 pom1
		ldx #0
		
@		ldy #DataMatrix_SIZE-1			;rysujemy obrazek
@		lda (pom),y
		eor #1
		bne *+4
		sta (pom1),y
		dey
		bpl @-
		
		clc
		lda pom
		adc #DataMatrix_SIZE
		sta pom
		bcc *+4
		inc pom+1
		
		clc
		lda pom1
		adc #40
		sta pom1
		bcc *+4
		inc pom1+1
		
		inx
		cpx #DataMatrix_SIZE
		bcc @-1
		
		
		jsr waitvbl			;wyświetl wynik
		mva #0 COLPF2
		mva #$0f COLPF1
		sta COLBAK
		
		mwa #dlistMatrix DLPTR
		mva #>znaki1 CHBASE
		mva #0 PMCTL
		mva #0 GRAFP3
		mva #58 DMACTL

@		jsr waitvbl			;puść już SELECT
		lda CONSOL
		and #SELECT
		beq @-
		
@		jsr waitvbl			;czy naciśnięty SELECT?
		lda CONSOL
		and #SELECT
		bne @-
		
@		jsr waitvbl			;puść już SELECT
		lda CONSOL
		and #SELECT
		beq @-
		
		mva #0 COLBAK
		
		rts
		
		