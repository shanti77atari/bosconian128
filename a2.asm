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
		
	org $2000

start	equ *
    sei
    lda #0
    sta IRQEN
    sta NMIEN
    sta DMACTL
    ;mva #$FF GRAFP0
    ;mva #15 COLPM0
    mva #$50 AUDCTL
    mva #$00 AUDC2
    mva #$00 AUDC3
    mva #$00 AUDC4
    mva #$FF AUDF2
    
    mva #$AF AUDC1
    mva #$50 AUDCTL
    ldy #>Sample_end
	ldx #<Sample_end

ld  lda SAMPLE
    sta WSYNC
    sta AUDF1
    sta STIMER
    add #$44
    ;sta HPOSP0
    inc ld+1
    bne ld1
    inc ld+2
ld1 cpx ld+1
    bne ld
	cpy ld+2
	bne ld
    mwa #SAMPLE ld+1
	jmp ld
	
SAMPLE	equ *
		ins '/samples/battle8.raw'
Sample_end		dta b(17)	
	
	