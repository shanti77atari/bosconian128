;odgrywamy sample na przerwaniu Pokey'a	

		org 128+4,$8000-23-72	;$48=72b	256-113=139
pok0	equ *
		sta pok0a+1
probka	equ *		
		lda #$ff
		sta AUDC4
		lda #0		
		sta IRQEN
		sta $fffe	
sam		equ *+1
@		lda $ffff
		beq @+
		sta _probka
		ora #%10000
		sta probka+1
_probka	equ *+1		
		lda #$ff
		sec
		ror
		:3 lsr
		sta probka1+1
		
		inc sam
		bne *+4
		inc sam+1
		
		lda #4
		sta IRQEN
		
pok0a	lda #$ff	;odtworz rejestr A
		rti
		
@		dec powtorz
		beq  @+
sam2	equ *+1
		lda #$ff
		sta sam
sam2s	equ *+1
		lda #$ff
		sta sam+1	
		jmp @-1

@		sta sirq
		sta IRQEN
		lda pok0a+1
		rti
		
		
		org 0,$8000-23			;23b
pok1	equ *		;gorna polowka
		sta pok1a+1
probka1	equ *
		lda #$ff
		sta AUDC4
		
		lda #0
		sta IRQEN
	
		lda #4+128	
		sta IRQEN
		sta $fffe
		
pok1a	lda #$ff
		rti		
		
;		