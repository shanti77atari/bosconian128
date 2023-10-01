;strona tytułowa
Title		equ *
		jsr prepare_title
		jsr waitvbl
Title2	equ *
		jsr title_init
		mva #0 atariX1
		
		lda #>znaki1
		sta CHBASE

		
		
		;jsr waitvbl
		mwa #dlist	DLPTR
		mva #0 zegar
		mva #%01000000 NMIEN		;wylacz przerwania DLI i IRQ
		mva #58 DMACTL
		
		jsr ppanel

@		jsr printNapis
		
		jsr ppanel		;bez irq
		lda CONSOL
		and #SELECT
		bne *+5
		jmp matrixOn
		
		lda FIRE
		bne *+5
		jmp waitvbl
		
		jsr waitvbl
		
		lda pozNapis
		cmp #29
		bcc @-
		
@		jsr ppanel
		lda CONSOL
		and #SELECT
		bne *+5
		jmp matrixOn

		lda FIRE
		bne *+5	
		jmp waitvbl
	
		jsr waitvbl
		jsr ppanel
		
		jsr efektNapis1
		
		lda napisX
		bpl @-	
		

@		jsr ppanel
		ldy #32
		jsr efnap1

		lda #$84
		sta COLPF0
		
		ldy #7
		lda #0
@		sta obraz1+19+29+7*48+33,y
		sta obraz1+19+29+25*48+33,y
		sta obraz1+19+29+20*48+33,y
		sta obraz1+19+29+22*48+33,y
		sta obraz1+19+29+18*48+33,y
		sta obraz1+19+29+19*48+33,y
		sta obraz1+19+29+21*48+33,y
		sta obraz1+19+29+23*48+33,y
		dey
		bpl @-
		
		
		ldx #6
@		lda #%11001100 				;last line
		sta sprites+$4d8-1,x
		lda #%00110000
		sta sprites+$5d8-1,x
		
		lda #%11110111			;code and gfx
		sta sprites+$4a0-1,x
		lda #%01110000
		sta sprites+$5a0-1,x

		lda #%01111101			;music and sfx
		sta sprites+$4b0-1,x
		lda #%11011100
		sta sprites+$5b0-1,x
		
		lda #%11111000				;pictures
		sta sprites+$4c0-1,x
		lda #%11111100
		sta sprites+$5c0-1,x
		
		dex
		bpl @-
		
		lda #0
		sta sprites+$4df
		sta sprites+$5df
		
		lda #5 
		ldx #7									;fragment napisu na duszku
@		sta sprites+$700+startWyniki+54,x
		dex
		bpl @-
		
		mva kolorLogo duszek4kolor
		mva #43 duszek4pos
			
		lda #$32					;zmiana trybu na gr0 w 2 liniach
		sta dlist+10
		
		sta dlist+21
		sta dlist+22
		sta dlist+23
		sta dlist+24
		sta dlist+25
		sta dlist+26
		sta dlist+28		
		
		ldx #13
@		lda theStarDestroyer,x
		sta obraz1+19+12+28+7*48,x
		lda sfxt,x
		sta obraz1+19+8+28+20*48,x
		dex
		bpl @-
		
		ldx #39
		lda #$80
@		sta obraz1+19+29+25*48,x
		dex
		bpl @-
		
		ldx #17
@		lda atariversion,x
		ora #$80
		sta obraz1+19+11+28+25*48,x
		;lda sfxt,x
		;sta obraz1+19+8+28+20*48,x
		dex
		bpl @-
		
	
		ldx #11
@		lda codet,x
		sta obraz1+19+7+28+18*48,x
		dex
		bpl @-
		
		ldx #15
@		lda codet1,x
		sta obraz1+19+7+28+19*48,x
		dex
		bpl @-
		
		ldx #16
@		lda sfxt1,x
		sta obraz1+19+8+28+21*48,x
		lda pict1,x
		sta obraz1+19+8+28+23*48+1,x
		dex
		bpl @-
		
		ldx #11
@		lda pict,x
		sta obraz1+19+8+28+22*48+1,x
		dex
		bpl @-
		
		mva #67-10 atariX1
		
		
		lda #2
		sta obraz1+19+25+28
		sta obraz1+19+25+9+3*48		;gwiazdy
		sta obraz1+19+25+14+6*48
		sta obraz1+19+25+30+10*48
		sta obraz1+19+25+13+14*48
		sta obraz1+19+25+24+17*48
		sta obraz1+19+25+19+26*48
		sta obraz1+19+25+29+27*48
		sta obraz1+19+25+8+24*48
		
		lda #129
		sta obraz1+19+25+2*48+22
		sta obraz1+19+25+4*48+31
		sta obraz1+19+25+22+9*48
		;sta obraz1+19+25+8+19*48
		sta obraz1+19+25+27+24*48
		sta obraz1+19+25+12+27*48
		
		mva #3 posx
		mva #0 posY
		mva #36 enemyX+4
		mva #14 enemyY+4
		mva #0 enemyDX+4
		mva #0 enemyDY+4
		mva #12 enemyFaza+4
		mva #EKOLOR1 enemyNegatyw+4
		mva #BANK2 enemyBank+4
		mva >enemy2shapetab enemyShapeH+4
		mva #0 ramka
		sta ramka4
		mva #37 pom0f
		sta pom0g
		mva #0 pom0e	;kierunek
		

		
		mva #0 zegar
	
@		jsr ppanel
		lda CONSOL
		and #SELECT
		bne bbs
		lda #0
		sta pom0g
		jmp @+1

bbs		lda fire
		jeq @+1

	
		lda pom0e
		bne bb0

		ldx pom0f
		cpx #37
		beq bb1
		:3 mva bufore3+# obraz1-3+#+14*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz1-3+#+15*48,x
		jmp bb1
		
		
bb0		ldx pom0f
		:3 mva bufore3+# obraz1-3+#+5*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz1-3+#+6*48,x
		jmp bb2	
		
bb1		equ *		
		sec
		lda enemyDX+4		;ruch w lewo
		sbc #%01000000
		sta enemyDX+4
		lda enemyX+4
		sbc #0
		and #127
		sta enemyX+4
		
		bne bb1_	;sprawdz czy juz poza ekranem
		inc pom0e	;zmien kierunek
		mva #0 enemyX+4
		sta enemyDX+4
		mva #4 enemyFaza+4
		mva #5 enemyY+4
		mva #BANK1 enemyBank+4
		jmp bb2
		
bb1_	tax
		stx pom0f
		:3 mva obraz1-3+#+14*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz1-3+#+15*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		jmp bb3
		
bb2		equ *		
		clc
		lda enemyDX+4		;ruch w prawo
		adc #%01000000
		sta enemyDX+4
		lda enemyX+4
		adc #0
		and #127
		sta enemyX+4
		
		cmp #38
		bne bb2_ 
		mva #254 zegar
		jmp @+1
		
bb2_	tax
		stx pom0f
		:3 mva obraz1-3+#+5*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz1-3+#+6*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		
bb3		equ *
		
		lda atariX1
		clc
		adc #2
		cmp #144+10
		bcc @+
		lda #67-10
@		sta atariX1
		
		jmp @-1	
		
@		;jsr waitvbl
		
		;mva #0 DMACTL
		lda #$34				;zmiana trybu w 2 liniach
		sta dlist+10
		
		sta dlist+21
		sta dlist+22
		sta dlist+23
		sta dlist+24
		sta dlist+25
		sta dlist+26
		sta dlist+28		
		
		ldx #6
@		lda #0
		sta sprites1+$4d8-1,x
		sta sprites1+$5d8-1,x
		sta sprites+$4b0-1,x
		sta sprites+$5b0-1,x
		sta sprites+$4c0-1,x
		sta sprites+$5c0-1,x
		sta sprites+$4a0-1,x
		sta sprites+$5a0-1,x
		dex
		bpl @-
			
		mva #$00 duszek4kolor
		mva #pozWyniki-1 duszek4pos
		
		lda #255
		ldx #7									;przywróc duszka
@		sta sprites+$700+startWyniki+54,x
		dex
		bpl @-	
		
		mva #$0a COLPF1
		
		lda zegar 
		cmp #254
		beq @+		;jesli minelo 5 sek wyswietl HS
		
		lda pom0g
		bne *+5
		jmp matrixOn
		
		rts
		
@		mva #0 zegar		;wyswietl tabele wynikow

		;ldy #1
		jsr tabhscore1

		mva #36 enemyX+4
		mva #23 enemyY+4
		mva #12 enemyFaza+4
		mva #EKOLOR1 enemyNegatyw+4
		mva #BANK3 enemyBank+4
		mva >enemy1shapetab enemyShapeH+4
		mva #1 ramka
		mva #4 ramka4
		mva #37 pom0f
		mva #0 pom0e	;kierunek

		;jsr waitvbl
		mva #0 zegar
		;mva #58 DMACTL
		
		
;przygotowanie obrazu1
		jsr ppanel1
		
		mva #>(obraz1+19) _zako1
		jsr zakryjObraz
		jsr ppanel1
		
		jsr zakryjObraz
		jsr ppanel1
		
		jsr zakryjObraz
		jsr ppanel1
		
		jsr zakryjObraz
		jsr ppanel1
		
		jsr zakryjObraz
		jsr ppanel1
		
		jsr zakryjObraz
		jsr ppanel1
		
		lda #0
		ldx #63
@		sta obraz1+19+28*48,x
		dex
		bpl @-
		
		
;---		
@		jsr ppanel1
		
		lda pom0e
		bne bbb0

		ldx pom0f
		cpx #37
		beq bbb1
		:3 mva bufore3+# obraz2-3+#+23*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz2-3+#+24*48,x
		jmp bbb1
		
		
bbb0	ldx pom0f
		:3 mva bufore3+# obraz2-3+#+7*48,x	;odtwórz ekran po duszku
		:3 mva bufore3+3+# obraz2-3+#+8*48,x
		jmp bbb2	
		
bbb1		equ *		
		sec
		lda enemyDX+4		;ruch w lewo
		sbc #%01000000
		sta enemyDX+4
		lda enemyX+4
		sbc #0
		and #127
		sta enemyX+4
		
		bne bbb1_	;sprawdz czy juz poza ekranem
		inc pom0e	;zmien kierunek
		mva #0 enemyX+4
		sta enemyDX+4
		mva #4 enemyFaza+4
		mva #7 enemyY+4
		mva #BANK1 enemyBank+4
		mva >enemy2shapetab enemyShapeH+4
		jmp bbb2
		
bbb1_	tax
		stx pom0f
		:3 mva obraz2-3+#+23*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz2-3+#+24*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		jmp bbb3
		
bbb2		equ *		
		clc
		lda enemyDX+4		;ruch w prawo
		adc #%01000000
		sta enemyDX+4
		lda enemyX+4
		adc #0
		and #127
		sta enemyX+4
		
		cmp #37
		bne bbb2_ 
		mva #254 zegar
		jmp @+
		
bbb2_	tax
		stx pom0f
		:3 mva obraz2-3+#+7*48,x bufore3+#	;zapamietaj obszar pod nową pozycją duszka
		:3 mva obraz2-3+#+8*48,x bufore3+3+#
		
		ldx #4
		jsr duszkiPrint
		
bbb3		equ *
		
		
		lda CONSOL
		and #SELECT
		bne bbbs
		
		jsr ppanel1
		jsr tabhs1cls
		mva #0 HPOSM+3
		jmp matrixOn 
		
bbbs	lda FIRE
		jne @-

@		equ *
		jsr ppanel1
		jsr tabhs1cls
		
		;jsr waitvbl
			
		mva #0 HPOSM+3
		
		lda zegar
		cmp #255
		beq @+
	
		rts

@		;mva #0 DMACTL
		jmp Title2

atariX1	dta b(0)


zakryjObraz	equ *
		ldx #0
		lda #$7d
_zako1	equ *+2		
@		sta obraz1+19,x
		dex
		bne @-
		inc _zako1
		rts
		
;tworzy prawy panel bez przerwan
ppanel	equ *
		jsr ppan_1		
		jsr ppan_2
		
		lda #21
@		cmp VCOUNT
		bne @-
		
		mva #pozWyniki+2 HPOSP		;score
		mva #pozWyniki+10 HPOSP+1
		mva #kolorLiczby COLPM
		sta COLPM+1
		
		jsr ppan_3
		mva #$0f COLPF1
		
		lda #34
@		cmp VCOUNT
		bne @-
		
		:2 sta WSYNC
		
		mva duszek4pos	HPOSP+3		
		mva duszek4kolor COLPM+3		;poczatek litery B
		
		jsr ppan_4
		
		lda #38
@		cmp VCOUNT
		bne @-
		:2 sta WSYNC
		
		mva #pozWyniki-1 HPOSP+3			;koniec litery B
		mva #0	COLPM+3
		
		lda #47
@		cmp VCOUNT
		bne @-
		
		sta WSYNC
		mva kolorMapa	COLPM+3
			
		mva #kolorLiczby COLPM
		lda #16+4
		sta SIZEM
		mva kolorCzerwony COLPM+1
		sta COLPM+2
		mva #pozWyniki+19 HPOSM+2
		mva #pozWyniki+23 HPOSM+1
		
		mva #0 HPOSM
		mva #1 SIZEP+2		;przeciwnicy na radarze
		mva #pozWyniki+3 HPOSP+2
		
		mva #0 HPOSP		;schowaj statek
		sta HPOSP+1
		
		lda #78
@		cmp VCOUNT
		bne @-
		
		mva #3 SIZEP
		sta SIZEP+1
		mva #71 HPOSP
		mva #$30 COLPM
		mva #71+32 HPOSP+1
		
		sta WSYNC
		sta WSYNC
		
		ldy #7
@		sta WSYNC
		mva #$30 COLPM+1
		:6 dec strz0
		mva kolorCzerwony COLPM+1
		dey 
		bne @-
		
		mva #$0e COLPF1
		
		
		lda #86
@		cmp VCOUNT
		bne @-
		mva #$0a COLPF1
		
		mva #3 SIZEP
		sta SIZEP+1
		mva #%00010111 SIZEM
		mva #71+32 HPOSP+1
		mva #71+56+16 HPOSM
		ldx #$50 ;COLPM
		
		;lda #$0a
		:2 sta WSYNC
		stx COLPM
		
		ldy #7
@		sta WSYNC
		mva #$50 COLPM+1
		:6 dec strz0
		mva kolorCzerwony COLPM+1
		dey 
		bne @-
		
		mva #$0e COLPF1
		sta WSYNC
		
		lda #94
@		cmp VCOUNT
		bne @-
		
		mva #$0a COLPF1
		mva #75+4 HPOSP
		mva #$b0 COLPM
		:2 sta WSYNC
		
		ldy #7
@		sta WSYNC
		mva #$b0 COLPM+1
		:6 dec strz0
		mva kolorCzerwony COLPM+1
		dey 
		bne @-
		
		
		lda #99
@		cmp VCOUNT
		bne @-
		
		
		sta WSYNC
		mva #$0f COLPF1
		mva #0 HPOSP
		sta HPOSP+1
		
		
		lda #102
@		cmp VCOUNT
		bne @-	
		
		mva #$0a COLPF1
		
		mva #0 COLPM+3		;koniec mapy zapasowe statki
		
		sta SIZEM
		sta SIZEP+2			;zakonczenie mapy
		sta HPOSP+2
		sta HPOSM
		sta HPOSM+1
		sta HPOSM+2
		
		lda #105
@		cmp VCOUNT
		bne @-
		
		mva #3 SIZEP
		sta SIZEP+1
		mva #$0e COLPM
		mva #$0a COLPM+1

		sta WSYNC
		
		lda #0
		ldx #$08
		ldy atariX1
		:3 sta WSYNC
		
		sta COLPF1
		stx COLPF2
		sty HPOSP
		sty HPOSP+1

		
		ldx #$3a
		ldy #0
		:7 sta WSYNC
		
		stx COLPF1
		sty COLPF2
		sty HPOSP
		sty HPOSP+1

		
		jmp ppan_end

theStarDestroyer	dta c'STAR',b(0),c'DESTROYER'
atariversion		dta b(0,0),c'FINAL',b(0),c'VER',b(91),b(0),b(94),b(91),b(98),b(0,0)
codet				dta c'CODE',b(0),'AND',b(0),'GFX'
codet1				dta c'JANUSZ',b(0),c'CHABOWSKI'
sfxt				dta c'MUSIC',b(0),c'AND',b(0),c'SFX',b(0)
sfxt1				dta c'MICHAL',b(0),c'SZPILOWSKI'
pict				dta c'TITLE',b(0),'SCREEN'
pict1				dta c'KRZYSZTOF',b(0),c'ZIEMBIK'				


prepare_title	equ *
			mva #0 lives
			mva #0 RadarX
			jsr printLives
	
;1
			ldx #55
@			lda titleChars1,x
			sta znaki1+121*8,x
			dex
			bpl @-
			
			lda #>znaki1
			jsr przepiszZnaki
			
			mva #0 kolor1up
			
			ldx #0
			lda #$7d
@			sta obraz1+19,x
			sta obraz1+$100+19,x
			sta obraz1+$200+19,x
			sta obraz1+$300+19,x
			sta obraz1+$400+19,x
			sta obraz1+$500+19,x
			dex
			bne @-
			
			lda #0
			ldx #63
@			sta obraz1+19+28*48,x
			dex
			bpl @-
		
			jsr czarnyPanel
;2		
			jmp tabhscore2
		
;Inicjalizacja strony tytułowej
title_init	equ *
			lda #$0A		
			sta COLPF0
			lda #$3a		
			sta COLPF1
			lda #$00		
			sta COLPF2
			lda kolorLogo
			sta COLPF3
			
			;jsr czarnyPanel
			lda #255
			ldx #44
@			sta sprites+$700+33,x
			dex
			bpl @-
		
					
			mwa #obraz1+19 dlist+2
			mva #0 VSCROL
			mva #>znaki1 CHBASE
			
			mva #0 lives
			mva #0 RadarX
			jsr printLives
			
			
			mva #pozWyniki-1 duszek4pos
			mva #0 duszek4kolor
			
			mva #0 pozNapis	;34 pozNapis
			
			mva #14 napisY
			mva #15 napisX
			mva #1 napisDX
			
			mva #12 pom0e
			sta wsync
			sta HSCROL
			
			mwa #obraz1+19+668 pom1		;pozycja poczatkowa dla efektu
			
			lda #<(obraz1+19+668) 
			sta efn1+1
			sta efn1b+1
			lda #>(obraz1+19+668) 
			sta efn1+2
			sta efn1b+2
			
			lda #<(obraz1+19+668+48) 
			sta efn2+1
			sta efn2b+1
			lda #>(obraz1+19+668+48) 
			sta efn2+2
			sta efn2b+2
			
			rts

pozNapis	equ pom0f
			
printNapis	equ *	
			
			lda pom0e
			sta wsync
			sta HSCROL		
			lda pom0e
			sec
			sbc #1
			ora #%1100
			sta pom0e
			cmp #14
			beq @+
			rts
			
@			ldy pozNapis
			cpy #27
			bcs @+
			.rept 11, #
				lda titleNapis+#*27,y
				sta obraz1+19+$120+33+#*48,y
			.endr
			jmp @+1
			
@			lda #$7d			;jesli juz caly tekst na ekranie
			.rept 11, #
				sta obraz1+19+$120+33+#*48,y
			.endr
			
@			lda #$7d
			.rept 6, #
				sta obraz1+19+33+#*48,y
				sta obraz1+19+33+(#+17)*48,y
			.endr
			:5 sta obraz1+19+33+(#+23)*48,y
			
			inc pozNapis
			inc dlist+2
			
			rts
			
napisX		equ pom0a
napisY		equ pom0b
napisDX		equ pom0c	

eftab1		equ *-125
			dta b($79,$fc,$fb,$fa)
eftab2		dta b(28*9+1)
			:13 dta b([28-#-1]*9)
			
eftab3		:14 dta b(<(efnap1+#*9))
			:14 dta b(>(efnap1+#*9))

efnap1		equ *
			.rept 28, #
				ldx obraz1+19+#*48+29,y
				lda eftab1,x
				sta obraz1+19+#*48+29,y
			.endr
			rts
			dta b(0)
			
efektNapis1	equ *
			ldy napisY
			cpy #14			;dla 15 nie rysuj pionowych linii
			bcs @+
	
			lda eftab3,y
			sta pom
			sta efn_s+1
			sta efn_s1+1
			lda eftab3+14,y
			sta pom+1
			sta efn_s+2
			sta efn_s1+2
			ldx eftab2,y
			lda #96 		;rts
			sta efnap1,x
			stx pom0
			
			clc
			lda napisX
			adc napisDX
			tay
efn_s		equ *
			jsr $ffff
			ldy napisX
efn_s1		equ *
			jsr $ffff
			
			ldx pom0
			lda #190		;ldx  ,y
			sta efnap1,x



@			ldy napisDX
			cpy #29
			bcs @+1

efn1		equ *			
			ldx $ffff,y
			lda eftab1,x
efn1b		equ *
			sta $ffff,y
efn2		equ *
			ldx $ffff,y
			lda eftab1,x
efn2b		equ *
			sta $ffff,y
			dey
			bpl efn1
			
			sec
			lda efn1+1
			sbc #49
			sta efn1+1
			sta efn1b+1
			bcs @+
			dec efn1+2
			dec efn1b+2
		
@			clc
			lda efn2+1
			adc #47
			sta efn2+1
			sta efn2b+1
			bcc @+
			inc efn2+2
			inc efn2b+2

			
@			dec napisX
			inc napisDX
			inc napisDX
			lda napisY
			beq @+
			dec napisY

@			rts
			
titleChars1	equ *
			:8 dta b(0)				;79
			:8 dta b(%11111111)		;7a
			:8 dta b(%11110000)		;7b
			:8 dta b(%00001111)		;7c
			:8 dta b(%01010101)		;7d
			:8 dta b(%01010000)		;7e
			:8 dta b(%00000101)		;7f
			
titleNapis	equ *
			dta b($80,$80,$7f,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$80,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$7e,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$80,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$80,$7f,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d,$7d)
			dta b($80,$7d,$80,$7d,$7e,$80,$7d,$7e,$80,$7d,$7e,$80,$7f,$7e,$80,$7d,$7f,$7d,$7f,$7f,$7e,$80,$7d,$7f,$7d,$7f,$7d)
			dta b($80,$7d,$7e,$7f,$80,$7e,$7f,$80,$7d,$7d,$80,$7d,$7f,$80,$7e,$7f,$80,$7d,$7f,$7f,$80,$7e,$7f,$80,$7d,$7f,$7d)
			dta b($80,$7d,$7e,$7f,$7f,$7d,$7f,$80,$80,$7d,$7f,$7d,$7d,$7f,$7d,$7f,$80,$7f,$7f,$7f,$7f,$7d,$7f,$80,$7f,$7f,$7d)
			dta b($80,$7d,$7e,$7f,$7f,$7d,$7f,$7d,$7e,$7f,$7f,$7d,$7d,$7f,$7d,$7f,$7f,$80,$7f,$7f,$80,$80,$7f,$7f,$80,$7f,$7d)
			dta b($80,$80,$80,$7f,$80,$7e,$7f,$7f,$7e,$7f,$80,$7d,$7f,$80,$7e,$7f,$7f,$7e,$7f,$7f,$7f,$7d,$7f,$7f,$7e,$7f,$7d)
			dta b($80,$80,$80,$7d,$7e,$80,$7d,$80,$80,$7d,$7e,$80,$7f,$7e,$80,$7d,$7f,$7d,$7f,$7f,$7f,$7d,$7f,$7f,$7d,$7f,$7d)
			