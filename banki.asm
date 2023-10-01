ROM_on	equ %11111111
BANK0	equ %11111110
BANK1	equ %11101110
BANK1s	equ %11101111		;z wlaczonym systemem
BANK2	equ %11101010
BANK2s	equ %11101011		
BANK3	equ %11100110
BANK3s	equ %11100111
BANK4	equ %11100010
BANK4s	equ %11100011
PORTB	equ $D301
EXTMEM	equ $4000

bom0		equ 203
bom0a	equ 204
bom		equ 205
bom1		equ 207
bom2		equ 203

enemy		equ dlist+35
enemyX		equ enemy+6
enemyX0		equ enemy+12
enemyY		equ enemy+18
enemyY0		equ enemy+24
enemyDX		equ enemy+30
enemyDY		equ enemy+36
enemyFaza	equ enemy+42
enemyBank	equ enemy+48
enemyShapeH	equ enemy+54
enemyDX0		equ enemy+60
enemyDY0		equ enemy+66

strzal		equ $100		;wyrównanie do strony
strzalX		equ strzal+4
strzalX1		equ strzal+8
strzalX2		equ strzal+12
strzalX3		equ strzal+16

strzalY1		equ strzal+20
strzalY2		equ strzal+24
strzalY3		equ strzal+28
strzalYbit	equ strzal+32
strzalKierunek	equ strzal+36
strzalTlo	equ strzal+40
strzalTlo1	equ strzal+44
strzalY		equ strzal+48
strzalXbit	equ strzal+52

sample		equ sample6adr+sample6len
sampleEnd	equ sample+12


enemy1shapeTab	equ EXTMEM
enemy1maskTab		equ EXTMEM+$080
enemy2shapeTab	equ EXTMEM+$100
enemy2maskTab	equ EXTMEM+$180
enemy1adr	equ EXTMEM+$200
enemy2adr	equ enemy1adr+2816	;512+3*768
enemy1mask	equ enemy2adr+2816

enemy3shapeTab	equ EXTMEM
enemy3maskTab	equ EXTMEM+$080
enemy4shapeTab	equ EXTMEM+$100
enemy4maskTab	equ EXTMEM+$180
enemy3adr	equ EXTMEM+$200
enemy4adr	equ enemy3adr+2816	;512+3*768
enemy3mask	equ enemy4adr+2816

enemy5shapeTab	equ EXTMEM
enemy5maskTab	equ EXTMEM+$080
explo_shapeTab	equ EXTMEM+$100
explo_maskTab	equ EXTMEM+$180
enemy5adr	equ EXTMEM+$200
enemy5mask	equ enemy5adr+2816
explo_adr	equ enemy5mask+2816
explo_mask	equ explo_adr+768	;96+3*144=528, ale wyrównujemy do strony czyli 768

sample1adr	equ $D800	;EXTMEM	;bank4	BlastOff
sample1len	equ 2306
sample2adr	equ sample1adr+sample1len  ;+dlugosc poprzedniego sampla   GameOver
sample2len	equ 2154 ;+21	;sampel z duke nukem
sample3adr	equ sample2adr+sample2len	;Alive alive
sample3len	equ 1225	;2233
sample4adr	equ sample3adr+sample3len		;condition red
sample4len	equ 2485
sample5adr	equ $C000		;Spy ship sighted
sample5len	equ 1993
sample6adr	equ sample5adr+sample5len		;Battle Station(formation)
sample6len	equ 1999

;Wolna pamięć od $f7ea do $fbff 
			org $2000

dlist_lm	dta b(112,112,112)
			dta b($42),a(nap_lm)
			dta b($41),a(dlist_lm)

nap_lm		dta d'Sorry, you need more than 64KB RAM   !!!'
			
;komunikat za mało pamięci
print_lowMemory	equ *
			mva <dlist_lm DLPTRS
			mva >dlist_lm DLPTRS+1
			mva #12 709
			mva #0 710
			rts
			
;sprawdzamy czy jest wiecej niz 64KB, znacznik Z=1 jest więcej niż 64
sprawdz_memory	equ *
			mva #%11110000 EXTMEM
			mva #BANK1 PORTB
			mva #%00001111 EXTMEM
			mva #BANK0 PORTB
			lda EXTMEM
			cmp #%11110000
			rts
			
testMem		equ *
			sei
			mva #0 NMIEN
			mva #BANK0 PORTB
			
			jsr sprawdz_memory
			bne @+
			mva #ROM_on PORTB
			mva #%01000000 NMIEN
			cli	
			rts
			
@			mva #ROM_on PORTB
			mva #%01000000 NMIEN
			cli		
			lda 20
			cmp 20
			beq *-2
			jsr print_lowMemory
			mva #58 DMACTLS
			
@			lda FIRE
			beq @-
@			lda FIRE
			bne @-
			jmp (10)		;skocz do DOS'a lub SELFTestu

			ini (testMem)
			
/*			;org $2000-140
			org $100
			
dli_graph	dta b(112),b(112),b(112)
			dta b($4a),a(bosco_graph)
			dta b($4a),a(bosco_graph)
			dta b($a)
			dta b($4a),a(bosco_graph+$10)
			dta b($a)
			dta b($4a),a(bosco_graph+$20)
			dta b($a)
			dta b($4a),a(bosco_graph+$30)
			dta b($a)
			dta b($4a),a(bosco_graph+$40)
			dta b($a)
			dta b($4a),a(bosco_graph+$50)
			dta b($a)
			dta b($4a),a(bosco_graph+$60)
			dta b($a)
			dta b($4a),a(bosco_graph+$70)
			dta b($a)
			dta b($4a),a(bosco_graph+$80)
			dta b($a)
			dta b($4a),a(bosco_graph+$90)
			dta b($a)
			dta b($4a),a(bosco_graph+$a0)
			dta b($41),a(dli_graph)
			
			org $600
bosco_graph	dta b(0)
			dta b(%01010101,%01000000)
			:14 dta b(0)
			dta b(%01010000,%01010000)
			:14 dta b(0)
			dta b(%10010000,%00010000)
			:14 dta b(0)
			dta b(%10100000,%10100000)
			:14 dta b(0)
			dta b(%10101010,%10000000)
			:14 dta b(0)
			dta b(%10100000,%10100000,%00010101,%00000001,%01010000,%00010101,%01000001,%01010000,%01000000,%01000100,%00010101,%00000100,%00000100)
			:3 dta b(0)
			dta b(%10100000,%00101000,%10100010,%01000110,%00000000,%01100000,%01001010,%00100100,%10010000,%10001000,%10100010,%01001001,%00001000)
			:3 dta b(0)
			dta b(%10100000,%00101000,%10000000,%10001010,%10100000,%10000000,%00001000,%00001000,%10101000,%10001000,%10000000,%10001010,%10001000)
			:3 dta b(0)
			dta b(%10100000,%00101000,%10000000,%10000000,%00101000,%10000000,%00001000,%00001000,%10001010,%10001000,%10101010,%10001000,%10101000)
			:3 dta b(0)
			dta b(%11101010,%10101100,%11100010,%10001100,%00101000,%11100000,%10001110,%00101000,%10000010,%10001000,%10000000,%10001000,%00101000)
			:3 dta b(0)
			dta b(%11111111,%11110000,%00111111,%00001111,%11110000,%00111111,%11000011,%11110000,%11000000,%11001100,%11000000,%11001100,%00001100)
			:2 dta b(0)
			
			org $2000

iniscr		equ *
			lda 20
@			cmp 20
			beq @-
	
			mva #0 712
			sta COLBAK

			lda $d014
			and #$0e
			beq @+
			lda #$96	;NTSC
			ldx #$44		;$34
			ldy #$fa
			jmp @+1
@			lda #$86	;PAL
			ldx #$34
			ldy #$fa
@			equ *
			
			sta 708
			sta COLPF0
			stx 709
			stx COLPF1
			sty 710
			sty COLPF2	
			
			mva #<dli_graph DLPTR
			sta DLPTRS
			mva #>dli_graph DLPTR+1
			sta DLPTRS+1
		
			mva #57 DMACTL		;pokaz ekran
			sta DMACTLS
			
			lda 20
@			cmp 20
			beq @-
						
			rts

			ini (iniscr) */

			org $8000
			
znaki_ad	equ *	
	dta b(0,0,0,0,0,0,0,0)
	
	dta b(0,0,0,0,0,0,0,0)	;znak #1 gwiazda
	dta b(0,0,0,0,0,0,0,0)	;2 gwiazda
	
;bazy
	dta b(%00000011)		;1 znak  stacji
	dta b(%00001111)
	dta b(%00111111)
	dta b(%00111111)
	dta b(%00001100)
	dta b(%11111111)
	dta b(%11111101)
	dta b(%11110110)
	
	dta b(%01010110)		;znak3
	dta b(%11111101)
	dta b(%11111111)
	dta b(%00001100)
	dta b(%00111111)
	dta b(%00111111)
	dta b(%00001111)
	dta b(%00000011)
	
	dta b(%11000000)		;znak4
	dta b(%00110000)
	dta b(%11001100)
	dta b(%11111100)
	dta b(%00110000)
	dta b(%11111111)
	dta b(%01111111)
	dta b(%10010101)
	
	dta b(%10011111)		;znak5
	dta b(%01111111)
	dta b(%11111111)
	dta b(%00110000)
	dta b(%11111100)
	dta b(%11001100)
	dta b(%00110000)
	dta b(%11000000)
	
	dta b(%00000000)		;znak6
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00111111)
	dta b(0)
	
	dta b(%00111111)		;znak7
	dta b(%00111111)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	
	dta b(%00000011)		;znak8
	dta b(%00001111)
	dta b(%00001100)
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	
	dta b(%00000000)		;znak9
	dta b(%11000000)
	dta b(%11000000)
	dta b(%11110000)
	dta b(%00110000)
	dta b(%11111100)
	dta b(%11001100)
	dta b(%00110000)
	
	dta b(%11000000)		;znak10
	dta b(%11110000)
	dta b(%00110000)
	dta b(%11000000)
	dta b(%11000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	
	dta b(%00000000)		;znak11
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00001111)
	dta b(%00001100)
	dta b(%00111111)
	dta b(%00110011)
	dta b(%00001100)
	
	dta b(%00110000)		;znak12
	dta b(%11110000)
	dta b(%11110000)
	dta b(%11110000)
	dta b(%00111100)
	dta b(%00111100)
	dta b(%00111100)
	dta b(%00110000)
	
	dta b(%00001100)		;znak13
	dta b(%00001111)
	dta b(%00001111)
	dta b(%00001111)
	dta b(%00111100)
	dta b(%00111100)
	dta b(%00111100)
	dta b(%00001100)
	
	dta b(%00000000)		;znak 14 I
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00000000)
	
	dta b(%00000000)		;znak 15 I
	dta b(%11000000)
	dta b(%10000000)
	dta b(%11000000)
	dta b(%11000000)
	dta b(%10000000)
	dta b(%11000000)
	dta b(%00000000)
	
	dta b(0)				;znak 16  schoda wdol
	dta b(%00110000)
	dta b(%00001100)
	dta b(%00110000)
	dta b(%00111100)
	dta b(%00001100)
	dta b(0,0)
	
	dta b(0)				;znak 17 schoda w gore
	dta b(%00001100)
	dta b(%00110000)
	dta b(%00001100)
	dta b(%00111100)
	dta b(%00110000)
	dta b(0,0)
	
	dta b(%00000000)		;znak 18 jadro gwiazda A
	dta b(%00110000)
	dta b(%00110000)
	dta b(%00111100)
	dta b(%00111100)
	dta b(%11111111)
	dta b(%11111011)
	dta b(%11101011)
	
	dta b(%11101011)		;znak 19 jadro gwiazda A
	dta b(%11101111)
	dta b(%11111111)
	dta b(%00111100)
	dta b(%00111100)
	dta b(%00001100)
	dta b(%00001100)
	dta b(%00000000)
	
	dta b(%00000000)		;znak 20 jadro gwiazda B
	dta b(%00000011)
	dta b(%00001111)
	dta b(%11111010)
	dta b(%00111110)
	dta b(%00001111)
	dta b(%00000011)
	dta b(%00000000)
	
	dta b(%00000000)		;znak 21 jadro gwiazda B
	dta b(%11000000)
	dta b(%11110000)
	dta b(%10111100)
	dta b(%10101111)
	dta b(%11110000)
	dta b(%11000000)
	dta b(%00000000)
	
	dta b(%00000011)		;trafione dzialko (b+20)
	dta b(%00001111)
	dta b(%00111110)
	dta b(%00110010)
	dta b(%11101000)
	dta b(%11101000)
	dta b(%10101010)
	dta b(%00100010)
	
	dta b(%00101000)		;b+21
	dta b(%11101000)
	dta b(%11100000)
	dta b(%11100000)
	dta b(%00110000)
	dta b(%00110000)
	dta b(%00001111)
	dta b(%00000011)
	
	dta b(%11000000)		;b+22
	dta b(%00110000)
	dta b(%00111100)
	dta b(%10111100)
	dta b(%00110011)
	dta b(%10101111)
	dta b(%10101011)
	dta b(%00101000)
	
	dta b(%10001000)		;b+23
	dta b(%10101011)
	dta b(%00101011)
	dta b(%00101011)
	dta b(%10101100)
	dta b(%10101100)
	dta b(%00110000)
	dta b(%11000000)
	
	dta b(%00111100)		;/ baza B
	dta b(%11001100)
	dta b(%11111100)
	dta b(%00110000)
	dta b(0,0,0,0)
	
	dta b(0,0,0,0)
	dta b(%00001100)
	dta b(%00001111)
	dta b(%00110011)
	dta b(%00111111)
	
	dta b(%00111100)		;\ baza B
	dta b(%00110011)
	dta b(%00111111)
	dta b(%00001100)
	dta b(0,0,0,0)
	
	dta b(0,0,0,0)
	dta b(%00110000)
	dta b(%11110000)
	dta b(%11001100)
	dta b(%11111100)
	
	
	dta b(%00000000)		;bomba
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00100000)
	dta b(%00001000)
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00100001)
	
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00001000)
	dta b(%00100000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	
	dta b(%10000000)
	dta b(%10000000)
	dta b(%00000000)
	dta b(%00000010)
	dta b(%01001000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01010010)
	
	dta b(%01000000)
	dta b(%00010000)
	dta b(%01001000)
	dta b(%00000010)
	dta b(%00000000)
	dta b(%10000000)
	dta b(%10000000)
	dta b(%00000000)
	
	dta b(%00000010)		;meteor
	dta b(%00001010)
	dta b(%00101010)
	dta b(%00101010)
	dta b(%00101010)
	dta b(%00101010)
	dta b(%10101010)
	dta b(%10101010)
	
	dta b(%10101011)
	dta b(%10101110)
	dta b(%10101110)
	dta b(%10101111)
	dta b(%11111111)
	dta b(%00111111)
	dta b(%00111111)
	dta b(%00001111)
	
	dta b(%10000000)
	dta b(%10111010)
	dta b(%10111010)
	dta b(%10101011)
	dta b(%10101010)
	dta b(%10101010)
	dta b(%10101011)
	dta b(%10101011)
	
	dta b(%10101100)
	dta b(%10101100)
	dta b(%10101100)
	dta b(%11111100)
	dta b(%11111100)
	dta b(%00110000)
	dta b(%00000000)
	dta b(%00000000)
	
;rakiety
	dta b(%00100000)
	dta b(%00100000)		;w gore
	dta b(%11111100)
	dta b(%01111100)
	dta b(%11111100)
	dta b(%00100000)
	dta b(%10101000)
	dta b(%11111100)
	
	dta b(%01110100)		;pasek pionowy
	dta b(%01110100)
	dta b(%01110100)
	dta b(%01110100)
	dta b(%01110100)
	dta b(%11111100)
	dta b(%10101000)
	dta b(%00100000)
	
	dta b(%00100000)		;|  pasek pionowy odwrotny
	dta b(%10101000)
	dta b(%11111100)
	dta b(%01110100)
	dta b(%01110100)
	dta b(%01110100)
	dta b(%01110100)
	dta b(%01110100)
	
	dta b(%11111100)		;w dol
	dta b(%10101000)
	dta b(%00100000)
	dta b(%11111100)
	dta b(%01111100)
	dta b(%11111100)
	dta b(%00100000)
	dta b(%00100000)
					
	dta b(%00001100)		;w lewo
	dta b(%00110100)
	dta b(%10111110)
	dta b(%10111110)
	dta b(%00111100)
	dta b(%00001100)
	dta b(0,0)
				
	dta b(%11010100)		;tyl rakiety -
	dta b(%10010111)
	dta b(%10111110)
	dta b(%10111110)
	dta b(%10010111)
	dta b(%11010100)
	dta b(0,0)
			
	dta b(%00010111)		;tyl rakiety w prawo
	dta b(%11010110)
	dta b(%10111110)
	dta b(%10111110)
	dta b(%11010110)
	dta b(%00010111)
	dta b(0,0)
			
	dta b(%00110000)		;w prawo
	dta b(%00011100)
	dta b(%10111110)
	dta b(%10111110)
	dta b(%00111100)
	dta b(%00110000)
	dta b(0,0)	
	
	;wybuchy
	dta b(0,0,0,0)
	dta b(%00000010)
	dta b(%00001001)
	dta b(%00111001)
	dta b(%00100101)
	dta b(%00100101)
	
	dta b(%00100101)
	dta b(%00111001)
	dta b(%00001001)
	dta b(%00000010)
	dta b(0,0,0)
	
	dta b(0,0,0,0)
	dta b(%10000000)
	dta b(%01100000)
	dta b(%01101100)
	dta b(%01011000)
	dta b(%01011000)
	
	dta b(%01011000)
	dta b(%01101100)
	dta b(%01100000)
	dta b(%10000000)
	dta b(0,0,0)
	
	;2
	dta b(0),b(%00000010)
	dta b(%00001001)
	dta b(%00100101)
	dta b(%00100101)
	dta b(%11100101)
	dta b(%10010101)
	dta b(%10010110)
	dta b(%10010110)
	
	dta b(%10010110)
	dta b(%10010101)
	dta b(%11100101)
	dta b(%00100101)
	dta b(%00100101)
	dta b(%00001001)
	dta b(%00000010)
	
	dta b(0),b(%10000000)
	dta b(%01100000)
	dta b(%01011000)
	dta b(%01011000)
	dta b(%01011011)
	dta b(%01010110)
	dta b(%10010110)
	dta b(%10010110)
	
	dta b(%10010110)
	dta b(%01010110)
	dta b(%01011011)
	dta b(%01011000)
	dta b(%01011000)
	dta b(%01100000)
	dta b(%10000000)	
	;3
	dta b(0),b(%00000010)
	dta b(%00001010)
	dta b(%00101011)
	dta b(%00101000)
	dta b(%11101000)
	dta b(%10101100)
	dta b(%10100000)
	dta b(%10100000)
	
	dta b(%10100000)
	dta b(%10101100)
	dta b(%11101000)
	dta b(%00101000)
	dta b(%00101011)
	dta b(%00001010)
	dta b(%00000010)
	
	dta b(0),b(%10000000)
	dta b(%10100000)
	dta b(%11101000)
	dta b(%00101000)
	dta b(%00101011)
	dta b(%00111010)
	dta b(%00001010)
	dta b(%00001010)
	
	dta b(%00001010)
	dta b(%00111010)
	dta b(%00101011)
	dta b(%00101000)
	dta b(%11101000)
	dta b(%10100000)
	dta b(%10000000)
	
	;4
	dta b(0),b(%00000010)
	dta b(%00001011)
	dta b(%00101100)
	dta b(%00100000)
	dta b(%00100000)
	dta b(%10110000)
	dta b(%10000000)
	dta b(%10000000)
	
	dta b(%10000000)
	dta b(%10110000)
	dta b(%00100000)
	dta b(%00100000)
	dta b(%00101100)
	dta b(%00001011)
	dta b(%00000010)
	
	dta b(0),b(%10000000)
	dta b(%11100000)
	dta b(%00111000)
	dta b(%00001000)
	dta b(%00001000)
	dta b(%00001110)
	dta b(%00000010)
	dta b(%00000010)
	
	dta b(%00000010)
	dta b(%00001110)
	dta b(%00001000)
	dta b(%00001000)
	dta b(%00111000)
	dta b(%11100000)
	dta b(%10000000)
	
	;maly wybuch
	dta b(%00100000)
	dta b(%00100000)
	dta b(%10001000)
	dta b(%10001000)
	dta b(%00100000)
	dta b(%00100000)
	dta b(%10001000)
	dta b(%10001000)
	
	dta b(%00100010)
	dta b(%00100010)
	dta b(%10001000)
	dta b(%10001000)
	dta b(%00100010)
	dta b(%00100010)
	dta b(%10001000)
	dta b(%10001000)
	
mwybuch2	equ *
	dta b(%10001000)
	dta b(%10001000)
	dta b(%00100000)
	dta b(%00100000)
	dta b(%10001000)
	dta b(%10001000)
	dta b(%00100000)
	dta b(%00100000)
	
	dta b(%10001000)
	dta b(%10001000)
	dta b(%00100010)
	dta b(%00100010)
	dta b(%10001000)
	dta b(%10001000)
	dta b(%00100010)
	dta b(%00100010)
	
;ksztalt wroga ^ kolor1
enemy1kszt	equ *
;faza 0
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00000110)
	dta b(%00010110)
	dta b(%00010101)
	dta b(%00010111)
	dta b(%01011100)
	dta b(%01010000)
	dta b(%01110000)
	:4 dta b(%01000000)
	dta b(0,0,0)
	
	dta b(0)
	dta b(%11000000)
	dta b(%01000000)
	dta b(%01110000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01011100)
	dta b(%00010100)
	dta b(%00010100)
	:4 dta b(%00000100)
	dta b(0,0,0)
			
;faza1
	dta b(0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00010111)
	dta b(%00011100)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0,0,0,0,0,0)
	
	dta b(0)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01100100)
	dta b(%01100100)
	dta b(%01010100)
	dta b(%11010100)
	:3 dta b(%00010100)
	dta b(%00011100)
	dta b(%00010000)
	dta b(%00010000)
	dta b(%01110000)
	dta b(%01000000)
	dta b(0)
			
;faza2	
	dta b(0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%01111111)
	dta b(%11000000)
	dta b(0,0,0,0,0,0,0)
	dta b(%00000001)
	dta b(%00000011)
	dta b(0)
	
	dta b(0)
	dta b(%01010100)
	dta b(%01010100)
	dta b(%01100100)
	dta b(%01100100)
	dta b(%01010100)
	dta b(%11010100)
	dta b(%00010100)
	dta b(%00010100)
	dta b(%00011100)
	dta b(%00010000)
	dta b(%01110000)
	dta b(%01000000)
	dta b(%11000000)
	dta b(0,0)
			
;faza3
	dta b(0,0)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00000011)
	dta b(0,0,0,0,0,0,0,0)
	dta b(%00000001)
	dta b(%00000111)
	dta b(0)
	
	dta b(0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01010101)
	dta b(%11011001)
	dta b(%00011001)
	dta b(%00010111)
	dta b(%00010100)
	dta b(%00011100)
	dta b(%01010000)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0)

;faza4
	dta b(0)
	dta b(%00010100)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0,0,0,0,0,0,0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00011100)
	dta b(0)
	
	dta b(0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%11010100)
	dta b(%00010101)
	dta b(%00011001)
	dta b(%00011001)
	dta b(%00010111)
	dta b(%01010100)
	dta b(%01011100)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0)
			
;faza5		
	dta b(0)
	dta b(%00000101)
	dta b(%00000001)
	dta b(%00000011)
	dta b(0,0,0,0,0,0,0)
	dta b(%00000001)
	dta b(%00010101)
	dta b(%00001101)
	dta b(0,0)
	
	dta b(0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%11010100)
	dta b(%00010100)
	dta b(%00010101)
	dta b(%00011001)
	dta b(%01011001)
	dta b(%01010111)
	dta b(%01011100)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0)
			
;faza6		
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00000011)
	dta b(0,0,0,0,0,0)
	dta b(%01000000)
	dta b(%11010101)
	dta b(%00110101)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0,0)
	
	dta b(0)
	dta b(%01000000)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%11010000)
	dta b(%00010100)
	dta b(%00110100)
	dta b(%00010100)
	dta b(%00010100)
	dta b(%01010100)
	dta b(%01100100)
	dta b(%01100100)
	dta b(%01010100)
	dta b(%01010100)
	dta b(0,0)
			
;faza7
	dta b(0,0,0,0,0,0,0)
	dta b(%01000000)
	dta b(%11010000)
	dta b(%00010100)
	dta b(%00110101)
	dta b(%00000101)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0,0)
	
	dta b(0)
	dta b(%01000000)
	dta b(%11010000)
	dta b(%00010000)
	dta b(%00010000)
	dta b(%00010100)
	dta b(%00110100)
	dta b(%00010100)
	dta b(%00010100)
	dta b(%01010100)
	dta b(%01010100)
	dta b(%01100100)
	dta b(%01100100)
	dta b(%01010100)
	dta b(%11010000)
	dta b(0)
			
;faza8
	dta b(0,0,0)
	:4 dta b(%01000000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%11010100)
	dta b(%00010111)
	dta b(%00010101)
	dta b(%00110110)
	dta b(%00000110)
	dta b(%00001101)
	dta b(%00000001)
	
	dta b(0,0,0)
	:4 dta b(%00000100)
	dta b(%00110100)
	dta b(%00010100)
	dta b(%11010100)
	:3 dta b(%01010000)
	dta b(%01000000)
	dta b(%01000000)
	dta b(0)
			
;faza9
	dta b(0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00000111)
	dta b(%00000100)
	dta b(%00010100)
	dta b(%00010100)
	dta b(%00011100)
	dta b(%00010100)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00011001)
	dta b(%00011001)
	dta b(%00010101)
	dta b(%00000111)
	dta b(0)
	
	dta b(0,0,0,0,0,0,0)
	dta b(%00000001)
	dta b(%00000111)
	dta b(%00010100)
	dta b(%01011100)
	dta b(%01010000)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0)
			
;faza10
	dta b(0)
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00000111)
	dta b(%00000100)
	dta b(%00011100)
	:3 dta b(%00010100)
	dta b(%00010101)
	dta b(%00011001)
	dta b(%00011001)
	dta b(%00010101)
	dta b(%00010101)
	dta b(0,0)
	
	dta b(%01000000)
	dta b(%11000000)
	dta b(0,0,0,0,0,0,0)
	dta b(%00000001)
	dta b(%01010111)
	dta b(%01011100)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0)
			
;faza11
	dta b(0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00000111)
	dta b(%00010100)
	dta b(%00011100)
	dta b(%01010100)
	dta b(%01100100)
	dta b(%01100101)
	dta b(%01010101)
	dta b(%00010101)
	dta b(%00000101)
	dta b(%00000011)
	dta b(0,0)
	
	dta b(0)
	dta b(%01010000)
	dta b(%11000000)
	dta b(0,0,0,0,0,0,0,0)
	dta b(%01000000)
	dta b(%01010100)
	dta b(%01110000)
	dta b(0,0)
			
;faza12
	dta b(0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00010111)
	dta b(%01010100)
	dta b(%01100100)
	dta b(%01100100)
	dta b(%01010100)
	dta b(%00010101)
	dta b(%00110101)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0,0)
	
	dta b(0)
	dta b(%00010100)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0,0,0,0,0,0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%00010100)
	dta b(0)
			
;faza13
	dta b(0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%01010101)
	dta b(%01100111)
	dta b(%01100100)
	dta b(%01010100)
	dta b(%00010100)
	dta b(%00110100)
	dta b(%00000101)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0,0)
	
	dta b(0,0)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%11000000)
	dta b(0,0,0,0,0,0,0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(0)
			
;faza14
	dta b(0,0)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00011001)
	dta b(%00011001)
	dta b(%00010111)
	:3 dta b(%00010100)
	dta b(%00110100)
	dta b(%00000100)
	dta b(%00001101)
	dta b(%00000001)
	dta b(%00000011)
	dta b(0)
	
	dta b(0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%11110101)
	dta b(0,0,0,0,0,0,0,0)
	dta b(%01000000)
	dta b(%01000000)
			
;faza15
	dta b(0)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00011001)
	dta b(%00011001)
	dta b(%00010101)
	dta b(%00010111)
	:3 dta b(%00010100)
	dta b(%00110100)
	dta b(%00000100)
	dta b(%00000100)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0)
	
	dta b(0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%11010100)
	dta b(%00110100)
	dta b(%00001101)
	dta b(0,0,0,0,0,0,0,0)
		
enemy3kszt	equ *
;faza0
	:4 dta b(%00000001)
	dta b(%00000101)
	:3 dta b(%00000110)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%00010101)
	dta b(%00000101)
	dta b(%00000100)
	dta b(%00000100)
	
	dta b(0,0,0,0)
	:4 dta b(%01000000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01011100)
	dta b(%01110000)
	dta b(%01000000)
	dta b(%01000000)
	dta b(%11000000)
			
;faza1
	dta b(0,0,0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00011101)
	dta b(%00110001)
	dta b(%00000001)
	dta b(%00000011)
	dta b(0)
	
	dta b(%00010000)
	dta b(%00010000)
	:3 dta b(%01010000)
	:3 dta b(%10010000)
	:3 dta b(%01010000)
	dta b(%01010100)
	dta b(%11111100)
	dta b(0,0,0)
			
;faza2
	dta b(0,0,0,0)
	dta b(%01010001)
	dta b(%01010101)
	dta b(%00010110)
	dta b(%00010110)
	dta b(%00010101)
	dta b(%01110101)
	dta b(%11000101)
	dta b(%00000101)
	dta b(%00000001)
	dta b(%00000100)
	dta b(%00001100)
	dta b(0)
	
	dta b(0)
	dta b(%00000100)
	dta b(%00010100)
	dta b(%01010100)
	dta b(%01011100)
	dta b(%10010000)
	dta b(%10010000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01110000)
	dta b(%01000000)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%11110000)
	dta b(0,0)
			
;faza3
	dta b(0,0)
	dta b(%00010000)
	dta b(%00010100)
	dta b(%00010101)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%01010110)
	dta b(%11010110)
	dta b(%00010101)
	dta b(%00110101)
	dta b(%00000101)
	dta b(%00000111)
	dta b(%00011100)
	dta b(%00110000)
	dta b(0)
	
	dta b(0,0,0,0)
	dta b(%01010101)
	dta b(%01010111)
	dta b(%10010100)
	dta b(%10011100)
	dta b(%01010000)
	dta b(%01110000)
	:5 dta b(%01000000)
	dta b(0)
			
;faza4
	dta b(0)
	dta b(%00000100)
	dta b(%00010100)
	dta b(%00010100)
	dta b(%00010101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%00010110)
	dta b(%00010110)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%00010111)
	dta b(%00010100)
	dta b(%00110100)
	dta b(%00000100)
	dta b(0)
	
	dta b(0,0,0,0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%10010101)
	dta b(%10011111)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0,0,0,0)
			
;faza5
	dta b(0)
	dta b(%00010000)
	dta b(%00010100)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%01010110)
	dta b(%01010110)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00010111)
	dta b(%00011100)
	dta b(%00110000)
	dta b(0,0)
	
	dta b(0)
	:5 dta b(%01000000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%10010100)
	dta b(%10010100)
	dta b(%01010101)
	dta b(%11111111)
	dta b(0,0,0,0)
			
;faza6
	dta b(0)
	dta b(%00000100)
	dta b(%00000100)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%01000101)
	dta b(%01010101)
	dta b(%00010110)
	dta b(%00010110)
	dta b(%00010101)
	dta b(%01010101)
	dta b(%01010011)
	dta b(0,0,0,0)
	
	dta b(0,0)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01000000)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%10010000)
	dta b(%10010000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%11010100)
	dta b(%00110100)
	dta b(%00001100)
	dta b(0)
			
;faza7
	dta b(0)
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00010001)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00000101)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%00110101)
	dta b(%00001101)
	dta b(%00000011)
	dta b(0,0,0,0)
	
	dta b(0,0,0)
	dta b(%01010100)
	dta b(%01010100)
	:3 dta b(%01010000)
	:3 dta b(%10010000)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%11010000)
	dta b(%00010000)
	dta b(%00110000)
			
;faza8		
	:3 dta b(%00000001)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00110101)
	dta b(%00000101)
	dta b(%00001101)
	:3 dta b(%00000001)
	dta b(%00000011)
	dta b(0,0,0,0)
	
	dta b(%00010000)
	dta b(%00010000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%01010100)
	dta b(%01010100)
	:3 dta b(%10010000)
	dta b(%01010000)
	:4 dta b(%01000000)
			
;faza9
	dta b(0,0,0)
	dta b(%00010101)
	dta b(%00010101)
	:3 dta b(%00000101)
	:3 dta b(%00000110)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000111)
	dta b(%00000100)
	dta b(%00001100)
	
	dta b(0)
	dta b(%01000000)
	dta b(%01000000)
	dta b(%01000100)
	dta b(%01010100)
	dta b(%01010100)
	dta b(%01010000)
	dta b(%01010101)
	dta b(%01010111)
	dta b(%01011100)
	dta b(%01110000)
	dta b(%11000000)
	dta b(0,0,0,0)
			
;faza10
	dta b(0,0)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00000110)
	dta b(%00000110)
	dta b(%00000101)
	dta b(%00010101)
	dta b(%00010111)
	dta b(%00011100)
	dta b(%00110000)
	dta b(0)
	
	dta b(0)
	dta b(%00010000)
	dta b(%00010000)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010001)
	dta b(%01010111)
	dta b(%10010100)
	dta b(%10010100)
	dta b(%01010100)
	dta b(%01110101)
	dta b(%11000111)
	dta b(0,0,0,0)
			
;faza11
	dta b(0)
	:5 dta b(%00000001)
	dta b(%00000101)
	dta b(%00000101)
	dta b(%00010110)
	dta b(%00010110)
	dta b(%01010101)
	dta b(%01110111)
	dta b(0,0,0,0)
	
	dta b(0)
	dta b(%00000100)
	dta b(%00011100)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01010100)
	dta b(%10010101)
	dta b(%10011111)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%00010100)
	dta b(%00001100)
	dta b(0,0)
			
;faza12
	dta b(0,0,0,0,0)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%01010110)
	dta b(%01010110)
	dta b(%00000101)
	dta b(%00000001)
	dta b(0,0,0,0,0)
	
	dta b(0)
	dta b(%00010000)
	dta b(%00010100)
	dta b(%00010100)
	dta b(%01010100)
	dta b(%01010101)
	dta b(%01010111)
	dta b(%10010100)
	dta b(%10010100)
	dta b(%01010101)
	dta b(%01010111)
	dta b(%01010100)
	dta b(%00010100)
	dta b(%00011100)
	dta b(%00110000)
	dta b(0)
			
;faza13
	dta b(0,0,0,0)
	dta b(%01010101)
	dta b(%01010101)
	dta b(%00010110)
	dta b(%00010110)
	dta b(%00000101)
	dta b(%00000101)
	:5 dta b(%00000001)
	dta b(0)
	
	dta b(0,0)
	dta b(%00000100)
	dta b(%00010100)
	dta b(%01010100)
	dta b(%01010000)
	dta b(%01010000)
	dta b(%10010101)
	dta b(%10010111)
	dta b(%01010100)
	dta b(%01011100)
	dta b(%01010000)
	dta b(%11010000)
	dta b(%00010100)
	dta b(%00001100)
	dta b(0)
			
;faza14
	dta b(0)
	dta b(%00010000)
	dta b(%00010100)
	dta b(%00010101)
	dta b(%00010101)
	dta b(%00000110)
	dta b(%00000110)
	:3 dta b(%00000101)
	dta b(%00000001)
	dta b(%00000001)
	dta b(%00000101)
	dta b(%00000101)
	dta b(0,0)
	
	dta b(0,0,0,0)
	dta b(%01000101)
	dta b(%01010111)
	dta b(%10010100)
	dta b(%10010100)
	dta b(%01010100)
	dta b(%01010101)
	dta b(%01010011)
	dta b(%01110000)
	dta b(%11000000)
	dta b(%00010000)
	dta b(%00110000)
	dta b(0)
			
;faza15
	dta b(%00000100)
	dta b(%00000100)
	:3 dta b(%00000101)
	:3 dta b(%00000110)
	:3 dta b(%00000101)
	dta b(%00010101)
	dta b(%00011111)
	dta b(0,0,0)
	
	dta b(0,0,0,0)
	dta b(%01000000)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01010101)
	dta b(%01011111)
	dta b(%01010000)
	dta b(%01010100)
	dta b(%01110100)
	dta b(%01001100)
	dta b(%01000000)
	dta b(%11000000)
	dta b(0)		
			
enemy5kszt	equ *
;faza0
			dta b(0)
			:2 dta b(%00000011)
			:2 dta b(%00001111)
			dta b(%00101101)
			dta b(%00111101)
			dta b(%00101111)
			dta b(%00111111)
			dta b(%00101011)
			dta b(%00100010)
			:4 dta b(%00100000)
			dta b(0)
			
			dta b(%10000000)
			:2 dta b(%11110000)
			:2 dta b(%11111100)
			dta b(%11011110)
			dta b(%11011111)
			dta b(%11111110)
			dta b(%11111111)
			dta b(%11111010)
			dta b(%11100010)
			:4 dta b(%10000010)
			dta b(%10000000)
			
;faza1
			dta b(0,0)
			dta b(%00000011)
			dta b(%00001111)
			dta b(%00001101)
			dta b(%00101101)
			dta b(%00111111)
			dta b(%00111011)
			dta b(%00100010)
			dta b(%11100011)
			dta b(%10000010)
			dta b(%10000010)
			dta b(%00001110)
			:2 dta b(%00001000)
			dta b(0)
			
			dta b(%00100000)
			dta b(%11110000)
			:3 dta b(%11111100)
			:2 dta b(%11011100)
			dta b(%11111100)
			dta b(%11111000)
			dta b(%10111100)
			:2 dta b(%00111000)
			:3 dta b(%00100000)
			dta b(%10000000)
			
;faza2
			dta b(0,0,0)
			dta b(%00001011)
			dta b(%00101111)
			dta b(%00101011)
			dta b(%10100011)
			dta b(%10000010)
			dta b(%00000011)
			dta b(%00000010)
			dta b(%00001010)
			dta b(%00001000)
			dta b(%00101000)
			dta b(%00100000)
			dta b(0,0)
			
			dta b(0,0)
			dta b(%11111110)
			dta b(%11111111)
			:2 dta b(%01111111)
			:2 dta b(%11110111)
			:2 dta b(%11111111)
			dta b(%10111000)
			dta b(%00111100)
			dta b(%00101000)
			dta b(%00100000)
			dta b(%10100000)
			dta b(%10000000)
			
;faza3
			dta b(0,0)
			dta b(%00000010)
			dta b(%00101011)
			dta b(%10101111)
			:2 dta b(%00000011)
			dta b(%00001011)
			dta b(%00001110)
			dta b(%00101011)
			dta b(%10100010)
			dta b(0,0)
			:2 dta b(%00000010)
			dta b(%00001000)
			
			dta b(0,0)
			dta b(%11000000)
			dta b(%11110000)
			dta b(%11111110)
			:2 dta b(%01111111)
			dta b(%11111111)
			dta b(%11011111)
			dta b(%11011100)
			dta b(%11111100)
			dta b(%10110000)
			dta b(%11110000)
			dta b(%10000000)
			dta b(0,0)
			
;faza4
			dta b(0)
			dta b(%10101000)
			dta b(%00001010)
			dta b(%00001110)
			dta b(%00000011)
			dta b(%00001111)
			dta b(%00001011)
			:2 dta b(%10101011)
			dta b(%00001011)
			dta b(%00001111)
			dta b(%00000011)
			dta b(%00001110)
			dta b(%00001010)
			dta b(%10101000)
			dta b(0)
			
			dta b(0,0,0)
			:2 dta b(%11110000)
			dta b(%01111100)
			dta b(%01111111)
			:2 dta b(%11111110)
			dta b(%01111111)
			dta b(%01111100)
			:2 dta b(%11110000)
			dta b(0,0,0)
			
;faza5
			dta b(%00001000)
			:2 dta b(%00000010)
			dta b(0,0)
			dta b(%10100010)
			dta b(%00101011)
			dta b(%00001110)
			dta b(%00001011)
			dta b(%00000011)
			dta b(%00001011)
			dta b(%10101111)
			dta b(%00101011)
			dta b(%00000010)
			dta b(0,0)
			
			dta b(0,0)
			dta b(%10000000)
			dta b(%11110000)
			dta b(%10110000)
			dta b(%11111100)
			dta b(%11011100)
			dta b(%11011111)
			dta b(%11111111)
			dta b(%01111111)
			dta b(%01111110)
			dta b(%11111100)
			dta b(%11110000)
			dta b(%11000000)
			dta b(0,0)
			
;faza6
			dta b(0,0)
			dta b(%00100000)
			dta b(%00101000)
			dta b(%00001000)
			dta b(%00001010)
			dta b(%00000010)
			dta b(%00000011)
			dta b(%10000010)
			dta b(%10100011)
			dta b(%00101011)
			dta b(%00101111)
			dta b(%00001011)
			dta b(0,0,0)
			
			dta b(%10000000)
			dta b(%10100000)
			dta b(%00100000)
			dta b(%00101000)
			dta b(%00111100)
			dta b(%10111000)
			:2 dta b(%11111111)
			:2 dta b(%11110111)
			:2 dta b(%01111111)
			dta b(%11111111)
			dta b(%11111110)
			dta b(0,0)
			
;faza7
			dta b(0)
			:2 dta b(%00001000)
			dta b(%00001110)
			:2 dta b(%10000010)
			dta b(%11100011)
			dta b(%00100010)
			dta b(%00111011)
			dta b(%00111111)
			dta b(%00101101)
			dta b(%00001101)
			dta b(%00001111)
			dta b(%00000011)
			dta b(0,0)
			
			dta b(%10000000)
			:3 dta b(%00100000)
			:2 dta b(%00111000)
			dta b(%10111100)
			:2 dta b(%11111100)
			:2 dta b(%11011100)
			:3 dta b(%11111100)
			dta b(%11110000)
			dta b(%00100000)
			
			
;faza8
			dta b(%00000010)
			:4 dta b(%10000010)
			dta b(%10001011)
			dta b(%10101111)
			dta b(%11111111)
			dta b(%10111111)
			dta b(%11110111)
			dta b(%10110111)
			:2 dta b(%00111111)
			:2 dta b(%00001111)
			dta b(%00000010)
			
			dta b(0)
			:4 dta b(%00001000)
			dta b(%10001000)
			dta b(%11101000)
			dta b(%11111100)
			dta b(%11111000)
			dta b(%01111100)
			dta b(%01111000)
			:2 dta b(%11110000)
			:2 dta b(%11000000)
			dta b(0)
			
;faza9
			dta b(%00000010)
			:3 dta b(%00001000)
			:2 dta b(%00101100)
			dta b(%00111110)
			:2 dta b(%00111111)
			:2 dta b(%00110111)
			:3 dta b(%00111111)
			dta b(%00001111)
			dta b(%00001000)
			
			dta b(0)
			:2 dta b(%00100000)
			dta b(%10110000)
			:2 dta b(%10000010)
			dta b(%11001011)
			dta b(%10001000)
			dta b(%11101100)
			dta b(%11111100)
			dta b(%01111000)
			dta b(%01110000)
			dta b(%11110000)
			dta b(%11000000)
			dta b(0,0)
			
;faza10
			dta b(%00000010)
			dta b(%00001010)
			dta b(%00001000)
			dta b(%00101000)
			dta b(%00111100)
			dta b(%00101110)
			:2 dta b(%11111111)
			:2 dta b(%11011111)
			:2 dta b(%11111101)
			dta b(%11111111)
			dta b(%10111111)
			dta b(0,0)
			
			dta b(0,0)
			dta b(%001000)
			dta b(%00101000)
			dta b(%00100000)
			dta b(%10100000)
			dta b(%10000000)
			dta b(%11000000)
			dta b(%10000010)
			dta b(%11001010)
			dta b(%11101000)
			dta b(%11111000)
			dta b(%11100000)
			dta b(0,0,0)
			
;faza11
			dta b(0,0)
			dta b(%00000010)
			dta b(%00001111)
			dta b(%00001110)
			dta b(%00111111)
			dta b(%00110111)
			dta b(%11110111)
			dta b(%11111111)
			dta b(%11111101)
			dta b(%10111101)
			dta b(%00111111)
			dta b(%00001111)
			dta b(%00000011)
			dta b(0,0)
			
			dta b(%00100000)
			:2 dta b(%10000000)
			dta b(0,0)
			dta b(%10001010)
			dta b(%11101000)
			dta b(%10110000)
			dta b(%11100000)
			dta b(%11000000)
			dta b(%11100000)
			dta b(%11111010)
			dta b(%11101000)
			dta b(%10000000)
			dta b(0,0)
			
;faza12
			dta b(0,0)
			dta b(%00000011)
			:2 dta b(%00001111)
			dta b(%00111101)
			dta b(%11111101)
			:2 dta b(%10111111)
			dta b(%11111101)
			dta b(%00111101)
			:2 dta b(%00001111)
			dta b(%00000011)
			dta b(0,0)
			
			dta b(0)
			dta b(%00101010)
			dta b(%10100000)
			dta b(%10110000)
			dta b(%11000000)
			dta b(%11110000)
			dta b(%11100000)
			:2 dta b(%11101010)
			dta b(%11100000)
			dta b(%11110000)
			dta b(%11000000)
			dta b(%10110000)
			dta b(%10100000)
			dta b(%00101010)
			dta b(0)
			
;faza13
			dta b(0,0)
			dta b(%00000011)
			dta b(%00001111)
			dta b(%00111111)
			dta b(%10111101)
			dta b(%11111101)
			dta b(%11111111)
			dta b(%11110111)
			dta b(%00110111)
			dta b(%00111111)
			dta b(%00001110)
			dta b(%00001111)
			dta b(%00000010)
			dta b(0,0)
			
			dta b(0,0)
			dta b(%10000000)
			dta b(%11101000)
			dta b(%11111010)
			dta b(%11100000)
			dta b(%11000000)
			dta b(%11100000)
			dta b(%10110000)
			dta b(%11101000)
			dta b(%10001010)
			dta b(0,0)
			:2 dta b(%10000000)
			dta b(%00100000)
			
;faza14
			dta b(0,0)
			dta b(%10111111)
			dta b(%11111111)
			:2 dta b(%11111101)
			:2 dta b(%11011111)
			:2 dta b(%11111111)
			dta b(%00101110)
			dta b(%00111100)
			dta b(%00101000)
			dta b(%00001000)
			dta b(%00001010)
			dta b(%00000010)
			
			dta b(0,0,0)
			dta b(%11100000)
			dta b(%11111000)
			dta b(%11101000)
			dta b(%11001010)
			dta b(%10000010)
			dta b(%11000000)
			dta b(%10000000)
			dta b(%10100000)
			dta b(%00100000)
			dta b(%00101000)
			dta b(%00001000)
			dta b(0,0)
			
;faza15
			dta b(%00001000)
			dta b(%00001111)
			:3 dta b(%00111111)
			:2 dta b(%00110111)
			:2 dta b(%00111111)
			dta b(%00111110)
			:2 dta b(%00101100)
			:3 dta b(%00001000)
			dta b(%00000010)
			
			dta b(0,0)
			dta b(%11000000)
			dta b(%11110000)
			dta b(%01110000)
			dta b(%01111000)
			dta b(%11111100)
			dta b(%11101100)
			dta b(%10001000)
			dta b(%11001011)
			:2 dta b(%10000010)
			dta b(%10110000)
			:2 dta b(%00100000)
			dta b(0)
			
;wybuch
explo_kszt	equ *
	
	dta b(%10000000)		;3faza
	dta b(%00101100)
	dta b(%00101110)		
	dta b(%00001011)
	dta b(%00110100)		
	dta b(%00100101)
	dta b(%00101100)		
	dta b(%00110111)
	
	dta b(%10100100)		
	dta b(%00010101)
	dta b(%00000100)		
	dta b(%00001000)
	dta b(%00101101)		
	dta b(%00101111)
	dta b(%10000000)		
	dta b(%10000000)
	
	dta b(%10000010)		
	dta b(%10001011)
	dta b(%11001000)		
	dta b(%00101100)
	dta b(%01111100)		
	dta b(%00010100)
	dta b(%11001011)		
	dta b(%01011010)
	
	dta b(%00010000)		
	dta b(%00010100)
	dta b(%00110101)		
	dta b(%01101010)
	dta b(%10111000)		
	dta b(%10001000)
	dta b(%10001110)		
	dta b(%10000010)
	
	dta b(%00000000)		;2faza
	dta b(%11000000)
	dta b(%01110000)
	dta b(%00011111)
	dta b(%00010100)
	dta b(%00000110)
	dta b(%00001010)
	dta b(%01011000)
	
	dta b(%00001000)
	dta b(%00000001)
	dta b(%00001110)
	dta b(%00001001)
	dta b(%00010110)
	dta b(%00010000)
	dta b(%01110000)
	dta b(%00000000)
	
	dta b(%00000000)
	dta b(%00000000)
	dta b(%01110001)
	dta b(%01110101)
	dta b(%10010100)
	dta b(%10100100)
	dta b(%00101011)
	dta b(%00011000)
	
	dta b(%10100000)
	dta b(%00101000)
	dta b(%10011100)
	dta b(%11011100)
	dta b(%00110100)
	dta b(%00110100)
	dta b(%01110001)
	dta b(%00000000)

	dta b(%00000000)		;1faza
	dta b(%00110000)
	dta b(%00011100)
	dta b(%00110111)
	dta b(%00000100)
	dta b(%00001101)
	dta b(%00000110)
	dta b(%00000110)
	
	dta b(%00111100)
	dta b(%00000010)
	dta b(%00000011)
	dta b(%00000111)
	dta b(%00110100)
	dta b(%00011100)
	dta b(%00000000)
	dta b(%00000000)
	
	dta b(%00000000)
	dta b(%00001100)
	dta b(%00110000)
	dta b(%01110000)
	dta b(%01010000)
	dta b(%11010000)
	dta b(%00101100)
	dta b(%00110000)
	
	dta b(%00100000)
	dta b(%10000000)
	dta b(%01110000)
	dta b(%01111100)
	dta b(%01000100)
	dta b(%11000011)
	dta b(%00000000)
	dta b(%00000000)

;migajaca bomba i rakieta	
bomba1	equ *
	dta b(%00000000)		;bomba
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00100000)
	dta b(%00001000)
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00100011)
	
	dta b(%00000011)
	dta b(%00000011)
	dta b(%00001000)
	dta b(%00100000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	dta b(%00000000)
	
	dta b(%10000000)
	dta b(%10000000)
	dta b(%00000000)
	dta b(%00000010)
	dta b(%11001000)
	dta b(%11110000)
	dta b(%11110000)
	dta b(%11110010)
	
	dta b(%11000000)
	dta b(%00110000)
	dta b(%11001000)
	dta b(%00000010)
	dta b(%00000000)
	dta b(%10000000)
	dta b(%10000000)
	dta b(%00000000)
	
rakieta1	equ *
	dta b(%00100000)
	dta b(%00100000)		;w gore
	dta b(%11111100)
	dta b(%11110100)
	dta b(%11111100)
	dta b(%00100000)
	dta b(%10101000)
	dta b(%11111100)
	
	dta b(%11111100)		;w dol
	dta b(%10101000)
	dta b(%00100000)
	dta b(%11111100)
	dta b(%11110100)
	dta b(%11111100)
	dta b(%00100000)
	dta b(%00100000)
;pozioma rakieta
	dta b(%00001100)		;w lewo
	dta b(%00111100)
	dta b(%10111110)
	dta b(%10111110)
	dta b(%00110100)
	dta b(%00001100)
	dta b(0,0)
			
	dta b(%00110000)		;w prawo
	dta b(%00111100)
	dta b(%10111110)
	dta b(%10111110)
	dta b(%00011100)
	dta b(%00110000)
	dta b(0,0)

	
blastoff_wav	equ *
	ins 'samples/blastoff.wav'
blastoff_end	equ *
gameover_wav	equ *
	ins 'samples/gameover.wav'		;gameover1=duke nukem
gameover_end	equ *



alive_wav		equ *
	ins 'samples/alive1.wav'
alive_end		equ *
conred_wav	equ *
	ins 'samples/conred.wav'
conred_end	equ *
spy_wav			equ *
	ins 'samples/spy.wav'
spy_end			equ *
	
		org $3000
formation_wav	equ *
	ins 'samples/formation.wav'
formation_end	equ *
			org $2200


			
				
			
;scroluje maskę 1 pixel w prawo  , sec zamiast clc, w bom0a ile faz
duszkiIni3	equ *
			txa
			pha

			lda bom
			pha
			lda bom+1
			pha
			
			ldx bom0a
			stx bom0
			
@			ldx #16
@			ldy #0
			lda (bom),y
			sec
			ror @
			sta (bom),y
			ldy #16
			lda (bom),y
			ror @
			sta (bom),y
			ldy #32
			lda (bom),y
			ror @
			sta (bom),y
			inc bom
			bne *+4
			inc bom+1
			dex
			bne @-
			
			clc
			lda bom
			adc #32
			sta bom
			bcc *+4
			inc bom+1
			
			
			dec bom0
			bne @-1	
		
			pla
			sta bom+1
			pla
			sta bom
			
			pla
			tax
			dex
			bne duszkiIni3
			
			clc
			lda bom+1
			adc #3
			sta bom+1
			
			rts				
			
			
;scroluje ksztalt 1 pixel w prawo, w bom0a liczba faz
duszkiIni2	equ *
			txa
			pha

			lda bom
			pha
			lda bom+1
			pha
			
			ldx bom0a
			stx bom0
			
@			ldx #16
@			ldy #0
			lda (bom),y
			clc
			ror @
			sta (bom),y
			ldy #16
			lda (bom),y
			ror @
			sta (bom),y
			ldy #32
			lda (bom),y
			ror @
			sta (bom),y
			inc bom
			bne *+4
			inc bom+1
			dex
			bne @-
			
			clc
			lda bom
			adc #32
			sta bom
			bcc *+4
			inc bom+1
			
			dec bom0
			bne @-1	
		
			pla
			sta bom+1
			pla
			sta bom
			
			pla
			tax
			dex
			bne duszkiIni2
			
			clc
			lda bom+1
			adc #3
			sta bom+1
			
			rts			
			
;przesuwa ksztalty w prawo			
duszkiIni1	equ *
			ldx #16	;16faz
@			ldy #0
@			lda (bom),y
			sta (bom1),y
			iny
			cpy #32
			bne @-
			
			lda bom0		;0 dla ksztaltu, 255 dla maski
@			sta (bom1),y
			iny
			cpy #48
			bne @-
			
			clc
			lda bom
			adc #32
			sta bom
			bcc @+
			inc bom+1

@			clc
			lda bom1
			adc #48
			sta bom1
			bcc @+
			inc bom1+1
			
@			dex
			bne @-4
			rts

;tworzy dokladna maskę			
largeMask	equ * ;w (bom) adres maski
			txa
			pha

			ldy #31		;wyczysc maske
			lda #0
@			sta maskbuf,y
			dey
			bpl @-

			ldx #7
@			ldy #15

@			jsr getbits
			bne @+4
			
			dex				;sprawdz po lewo
			bmi @+		;<0
			jsr getbits
			beq @+			;=00
			jsr ustawbits	;wpisz 00
@			inx
			
			inx		;sprawdz po prawo
			cpx #8
			bcs @+	;poza zakresem
			jsr getbits
			beq @+		;=00
			jsr ustawbits
@			dex

			dey			;sprawdz powyzej
			bmi @+
			jsr getbits
			beq @+
			jsr ustawbits
@			iny

			iny			;sprawdz niżej
			cpy #16
			bcs @+
			jsr getbits
			beq @+
			jsr ustawbits
@			dey

@			dey
			bpl @-5
			dex
			bpl @-6
			
			ldy #31
@			lda (bom),y		;popraw i zapisz maske
			eor maskbuf,y	
			sta (bom),y
			dey
			bpl @-
			
			clc				;zwiekszamy ksztalt
			lda bom
			adc #32
			sta bom
			bcc @+
			inc bom+1
			
@			pla
			tax
			dex
			bpl largeMask
			
			rts
			
tabgetbits	dta b(%11000000,%00110000,%00001100,%00000011)
tabgetbits1	dta b(%00111111,%11001111,%11110011,%11111100)		
maskbuf		:32 dta b(0)	
getbits		equ *
			txa
			pha
			tya
			pha
			
			cpx #4
			bcc @+
			tya
			clc
			adc #16
			tay

@			txa
			and #%11
			tax
			
			lda (bom),y
			and tabgetbits,x
			sta bom0
			
			pla 
			tay
			pla
			tax
			lda bom0
			rts
			
ustawbits	equ *
			txa
			pha
			tya
			pha
			
			cpx #4
			bcc @+
			tya
			clc
			adc #16
			tay

@			txa
			and #%11
			tax
			
			lda maskbuf,y
			and tabgetbits1,x
			ora tabgetbits,x
			sta maskbuf,y
			
			pla 
			tay
			pla
			tax
			rts
			
			
;tworzy maske ze skokiem 32 bajty, czyli 2 strony
makeMask1	equ *
			ldx #4		;16 faz
			
mm2			ldy #127
mm1			lda (bom),y
			
			sta bom0
			and #%11000000
			beq @+
			lda #%11000000
@			eor #%11000000
			sta bom0a

			lda bom0
			and #%00110000
			beq @+
			lda #%00110000
@			eor #%00110000
			ora bom0a
			sta bom0a
			
			lda bom0
			and #%00001100
			beq @+
			lda #%00001100
@			eor #%00001100
			ora bom0a
			sta bom0a
			
			lda bom0
			and #%00000011
			beq @+
			lda #%00000011
@			eor #%00000011
			ora bom0a
			
			sta (bom1),y
			dey
			bpl mm1
			
			
			clc
			lda bom
			adc #128
			sta bom
			lda bom+1
			adc #0
			sta bom+1
			clc
			lda bom1
			adc #128
			sta bom1
			lda bom1+1
			adc #0
			sta bom1+1
			
			dex
			bne mm2
			
			rts

		

		
;zmiana koloru sprita, zamien 01 na 10 i odwrotnie , 00 i 11 bez zmian
change_color	equ *
			sta bom
			mva #0 bom+1
			ldy #4
			
@			lda bom
			asl
			rol bom+1
			asl
			rol bom+1
			sta bom
			
			lda bom+1
			and #%11
			beq @+
			cmp #%11
			beq @+
			eor #%11
@			sta bom1
			lda bom+1
			and #%11111100
			ora bom1
			sta bom+1
			dey
			bne @-1
			
			lda bom+1
			rts

przepisz_sampla	equ *
			mwa bom1 sample,x
			ldy #0
@			lda (bom),y
			sta (bom1),y
			
			inc bom
			bne *+4
			inc bom+1
			
			inc bom1
			bne *+4
			inc bom1+1
		
@			lda bom
			cmp bom2
			bne @-1
			lda bom+1
			cmp bom2+1
			bne @-1
			
			mwa bom1 sampleEnd,x
			
			rts
			
;utworz tabele ksztaltow/mask , adres tablicy  lmb=x smb=y, ksztalt/maska w (bom)			
makeShapeTab	equ *
			stx _mst1
			sty _mst1+1
			clc
			txa
			adc #64
			sta _mst2
			tya
			adc #0
			sta _mst2+1
			
			ldx #0
			ldy #16
			lda #32
			jsr makeShapeTab1
			ldy #64
			lda #48
			jmp makeShapeTab1
			
			
makeShapeTab1	equ *	
			sta bom0
			sty _mst3
@			mva bom $ffff,x
_mst1		equ *-2
			mva bom+1 $ff00,x
_mst2		equ *-2
			clc
			lda bom
			adc bom0
			sta bom
			bcc *+4
			inc bom+1
			inx
_mst3		equ *+1			
			cpx #$ff
			bne @-
			rts			
				
makeShapes	equ *
			mva #0 bom0
			lda bom
			sta bom1
			clc
			lda bom+1
			adc #2
			sta bom1+1
			
			jsr duszkiIni1
			dec bom+1
			dec bom+1
			jsr duszkiIni1
			dec bom+1
			dec bom+1
			jsr duszkiIni1
			
			mva #16 bom0a
			ldx #2
			jsr duszkiIni2
			ldx #4
			jsr duszkiIni2
			ldx #6
			jmp duszkiIni2
			
makeMask2	equ *
			mva #255 bom0
			lda bom
			sta bom1
			clc
			lda bom+1
			adc #2
			sta bom1+1
			
			jsr duszkiIni1
			dec bom+1
			dec bom+1
			jsr duszkiIni1
			dec bom+1
			dec bom+1
			jsr duszkiIni1
			
			mva #16 bom0a
			ldx #2
			jsr duszkiIni3
			ldx #4
			jsr duszkiIni3
			ldx #6
			jmp duszkiIni3			
			
			
;kopiowanie danych do bankow pamieci


			
;przepisuje ksztalty duszkow do banków pamięci
init_banki	equ *
			sei					;wyłącz ROM
			mva #0 NMIEN
			mva #BANK0 PORTB
;1 duszek
			mva #BANK1 PORTB		;włączamy 1 bank
			
			ldx #0
@			lda enemy1kszt,x
			sta enemy1adr,x
			lda enemy1kszt+$100,x
			sta enemy1adr+$100,x
			dex
			bne @-
			
			mwa #enemy1adr bom		;przepisz i przesuń kształty
			jsr makeShapes
			
			mwa #enemy1adr bom
			ldx #<enemy1shapeTab
			ldy #>enemy1shapeTab
			jsr makeShapeTab
;maska12
			mwa #enemy1adr bom
			mwa #enemy1mask	bom1
			jsr makeMask1
			mwa #enemy1mask	bom
			ldx #15
			jsr largeMask
			
			mwa #enemy1mask bom
			jsr makeMask2
			
			mwa #enemy1mask bom
			ldx #<enemy1maskTab
			ldy #>enemy1maskTab
			jsr makeShapeTab
			
;2 duszek
			ldx #0
@			lda enemy1kszt,x
			jsr change_color
			sta enemy2adr,x
			lda enemy1kszt+$100,x
			jsr change_color
			sta enemy2adr+$100,x
			dex
			bne @-
			
			mwa #enemy2adr bom
			jsr makeShapes
			
			mwa #enemy2adr bom
			ldx #<enemy2shapeTab
			ldy #>enemy2shapeTab
			jsr makeShapeTab
			
			mwa #enemy1mask bom
			ldx #<enemy2maskTab
			ldy #>enemy2maskTab
			jsr makeShapeTab

;3 duszek
			mva #BANK2 PORTB
			
			ldx #0
@			lda enemy3kszt,x
			sta enemy3adr,x
			lda enemy3kszt+$100,x
			sta enemy3adr+$100,x
			dex
			bne @-
			
			mwa #enemy3adr bom
			jsr makeShapes
			
			mwa #enemy3adr bom
			ldx #<enemy3shapeTab
			ldy #>enemy3shapeTab
			jsr makeShapeTab
		
;mask34			
			
			mwa #enemy3adr bom
			mwa #enemy3mask	bom1
			jsr makeMask1
			mwa #enemy3mask	bom
			ldx #15
			jsr largeMask
			
			mwa #enemy3mask bom
			jsr makeMask2
			
			mwa #enemy3mask bom
			ldx #<enemy3maskTab
			ldy #>enemy3maskTab
			jsr makeShapeTab
			
;4 duszek
			ldx #0
@			lda enemy3kszt,x
			jsr change_color
			sta enemy4adr,x
			lda enemy3kszt+$100,x
			jsr change_color
			sta enemy4adr+$100,x
			dex
			bne @-
			
			mwa #enemy4adr bom
			jsr makeShapes
			
			mwa #enemy4adr bom
			ldx #<enemy4shapeTab
			ldy #>enemy4shapeTab
			jsr makeShapeTab
			
			mwa #enemy3mask bom			;ta sama maska co enemy3
			ldx #<enemy4maskTab
			ldy #>enemy4maskTab
			jsr makeShapeTab
			
;spy
			mva #BANK3 PORTB
			
			ldx #0
@			lda enemy5kszt,x
			sta enemy5adr,x
			lda enemy5kszt+$100,x
			sta enemy5adr+$100,x
			dex
			bne @-
			
			mwa #enemy5adr bom
			jsr makeShapes
			
			mwa #enemy5adr bom
			ldx #<enemy5shapeTab
			ldy #>enemy5shapeTab
			jsr makeShapeTab
			
			mwa #enemy5adr bom
			mwa #enemy5mask	bom1
			jsr makeMask1
			mwa #enemy5mask	bom
			ldx #15
			jsr largeMask
			
			mwa #enemy5mask bom
			jsr makeMask2
			
			mwa #enemy5mask bom
			ldx #<enemy5maskTab
			ldy #>enemy5maskTab
			jsr makeShapeTab
		
;wybuch
			ldx #95
@			lda explo_kszt,x
			sta explo_adr,x
			dex
			bpl @-
			
			mva #0 bom0
			
			mwa #explo_adr bom
			mwa #(explo_adr+96) bom1	
			ldx #3
			jsr duszkiini1+2
			mwa #explo_adr bom
			;mwa #(explo_adr+240) bom1		
			ldx #3
			jsr duszkiini1+2
			mwa #explo_adr bom
			;mwa #(explo_adr+384) bom1
			ldx #3
			jsr duszkiini1+2
			
			mwa #(explo_adr+96) bom
			
			mva #3 bom0a		;4fazy
			ldx #2
			jsr duszkiIni2
			
			mwa #(explo_adr+240) bom
			ldx #4
			jsr duszkiIni2
			
			mwa #(explo_adr+384) bom				
			ldx #6
			jsr duszkiIni2

			mva #<(explo_adr) explo_shapetab
			sta explo_shapetab+1
			mva #>(explo_adr) explo_shapetab+64
			sta explo_shapetab+64+1
			mva #<(explo_adr+32) explo_shapetab+2
			mva #>(explo_adr+32) explo_shapetab+64+2
			mva #<(explo_adr+64) explo_shapetab+3
			mva #>(explo_adr+64) explo_shapetab+64+3
			
			mva #<(explo_adr+96) explo_shapetab+16
			sta explo_shapetab+16+1
			mva #>(explo_adr+96) explo_shapetab+64+16
			sta explo_shapetab+64+16+1
			mva #<(explo_adr+96+48) explo_shapetab+16+2
			mva #>(explo_adr+96+48) explo_shapetab+64+16+2
			mva #<(explo_adr+96+48+48) explo_shapetab+16+3
			mva #>(explo_adr+64+48+48) explo_shapetab+64+16+3
			
			mva #<(explo_adr+96+144) explo_shapetab+32
			sta explo_shapetab+32+1
			mva #>(explo_adr+96+144) explo_shapetab+64+32
			sta explo_shapetab+64+32+1
			mva #<(explo_adr+96+144+48) explo_shapetab+32+2
			mva #>(explo_adr+96+144+48) explo_shapetab+64+32+2
			mva #<(explo_adr+96+144+48+48) explo_shapetab+32+3
			mva #>(explo_adr+64+144+48+48) explo_shapetab+64+32+3
			
			mva #<(explo_adr+96+144+144) explo_shapetab+48
			sta explo_shapetab+48+1
			mva #>(explo_adr+96+144+144) explo_shapetab+64+48
			sta explo_shapetab+64+48+1
			mva #<(explo_adr+96+144+144+48) explo_shapetab+48+2
			mva #>(explo_adr+96+144+144+48) explo_shapetab+64+48+2
			mva #<(explo_adr+96+144+144+48+48) explo_shapetab+48+3
			mva #>(explo_adr+64+144+144+48+48) explo_shapetab+64+48+3
;mask_explo			
			mwa #explo_adr bom
			mwa #explo_mask	bom1
			ldx #1
			jsr makeMask1+2
			mwa #explo_mask	bom
			ldx #2		;ile faz-1
			jsr largeMask
			
			mva #255 bom0
			
			mwa #explo_mask bom		;kopiujemy podstawowa maske
			mwa #(explo_mask+96) bom1	;
			ldx #3
			jsr duszkiini1+2
			mwa #explo_mask bom
			;mwa #(explo_mask+240) bom1		;3*256+48
			ldx #3
			jsr duszkiini1+2
			mwa #explo_mask bom
			;mwa #(explo_mask+384) bom1			;6*256+96+512  (zajmuje strone do )
			ldx #3
			jsr duszkiini1+2
			
			mwa #(explo_mask+96) bom	
			mva #3 bom0a		;tylko 3 fazy
			ldx #2
			jsr duszkiIni3				;robimy przesuniecia maski
			
			mwa #(explo_mask+240) bom	
			ldx #4
			jsr duszkiIni3
					
			mwa #(explo_mask+384) bom			
			ldx #6
			jsr duszkiIni3
			
;maska			
			mva #<(explo_mask) explo_masktab
			sta explo_masktab+1
			mva #>(explo_mask) explo_masktab+64
			sta explo_masktab+64+1
			mva #<(explo_mask+32) explo_masktab+2
			mva #>(explo_mask+32) explo_masktab+64+2
			mva #<(explo_mask+64) explo_masktab+3
			mva #>(explo_mask+64) explo_masktab+64+3
			
			mva #<(explo_mask+96) explo_masktab+16
			sta explo_masktab+16+1
			mva #>(explo_mask+96) explo_masktab+64+16
			sta explo_masktab+64+16+1
			mva #<(explo_mask+96+48) explo_masktab+16+2
			mva #>(explo_mask+96+48) explo_masktab+64+16+2
			mva #<(explo_mask+96+48+48) explo_masktab+16+3
			mva #>(explo_mask+64+48+48) explo_masktab+64+16+3
			
			mva #<(explo_mask+96+144) explo_masktab+32
			sta explo_masktab+32+1
			mva #>(explo_mask+96+144) explo_masktab+64+32
			sta explo_masktab+64+32+1
			mva #<(explo_mask+96+144+48) explo_masktab+32+2
			mva #>(explo_mask+96+144+48) explo_masktab+64+32+2
			mva #<(explo_mask+96+144+48+48) explo_masktab+32+3
			mva #>(explo_mask+64+144+48+48) explo_masktab+64+32+3
			mva #<(explo_mask+96+144+144) explo_masktab+48
			sta explo_masktab+48+1
			mva #>(explo_mask+96+144+144) explo_masktab+64+48
			sta explo_masktab+64+48+1
			mva #<(explo_mask+96+144+144+48) explo_masktab+48+2
			mva #>(explo_mask+96+144+144+48) explo_masktab+64+48+2
			mva #<(explo_mask+96+144+144+48+48) explo_masktab+48+3
			mva #>(explo_mask+64+144+144+48+48) explo_masktab+64+48+3
			
bonus_adr	equ $6700
bonus_mask	equ $6900
bonus_shapetab	equ $6600

			
;bonus
			mva #BANK1 PORTB

			ldx #192
@			lda bonus200-1,x
			sta bonus_adr-1,x
			lda bonus200m-1,x
			sta bonus_mask-1,x
			dex
			bne @-

			mva #<(bonus_adr) bonus_shapetab+16
			mva #>(bonus_adr) bonus_shapetab+64+16
			mva #<(bonus_adr+48) bonus_shapetab+16+1
			mva #>(bonus_adr+48) bonus_shapetab+64+16+1
			mva #<(bonus_adr+96) bonus_shapetab+16+2
			mva #>(bonus_adr+96) bonus_shapetab+64+16+2
			mva #<(bonus_adr+144) bonus_shapetab+16+3
			mva #>(bonus_adr+144) bonus_shapetab+64+16+3
			
			mva #<(bonus_mask) bonus_shapetab+128+16
			mva #>(bonus_mask) bonus_shapetab+128+64+16
			mva #<(bonus_mask+48) bonus_shapetab+128+16+1
			mva #>(bonus_mask+48) bonus_shapetab+128+64+16+1
			mva #<(bonus_mask+96) bonus_shapetab+128+16+2
			mva #>(bonus_mask+96) bonus_shapetab+128+64+16+2
			mva #<(bonus_mask+144) bonus_shapetab+128+16+3
			mva #>(bonus_mask+144) bonus_shapetab+128+64+16+3

			
;sample
			mva #BANK4 PORTB

			ldx #0
			mwa #blastoff_wav bom
			mwa #sample1adr bom1
			mwa #blastoff_end bom2
			jsr przepisz_sampla
			
			ldx #2
			mwa #gameover_wav bom
			mwa #sample2adr bom1
			mwa #gameover_end bom2
			jsr przepisz_sampla
			
			ldx #4
			mwa #alive_wav bom
			mwa #sample3adr bom1
			mwa #alive_end bom2
			jsr przepisz_sampla

			ldx #6
			mwa #conred_wav bom
			mwa #sample4adr bom1
			mwa #conred_end bom2
			jsr przepisz_sampla
			
			ldx #8
			mwa #spy_wav bom
			mwa #sample5adr bom1
			mwa #spy_end bom2
	
			jsr przepisz_sampla
			
			ldx #10
			mwa #formation_wav bom
			mwa #sample6adr bom1
			mwa #formation_end bom2
			jsr przepisz_sampla

			
			ldx #0
@			lda znaki_ad,x
			sta znaki1,x
			sta znaki2,x
			lda znaki_ad+$100,x
			sta znaki1+$100,x
			sta znaki2+$100,x
			lda znaki_ad+$200,x
			dex
			bne @-
			
			ldx #31
@			lda bomba1,x
			sta znaki2+firstBombaChar*8,x
			dex
			bpl @-
		
			ldx #7
@			lda rakieta1,x
			sta znaki2+firstRakietaChar*8,x
			lda rakieta1+8,x
			sta znaki2+(firstRakietaChar+3)*8,x
			lda rakieta1+16,x
			sta znaki2+(firstRakietaChar+4)*8,x
			lda rakieta1+24,x
			sta znaki2+(firstRakietaChar+7)*8,x
			lda mwybuch2,x
			sta znaki2+firstMalyWybuchChar*8,x
			lda mwybuch2+8,x
			sta znaki2+firstMalyWybuchChar*8+8,x
			lda mwybuch2-8,x
			sta znaki1+firstMalyWybuchChar*8+8,x
			dex
			bpl @-
			
			
			
			ldx #10*8-1
@			mva #BANK1 PORTB
		
			lda	EXTMEM,x
			sta $ba10,x
			lda EXTMEM+$2000,x
			sta $ba10+80,x
		
			mva #BANK2 PORTB
		
			lda	EXTMEM,x
			sta $ba10+160,x
			lda EXTMEM+$2000,x
			sta $ba10+240,x
		
			mva #BANK3 PORTB
		
			lda	EXTMEM,x
			sta $ba10+320,x
			lda EXTMEM+$2000,x
			sta $ba10+400,x
		
			dex
			bpl @-
	
;konczymy przygotowania	
			mva #ROM_on PORTB
			mva #%01000000 NMIEN ;wlacz VBLK
			cli
			
			rts
			
bonus200	
		:4 dta b(0)	
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00110001)
		dta b(%00000111)
		dta b(%00011100)
		dta b(%00010000)
		dta b(%00010101)
		dta b(%00111111)
		:4 dta b(0)
		
		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)

		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)
		
bonus300
		:4 dta b(0)	
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00110001)
		dta b(%00000111)
		dta b(%00001101)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)	
		
		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)

		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)	
		
bonus400
		:4 dta b(0)	
		dta b(%00010000)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110101)
		dta b(%00001101)
		dta b(%00000001)
		dta b(%00000001)
		dta b(%00000011)
		:4 dta b(0)
		
		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)

		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)
		
bonus800
		:4 dta b(0)	
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)
		
		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)

		:4 dta b(0)
		dta b(%00000100)
		dta b(%00011101)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00010001)
		dta b(%00110111)
		dta b(%00001100)
		:4 dta b(0)	

bonus200m	
		:3 dta b(255)	
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000011)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		:3 dta b(255)
		
		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)

		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)
		
bonus300m
		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)	
		
		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)

		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)
		
bonus400m
		:3 dta b(255)
		dta b(%11001111)
		dta b(%00000011)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110000)
		dta b(%11110000)
		dta b(%11110000)
		dta b(%11110000)
		:3 dta b(255)
		
		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)

		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)
		
bonus800m
		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)
		
		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)

		:3 dta b(255)
		dta b(%11110011)
		dta b(%11000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%00000000)
		dta b(%11000000)
		dta b(%11110011)
		:3 dta b(255)	
			
			ini (init_banki)
			