!to "picload.prg", cbm
* = $801

loader_start = $334
kernal_setlfs         = $ffba ; set file parameters
kernal_setnam         = $ffbd ; set file name
kernal_load           = $ffd5 ; load file
kernal_close          = $ffc3 ; close a file


; Basic line: "1 sys2061"
!byte $0b, $08, $01,$00, $9e, $32, $30, $36, $31, 0, 0, 0

!zone picloader {

; Copy bitmap data

;	ldy #31
	ldx #0
.copy_bitmap
	lda koala_base,x
	sta $e000,x
	inx
	bne .copy_bitmap
	inc .copy_bitmap + 2
	inc .copy_bitmap + 5
	bne .copy_bitmap
	
; Copy screen RAM and colour RAM

.copy_screen
	lda koala_base + 8000,x
	sta $cc00,x
	lda koala_base + 8000 + 250,x
	sta $cc00 + 250,x
	lda koala_base + 8000 + 500,x
	sta $cc00 + 500,x
	lda koala_base + 8000 + 750,x
	sta $cc00 + 750,x
	lda koala_base + 8000 + 1000,x
	sta $d800,x
	lda koala_base + 8000 + 1250,x
	sta $d800 + 250,x
	lda koala_base + 8000 + 1500,x
	sta $d800 + 500,x
	lda koala_base + 8000 + 1750,x
	sta $d800 + 750,x
	inx
	cpx #250
	bcc .copy_screen


; Copy background colour
	lda koala_base + 10000
	sta $d020
	sta $d021

; Show image

	; Set bank
	lda $dd00
	and #%11111100
	sta $dd00
	
	lda $d018
	; Set bitmap address to $e000
	ora #%00001000
	; Set screen address to $cc00
	and #%00001111
	ora #%00110000
	sta $d018

; Set graphics mode

	lda $d011
	and #%10011111
	ora #%00100000
	sta $d011
	lda $d016
	and #%11101111
	ora #%00010000
	sta $d016

; Wait for <SPACE>

;.getchar
;	jsr $ffe4
;	cmp #32
;	bne .getchar

; Copy loader

	ldx #.end_of_loader - .loader - 1
-	lda .loader,x
	sta loader_start,x
	dex
	bpl -
	jmp loader_start;

.loader
!pseudopc loader_start {
    lda #5
    ldx #<.filename
    ldy #>.filename
    jsr kernal_setnam
    lda #1      ; file number
    ldx $ba ; Device#
	ldy #1      ; $01 means: load to address stored in file
    jsr kernal_setlfs
    lda #$00      ; $00 means: load to memory (not verify)
    jsr kernal_load
    lda #1 
    jsr kernal_close
; Hide image and set default graphics bank


; Set graphics mode

	lda $d011
	and #%10011111
	sta $d011
	lda $d016
	and #%11101111
	sta $d016

	; Set bank
	lda $dd00
	and #%11111100
	ora #%00000011
	sta $dd00

	; Set screen address to $0400 and charmem to $d000 
	lda #%00010100
	sta $d018
	
	lda #147
	jsr $ffd2
	
	lda #$52 ; r
	sta 631
	lda #$d5
	sta 632
	lda #13
	sta 633
	lda #3
	sta 198
	
	; Set text colour to black
	lda #0
	sta 646

	rts
.filename
!pet "story"
}
.end_of_loader
} ; zone picloader

koala_base
	
	!binary "loaderpic.kla",,2 
	