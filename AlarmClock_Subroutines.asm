;;XTAL equ 22222222
;;RELOAD_TIMER1 set 65536-(XTAL/(12*Sound_Freq))
;;Sound_Freq set 1000

;;Option 3 Brute Force X-OR 
Alarm_Compare:
	push psw
	push acc
	push AR0
	push AR1
	push AR2

;Check for Alarm_Status; 0=off, 1=on
	mov c, Alarm_Status
	jnc EndCheck

;	clr c
	MOV R1, Alarm_Digits		;Move into R1 and A the first digit of Hour
	Mov A, R1
	anl A, #0F0H
	mov R1, A
	
	MOV A, Temp_Hours
	;swap A
	anl A, #0F0H
;	MOV R2, A  
Hour1:	xrl A, R1
	jnz	EndCheck
;	clr c
	MOV R1, Alarm_Digits+1		;Move into R1 and A the Second digit of Hour
	Mov A, R1
	anl A, #0F0H
	swap A
	mov R1, A
	
	MOV A, Temp_Hours
	anl A, #0FH
;	MOV R2, A  
Hour0: 	xrl A, R1
	jnz	EndCheck
;	clr c							;Move into R1 and A the first digit of Minutes
	MOV R1, Alarm_Digits+2
	Mov A, R1
	anl A, #0F0H
	mov R1, A
	
	MOV A, Temp_Minutes
	;swap A
	anl A, #0F0H
;	MOV R2, A  
Minute1: 	xrl A, R1
	jnz	EndCheck
;	clr c							;Move into R1 and A the Second digit of Minutes
	MOV R1, Alarm_Digits+3
	Mov A, R1
	anl A, #0F0H
	mov R1, A
		
	MOV A, Temp_Minutes
	anl A, #0FH
	swap A
;	MOV R2, A  
Minute0: 	xrl A, R1
	jnz	EndCheck
	
;	clr c							;Move into R1 and A the Second digit of Seconds
	MOV R1, Sec
	Mov A, R1
	anl A, #0F0H
	mov R1, A
		
	MOV A, #00H

Seconds1: 	xrl A, R1
	jnz	EndCheck
;	clr c							;Move into R1 and A the Second digit of Seconds
	MOV R1, Sec
	Mov A, R1
	anl A, #0FH
	mov R1, A
		
	MOV A, #00H
Seconds0: 	xrl A, R1
	jnz	EndCheck
	
	mov A, #0x01	;State=12; Start Alarm	
	mov Alarm_state, A
	lcall SetAlarm

EndCheck:

	pop AR2
	pop AR1
	pop AR0
	pop acc
	pop psw
ret



SetAlarm:
	mov state, #0x12
EndAlarm:	
ret	

