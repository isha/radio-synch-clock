;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; LCD COMMANDS
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Delay:

	push dpl
	push dph
	push psw 
	using	0
	mov	r2,dpl
	mov	r3,dph
	mov	r4,#0x00
	mov	r5,#0x00

D1:
	clr	c
	mov	a,r4
	subb	a,r2
	mov	a,r5
	subb	a,r3
	jnc	D4
	mov	r6,#0x5E
	mov	r7,#0x01
D2:
	dec	r6
	cjne	r6,#0xff,D3
	dec	r7
D3:
	mov	a,r6
	orl	a,r7
	jnz	D2
	inc	r4
	cjne	r4,#0x00,D1
	inc	r5
	sjmp	D1
D4:
	pop psw
	pop dph
	pop dpl
	ret
	
	
Sorting_like_Isha:

mov c, acc.7
mov P3.3, c
mov c, acc.6
mov P3.2, c
mov c, acc.5
mov P3.5, c
mov c, acc.4
mov P3.6, c
mov c, acc.3
mov P3.7, c
mov c, acc.2
mov P2.0, c
mov c, acc.1
mov P2.1, c
mov c, acc.0
mov P2.2, c

ret
	


Sorting_Bits_for_8051:

		push psw	
		push aR0
		push aR1
		push aR2
		
		clr c
		mov b, a
		anl a, #00000111b
		lcall checkP2_0
		
		mov a, b
		anl a, #00111000b
		lcall checkP3a_0
	
		mov a, b
		anl a, #11000000b
		lcall checkP3b_0

		mov b, R1	
		clr a
		orl a, b		
		mov b, R2
		orl a, b
		
		mov P3, a	;ADD HERE: MOV P3, a
				
		clr a
		mov b, R0
		orl a, b
		

		mov P2, a		; ADD HERE: MOV P2, a
	
		pop aR2
		pop aR1
		pop aR0
		pop psw
		
		ret


checkP2_0:	
cjne a, #00000001b, checkP2_1
 mov R0, #00000100b
 ret
checkP2_1:
cjne a, #00000011b, checkP2_2
 mov R0, #00000110b
 ret
checkP2_2:
cjne a, #00000100b, checkP2_3
 mov R0, #00000001b
 ret
checkP2_3:
cjne a, #00000110b, checkP2_4
 mov R0, #00000011b
 ret
checkP2_4:
mov R0, a
 ret
 
checkP3a_0:	
cjne a, #00001000b, checkP3a_1
 mov R1,#10000000b
 ret
checkP3a_1:
cjne a, #00011000b, checkP3a_2
 mov R1,#11000000b
 ret
checkP3a_2:
cjne a, #00100000b, checkP3a_3
 mov R1,#00100000b
 ret
checkP3a_3:
cjne a, #00110000b, checkP3a_4
 mov R1,#01100000b
 ret
checkP3a_4:
rl a
rl a
mov R1, a
 ret

checkP3b_0:
swap a
mov R2, a
ret
		
	
Command_left:

	push dpl
	push dph

	lcall Sorting_like_Isha
;	lcall Sorting_Bits_for_8051
;	mov P2, a
	
	clr	R_W
	clr	D_I
	setb	E1
	clr	E1

	pop dph
	pop dpl
	ret

Command_right:

	push dpl
	push dph
	
	lcall Sorting_like_Isha
;	lcall Sorting_Bits_for_8051
;	mov P2, a
	clr	R_W
	clr	D_I
	setb	E2
	clr	E2

	pop dph
	pop dpl
	ret

Writeleft:
	
	push dpl
	push dph
	
	lcall Sorting_like_Isha
;	lcall Sorting_Bits_for_8051
;   mov P2, a
	clr	R_W
	setb	D_I
	setb	E1
	clr	E1

	pop dph
	pop dpl
	ret

Writeright:

	push dpl
	push dph
	
	lcall Sorting_like_Isha
;	lcall Sorting_Bits_for_8051
;	mov P2, a
	clr	R_W
	setb	D_I
	setb	E2
	clr	E2
	
	pop dph
	pop dpl
	ret

bothSides:
	

	mov  r2,a
	push	ar2
	lcall	Command_left
	pop	ar2
	mov	a,r2
	ljmp	Command_right

	
bothWrite:

	mov  r2,a
	push	ar2
	lcall	Writeleft
	pop	ar2
	mov	a,r2
	ljmp	Writeright
	

