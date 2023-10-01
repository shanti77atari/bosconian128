;FastSprites	= 1		;rysuj duszki bez maski za pomocą EOR, zielony zamiast czerwonego
A800			= 1		;poprawka do emulatora A800 (IRQ)
PSP_CODE		= 1		;

			opt h-
			ins "title.obx"
			ins "logo.obx"
			opt h+
	

CONSOL		equ $D01F
VCOUNT		equ $D40B
WSYNC		equ $D40A
COLPFS0		equ 708
COLPFS1		equ 709
COLPFS2		equ 710
COLPFS3		equ 711
COLBAKS		equ 712
COLBAK		equ $D01A
COLPF0		equ $D016
COLPF1		equ $D017
COLPF2		equ $D018
COLPF3		equ $D019
RANDOM		equ $D20A
DLPTRS		equ $0230
DLPTR		equ $D402
CHBAS		equ $02F4
CHBASE		equ $D409
GTIACTL		equ $D01B  ;priorytet wyswietlania kolorow i duszkow +piaty duszek
GTIACTLS		equ $26F
PMCTL		equ $D01D
DMACTLS		equ $022F
DMACTL		equ $D400
PMBASE		equ $D407
HPOSP		equ $D000
HPOSM		equ $D004
COLPM		equ $D012
COLPMS		equ $02C0
SIZEM		equ $D00C
SIZEP		equ $D008
VSCROL		equ $D405
HSCROL		equ $D404
AUDCTL		equ $D208
AUDF1		equ $D200
AUDF2		equ $D202
AUDF3		equ $D204
AUDF4		equ $D206
IRQEN		equ $D20E
VTIMER1		equ $0216
VTIMER4		equ $0214
STIMER		equ $D209
AUDC1		equ $D201
AUDC2		equ $D203
AUDC3		equ $D205
AUDC4		equ $D207
DLIV			equ $0200
NMIEN		equ $D40E
JOY			equ $D300
FIRE			equ $D010
VBLKI		equ $222
VBLKD		equ $224	
SKCTL		equ $d20f
GRAFP0		equ $d00d
GRAFP1		equ $d00e
GRAFP2		equ $d00f
GRAFP3		equ $d010
GRAFM		equ $d011

;od 0 do 71 pok0
;od 104 do 126 pok1

			opt h-
			org 23
;zmienne
posx 	org *+1	;equ 227	;0
posY	org *+1	;	equ 228	;1
movX	org *+1	;	equ 229	;2
movY	org *+1	;	equ 230	;3
movX0	org *+1	;equ 231	;4
movY0	org *+1	;equ 232	;5
movYs	org *+1	;equ 233	;6
sirq	org *+1	;equ 234	;7
ramka	org *+1	;equ 235	;8
vblFlaga	org *+1	;	equ 236	;9
pauza		org *+1	;equ 237	;10
stan_gry		org *+1	;equ 238	;11
trafienie		org *+1	;equ 239	;12
startMapy		org *+1	;equ 240	;13
lastEnemy		org *+1	;equ 241	;14


vblX		org *+1	;equ 242	;15
vblY		org *+1	;equ 243	;16
vblA		org *+1	;equ 244	;17
znacznik	org *+1	;equ 245	;18
bazyIle	org *+1	;equ 246	;19		;ile baz		;42


kanal_audf1			org *+2	;equ 0
kanal_audf2			org *+2	;equ 2
kanal_audf3			org *+2	;equ 4
kanal_audc1			org *+2	;equ 6
kanal_audc2			org *+2	;equ 8
kanal_audc3			org *+2	;equ 10			;54


pom0	org *+1	;equ 247	;21
pom0a	org *+1	;equ 248	;22
pom0b	org *+1	;equ 249	;23
pom0c	org *+1	;equ 250	;24
pom0d	org *+1	;equ 251	;25
pom0e	org *+1	;equ 252	;26
pom0f	org *+1	;equ 253	;27
kolpom0	org *+1	;equ 254
zegar		org *+1	;equ 255	; wcześniej 20		;63


licznikPokey	org *+1	;equ 40
znakX1	org *+1	;equ 43
znakY1	org *+1	;equ 44
znakDX	org *+1	;equ 45
znakDY	org *+1	;equ 46		;82
znakX		org *+18	;equ 47 ;18
znakY		org *+18	;equ znakX+18	;18

pom		org *+2	;	equ 28
pom1		org *+2	;equ 30
pom2		org *+2	;equ 32
pom3		org *+2	;equ 34
screenL	org *+2	;equ 36
screenH	org *+2	;equ 38
strz	org *+2	;equ 23
strz1	org *+2	;equ 25
strz0	org *+1	;equ 27
strz0a	org *+1	;equ 96
strz0b	org *+1	;equ 97
strz0c	org *+1	;equ 98
strz0d	org *+1	;equ 99
strz0e	org *+1	;equ 100
strz0f	org *+1	;equ 101	
rejX		org *+1	;equ 41
rejA		org *+1	;equ 42

muzyka	org *+1	;equ 83
rejY		org *+1	;equ 84
	
;tu procedura pok1 (104)


			org 204
pom0g		org *+1	;equ 85
flaga		org *+1	;equ 86
bankStos	org *+1	;equ 87
kolorPanel	org *+1	;equ 88
rodzajSpeech	org *+1	;equ 89
ramka4	org *+1	;equ 90
bombIle	org *+1	;equ 91
czyRakiety	org *+1	;equ 92
rads		org *+1	;equ 93
powtorz	org *+1	;equ 94
sJoy		org *+1	;equ 95		;214

		
			org $1200
fazaWybuch	org *+1
enemyPosX	org *+6
enemyPosY	org *+6
formacjaX	org *+1
forLicznik	org *+1
formacja_zbite	org *+1
dowodca		org *+1		

ntscf		org *+1
kolorCzerwony	org *+1	
kolorMapa		org *+1
kolorRound		org *+1
kolor1ups		org *+1
kolorLevel		org *+1
kolorLogo		org *+1
kolorGreen		org *+1
kolorYellow		org *+1
kolorRed		org *+1
KOLOR1			org *+1
KOLOR3			org *+1

ile_Kolorow	equ 11

;od 237 zmienne RMT
			opt h+
			


pozWyniki	equ 177  ;pozycja tabeli wynikow
OPTION		equ 4
SELECT		equ 2
START		equ 1


sprites1	equ $F800	;adres duszkow gdy wlaczony jest panel
znaki1	equ $B800		;2 bit w starszym bajcie skasowany
znaki2	equ znaki1+$400	;drugi zestaw znakow
obraz1a	equ $200
obraz1	equ obraz1a+8+8*48
obraz2a	equ obraz1+28*48+48
obraz2	equ obraz2a+8+8*48

b					equ 3	;11		;nr pierwszego zanku bazy
firstBombaChar		equ b+28		;pierwszy znak bomby
firstMeteorChar		equ firstBombaChar+4		;meteoru
firstRakietaChar	equ firstMeteorChar+4
firstWybuchChar		equ firstRakietaChar+8	;47
firstMalyWybuchChar	equ firstWybuchChar+16	;+20	;63
firstStrzalChar		equ firstMalyWybuchChar+2 ;63+2=65	
firstPociskChar		equ firstStrzalChar+4	;65+4=69
											;69+5=74 duszki
startWyniki equ 16
lenDlist	equ 29	;ilosc linii ekranu w dlist

EKOLOR0		equ 0		;duszek przyjmuje kolor tła, oprócz gwiazd
EKOLOR1		equ 128		;duszek wymusza negatyw



;kolory

kolorLiczby		equ $0c  ;bialy
pozliczby		equ 180

			icl 'banki.asm'
			
			org PORTB
			dta b(BANK4s)
			org $4000
			icl 'hscore.asm'
			icl 'title.asm'
			icl 'pokey.asm'
	
			
rmt_goto	equ MODUL_END-4*$1d	;$7310-4*$20 	;$1F+1			
MODUL	equ $6100
			opt h-
			ins "b1.rmt"
			opt h+ 
MODUL_END		equ $6f90
			org $7400
	
		
asteroid_dat	dta a(0)
				ins '/sfx/asteroid_audf'
bomba_dat		dta a(0)
				ins '/sfx/bomba_audf'
spyHit_dat	dta b(0)
				ins '/sfx/spyHit_audf'
enemyHit_dat dta a(0)
				ins '/sfx/enemyHit_audf'
strzal_dat	dta a(0)
				ins '/sfx/strzal_audf'	
dzialko_dat	dta a(0)
				ins '/sfx/dzialko_audf'
wybuch_dat	dta a(0)
				ins '/sfx/wybuch_audf'	
dead_dat		dta a(0)
				ins '/sfx/dead_audf'		
antyair_dat	dta a(0)
				ins '/sfx/antyair_audf'		
extraLife_dat dta a(0)
				ins '/sfx/extraLife_audf'
alarm_dat		dta b(0)
				ins '/sfx/alarm_audf'	
rakieta_dat	dta a(0)
				ins '/sfx/rakieta_audf'	
silnik_dat	dta b(0)
				ins '/sfx/silnik_audf'					

	
asteroid1_dat	dta a(0)
				ins '/sfx/asteroid_audc'
bomba1_dat		dta a(0)
				ins '/sfx/bomba_audc'
spyHit1_dat	dta a(0)
				ins '/sfx/spyHit_audc'
enemyHit1_dat dta a(0)
				ins '/sfx/enemyHit_audc'
strzal1_dat	dta a(0)
				ins '/sfx/strzal_audc'	
dzialko1_dat	dta a(0)
				ins '/sfx/dzialko_audc'
wybuch1_dat	dta a(0)
				ins '/sfx/wybuch_audc'	
dead1_dat		dta a(0)
				ins '/sfx/dead_audc'		
antyair1_dat	dta a(0)
				ins '/sfx/antyair_audc'		
extraLife1_dat dta a(0)
				ins '/sfx/extraLife_audc'
alarm1_dat		dta b(0)
				ins '/sfx/alarm_audc'	
rakieta1_dat	dta a(0)
				ins '/sfx/rakieta_audc'	
silnik1_dat	dta b(0)
				ins '/sfx/silnik_audc'	
 
					
			//pod rom
			icl 'poziomy.asm'
			
			org PORTB
			dta b(BANK3s)
			icl 'datamatrix.asm'
			icl 'matrix.asm'
			
			org PORTB
			dta b(ROM_on)
			
			//wlasciwy program
			icl 'przerwania.asm'
			
			icl 'bszczaly.asm'
			icl 'duszki3.asm'
			icl 'bliczby.asm'
			
			;Po $4000
			icl 'bmove.asm'
			
			icl 'bgrafika.asm'
			icl 'bantyair.asm'
			
			icl 'wybuch.asm'
			icl 'time.asm'
			icl 'rakiety.asm'
			
			icl 'spy.asm'

			icl 'formation.asm'
			
			
			icl 'kolizje.asm'
			icl 'enemy.asm'
			;poza $8000
			icl 'blevele.asm'
			
			
			
			;GLOWNY PROGRAM
kol_tab	.he 36,50,4a,8a,ba,34,b8,ea,34,28,34
		.he 46,62,5a,98,ca,44,c8,fc,46,38,44
		
czarp1	equ *
		:4 dta b(%10110101)
		:2 dta b(255)
		dta b(%10100101)
		dta b(255)
		:2 dta b(%10110101)
		
livesRed	equ *
			ldx #9
@			lda czarp1,x
			sta sprites+startWyniki+$7c6,x
			dex
			bpl @-
			rts
			
livesRedOff	equ *
			ldx #9
			lda #255
@			sta sprites+startWyniki+$7c6,x
			dex
			bpl @-
			rts
		
czarnyPanel	equ	*
			lda #255  
			ldx #0
@			sta sprites+$700,x  ;wypelniamy 4 duszka
			dex
			bne @-
			
			ldx #240
@			sta sprites1+$700,x
			dex
			bne @-
			
			
			
			sta sprites1+$700+12
			sta sprites1+$700+242
			lda #255	;#126
			sta sprites1+$700+10
			sta sprites1+$700+244
			lda #255	;#60
			sta sprites1+$700+8
			sta sprites1+$700+246
			
			lda #0
			sta sprites1+$700+13
			sta sprites1+$700+11
			sta sprites1+$700+9
			sta sprites1+$700+241
			sta sprites1+$700+243
			sta sprites1+$700+245
			sta sprites1+$700+247
			
			rts

			
spriteOn	equ *
			jsr czysc_duszki
			jsr piszCondition
			jsr pisz_zycia
			jsr pisz_panel
			
			jsr czarnyPanel
			
			lda #3
			sta PMCTL   ;wlaczenie spritow
			lda #>sprites
			sta PMBASE ;adres obrazu duszkow
			lda #1
			
			sta GTIACTL	
			
			lda #3
			sta SIZEP+3
			lda #0
			sta COLPM+3
			
			
			rts




newPoziom		dta b(0)
			
antyairOpoznienie dta b(0)

;sampleDiv	equ $1200	;druga strona, tablica podziału próbki przez 4
tabX	equ $1300		
tabDiv100	equ $1400
adresZnakL	equ $1500
adresZnakH	equ $1600

sprites 	equ $1800		;+$300 = od $1B00 do $2000-1 efektywnie

obraz1La	equ $1700
obraz1Ha	equ obraz1La+37
obraz2La	equ obraz1Ha+37
obraz2Ha	equ obraz2La+37
dlist		equ obraz2Ha+37 ;35 bajtów, zajete 183 bajty na tej stronie

obraz1L		equ $1800 			;za samplami
obraz1H		equ obraz1L+29
obraz2L		equ obraz1H+29
obraz2H		equ obraz2L+29


run		equ *	
		mva #0 DMACTLS		;ukryj ekran
		sta DMACTL
		sta stan_gry
		
		;lda #0
		sta $d208
		ldy #3
		sty $d20f
		
		sei
		mva #0 NMIEN
		sta $d20e
		sta HPOSM+3
		lda #pozWyniki-1
		sta HPOSP+3
		
		
@		lda vcount
		bne @-
		

@		lda vcount
@		cmp vcount
		beq @-
		bcc @-1
		
		ldx #0
		cmp #140
		bcs *+4
		ldx #1
		stx ntscf			;0=pal,1=ntsc
		
		
		mva #<asteroid_dat kanal_audf1
		sta kanal_audf2
		sta kanal_audf3
		mva #>asteroid_dat kanal_audf1+1
		sta kanal_audf2+1
		sta kanal_audf3+1
		mva #<asteroid1_dat kanal_audc1
		sta kanal_audc2
		sta kanal_audc3
		mva #>asteroid1_dat kanal_audc1+1
		sta kanal_audc2+1
		sta kanal_audc3+1
		
		ldy #0
		ldx #0
		lda $d014
		and #$0e
		beq @+
		ldx #ile_kolorow
@		lda kol_tab,x
		sta kolorCzerwony,y
		inx
		iny
		cpy #ile_kolorow
		bne @-
		
		ldx #2
@		lda kolorGreen,x
		sta conditionC,x
		dex
		bpl @-
		
		
		mva #BANK0 PORTB		;wylaczamy bios
		
		mva <nmi $fffa
		mva >nmi $fffa+1
		mwa #pokey $fffe
		
		mwa #dli DLIV ;wektor przerwania dli
		
		mva #%01000000 NMIEN ;zezwolenia na przerwania dli _+ VBLK
		cli
	
		;INIT TABLIC
				

		
		;tablica podziału przez x*100/256=x*25/64
		ldx #0
@		stx pom
		lda #0
		sta pom+1
		;x*25
		ldy #25-1		;o 1 mniej bo w pom juz jest x
@		clc
		txa
		adc pom
		sta pom
		lda pom+1
		adc #0
		sta pom+1
		dey
		bne @-
		;/64  przesun o 6 w prawo czyli latwiej o 2 w lewo
		lda pom+1
		asl pom
		rol
		asl pom
		rol 
		;zapisz w tablicy
		sta tabDiv100,x
		inx
		bne @-1
		
		;tabX
		ldy #80
		ldx #208
@		txa
		sta tabx,x		;od 208 do 79 -> (208-79)
		sta tabX,y		;od 80 do 207 -> (208-79)
		iny
		inx
		cpx #80
		bne @-
		
		;adresy znaków
		mwa #znaki1	pom
		ldy #0
@		lda pom
		sta adresZnakL,y
		sta adresZnakL+128,y
		lda pom+1
		sta adresZnakH,y
		sta adresZnakH+128,y
		clc
		lda pom
		adc #8
		sta pom
		bcc @+
		inc pom+1
@		iny
		cpy #128
		bne @-1
		
		;adresy linii obraz1a
		mwa #obraz1a pom
		mwa #obraz2a pom1
		ldy #0
@		lda pom
		sta obraz1La,y
		lda pom+1
		sta obraz1Ha,y
		lda pom1
		sta obraz2La,y
		lda pom1+1
		sta obraz2Ha,y
		clc
		lda pom
		adc #48
		sta pom
		bcc @+
		inc pom+1
@		clc
		lda pom1
		adc #48
		sta pom1
		bcc @+
		inc pom1+1
@		iny
		cpy #37
		bne @-2
		
		;adresy linii obraz1LH
		mwa #obraz1 pom
		mwa #obraz2 pom1
		ldy #0
@		lda pom
		sta obraz1L,y
		lda pom+1
		sta obraz1H,y
		lda pom1
		sta obraz2L,y
		lda pom1+1
		sta obraz2H,y
		clc
		lda pom
		adc #48
		sta pom
		bcc @+
		inc pom+1
@		clc
		lda pom1
		adc #48
		sta pom1
		bcc @+
		inc pom1+1
@		iny
		cpy #29
		bne @-2
		
		;dlist
		mva #$d0 dlist
		mva #$74 dlist+1
		mwa #obraz1 dlist+2
		ldy #26
		lda #$34
@		sta dlist+4,y
		dey
		bpl @-
		mva #$14 dlist+31
		mva #$41 dlist+32
		mwa #dlist dlist+33	
		
		ldx #10*8-1
@		lda cyfra1,x
		:4 asl
		sta cyfra2,x
		dex
		bpl @-
		
;przerwanie pokeya na strone 0
		mva #BANK4 PORTB
		ldx #22
@		lda $8000-23,x
		sta 0,x
		dex
		bpl @-
		
		ldx #71
@		lda $8000-23-72,x
		sta 132,x
		dex
		bpl @-
		mva #BANK0 PORTB
		
		
		;-----
		jsr gwiazdyInit
		
		mva #10 punkty
		
		mva #10 antyairOpoznienie
		jsr czyscObraz2
		
		
		mwa #obraz2 dlist+2
		
		lda #<dlist    ;program antica
		sta DLPTR
		lda #>dlist
		sta DLPTR+1
		mva #>znaki1 CHBASE
		
		jsr waitvbl
			
		mva #0 COLBAK
		sta flagHscore
		
		jsr spriteOn
		
		ldy #0
		jsr setCondition
		mva #1 poziom		
		jsr piszPoziom
		jsr piszHscore1
		
Title_s	mva #BANK0 PORTB
		jsr waitvbl
		mva #0 DMACTL
		sta GRAFM
.IF .DEF PSP_CODE
		sta psp
.ENDIF
		
		jsr init_fx
		jsr livesRedOff
				
		mva #0 sfxlicznik1
		sta pauza
		sta formacja_stan
		sta formacja_radar
		jsr piszCondition
		ldy kondycja_stan		;poprzednia kondycja
		jsr setCondition
		mva #0 stan_gry
		
		mva #BANK4 PORTB
		
		ldx #<MODUL					;low byte of RMT module to X reg
		ldy #>MODUL					;hi byte of RMT module to Y reg
		lda #$06						;starting song line 0-255 to A reg 	
		jsr RASTERMUSICTRACKER
		

		mva #6 kolpom0
		
		mva #1 stan_gry
		
		jsr Title
		
@		lda VCOUNT
		cmp #124
		bcc @-		
		
		mva #0 DMACTL
		sta score
		sta score+1
		sta score+2
		mwa #dlist	DLPTR
		mva #>SPRITES PMBASE
		
		mva #0 stan_gry

		
		mva #BANK0 PORTB
		
		jsr init_fx
		
		jsr czarnyPanel
		jsr pisz_zycia
	
		
		
		
		mwa #obraz1 dlist+2
		jsr czyscObraz1
		
		;mva #10 poziom		;poziom startowy
		;jsr piszPoziom
		
		lda JOY
		and #1
		beq @+
		mva #1 poziom		
		
@		jsr wczytajLevel
		
		jsr pokazBazyRadar
		
		ldy #0
		jsr setCondition
		jsr czyscScore
		jsr piszScore1
			
		mva #3	lives
		jsr printLives
		mva #1 scoreZmiana	;nie ma nowych punktów
			
					
		jsr livesRed

		
		mva #1 zegar
		
		mva KOLOR1 COLPF1
		mva KOLOR3 COLPF3
		
		mva #0 flagHscore
		
		
		mva #%11000000 NMIEN
		
		mva #2 stan_gry

		jmp poczatek		;nie pokazuj ekranu przed narysowaniem
		
;glowna petla		
loop	equ *
;
;Czekamy na ramke 2
;		

		mwa #obraz1 dlist+2
		mva #>znaki1 CHBASE
		mva movX HSCROL
		mva movY VSCROL
		mva #0 zegar
		
		mva #58 DMACTL		
		
		lda speech		;jesli sampel to mrygaj 2 duszkiem
		beq @+
		lda kolorPanel
		adc #2
		and #%1111
		sta kolorPanel
		ldx rodzajSpeech
		ora panelTab,x
		sta COLPM+2 
@		equ *		
;obsluga sampli		
		lda nobanner
		jeq glos1
		cmp #1
		bne @+

		mva #%01000000 NMIEN

		
		sei
		mwa #pok0 $fffe
		
		lda #15
		sta AUDF4
		mvy #0 IRQEN
		cli
		
		jsr schowaj_duszki
		lda formacja_stan
		beq *+5
		jsr pisz_formation		;tylko jesli wlaczona formacja
		
		inc nobanner
		
		
		mva #4 sirq
		sta IRQEN
		jmp glos1
		
@		lda sirq
		bne glos1		;jeszcze sie nie skonczyl		
		
		mva #0 AUDF4
		sta speech
		sta nobanner
		
		mva #%11000000 NMIEN
		
		;sta nobanner
		jsr pokaz_duszki

glos1		equ *
poczatek	equ *
	
		jsr play_FX
		
	
		mwa #obraz2L screenL
		mwa #obraz2H screenH
		
		jsr printShip
		
		lda nobanner
		cmp #2
		bcs *+5
		jsr radar


		jsr czyscObraz2
		
		jsr timeEvents
		
;rysujemy na obrazie 2
		mva #1 ramka
		sta vblFlaga
		mva #4 ramka4		;ramka*4	
		
		jsr moveShip			;przesun i narysuj statek			
			
		jsr gwiazdyRysuj2
		jsr animacjaJadraA
		jsr animacjaJadraB
		
	
		jsr coreWaveA
		jsr coreWaveB
		
		lda trafienie
		ora startMapy
		bne @+
		lda czyRakiety
		beq @+
		jsr moveRakiety		;rakiety
		jsr rakiety
@		equ *
		
		jsr printEkran	
				
		jsr rysujWybuchy		;animuj wybuchy
		jsr rysujmWybuchy
							
		lda trafienie
		ora startMapy
		bne @+
		
		jsr kolStatekWybuch	
		jsr movePociski1	
		
		
		jsr kolStatekObiekty
		jsr kolStatekBazy
		
		
		jsr kolRakietyStatek		
		jsr kolRakietyObiekty
@		
		jsr spy
		jsr formacja
		
		
		lda trafienie
		ora startMapy
		bne @+
		jsr printSpyScore
		
@		jsr moveEnemy
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr dodaj_przeciwnika
		
		
@		equ *		
		jsr rysujEnemy
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr obliczEnemyXY
		jsr kolStatekEnemy
		
		jsr printPociski
		jsr kolPociskiEnemy
		;jsr kolObiektyEnemy
		
		
		jsr kolPociskiStatek
		jsr kolPociskiObiekty
		
@		equ *	

	
		lda nobanner
		cmp #2
		bcs @+
		jsr poprawlives2
@		equ *
		
		lda #0
@		cmp zegar
		beq @-
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr moveStrzal
		
		jsr pushFire			;czy wcisnieto fire?

		jsr obliczStrzalXY2		;kolizje strzlow statku
		jsr printStrzal
  
		
		jsr kolStrzalyEnemy
		jsr kolStrzalyRakiety
		jsr kolStrzalyObiekty
		jsr kolStrzalyBazy
				
		jsr moveStrzal
				
		jsr obliczStrzalXY2
		
		
		jsr locateStrzal2
		mva #<strzalTlo1 _tlo1+1
		sta _tlo2+1
		jsr kolStrzalyEnemy
		jsr kolStrzalyObiekty		;do poprawki
		mva #<strzalTlo _tlo1+1
		sta _tlo2+1
		jsr kolStrzalyBazy
		
					
@		jsr sumaPunkty		;sumuj punkty
		
		jsr play_FX

		jsr sounds			;dodaj wszystkie efekty
		jsr czyNowyLevel	;sprawdz czy ukonczono poziom
		
		
	
		
;
;Czekamy na ramke		1
;		
@		lda zegar
@		cmp zegar
		beq @-	

loop2	equ *	
			
		
		
		mwa #obraz2 dlist+2
		mva #>znaki2 CHBASE
		mva movX HSCROL	
		mva movY VSCROL
		
		mva #0 zegar
		mva #58 DMACTL		
		
		
		lda speech		;jesli sampel to mrygaj 2 duszkiem
		beq @+
		lda kolorPanel
		adc #2
		and #%1111
		sta kolorPanel
		ldx rodzajSpeech
		ora panelTab,x
		sta COLPM+2 
		
@		lda formacja_stan
		beq @+
		cmp #5
		beq @+
		
		lda conditionColor
		eor #$34
		sta conditionColor
@		equ *
	
		jsr play_FX
		
		mwa #obraz1L screenL
		mwa #obraz1H screenH
		
		jsr printShip
		
		lda nobanner
		cmp #2
		bcs @+
		jsr radar
@		equ *
	

		jsr czyscObraz1	

;rysujemy na obrazie1
		mva #0 ramka
		sta ramka4
		mva #1 vblFlaga
		
		jsr moveShip			;przesun i narysuj statek

		jsr gwiazdyRysuj1
		jsr animacjaJadraA
		jsr animacjaJadraB
			
	
		jsr coreWaveA
		jsr coreWaveB
	
		
		lda trafienie
		ora startMapy
		bne @+
		ora czyRakiety
		beq @+
		jsr moveRakiety		;rakiety
		jsr rakiety
@		equ *
		
		jsr printEkran
		
		jsr rysujWybuchy
		jsr rysujmWybuchy
		
		
		lda trafienie		
		ora startMapy
		bne @+
		
		
		jsr kolStatekWybuch
		jsr movePociski1
		jsr antyair1
		
		jsr kolStatekObiekty
		jsr kolStatekBazy
		jsr kolRakietyStatek

		
		;jsr kolRakietyObiekty
				
		jsr losuj		;losuj spy,formacja
		
@		equ *		
		jsr spy
		jsr formacja
		
		lda trafienie		
		ora startMapy
		bne @+
		
		jsr printSpyScore
		
@		equ *		
		jsr moveEnemy

		jsr rysujEnemy
		
		lda trafienie		
		ora startMapy
		bne @+
		
		jsr obliczEnemyXY
		jsr kolStatekEnemy	
		jsr kolObiektyEnemy	

		jsr printPociski
		jsr kolPociskiEnemy	
		jsr kolPociskiStatek
		jsr kolPociskiObiekty		;kolizje Pociskow z Bomami i meteorami
		
		
@		equ *		
				
		lda nobanner		;jesli sampel to nie poprawiaj lives
		cmp #2
		bcs @+
		jsr poprawlives1
@		equ *

		
		lda #0
@		cmp zegar
		beq @-
		
		lda trafienie
		ora startMapy
		bne @+
		
		jsr moveStrzal
		
		jsr pushFire
		jsr obliczStrzalXY2
		jsr printStrzal
		
		jsr kolStrzalyEnemy
		jsr kolStrzalyRakiety
		jsr kolStrzalyObiekty
		jsr kolStrzalyBazy

		jsr moveStrzal
		
		jsr obliczStrzalXY2		
		
		jsr locateStrzal1
		mva #<strzalTlo1 _tlo1+1
		sta _tlo2+1
		jsr kolStrzalyEnemy
		jsr kolStrzalyObiekty		;do poprawki
		mva #<strzalTlo _tlo1+1
		sta _tlo2+1
		jsr kolStrzalyBazy
			
		
@		lda nobanner
		beq @+
		jmp loop1
		
@		lda CONSOL
		and #START
		bne @+3
		mva #1 pauza
		mva #0 AUDC1
		sta AUDC2
		sta AUDC3
@		lda CONSOL
		and #START+OPTION
		cmp #START+OPTION
		bne @-
		
@		lda CONSOL
		sta pom0
		and #OPTION+START
		cmp #OPTION+START
		beq @-
		
		lda pom0
		and #START
		beq @+		;wznów gre
		mva #50 startMapy
		
		jsr zmaz_radar
		
		jmp title_s-3		;resetuj + nie zaliczaj hscore , wypisz stare
	
@		lda CONSOL
		and #START
		cmp #START
		bne @-
		mva #0 pauza
@		equ *	
		
		lda scoreZmiana
		bne @+
		jsr piszScore1		;wyswietlaj zmienione hscore tylko jesli nie ma sampla
		jsr czyHscore
@		equ *		

loop1	equ *

		jsr play_FX
		jsr sounds		;dodaj efekty
		
		
@		lda zegar
@		cmp zegar
		beq @-	
		
		jmp loop
		
		
STEREOMODE	equ 0

		
		icl "rmtplayr.asm"	
		
kanal1				org *+1
petla1				org *+1
kanal2				org *+1
petla2				org *+1
kanal3				org *+1
petla3				org *+1

kanal1s				org *+2		;2 bajty , uzywamy tylko 1
kanal2s				org *+2
kanal3s				org *+2	
sfx					org *+1
	
add_fx
		mva #BANK4 PORTB
		lda audf_table,y
		sta kanal_audf1,x
		lda audf_table+1,y
		sta kanal_audf1+1,x
		
		lda audc_table,y
		sta kanal_audc1,x
		lda audc_table+1,y
		sta kanal_audc1+1,x
		
		lda len_table,y
		sta kanal1,x				;dlugosc
		sta kanal1s,x
		lda len_table+1,y
		sta petla1,x			;petla
		mva #BANK0 PORTB
		rts
		

play_fx
		lda sfx
		bne @+				;=1 graj moje fxy
		jmp playFX

@		equ *
		mva #BANK4 PORTB
		ldy kanal1
		beq pfx2
		lda (kanal_audf1),y
		sta _vbsnd1
		lda (kanal_audc1),y
		sta _vbsnd2
		dey
		bne @+					;jeszcze nie koniec
		lda petla1			;czy zapetlony 0=nie
		beq @+
		ldy kanal1s
@		sty kanal1

pfx2   ldy kanal2
		beq pfx3
		lda (kanal_audf2),y
		sta _vbsnd3
		lda (kanal_audc2),y
		sta _vbsnd4
		dey
		bne @+					;jeszcze nie koniec
		lda petla2			;czy zapetlony 0=nie
		beq @+
		ldy kanal2s
@		sty kanal2
		
pfx3	ldy kanal3
		beq pfx0
		lda (kanal_audf3),y
		sta _vbsnd5
		lda (kanal_audc3),y
		sta _vbsnd6
		dey
		bne @+					;jeszcze nie koniec
		lda petla3			;czy zapetlony 0=nie
		beq @+
		ldy kanal3s
@		sty kanal3		

pfx0	mva #BANK0 PORTB
		rts		
		
	
audf_table
		dta a(asteroid_dat),a(bomba_dat),a(spyHit_dat),a(0),a(0)
		dta a(enemyHit_dat),a(strzal_dat),a(dzialko_dat),a(wybuch_dat),a(dead_dat)
		dta a(0),a(0),a(antyair_dat),a(extraLife_dat),a(alarm_dat)
		dta a(rakieta_dat),a(silnik_dat)

audc_table
		dta a(asteroid1_dat),a(bomba1_dat),a(spyHit1_dat),a(0),a(0)
		dta a(enemyHit1_dat),a(strzal1_dat),a(dzialko1_dat),a(wybuch1_dat),a(dead1_dat)
		dta a(0),a(0),a(antyair1_dat),a(extraLife1_dat),a(alarm1_dat)
		dta a(rakieta1_dat),a(silnik1_dat)
		
len_table
		dta b(9+1,0),b(56+1,0),b(34+1,0),a(0),a(0)					;+1 bo dodajemy ciszę
		dta b(27+1,0),b(19+1,0),b(20+1,0),b(62+1,0),b(70+1,0)
		dta a(0),a(0),b(13+1,0),b(49+1,0),b(60,1)
		dta b(46+1,0),b(144,1)
		



		run run
		