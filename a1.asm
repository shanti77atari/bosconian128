WSYNC		equ $D40A
SKCTL		equ $d20f
AUDCTL		equ $D208
AUDF1		equ $D200
AUDF2		equ $D202
AUDF3		equ $D204
AUDF4		equ $D206
IRQEN		equ $D20E
IRQENS		equ $10
VTIMER1		equ $0210
STIMER		equ $D209
AUDC1		equ $D201
AUDC2		equ $D203
AUDC3		equ $D205
AUDC4		equ $D207	
DMACTLS		equ $022F
RANDOM		equ $D20A	
NMIEN		equ $D40E
DMACTL		equ $D400
VCOUNT		equ $D40B
COLBAK		equ $D01A


rejA		equ 203
rejY		equ 205
sam			equ 206
sam1		equ 208
sam2		equ 210
powtorz		equ 212
sirq		equ 213

		org $600
		
		lda #0
		sta $d208
		ldy #3
		sty $d20f
		mva #0 NMIEN
		
		lda #0		;64khz
		sta AUDCTL
		;sta DMACTL
		
		sei
		mva #0 NMIEN
		lda #$fe
		sta $D301
		
		mwa #pok0 $fffe
		mva #0 IRQEN
		cli
		mva #%10000 probka+1
		
loop	equ *		
		mwa #SAMPLE sam
		mwa #SAMPLE sam2
		mwa #Sample_end	sam1
		mva #1 powtorz
		lda SAMPLE
		and #15+2
		ora #%10000
		sta probka+1
		
		
		mva Sample_end AUDF4
		lda #4
		sta IRQEN
		sta STIMER
		sta sirq
		
		
@		lda sirq
		bne @-
		
		mwa #SAMPLE2 sam
		mwa #SAMPLE2 sam2
		mwa #s2end	sam1
		mva #1 powtorz
		lda SAMPLE2
		and #15
		ora #%10000
		sta probka+1
		
		mva #30 AUDF4
		lda #4
		sta IRQEN
		sta STIMER
		sta sirq
		
@		lda sirq
		bne @-		
		
		jmp loop
		
/*		mwa #SAMPLE3 sam
		mwa #SAMPLE3 sam2
		mwa #s3end	sam1
		mva #1 powtorz
		lda SAMPLE3
		and #15
		ora #%10000
		sta probka+1
		
		
		mva s3end AUDF4
		lda #4
		sta IRQEN
		sta STIMER
		sta sirq
		
		
@		lda sirq
		bne @-
		
		mwa #SAMPLE2 sam
		mwa #SAMPLE2 sam2
		mwa #s2end	sam1
		mva #1 powtorz
		lda SAMPLE2
		and #15
		ora #%10000
		sta probka+1
		
		mva #30 AUDF4
		lda #4
		sta IRQEN
		sta STIMER
		sta sirq
		
@		lda sirq
		bne @-				
		
		
		jmp loop*/
		
		 
		.align		
pok0	equ *
		sta rejA
probka	equ *		
		lda #$ff
		sta AUDC1
		sta COLBAK
		
		sty rejY
		ldy #0		
		sty IRQEN
		lda (sam),y
		ora #%10000
		sta probka1+1
		
		inc sam
		bne @+
		inc sam+1
		
@		lda sam
		cmp sam1
		beq @+1

@		lda #4		;resetuj licznik
		sta IRQEN	
		
		mva <pok1 $fffe
			
		lda rejA	;odtworz rejestr A
		ldy rejY
		rti
				
@		lda sam+1
		cmp sam1+1
		bne @-1

		dec powtorz
		beq @+
		lda sam2
		sta sam
		lda sam2+1
		sta sam+1
		jmp @-1
		
@		lda #0		;wylacz przerwanie
		sta sirq
		
		lda rejA	
		ldy rejY
		rti
		
pok1	equ *		;gorna polowka
		sta rejA
probka1	equ *
		lda #$ff
		sta AUDC1
		sta COLBAK
		sty rejY
		
		ldy #0
		sty IRQEN
		lda (sam),y
		:4 lsr
		ora #%10000
		sta probka+1
		
		lda #4
		sta IRQEN
		
		mva <pok0 $fffe
		
		ldy rejY
		lda rejA
		rti		

SAMPLE	equ *
		ins '/samples/roundclr35.wav'
Sample_end		dta b(17)


SAMPLE2	equ *
		:512 dta b($88)
s2end	dta b(0)
/*		
SAMPLE3	ins '/samples/spy.wav'		
s3end	dta b(15)*/

		
		