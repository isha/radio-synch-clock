; math32.asm: Addition, subtraction, multiplication,
; and division of 32-bit integers. Also included is a
; binary to bcd conversion subrooutine.
;
; (c) 2011-2012 Jesus Calvino-Fraga
;
DSEG at 60H
x:     ds 4
y:     ds 4
bcd:   ds 5 ; BCD of x is stored here after calling hex2bcd

CSEG

;------------------------------------------------
; Converts the 32-bit hex number in 'x' to a 
; 10-digit packed BCD in 'bcd'
;------------------------------------------------
hex2bcd:
	push acc
	push psw
	push AR0
	push AR1
	push AR2
	push AR3
	push AR4
	
	clr a
	mov bcd+0, a ; Initialize BCD result to 0000000000 
	mov bcd+1, a
	mov bcd+2, a
	mov bcd+3, a
	mov bcd+4, a
	mov R4, #32 ;Loop counter.
	; Copy x to working registers
	mov R0, x+0
	mov R1, x+1
	mov R2, x+2
	mov R3, x+3
    
hex2bcd_L0:
	mov a, R0 ;Shift the 32-bits of x left through carry
	rlc a
	mov R0, a
	mov a, R1
	rlc a
	mov R1, a
	mov a, R2
	rlc a
	mov R2, a
	mov a, R3
	rlc a
	mov R3, a
    
	; Perform bcd + bcd + carry using BCD arithmetic
	mov a, bcd+0
	addc a, bcd+0
	da a
	mov bcd+0, a
	
	mov a, bcd+1
	addc a, bcd+1
	da a
	mov bcd+1, a
	
	mov a, bcd+2
	addc a, bcd+2
	da a
	mov bcd+2, a
	
	mov a, bcd+3
	addc a, bcd+3
	da a
	mov bcd+3, a

	mov a, bcd+4
	addc a, bcd+4
	da a
	mov bcd+4, a
	
	djnz R4, hex2bcd_L0
	
	pop AR4
	pop AR3
	pop AR2
	pop AR1
	pop AR0
	pop psw
	pop acc
	
	ret

;------------------------------------------------
; x = x + y
;------------------------------------------------
add32:
	push acc
	push psw
	mov a, x+0
	add a, y+0
	mov x+0, a
	mov a, x+1
	addc a, y+1
	mov x+1, a
	mov a, x+2
	addc a, y+2
	mov x+2, a
	mov a, x+3
	addc a, y+3
	mov x+3, a
	pop psw
	pop acc
	ret

;------------------------------------------------
; x = x - y
;------------------------------------------------
sub32:
	push acc
	push psw
	clr c
	mov a, x+0
	subb a, y+0
	mov x+0, a
	mov a, x+1
	subb a, y+1
	mov x+1, a
	mov a, x+2
	subb a, y+2
	mov x+2, a
	mov a, x+3
	subb a, y+3
	mov x+3, a
	pop psw
	pop acc
	ret
	
;------------------------------------------------
; x = x * y
;------------------------------------------------
mul32:

	push acc
	push b
	push psw
	push AR0
	push AR1
	push AR2
	push AR3
		
	; R0 = x+0 * y+0
	; R1 = x+1 * y+0 + x+0 * y+1
	; R2 = x+2 * y+0 + x+1 * y+1 + x+0 * y+2
	; R3 = x+3 * y+0 + x+2 * y+1 + x+1 * y+2 + x+0 * y+3
	
	; Byte 0
	mov	a,x+0
	mov	b,y+0
	mul	ab		; x+0 * y+0
	mov	R0,a
	mov	R1,b
	
	; Byte 1
	mov	a,x+1
	mov	b,y+0
	mul	ab		; x+1 * y+0
	add	a,R1
	mov	R1,a
	clr	a
	addc a,b
	mov	R2,a
	
	mov	a,x+0
	mov	b,y+1
	mul	ab		; x+0 * y+1
	add	a,R1
	mov	R1,a
	mov	a,b
	addc a,R2
	mov	R2,a
	clr	a
	rlc	a
	mov	R3,a
	
	; Byte 2
	mov	a,x+2
	mov	b,y+0
	mul	ab		; x+2 * y+0
	add	a,R2
	mov	R2,a
	mov	a,b
	addc a,R3
	mov	R3,a
	
	mov	a,x+1
	mov	b,y+1
	mul	ab		; x+1 * y+1
	add	a,R2
	mov	R2,a
	mov	a,b
	addc a,R3
	mov	R3,a
	
	mov	a,x+0
	mov	b,y+2
	mul	ab		; x+0 * y+2
	add	a,R2
	mov	R2,a
	mov	a,b
	addc a,R3
	mov	R3,a
	
	; Byte 3
	mov	a,x+3
	mov	b,y+0
	mul	ab		; x+3 * y+0
	add	a,R3
	mov	R3,a
	
	mov	a,x+2
	mov	b,y+1
	mul	ab		; x+2 * y+1
	add	a,R3
	mov	R3,a
	
	mov	a,x+1
	mov	b,y+2
	mul	ab		; x+1 * y+2
	add	a,R3
	mov	R3,a
	
	mov	a,x+0
	mov	b,y+3
	mul	ab		; x+0 * y+3
	add	a,R3
	mov	R3,a
	
	mov	x+3,R3
	mov	x+2,R2
	mov	x+1,R1
	mov	x+0,R0

	pop AR3
	pop AR2
	pop AR1
	pop AR0
	pop psw
	pop b
	pop acc
	
	ret

;------------------------------------------------
; x = x / y
; This subroutine uses the 'paper-and-pencil' 
; method described in page 139 of 'Using the
; MCS-51 microcontroller' by Han-Way Huang.
;------------------------------------------------
div32:
	push acc
	push psw
	push AR0
	push AR1
	push AR2
	push AR3
	push AR4
	
	mov	R4,#32
	clr	a
	mov	R0,a
	mov	R1,a
	mov	R2,a
	mov	R3,a
	
div32_loop:
	; Shift the 64-bit of [[R3..R0], x] left:
	clr c
	; First shift x:
	mov	a,x+0
	rlc a
	mov	x+0,a
	mov	a,x+1
	rlc	a
	mov	x+1,a
	mov	a,x+2
	rlc	a
	mov	x+2,a
	mov	a,x+3
	rlc	a
	mov	x+3,a
	; Then shift [R3..R0]:
	mov	a,R0
	rlc	a 
	mov	R0,a
	mov	a,R1
	rlc	a
	mov	R1,a
	mov	a,R2
	rlc	a
	mov	R2,a
	mov	a,R3
	rlc	a
	mov	R3,a
	
	; [R3..R0] - y
	clr c	     
	mov	a,R0
	subb a,y+0
	mov	a,R1
	subb a,y+1
	mov	a,R2
	subb a,y+2
	mov	a,R3
	subb a,y+3
	
	jc	div32_minus		; temp >= y?
	
	; -> yes;  [R3..R0] -= y;
	; clr c ; carry is always zero here because of the jc above!
	mov	a,R0
	subb a,y+0 
	mov	R0,a
	mov	a,R1
	subb a,y+1
	mov	R1,a
	mov	a,R2
	subb a,y+2
	mov	R2,a
	mov	a,R3
	subb a,y+3
	mov	R3,a
	
	; Set the least significant bit of x to 1
	orl	x+0,#1
	
div32_minus:
	djnz R4, div32_loop	; -> no
	
div32_exit:

	pop AR4
	pop AR3
	pop AR2
	pop AR1
	pop AR0
	pop psw
	pop acc
	
	ret
