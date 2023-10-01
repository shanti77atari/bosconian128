;trzecia wersja duszków
firstDuchChar	equ 74

;zgodnosc2
enemyNegatyw	org *+6	;dta b(0,0,0,0,0,0)
enemyEkran	org *+6	;dta b(0,0,0,0,0,0)		;1=duszek widoczny na ekranie
enemyLastFaza	org *+6	;dta b(0,0,0,0,0,0)
enemyWybuch	org *+6	;dta b(0,0,0,0,0,0)
.IF .DEF PSP_CODE
psp			org *+1
.ENDIF


;tablice
duszkiZnakiL	equ *
			:6 dta b(<((firstDuchChar+9*#)*8+znaki1))
duszkiZnakiH	equ *
			:6 dta b(>((firstDuchChar+9*#)*8+znaki1))
duszkiChar		equ *
			:6 dta b(firstDuchChar+(#*9))


;0page
_nznak		equ pom1
_kszt		equ pom2
_mask		equ pom3
nchar		equ pom0
zapX		equ duchx
duchX		equ pom0a	


duszkiPrint	equ *	
			sec
			lda enemyX,x
			sbc posX
			tay
			lda tabX,y
			sta enemyX0,x
			clc
			adc #2
			cmp #33+2
			bcc @+
			lda enemyY,x		;obliczmy też Y0 dla duszka poza ekranem
			sbc posY
			sta enemyY0,x
			lda #1
			sta enemyEkran,x
			rts		;poza ekranem
			
@			adc #6
			sta duchX
			
			sec
			lda enemyY,x
			sbc posY
			sta enemyY0,x
			clc
			adc #2
			cmp #29+2
			bcc @+
			lda #1
			sta enemyEkran,x
			rts		;poza ekranem	
			
@			tay

			
			lda ramka
			bne @+					;adres pamieci obrazu pod duszkiem
			clc
			lda obraz1La+6,y
			adc duchX
			sta pom
			lda obraz1Ha+6,y
			adc #0
			sta pom+1
			bne @+1		;skok bezwarunkowy
@			clc
			lda obraz2La+6,y
			adc duchX
			sta pom
			lda obraz2Ha+6,y
			adc #0
			sta pom+1
			
@			equ *
			stx zapX	;zapamietaj X
			lda enemyShapeH,x		;adres ksztaltu
			sta _shapeAD_L+2
			sta _shapeAD_H+2
			
.IF .NOT .DEF FastSprites
			sta _maskAD_L+2
			sta _maskAD_H+2
.ENDIF
	
.IF .DEF PSP_CODE		
			lda psp
			beq no_psp
			lda enemyBank,x
			cmp PORTB
			beq @+
			sta PORTB
			jmp @+
no_psp		lda PORTB
			sta pom0d
			mva enemyBank,x PORTB
@			equ *			
.ELSE		
			lda PORTB
			sta pom0d
			mva enemyBank,x PORTB		;przelaczamy bank pamieci
.ENDIF		
			lda enemyDY,x
			and #%11000000
			asl
			:2 rol
			sta enemyDY0,x
			asl
			sta pom0c	;DY*2

			lda enemyDX,x
			and #%11000000
			asl
			rol
			rol
			sta enemyDX0,x	;DX
			asl
			sta pom0b		;DX*2
			:3 asl
			ora enemyFaza,x
			tay
			
			lda duszkiChar,x			
			ora enemyNegatyw,x	
			sta nchar
			
			sec
_shapeAD_L	equ *
			lda enemy1shapetab,y			;adres ksztaltu faza*4 + DX
			sbc pom0c				;-(DY*2)
			sta _kszt
_shapeAD_H	equ *
			lda enemy1shapetab+64,y
			sbc #0
			sta _kszt+1		

.IF .NOT .DEF fastSprites		
			sec
_maskAD_L	equ *
			lda enemy1masktab,y
			sbc pom0c
			sta _mask
_maskAD_H	equ *
			lda enemy1masktab+64,y
			sbc #0
			sta _mask+1
.ENDIF
			
			lda enemyDY0,x
			bne @+
			ora pom0b
			beq printDX4
			jmp printDX6
@			lda pom0b	;DX
			beq @+
			jmp printDY9
@			jmp printDY6
		
;DX=0,DY=0		
printDX4		equ *

;adresy nowych znakow			
			lda duszkiZnakiH,x
			ora ramka4
			sta nznakX40+2
			tay
			lda duszkiZnakiL,x		;wskaznik do adresu pierwszego znaku duszka
			sta nznakX40+1
			clc
			adc #8
			
			sta nznakX41+1
			sty nznakX41+2
			adc #8
			
			sta nznakX42+1
			sty nznakX42+2
			adc #8
			
			sta nznakX43+1
			sty nznakX43+2
			
			
;adresy starych znakow
			ldy #0			;1znak
			lda (pom),y
			tax
			and #128			
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX40+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX40+2
			
			inc nchar
			ldy #48			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX41+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX41+2
			
			inc nchar
			ldy #1			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX42+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX42+2
			
			inc nchar
			ldy #49			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX43+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX43+2

;adresy ksztaltow	dla danych znakow
			lda _kszt		;adresy ksztaltow
			sta ksztX40+1
			ldy _kszt+1
			sty ksztX40+2
.IF .NOT .DEF fastSprites
			ldx _mask+1
			sta maskX40+1
			stx maskX40+2
.ENDIF
			clc
			adc #8
			
			sta ksztX41+1
			sty ksztX41+2
.IF .NOT .DEF fastSprites
			sta maskX41+1
			stx maskX41+2
.ENDIF
			adc #8
			
			sta ksztX42+1
			sty ksztX42+2
.IF .NOT .DEF fastSprites
			sta maskX42+1
			stx maskX42+2
.ENDIF
			adc #8
			
			sta ksztX43+1
			sty ksztX43+2
.IF .NOT .DEF fastSprites
			sta maskX43+1
			stx maskX43+2
.ENDIF
			
;rysuje duszki przy przesunięciu DX=0 i DY=0 , 4znaki
			ldy #7
@			equ *
			.rept 4, #
sznakX4:1	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskX4:1	and $ffff,y
ksztX4:1	ora $ffff,y
.ELSE
ksztX4:1	equ *
			eor	$ffff,y
.ENDIF
nznakX4:1	equ *
			sta $ffff,y
			.endr
			dey
			bpl @-

.IF .DEF PSP_CODE			
			lda psp
			bne @+
.ENDIF			
			lda pom0d
			sta PORTB
@			ldx zapX
			lda #0
			sta enemyEkran,x
			rts	
			
;DX>0,DY=0		
printDX6		equ *
;adresy nowych znakow	
			lda duszkiZnakiH,x
			ora ramka4
			sta nznakX60+2
			tay
			lda duszkiZnakiL,x		;wskaznik do adresu pierwszego znaku duszka
			sta nznakX60+1
			clc
			adc #8
			
			sta nznakX61+1
			sty nznakX61+2
			adc #8
			
			sta nznakX62+1
			sty nznakX62+2
			adc #8
			
			sta nznakX63+1
			sty nznakX63+2
			adc #8
			bcc *+4
			iny
			clc
			
			sta nznakX64+1
			sty nznakX64+2
			adc #8
			
			sta nznakX65+1
			sty nznakX65+2

;adresy starych znakow
			ldy #0			;1znak
			lda (pom),y
			tax					
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX60+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX60+2

			inc nchar
			ldy #48			;1znak
			lda (pom),y
			tax		
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX61+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX61+2
			
			inc nchar
			ldy #1			;1znak
			lda (pom),y
			tax		
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX62+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX62+2
			
			inc nchar
			ldy #49			;1znak
			lda (pom),y
			tax		
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX63+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX63+2
			
			inc nchar
			ldy #2			;1znak
			lda (pom),y
			tax		
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX64+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX64+2
			
			inc nchar
			ldy #50			;1znak
			lda (pom),y
			tax			
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakX65+1
			lda adresZnakH,x
			ora ramka4
			sta sznakX65+2

;adresy ksztaltow	dla danych znakow
			lda _kszt		;adresy ksztaltow
			sta ksztX60+1
			ldy _kszt+1
			sty ksztX60+2
.IF .NOT .DEF fastSprites
			ldx _mask+1
			sta maskX60+1
			stx maskX60+2
.ENDIF
			clc
			adc #8
			bcc @+
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			iny
			clc
			
@			sta ksztX61+1
			sty ksztX61+2
.IF .NOT .DEF fastSprites
			sta maskX61+1
			stx maskX61+2
.ENDIF
			adc #8
			bcc @+
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			iny
			clc
			
@			sta ksztX62+1
			sty ksztX62+2
.IF .NOT .DEF fastSprites
			sta maskX62+1
			stx maskX62+2
.ENDIF
			adc #8
			bcc @+
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			iny
			clc
			
@			sta ksztX63+1
			sty ksztX63+2
.IF .NOT .DEF fastSprites
			sta maskX63+1
			stx maskX63+2
.ENDIF
			adc #8
			bcc @+
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			iny
			clc
			
@			sta ksztX64+1
			sty ksztX64+2
.IF .NOT .DEF fastSprites
			sta maskX64+1
			stx maskX64+2
.ENDIF
			adc #8
			bcc @+
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			iny
			
@			sta ksztX65+1
			sty ksztX65+2
.IF .NOT .DEF fastSprites
			sta maskX65+1
			stx maskX65+2
.ENDIF
			
;rysuje duszki przy przesunięciu DX>0 i DY=0
			ldy #7
@			equ *
			.rept 6, #
sznakX6:1	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskX6:1	and $ffff,y
ksztX6:1	ora $ffff,y
.ELSE
ksztX6:1	equ *
			eor	$ffff,y
.ENDIF
nznakX6:1	equ *
			sta $ffff,y
			.endr
			dey
			bpl @-
			
.IF .DEF PSP_CODE			
			lda psp
			bne @+
.ENDIF				
			lda pom0d
			sta PORTB
@			ldx zapX
			lda #0
			sta enemyEkran,x
			rts
			
			
printDY6	equ *
;adresy nowych znakow
			lda duszkiZnakiH,x
			ora ramka4
			sta nznakY60+2
			sta nznakY60b+2
			tay
			lda duszkiZnakiL,x		;wskaznik do adresu pierwszego znaku duszka
			sta nznakY60+1
			sta nznakY60b+1
			clc
			adc #8
			bcc @+
			iny
			clc
			
@			sta nznakY61+1
			sta nznakY61b+1
			sty nznakY61+2
			sty nznakY61b+2
			adc #8
			
			sta nznakY62+1
			sta nznakY62b+1
			sty nznakY62+2
			sty nznakY62b+2
			adc #8
			
			sta nznakY63+1
			sta nznakY63b+1
			sty nznakY63+2
			sty nznakY63b+2
			adc #8
			bcc *+4
			iny
			clc
			
			sta nznakY64+1
			sta nznakY64b+1
			sty nznakY64+2
			sty nznakY64b+2
			adc #8
			
			sta nznakY65+1
			sta nznakY65b+1
			sty nznakY65+2
			sty nznakY65b+2

;adresy starych znaków

			ldy pom0c
			dey
			sty petlaY6+1
		
			ldy #0			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY60+1
			sta sznakY60b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY60+2
			sta sznakY60b+2
				
			inc nchar
			ldy #48			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY61+1
			sta sznakY61b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY61+2
			sta sznakY61b+2
			
			inc nchar
			ldy #96			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY62+1
			sta sznakY62b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY62+2
			sta sznakY62b+2
			
			inc nchar
			ldy #1			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY63+1
			sta sznakY63b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY63+2
			sta sznakY63b+2
			
			inc nchar
			ldy #49			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY64+1
			sta sznakY64b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY64+2
			sta sznakY64b+2
			
			inc nchar
			ldy #97			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY65+1
			sta sznakY65b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY65+2
			sta sznakY65b+2

;adresy ksztaltow	dla danych znakow
			lda _kszt		;adresy ksztaltow
			sta ksztY60+1
			ldy _kszt+1
			sty ksztY60+2
.IF .NOT .DEF fastSprites
			ldx _mask+1
			sta maskY60+1
			stx maskY60+2
.ENDIF
			clc
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			
			clc
@			sta ksztY61+1
			sta ksztY61b+1
			sty ksztY61+2
			sty ksztY61b+2
.IF .NOT .DEF fastSprites
			sta maskY61+1
			sta maskY61b+1
			stx maskY61+2
			stx maskY61b+2
.ENDIF
			adc #8 	
			
			sta ksztY62b+1
			sty ksztY62b+2
.IF .NOT .DEF fastSprites
			sta maskY62b+1
			stx maskY62b+2
.ENDIF
			
			sta ksztY63+1
			sty ksztY63+2
.IF .NOT .DEF fastSprites
			sta maskY63+1
			stx maskY63+2
.ENDIF
			adc #8
			
			sta ksztY64+1
			sta ksztY64b+1
			sty ksztY64+2
			sty ksztY64b+2
.IF .NOT .DEF fastSprites
			sta maskY64+1
			sta maskY64b+1
			stx maskY64+2
			stx maskY64b+2
.ENDIF
			adc #8
			
			sta ksztY65b+1
			sty ksztY65b+2
.IF .NOT .DEF fastSprites
			sta maskY65b+1
			stx maskY65b+2
.ENDIF
			
;rysuje duszki przy DX=0 i DY>0 , 6 znaków
			ldy #7
@			equ *

sznakY60	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY60		and $ffff,y
ksztY60		ora $ffff,y
.ELSE
ksztY60		equ *
			eor $ffff,y
.ENDIF
nznakY60	equ *
			sta $ffff,y
			
sznakY61	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY61		and $ffff,y
ksztY61		ora $ffff,y
.ELSE
ksztY61		equ *
			eor $ffff,y
.ENDIF
nznakY61	equ *
			sta $ffff,y
			
sznakY62	equ *
			lda $ffff,y
nznakY62	equ *
			sta $ffff,y		

sznakY63	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY63		and $ffff,y
ksztY63		ora $ffff,y
.ELSE
ksztY63		equ *
			eor $ffff,y
.ENDIF
nznakY63	equ *
			sta $ffff,y
			
sznakY64	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY64		and $ffff,y
ksztY64		ora $ffff,y
.ELSE
ksztY64		equ *
			eor $ffff,y
.ENDIF
nznakY64	equ *
			sta $ffff,y
			
sznakY65	equ *
			lda $ffff,y
nznakY65	equ *
			sta $ffff,y				
			
			dey
petlaY6		equ *
			cpy #$ff
			bne @-
			
@			equ *
sznakY60b	equ *
			lda $ffff,y
nznakY60b	equ *
			sta $ffff,y
			
sznakY61b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY61b	and $ffff,y
ksztY61b	ora $ffff,y
.ELSE
ksztY61b	equ *
			eor $ffff,y
.ENDIF
nznakY61b	equ *
			sta $ffff,y	
			
sznakY62b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY62b	and $ffff,y
ksztY62b	ora $ffff,y
.ELSE
ksztY62b	equ *
			eor $ffff,y
.ENDIF
nznakY62b	equ *
			sta $ffff,y			
			
sznakY63b	equ *
			lda $ffff,y
nznakY63b	equ *
			sta $ffff,y
			
sznakY64b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY64b	and $ffff,y
ksztY64b	ora $ffff,y
.ELSE
ksztY64b	equ *
			eor $ffff,y
.ENDIF
nznakY64b	equ *
			sta $ffff,y	
			
sznakY65b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY65b	and $ffff,y
ksztY65b	ora $ffff,y
.ELSE
ksztY65b	equ *
			eor $ffff,y
.ENDIF
nznakY65b	equ *
			sta $ffff,y	
			
			dey
			bpl @-

.IF .DEF PSP_CODE			
			lda psp
			bne @+
.ENDIF				
			lda pom0d
			sta PORTB
@			ldx zapX
			lda #0
			sta enemyEkran,x
			rts
			
printDY9	equ *
;adresy nowych znakow
			lda duszkiZnakiH,x
			ora ramka4
			sta nznakY90+2
			sta nznakY90b+2
			tay
			lda duszkiZnakiL,x		;wskaznik do adresu pierwszego znaku duszka
			sta nznakY90+1
			sta nznakY90b+1
			clc
			adc #8
			
			sta nznakY91+1
			sta nznakY91b+1
			sty nznakY91+2
			sty nznakY91b+2
			adc #8
			
			sta nznakY92+1
			sta nznakY92b+1
			sty nznakY92+2
			sty nznakY92b+2
			adc #8
			
			sta nznakY93+1
			sta nznakY93b+1
			sty nznakY93+2
			sty nznakY93b+2
			adc #8
			bcc *+4
			iny
			clc
			
			sta nznakY94+1
			sta nznakY94b+1
			sty nznakY94+2
			sty nznakY94b+2
			adc #8
			
			sta nznakY95+1
			sta nznakY95b+1
			sty nznakY95+2
			sty nznakY95b+2
			adc #8
			
			sta nznakY96+1
			sta nznakY96b+1
			sty nznakY96+2
			sty nznakY96b+2
			adc #8
			
			sta nznakY97+1
			sta nznakY97b+1
			sty nznakY97+2
			sty nznakY97b+2
			adc #8
			
			sta nznakY98+1
			sta nznakY98b+1
			sty nznakY98+2
			sty nznakY98b+2

;adresy starych znakow
			ldy pom0c
			dey
			sty petlaY9+1

			ldy #0			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY90+1
			sta sznakY90b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY90+2
			sta sznakY90b+2
			
			inc nchar
			ldy #48			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY91+1
			sta sznakY91b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY91+2
			sta sznakY91b+2
			
			inc nchar
			ldy #96			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY92+1
			sta sznakY92b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY92+2
			sta sznakY92b+2
			
			inc nchar
			ldy #1			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY93+1
			sta sznakY93b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY93+2
			sta sznakY93b+2
			
			inc nchar
			ldy #49			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY94+1
			sta sznakY94b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY94+2
			sta sznakY94b+2
			
			inc nchar
			ldy #97			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY95+1
			sta sznakY95b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY95+2
			sta sznakY95b+2
			
			inc nchar
			ldy #2			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY96+1
			sta sznakY96b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY96+2
			sta sznakY96b+2
			
			inc nchar
			ldy #50			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY97+1
			sta sznakY97b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY97+2
			sta sznakY97b+2
			
			inc nchar
			ldy #98			;1znak
			lda (pom),y
			tax
			and #128
			ora nchar		;nr znaku duszka
			sta (pom),y
			lda adresZnakL,x
			sta sznakY98+1
			sta sznakY98b+1
			lda adresZnakH,x
			ora ramka4
			sta sznakY98+2
			sta sznakY98b+2
			
;adresy ksztaltow	dla danych znakow
			lda _kszt		;adresy ksztaltow
			sta ksztY90+1
			ldy _kszt+1
			sty ksztY90+2
.IF .NOT .DEF fastSprites
			ldx _mask+1
			sta maskY90+1
			stx maskY90+2
.ENDIF
			clc
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			clc
			
@			sta ksztY91+1
			sta ksztY91b+1
			sty ksztY91+2
			sty ksztY91b+2
.IF .NOT .DEF fastSprites
			sta maskY91+1
			sta maskY91b+1
			stx maskY91+2
			stx maskY91b+2
.ENDIF
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			clc
			
@			sta ksztY92b+1
			sty ksztY92b+2
.IF .NOT .DEF fastSprites
			sta maskY92b+1
			stx maskY92b+2
.ENDIF
		
			sta ksztY93+1
			sty ksztY93+2
.IF .NOT .DEF fastSprites
			sta maskY93+1
			stx maskY93+2
.ENDIF
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			clc
			
@			sta ksztY94+1
			sta ksztY94b+1
			sty ksztY94+2
			sty ksztY94b+2
.IF .NOT .DEF fastSprites
			sta maskY94+1
			sta maskY94b+1
			stx maskY94+2
			stx maskY94b+2
.ENDIF
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			clc
			
@			sta ksztY95b+1
			sty ksztY95b+2
.IF .NOT .DEF fastSprites
			sta maskY95b+1
			stx maskY95b+2
.ENDIF
	
			sta ksztY96+1
			sty ksztY96+2
.IF .NOT .DEF fastSprites
			sta maskY96+1
			stx maskY96+2
.ENDIF
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			clc
			
@			sta ksztY97+1
			sta ksztY97b+1
			sty ksztY97+2
			sty ksztY97b+2
.IF .NOT .DEF fastSprites
			sta maskY97+1
			sta maskY97b+1
			stx maskY97+2
			stx maskY97b+2
.ENDIF
			adc #8
			bcc @+
			iny
.IF .NOT .DEF fastSprites
			inx
.ENDIF
			
@			sta ksztY98b+1
			sty ksztY98b+2
.IF .NOT .DEF fastSprites
			sta maskY98b+1
			stx maskY98b+2
.ENDIF

			
;rysuje duszki przy DX>0 i DY>0 , 9 znaków
			ldy #7
@			equ *

sznakY90	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY90		and $ffff,y
ksztY90		ora $ffff,y
.ELSE
ksztY90		equ *
			eor $ffff,y
.ENDIF
nznakY90	equ *
			sta $ffff,y
			
sznakY91	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY91		and $ffff,y
ksztY91		ora $ffff,y
.ELSE
ksztY91		equ *
			eor $ffff,y
.ENDIF
nznakY91	equ *
			sta $ffff,y
			
sznakY92	equ *
			lda $ffff,y
nznakY92	equ *
			sta $ffff,y		

sznakY93	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY93		and $ffff,y
ksztY93		ora $ffff,y
.ELSE
ksztY93		equ *
			eor $ffff,y
.ENDIF
nznakY93	equ *
			sta $ffff,y
			
sznakY94	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY94		and $ffff,y
ksztY94		ora $ffff,y
.ELSE
ksztY94		equ *
			eor $ffff,y
.ENDIF
nznakY94	equ *
			sta $ffff,y
			
sznakY95	equ *
			lda $ffff,y
nznakY95	equ *
			sta $ffff,y				
			
sznakY96	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY96		and $ffff,y
ksztY96		ora $ffff,y
.ELSE
ksztY96		equ *
			eor $ffff,y
.ENDIF
nznakY96	equ *
			sta $ffff,y
			
sznakY97	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY97		and $ffff,y
ksztY97		ora $ffff,y
.ELSE
ksztY97		equ *
			eor $ffff,y
.ENDIF
nznakY97	equ *
			sta $ffff,y
			
sznakY98	equ *
			lda $ffff,y
nznakY98	equ *
			sta $ffff,y	
			
			dey
petlaY9		equ *
			cpy #$ff
			bne @-
			
@			equ *
sznakY90b	equ *
			lda $ffff,y
nznakY90b	equ *
			sta $ffff,y
			
sznakY91b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY91b	and $ffff,y
ksztY91b	ora $ffff,y
.ELSE
ksztY91b	equ *
			eor $ffff,y
.ENDIF
nznakY91b	equ *
			sta $ffff,y	
			
sznakY92b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY92b	and $ffff,y
ksztY92b	ora $ffff,y
.ELSE
ksztY92b	equ *
			eor $ffff,y
.ENDIF
nznakY92b	equ *
			sta $ffff,y			
			
sznakY93b	equ *
			lda $ffff,y
nznakY93b	equ *
			sta $ffff,y
			
sznakY94b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY94b	and $ffff,y
ksztY94b	ora $ffff,y
.ELSE
ksztY94b	equ *
			eor $ffff,y
.ENDIF
nznakY94b	equ *
			sta $ffff,y	
			
sznakY95b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY95b	and $ffff,y
ksztY95b	ora $ffff,y
.ELSE
ksztY95b	equ *
			eor $ffff,y
.ENDIF
nznakY95b	equ *
			sta $ffff,y		
			
sznakY96b	equ *
			lda $ffff,y
nznakY96b	equ *
			sta $ffff,y
			
sznakY97b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY97b	and $ffff,y
ksztY97b	ora $ffff,y
.ELSE
ksztY97b	equ *
			eor $ffff,y
.ENDIF
nznakY97b	equ *
			sta $ffff,y	
			
sznakY98b	equ *
			lda $ffff,y
.IF .NOT .DEF fastSprites
maskY98b	and $ffff,y
ksztY98b	ora $ffff,y
.ELSE
ksztY98b	equ *
			eor $ffff,y
.ENDIF
nznakY98b	equ *
			sta $ffff,y	
			
			dey
			bpl @-

.IF .DEF PSP_CODE			
			lda psp
			bne @+
.ENDIF				
			lda pom0d
			sta PORTB
@			ldx zapX
			lda #0
			sta enemyEkran,x
			rts	
			
			
			