;-------------------------------------;

		; INITIALIZE LCD
	
;-------------------------------------;

$MOD52

org 0000H
ljmp LCD_Init

DSEG at 30H

	; Values from Real Time Clock
	Sec: ds 1
	Mins: ds 1
	Hours: ds 1
	Date: ds 1
	Month: ds 1
	Year: ds 2

	; Alarm clock vars
	state: ds 1
	state_button: ds 1
	alarm_state: ds 1
	alarm_digits: ds 4

	; Temperature Code
	kelvin_temp: ds 2
	celsius_temp: ds 2
	fahrenheit_temp: ds 2
	humidity_temp: ds 2


	; TimeZone Code
	timezone: ds 1
	Temp_Day:   ds 2
	Temp_Hours: ds 1
	Temp_Minutes: ds 1	
	day_of_week: ds 1
	menudelay: ds 1
	
	
	; Alarm Code
	buttonstate: ds 1

	
	; updated values from radio
	R_Mins: ds 1
	R_Hours: ds 1
	R_Day: ds 2 ; From signal
	R_Year: ds 1
	R_Date: ds 1
	R_month: ds 1
	
	percentage: ds 1
	
	
	; LEDs for seconds display
	DisplayChoice: ds 1
	DisplayChoice1: ds 1
	DisplayChoice2: ds 1
	DisplayState: ds 1
	Choice: ds 1
	Secondsstate: ds 1
	SecondsBin: ds 1
	LEDs: ds 1
	select: ds 1

	; Temporary Values for Calculation
	temp: ds 2
	
	
BSEG
	
	alarm_status: dbit 1
	voice_status: dbit 1
	negative_temp_F: dbit 1
	negative_temp_C: dbit 1
	
	DST: dbit 1
	DST_status: dbit 2
	
	leap_bit: dbit 1


CSEG
	; RTC Signals
	RTC_CLK equ P1.7
	RTC_IO equ P1.3
	RTC_CE equ P1.4
	
	; Signal from Radio
	R_SIG equ P0.0
	MARKER equ #11111110b
	ONE equ #11110000b

	; LCD Signals	
	D_I  EQU P2.3
	R_W  EQU P2.4
	E1   EQU P2.6
	E2   EQU P2.5
	RST  EQU P2.7 

	; Buttons
	BUTTON1 EQU P1.2
	BUTTON2 EQU P0.7
	BUTTON3 EQU P0.5
	BUTTON4 EQU P0.6
	BUTTON5 EQU P1.1

	Date_LUT: 
	dw 0fffH, 101h,	201h,	301h,	401h,	501h,	601h,	701h,	801h,	901h,	1001h,	1101h,	1201h,	1301h,	1401h,	1501h,	1601h,	1701h,	1801h,	1901h,	2001h,	2101h,	2201h,	2301h,	2401h,	2501h,	2601h,	2701h,	2801h,	2901h,	3001h,	3101h,	102h,	202h,	302h,	402h,	502h,	602h,	702h,	802h,	902h,	1002h,	1102h,	1202h,	1302h,	1402h,	1502h,	1602h,	1702h,	1802h,	1902h,	2002h,	2102h,	2202h,	2302h,	2402h,	2502h,	2602h,	2702h,	2802h,	103h,	203h,	303h,	403h,	503h,	603h,	703h,	803h,	903h,	1003h,	1103h,	1203h,	1303h,	1403h,	1503h,	1603h,	1703h,	1803h,	1903h,	2003h,	2103h,	2203h,	2303h,	2403h,	2503h,	2603h,	2703h,	2803h,	2903h,	3003h,	3103h,	104h,	204h,	304h,	404h,	504h,	604h,	704h,	804h,	904h,	1004h,	1104h,	1204h,	1304h,	1404h,	1504h,	1604h,	1704h,	1804h,	1904h,	2004h,	2104h,	2204h,	2304h,	2404h,	2504h,	2604h,	2704h,	2804h,	2904h,	3004h,	105h,	205h,	305h,	405h,	505h,	605h,	705h,	805h,	905h,	1005h,	1105h,	1205h,	1305h,	1405h,	1505h,	1605h,	1705h,	1805h,	1905h,	2005h,	2105h,	2205h,	2305h,	2405h,	2505h,	2605h,	2705h,	2805h,	2905h,	3005h,	3105h,	106h,	206h,	306h,	406h,	506h,	606h,	706h,	806h,	906h,	1006h,	1106h,	1206h,	1306h,	1406h,	1506h,	1606h,	1706h,	1806h,	1906h,	2006h,	2106h,	2206h,	2306h,	2406h,	2506h,	2606h,	2706h,	2806h,	2906h,	3006h,	107h,	207h,	307h,	407h,	507h,	607h,	707h,	807h,	907h,	1007h,	1107h,	1207h,	1307h,	1407h,	1507h,	1607h,	1707h,	1807h,	1907h,	2007h,	2107h,	2207h,	2307h,	2407h,	2507h,	2607h,	2707h,	2807h,	2907h,	3007h,	3107h,	108h,	208h,	308h,	408h,	508h,	608h,	708h,	808h,	908h,	1008h,	1108h,	1208h,	1308h,	1408h,	1508h,	1608h,	1708h,	1808h,	1908h,	2008h,	2108h,	2208h,	2308h,	2408h,	2508h,	2608h,	2708h,	2808h,	2908h,	3008h,	3108h,	109h,	209h,	309h,	409h,	509h,	609h,	709h,	809h,	909h,	1009h,	1109h,	1209h,	1309h,	1409h,	1509h,	1609h,	1709h,	1809h,	1909h,	2009h,	2109h,	2209h,	2309h,	2409h,	2509h,	2609h,	2709h,	2809h,	2909h,	3009h,	110h,	210h,	310h,	410h,	510h,	610h,	710h,	810h,	910h,	1010h,	1110h,	1210h,	1310h,	1410h,	1510h,	1610h,	1710h,	1810h,	1910h,	2010h,	2110h,	2210h,	2310h,	2410h,	2510h,	2610h,	2710h,	2810h,	2910h,	3010h,	3110h,	111h,	211h,	311h,	411h,	511h,	611h,	711h,	811h,	911h,	1011h,	1111h,	1211h,	1311h,	1411h,	1511h,	1611h,	1711h,	1811h,	1911h,	2011h,	2111h,	2211h,	2311h,	2411h,	2511h,	2611h,	2711h,	2811h,	2911h,	3011h,	112h,	212h,	312h,	412h,	512h,	612h,	712h,	812h,	912h,	1012h,	1112h,	1212h,	1312h,	1412h,	1512h,	1612h,	1712h,	1812h,	1912h,	2012h,	2112h,	2212h,	2312h,	2412h,	2512h,	2612h,	2712h,	2812h,	2912h,	3012h,	3112h
	
	LeapDate_LUT:
	dw 0FFFH, 101h,	201h,	301h,	401h,	501h,	601h,	701h,	801h,	901h,	1001h,	1101h,	1201h,	1301h,	1401h,	1501h,	1601h,	1701h,	1801h,	1901h,	2001h,	2101h,	2201h,	2301h,	2401h,	2501h,	2601h,	2701h,	2801h,	2901h,	3001h,	3101h,	102h,	202h,	302h,	402h,	502h,	602h,	702h,	802h,	902h,	1002h,	1102h,	1202h,	1302h,	1402h,	1502h,	1602h,	1702h,	1802h,	1902h,	2002h,	2102h,	2202h,	2302h,	2402h,	2502h,	2602h,	2702h,	2802h,	2902h,	103h,	203h,	303h,	403h,	503h,	603h,	703h,	803h,	903h,	1003h,	1103h,	1203h,	1303h,	1403h,	1503h,	1603h,	1703h,	1803h,	1903h,	2003h,	2103h,	2203h,	2303h,	2403h,	2503h,	2603h,	2703h,	2803h,	2903h,	3003h,	3103h,	104h,	204h,	304h,	404h,	504h,	604h,	704h,	804h,	904h,	1004h,	1104h,	1204h,	1304h,	1404h,	1504h,	1604h,	1704h,	1804h,	1904h,	2004h,	2104h,	2204h,	2304h,	2404h,	2504h,	2604h,	2704h,	2804h,	2904h,	3004h,	105h,	205h,	305h,	405h,	505h,	605h,	705h,	805h,	905h,	1005h,	1105h,	1205h,	1305h,	1405h,	1505h,	1605h,	1705h,	1805h,	1905h,	2005h,	2105h,	2205h,	2305h,	2405h,	2505h,	2605h,	2705h,	2805h,	2905h,	3005h,	3105h,	106h,	206h,	306h,	406h,	506h,	606h,	706h,	806h,	906h,	1006h,	1106h,	1206h,	1306h,	1406h,	1506h,	1606h,	1706h,	1806h,	1906h,	2006h,	2106h,	2206h,	2306h,	2406h,	2506h,	2606h,	2706h,	2806h,	2906h,	3006h,	107h,	207h,	307h,	407h,	507h,	607h,	707h,	807h,	907h,	1007h,	1107h,	1207h,	1307h,	1407h,	1507h,	1607h,	1707h,	1807h,	1907h,	2007h,	2107h,	2207h,	2307h,	2407h,	2507h,	2607h,	2707h,	2807h,	2907h,	3007h,	3107h,	108h,	208h,	308h,	408h,	508h,	608h,	708h,	808h,	908h,	1008h,	1108h,	1208h,	1308h,	1408h,	1508h,	1608h,	1708h,	1808h,	1908h,	2008h,	2108h,	2208h,	2308h,	2408h,	2508h,	2608h,	2708h,	2808h,	2908h,	3008h,	3108h,	109h,	209h,	309h,	409h,	509h,	609h,	709h,	809h,	909h,	1009h,	1109h,	1209h,	1309h,	1409h,	1509h,	1609h,	1709h,	1809h,	1909h,	2009h,	2109h,	2209h,	2309h,	2409h,	2509h,	2609h,	2709h,	2809h,	2909h,	3009h,	110h,	210h,	310h,	410h,	510h,	610h,	710h,	810h,	910h,	1010h,	1110h,	1210h,	1310h,	1410h,	1510h,	1610h,	1710h,	1810h,	1910h,	2010h,	2110h,	2210h,	2310h,	2410h,	2510h,	2610h,	2710h,	2810h,	2910h,	3010h,	3110h,	111h,	211h,	311h,	411h,	511h,	611h,	711h,	811h,	911h,	1011h,	1111h,	1211h,	1311h,	1411h,	1511h,	1611h,	1711h,	1811h,	1911h,	2011h,	2111h,	2211h,	2311h,	2411h,	2511h,	2611h,	2711h,	2811h,	2911h,	3011h,	112h,	212h,	312h,	412h,	512h,	612h,	712h,	812h,	912h,	1012h,	1112h,	1212h,	1312h,	1412h,	1512h,	1612h,	1712h,	1812h,	1912h,	2012h,	2112h,	2212h,	2312h,	2412h,	2512h,	2612h,	2712h,	2812h,	2912h,	3012h,	3112h

	
	; Look-up table for RRC 7Segs
	myLUT_R:
	DB 003H, 09FH, 025H, 00DH, 099H  
	DB 049H, 041H, 01FH, 001H, 009H
	
	SecondLEDs: 
	DB 0FFH, 0FEH, 0FCH, 0F8H, 0F0H, 0E0H, 0C0H, 80H, 00H

	Weekday_month:
	db 0Fh, 00h, 03H, 03h, 06h
	db 01h, 04h, 06h, 02h, 05h
	db 00h, 03h, 05h
	

	; Initialize shift registers
	SPCTL		EQU	0D5h
	SPCFG		EQU	0AAh
	SPDAT		EQU	086h
	SPI_Temp	EQU	08h		

	; Map serial interface ports
	SR_MOSI EQU P1.5
	SR_SCLK EQU P1.7
	SR_MISO EQU P1.6
	SR_CE   EQU P1.4
	
	
	
;--------------------------------------------;

		; BEGINNING OF LCD CODE
		
;--------------------------------------------;

Clear_Screen:
	 mov R0, #0xB8

Choose_Page:
	mov a, R0
	lcall bothSides
	mov R1, #0x00
	lcall bothSides
	mov a, #0x00
	mov R1, #61

Columns: 
	lcall bothWrite
	dec R1
	cjne R1, #0x00, Columns
	inc R0
	cjne R0, #0xBC, Choose_page
	ret
	
fake_ISR:
	push PSW
	push DPH
	push DPL
	push AR1
	push AR0
	push AR2
	push ACC
	lcall UpdateTime
	pop ACC
	pop AR2
	pop AR0
	pop AR1
	pop DPL
	pop DPH
	pop PSW
	ret

LCD_Init:
	mov sp, #7FH

	mov menudelay, #00h
	clr a
	mov P2, #0x00
	mov P3, #0x00
	
	; Initialization Sub routines
	lcall RTC_init
	lcall Read_RTC
	lcall TempandHum
	
	
	mov Year+1, #20H
	
	mov SecondsState, #00H
	mov displaystate, #00H
	mov dptr, #007BH
	mov a, #055H

	mov P2, #0x00 ; P2 = 0
	mov P3, #0x00 ; P3 = 0
	clr RST		  ; RST = 0
	mov dptr, #0x0001
	lcall Delay
	setb RST		; RST = 1
	mov dptr, #0x000A
	lcall Delay
	
	clr D_I ; D_I = 0
	setb E1 ; E1 = 1
	setb E2 ; E2 = 1
	setb R_W ; R_W = 1	

	mov	a,#0xE2
	lcall	bothSides
	mov	dptr,#0x000A
	lcall	Delay
	mov	a,#0xA4
	lcall	bothSides
	mov	a,#0xA9
	lcall	bothSides
	mov	a,#0xA0
	lcall	bothSides
	mov	a,#0xEE
	lcall	bothSides
	mov	a,#0xC0
	lcall	bothSides
	mov	a,#0xAF
	lcall	bothSides
	
	lcall Clear_Screen
	
	lcall Read_RTC
	lcall timezone_calculation
	mov dptr, #main_menu
	
	
	lcall Print_menu
	mov day_of_week, #0x00 ; Sunday is default
	mov state, #0x01
	mov timezone, #0x00 ; Default Timezone
	mov Alarm_Digits, #0x00
	mov Alarm_Digits+1, #0x00
	mov Alarm_Digits+2, #0x00
	mov Alarm_Digits+3, #0x00
	
	clr negative_Temp_C
	clr negative_Temp_F
	clr	alarm_status
	mov R_Day, #47
	
	setb voice_status

	lcall Forever

;--------------------------------------------;

	; PRINT MENUS (WHOLE SCREEN, ANY MENU)
	
;--------------------------------------------;

Print_Menu:
	clr c
	mov a, #00H
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov R1, #0xB8
	mov R0, #0x00

Loop_pages:
	
	mov a, R1			; chooses the page X
	lcall bothSides		; command to select page

Column_left:
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #0x3D, Column_left
	mov R0, #00h
	
Column_right:	
	clr a
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #0x3D, Column_right
	inc R1
	mov a, #00H
	mov R0, a
	cjne R1, #0xBC, Loop_pages 	
	ret

;-----------------------------------------;

	; HOME MENU
		
;-----------------------------------------;

	; Printing Humidity

clearXandY:
	push ACC
	push PSW
	clr A
	mov x, A
	mov x+1, A
	mov x+2, A
	mov x+3, A
	mov y, A
	mov y+1, A
	mov y+2, A
	mov y+3, A
	mov bcd, A
	mov bcd+1, A
	mov bcd+2, A
	mov bcd+3, A
	pop PSW
	pop ACC
	ret	
	
	
Get_Humid_Digit1:

	mov b, #4
	mov a, humidity_temp + 1
	anl a, #11110000b
	swap a
	mul ab	
	mov R0, a
	ret
	
Get_Humid_Digit2:
	
	mov b, #4
	clr a
	mov a, humidity_temp + 1
	anl a, #00001111b
	mul ab
	mov R0, a
	ret
	
Get_Humid_Digit3:

	clr a
	mov b, #4
	mov a, humidity_temp
	anl a, #11110000b
	swap a
	mul ab
	mov R0, a
	ret
	
Get_Humid_Digit4:

	clr a
	mov b, #4
	mov a, humidity_temp
	anl a, #00001111b
	mul ab
	mov R0, a
	ret	
		
Print_Humidity_Home:
	
	lcall Get_Humid_Digit1
	
	mov dptr, #numbers_home_humid
	mov a, R0	;index of digit 1			
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov a, #0xBA
	lcall bothSides
	mov R0, #9
	lcall fake_ISR

Humid_Digit_1:

	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #13, Humid_Digit_1
	
	lcall Get_Humid_Digit2
	lcall fake_ISR
	mov dptr, #numbers_home_humid
	mov a, R0						;index of digit 2
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R0, #14

Humid_Digit_2:

	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #18, Humid_Digit_2
	
	lcall Get_Humid_Digit3
	
	mov dptr, #numbers_home_humid
	mov a, R0						;index of digit 3
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R0, #19
	lcall fake_ISR

Humid_Digit_3:	
	
	mov a, R0
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #23, Humid_Digit_3
	
	lcall Get_Humid_Digit4
	push AR0
	lcall UpdateTime
	pop AR0
	mov dptr, #numbers_home_humid
	mov a, R0						;index of digit 4
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R0, #26

Humid_Digit_4:	
	
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #30, Humid_Digit_4
	lcall fake_ISR
	ret


	; TEMPERATURE (HOME MENU)


Get_Celsius_Home_Digit1:

	mov b, #10
	mov a, celsius_temp + 1
	anl a, #00001111b
	mul ab	
	mov R0, a
	ret
	
Get_Celsius_Home_Digit2:
	
	mov b, #10
	clr a
	mov a, celsius_temp
	anl a, #11110000b
	swap a
	mul ab
	mov R0, a
	ret
	
Get_Celsius_Home_Digit3:

	clr a
	mov b, #10
	mov a, celsius_temp
	anl a, #00001111b
	mul ab
	mov R0, a
	ret
	

Print_Temperature_Home:

	lcall Get_Celsius_Home_Digit1
	mov dptr, #numbers_home_temp
	mov a, R0						;index of digit 1
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB8
	mov R0, #12
	lcall fake_ISR

Digit_1:
	
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #17, Digit_1
	inc R1
	mov R0, #12
	cjne R1, #0xBA, Digit_1

	lcall Get_Celsius_Home_Digit2
	mov dptr, #numbers_home_temp
	mov a, R0						;index of digit 2
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov R1, #0xB8
	mov R0, #18
	lcall fake_ISR

Digit_2:

	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #23, Digit_2
	inc R1
	mov R0, #18
	cjne R1, #0xBA, Digit_2

	lcall Get_Celsius_Home_Digit3
	mov dptr, #numbers_home_temp
	mov a, R0					;index of digit 3
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov R1, #0xB8
	mov R0, #26

Digit_3:	
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #31, Digit_3
	inc R1
	mov R0, #26
	cjne R1, #0xBA, Digit_3

	ret

		
			
	; Day of the WEEK
		

Print_DayofWeek_Home:
	
	lcall Get_Current_DayofWeek
	mov a, #0x00	; Index of the day of week
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB8
	mov R0, #45
	
	
Week_Day_Word_left:
		
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #61, Week_Day_Word_left
	mov R0, #00
	lcall fake_ISR

Week_Day_Word_right:
		
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #31, Week_Day_Word_right
	inc R1
	mov R0, #45
	cjne R1, #0xBA, Week_Day_Word_left
	

	ret

Get_Current_DayofWeek:
	
	mov a, day_of_week
	
	Sun:
	cjne a, #0x00, Mon
	mov dptr, #saturday
	ret
	
	Mon:
	cjne a, #0x01, Tue
	mov dptr, #sunday
	ret
	
	Tue:
	cjne a, #0x02, Wed
	mov dptr, #monday
	ret
	
	Wed:
	cjne a, #0x03, Thu
	mov dptr, #tuesday
	ret
	
	Thu:
	cjne a, #0x04, Fri
	mov dptr, #wednesday
	ret
	
	Fri:
	cjne a, #0x05, Sat
	mov dptr, #thursday
	ret
	
	Sat:
	cjne a, #0x06, Sun
	mov dptr, #friday
	ret
	
	None:
	ret	
		

	; WIDGETS (HOME MENU)
	

Print_Widgets_Home:

	lcall Get_Alarm_Widget
	mov dptr, #alrm_widget
	mov a, R0					; Index of widget of Alarm
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov a, #0xB8
	lcall bothSides
	mov R0, #48

Alrm_Widget_:
	
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #59, Alrm_Widget_
	lcall fake_ISR
	lcall Get_Voice_Widget
	mov dptr, #voice_widget
	mov a, R0					; Index of widget of Voice
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov a, #0xB9
	lcall bothSides
	mov R0, #48

Voice_Widget_:

	mov a, R0
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #59, Voice_Widget_

	lcall Get_UTC_Widget
	mov dptr, #utc_widget		; Index of widget of UTC
	mov a, R0
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov a, #0xBA
	lcall bothSides
	mov R0, #48
	lcall fake_ISR

UTC_Widget_:	
	
	mov a, R0
	lcall bothSides
	
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #59, UTC_Widget_

	ret

Get_UTC_Widget:
	
	mov b, #0x0B
	mov a, timezone
	mul ab
	mov R0, a
	
	ret
	
Get_Alarm_Widget:
	
	jnb alarm_status, print_off
	mov R0, #0x0B
	ret
	
print_off: 
	mov R0, #0x00
	ret

Get_Voice_Widget:
	
	jnb voice_status, print_voice_off
	mov R0, #0x0B
	ret
	
print_voice_off: 
	mov R0, #0x00
	ret
	
	ret		

;------------------------------------------;

		; TEMPERATURE MENU
		
;------------------------------------------;

Get_Kelvin_Digit1:

	mov b, #10
	mov a, kelvin_temp + 1
	anl a, #11110000b
	swap a
	mul ab	
	mov R0, a

	ret
	
Get_Kelvin_Digit2:
	
	mov b, #10
	clr a
	mov a, kelvin_temp + 1
	anl a, #00001111b
	mul ab
	mov R0, a
	lcall fake_ISR
	ret
	
Get_Kelvin_Digit3:

	clr a
	mov b, #10
	mov a, kelvin_temp
	anl a, #11110000b
	swap a
	mul ab
	mov R0, a

	ret
	
Get_Kelvin_Digit4:

	clr a
	mov b, #10
	mov a, kelvin_temp
	anl a, #00001111b
	mul ab
	mov R0, a
	
	ret	

Kelvin:

	lcall Get_Kelvin_Digit1
	mov dptr, #numbers_temp_menu
	mov a, R0			; Index of digit 1 (kelvin)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #08
	lcall fake_ISR

Kelvin_Digit_1:
		
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #13, Kelvin_Digit_1
	inc R1
	mov R0, #08
	cjne R1, #0xBB, Kelvin_Digit_1
	
	lcall Get_Kelvin_Digit2
	mov dptr, #numbers_temp_menu
	mov a, R0			; Index of digit 2 (kelvin)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #14
	lcall fake_ISR

Kelvin_Digit_2:

	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #19, Kelvin_Digit_2
	inc R1
	mov R0, #14
	cjne R1, #0xBB, Kelvin_Digit_2
	
	lcall Get_Kelvin_Digit3
	mov dptr, #numbers_temp_menu
	mov a, R0			; Index of digit 3 (kelvin)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #20
	lcall fake_ISR

Kelvin_Digit_3:	
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #25, Kelvin_Digit_3
	inc R1
	mov R0, #20
	cjne R1, #0xBB, Kelvin_Digit_3

	lcall Get_Kelvin_Digit4
	mov dptr, #numbers_temp_menu
	mov a, R0			; Index of digit 4 (kelvin)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #28
	lcall fake_ISR

Kelvin_Digit_4:	
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #33, Kelvin_Digit_4
	inc R1
	mov R0, #28
	cjne R1, #0xBB, Kelvin_Digit_4

	ret

Get_Celsius_Digit1:

	mov b, #10
	mov a, celsius_temp + 1
	anl a, #00001111b
	mul ab	
	mov R0, a
	ret
	
Get_Celsius_Digit2:
	
	mov b, #10
	clr a
	mov a, celsius_temp
	anl a, #11110000b
	swap a
	mul ab
	mov R0, a
	ret
	
Get_Celsius_Digit3:

	clr a
	mov b, #10
	mov a, celsius_temp
	anl a, #00001111b
	mul ab
	mov R0, a
	ret
	
Celsius:

	lcall Get_Celsius_Digit1
	mov dptr, #numbers_temp_menu
	mov a, R0		; Index of digit 1 (celsius)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #48

	lcall fake_ISR

Celsius_Digit_1:
	
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #53, Celsius_Digit_1
	inc R1
	mov R0, #48
	cjne R1, #0xBB, Celsius_Digit_1

	lcall Get_Celsius_Digit2
	mov dptr, #numbers_temp_menu
	mov a, R0		; Index of digit 2 (celsius)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #55
	lcall fake_ISR

Celsius_Digit_2:

	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #60, Celsius_Digit_2
	inc R1
	mov R0, #55
	cjne R1, #0xBB, Celsius_Digit_2
	
	lcall Get_Celsius_Digit3
	mov dptr, #numbers_temp_menu
	mov a, R0			; Index of digit 3 (celsius)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #02
	lcall fake_ISR

Celsius_Digit_3:	
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #07, Celsius_Digit_3
	inc R1
	mov R0, #02
	cjne R1, #0xBB, Celsius_Digit_3

	ret

Get_Fahrenheit_Digit1:

	mov b, #10
	mov a, fahrenheit_temp + 1
	anl a, #11110000b
	swap a
	mul ab	
	mov R0, a
	ret
	
Get_Fahrenheit_Digit2:
	
	mov b, #10
	clr a
	mov a, fahrenheit_temp + 1
	anl a, #00001111b
	mul ab
	mov R0, a
	ret
	
Get_Fahrenheit_Digit3:

	clr a
	mov b, #10
	mov a, fahrenheit_temp
	anl a, #11110000b
	swap a
	mul ab
	mov R0, a
	ret
	
Get_Fahrenheit_Digit4:

	clr a
	mov b, #10
	mov a, fahrenheit_temp
	anl a, #00001111b
	mul ab
	mov R0, a
	ret	

Fahrenheit:

	lcall Get_Fahrenheit_Digit1
	mov dptr, #numbers_temp_menu
	mov a, R0		; Index of digit 1 (Fahrenheit)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #23
	lcall fake_ISR

Fahrenheit_Digit_1:
	
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #28, Fahrenheit_Digit_1
	inc R1
	mov R0, #23
	cjne R1, #0xBB, Fahrenheit_Digit_1

	lcall Get_Fahrenheit_Digit2
	mov dptr, #numbers_temp_menu
	mov a, R0		; Index of digit 2 (Fahrenheit)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #29
	lcall fake_ISR

Fahrenheit_Digit_2:

	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #34, Fahrenheit_Digit_2
	inc R1
	mov R0, #29
	cjne R1, #0xBB, Fahrenheit_Digit_2
	
	lcall Get_Fahrenheit_Digit3
	mov dptr, #numbers_temp_menu
	mov a, R0		; Index of digit 3 (Fahrenheit)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #35
	lcall fake_ISR

Fahrenheit_Digit_3:	
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #40, Fahrenheit_Digit_3
	inc R1
	mov R0, #35
	cjne R1, #0xBB, Fahrenheit_Digit_3

	lcall Get_Fahrenheit_Digit4
	mov dptr, #numbers_temp_menu
	mov a, R0			; Index of digit 4 (Fahrenheit)
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB9
	mov R0, #43
	lcall fake_ISR

Fahrenheit_Digit_4:	
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #48, Fahrenheit_Digit_4
	inc R1
	mov R0, #43
	cjne R1, #0xBB, Fahrenheit_Digit_4

	ret	

;-----------------------------------------;

		; UTC MENU
		
;-----------------------------------------;

Get_Current_UTC:
	
	mov a, timezone
	
	PST:
	cjne a, #0x00, MST
	mov dptr, #utc_menu_pst
	lcall Print_Menu
	ret
	
	MST:
	cjne a, #0x01, CST
	mov dptr, #utc_menu_mst
	lcall Print_Menu
	ret
	
	CST:
	cjne a, #0x02, EST
	mov dptr, #utc_menu_cst
	lcall Print_Menu
	ret
	
	EST:
	cjne a, #0x03, AST
	mov dptr, #utc_menu_est
	lcall Print_Menu
	ret
	
	AST:
	cjne a, #0x04, NST
	mov dptr, #utc_menu_ast
	lcall Print_Menu
	ret
	
	NST:
	cjne a, #0x05, None_
	mov dptr, #utc_menu_nst
	lcall Print_Menu
	ret
	
	None_:
	ret

;------------------------------------------;

		; ALARM MENU
		
;------------------------------------------;
	
Check_Status:
	jnb alarm_status, Status_Off
	mov dptr, #alarm_on
	lcall Print_Status
	ret	
Status_Off:
	mov dptr, #alarm_off
	lcall Print_Status
	ret

Print_Status:

	mov a, #00H
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	
	mov a, #0xBB
	lcall bothSides
	mov R0, #48
	

Status_Left_Side:
	
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #61, Status_Left_Side
	mov R0, #00	
	
Status_Right_Side:
	
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #4, Status_Right_Side

	ret
	
Get_Digit1:

	mov b, #16
	mov a, alarm_digits
	anl a, #11110000b
	swap a
	mul ab	
	mov R4, a
	ret
	
Get_Digit2:
	
	mov b, #16
	clr a
	mov a, alarm_digits + 1
	anl a, #11110000b
	swap a
	mul ab
	mov R5, a
	ret
	
Get_Digit3:

	clr a
	mov b, #16
	mov a, alarm_digits + 2
	anl a, #11110000b
	swap a
	mul ab
	mov R6, a
	ret
	
Get_Digit4:

	clr a
	mov b, #16
	mov a, alarm_digits + 3
	anl a, #11110000b
	swap a
	mul ab
	mov R7, a
	ret	

Get_Current_Alarm:

	lcall Get_Digit1
	lcall Get_Digit2
	lcall Get_Digit3
	lcall Get_Digit4
	
	mov dptr, #alarm_numbers
	mov a, R4
	mov R0, #40
	lcall Print_Left
	
	mov dptr, #alarm_numbers
	mov a, R5
	mov R0, #49
	lcall Print_Left
	
	mov dptr, #alarm_numbers
	mov a, R6
	mov R0, #0
	lcall Print_Right
	
	mov dptr, #alarm_numbers
	mov a, R7
	mov R0, #9
	lcall Print_Right
	
ret

ChangeStatus:

	cpl alarm_status
	lcall Check_Status
	ret

Save_Alarm:

	mov dptr, #alarm_menu
	lcall Print_Menu
	setb alarm_status
	lcall Check_Status	
	lcall Get_Current_Alarm
	ret

SaveDigit1:
	clr c
	mov a, R4
	rrc a
	rrc a
	rrc a
	rrc a	
	swap a
	anl a, #11110000B
	mov alarm_digits, a
	ret

SaveDigit2:

	clr c
	mov a, R5
	rrc a
	rrc a
	rrc a
	rrc a	
	swap a
	anl a, #11110000B
	mov alarm_digits + 1, a
	ret
	
SaveDigit3:

	clr c
	mov a, R6
	rrc a
	rrc a
	rrc a
	rrc a	
	swap a
	anl a, #11110000B
	mov alarm_digits + 2, a
	ret

SaveDigit4:
	clr c
	mov a, R7
	rrc a
	rrc a
	rrc a
	rrc a	
	swap a
	anl a, #11110000B
	mov alarm_digits + 3, a
	ret

Inc_Number1: 

	lcall Get_Digit1
	
	mov a, R4
	cjne a, #0x20, if_not_equal_to_2a	
	mov a, #0x00
	mov R4, a
	lcall SaveDigit1
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #40
	lcall Print_Left
	
	ret
	
if_not_equal_to_2a:
	
	lcall Get_Digit1
	lcall Get_Digit2
	
	mov a, R4
	cjne a, #0x10, if_not_equal_to_1a
	mov a, #0x00
	mov R5, a
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	mov a, R4
	add a, #16
	mov R4, a
	lcall SaveDigit1
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #40
	lcall Print_Left
	
	ret
	
if_not_equal_to_1a:
	lcall Get_Digit1
	mov a, R4
	add a, #16
	mov R4, a
	lcall SaveDigit1
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #40
	lcall Print_Left
	
	ret
	
Dec_Number1:
	
	lcall Get_Digit1
	lcall Get_Digit2
	
	mov a, R4
	cjne a, #0x00, if_not_equal_to_0b
	mov a, R5
	mov a, #0x00
	mov R5, a
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	mov a, #0x20
	mov R4, a
	lcall SaveDigit1
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #40
	lcall Print_Left
	
	ret
	
	if_not_equal_to_0b:
	
	lcall Get_Digit1
	mov a, R4
	subb a, #16
	mov R4, a
	lcall SaveDigit1
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #40
	lcall Print_Left

	ret	
	
Inc_Number2: 

	lcall Get_Digit2
	lcall Get_Digit1
	
	mov a, R4
	cjne a, #0x20, no_restraina
	mov a, R5
	cjne a, #0x30, ResetDigit2a	
	mov a, #0x00
	mov R5, a	
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	
	ret
	
	ResetDigit2a: 
	add a, #16
	mov R5, a	
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left

	ret	
	
no_restraina:		
	mov a, R5
	cjne a, #0x90, ResetDigit2b	
	mov a, #0x00
	mov R5, a	
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	
	ret
	
	ResetDigit2b: 
	add a, #16
	mov R5, a	
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	
	ret

Dec_Number2:
	
	lcall Get_Digit2
	lcall Get_Digit1
	
	mov a, R4
	cjne a, #0x20, no_restrainb
	mov a, R5
	cjne a, #0x00, ResetDigit2c	
	mov a, #0x30
	mov R5, a	
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	
	ret
	
	ResetDigit2c: 
	subb a, #16
	mov R5, a	
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left

	ret

no_restrainb:	
	mov a, R5
	cjne a, #0x00, ResetDigit2d
	mov a, #0x90
	mov R5, a
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left
	
	ret
	
	ResetDigit2d: 
	subb a, #16
	mov R5, a
	lcall SaveDigit2
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #49
	lcall Print_Left

	ret

Inc_Number3: 

	lcall Get_Digit3
	
	mov a, R6
	cjne a, #0x50, ResetDigit3a	
	mov a, #0x00
	mov R6, a
	lcall SaveDigit3
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #0
	lcall Print_Right
	
	ret
	
	ResetDigit3a: 
	add a, #16
	mov R6, a
	lcall SaveDigit3
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #0
	lcall Print_Right
	
	ret	
	
Dec_Number3:
	
	lcall Get_Digit3
	
	mov a, R6
	cjne a, #0x00, ResetDigit3b
	mov a, #0x50
	mov R6, a
	lcall SaveDigit3
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #0
	lcall Print_Right
	
	ret
	
	ResetDigit3b: 
	subb a, #16
	mov R6, a
	lcall SaveDigit3
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #0
	lcall Print_Right

	ret

Inc_Number4: 

	lcall Get_Digit4
	
	mov a, R7
	cjne a, #0x90, ResetDigit4a	
	mov a, #0x00
	mov R7, a
	lcall SaveDigit4
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #9
	lcall Print_Right
	
	ret
	
	ResetDigit4a: 
	add a, #16
	mov R7, a
	lcall SaveDigit4
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #9
	lcall Print_Right
	
	ret	
	
Dec_Number4:
	
	lcall Get_Digit4
	
	mov a, R7
	cjne a, #0x00, ResetDigit4b
	mov a, #0x90
	mov R7, a
	lcall SaveDigit4
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #9
	lcall Print_Right
	
	ret
	
	ResetDigit4b: 
	subb a, #16
	mov R7, a
	lcall SaveDigit4
	lcall Delay2
	mov dptr, #alarm_numbers
	mov R0, #9
	lcall Print_Right

	ret	

Delay2:
	mov R2, #250
delay2_l1:	
	djnz R2, delay2_l1
 
    ret

Print_Left:
	
	push aR6
	push aR7
	
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	
	mov a, R0
	mov R6, a ; column is R6
	mov R7, #00 ; size is R7
	mov R1, #0xB8

Print_Left_Digit:
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	inc R7
	mov a, R7
	cjne a, #8, Print_Left_Digit
	mov a, R6
	mov R0, a
	mov R7, #00
	inc R1
	cjne R1, #0xBA, Print_Left_Digit
	
	pop aR7
	pop aR6
	
	ret
	
Print_Right:
	
	push aR6
	push aR7	
	
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a
	mov a, R0
	mov R6, a ; column is R6
	mov R7, #00 ; size is R7
	mov R1, #0xB8

Print_Right_Digit:
	
	mov a, R1
	lcall bothSides
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	inc R7
	mov a, R7
	cjne a, #8, Print_Right_Digit
	mov a, R6
	mov R0, a
	mov R7, #00
	inc R1
	cjne R1, #0xBA, Print_Right_Digit

	pop aR7
	pop aR6

	ret
	
;---------------------------------------;

			; VOICE MENU
			
;---------------------------------------;

Check_Voice_Status:

	jnb voice_status, nothing_recorded
	mov dptr, #rec_available
	lcall Print_Voice
	ret
	
nothing_recorded:
	mov dptr, #empty
	lcall Print_Voice
	ret	

Print_Voice:
	
	mov a, #00h	; Index of the voice word
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xB8
	mov R0, #24
	
	
Voice_Word_left:
		
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #61, Voice_Word_left
	mov R0, #00
	
Voice_Word_right:
		
	mov a, R0
	lcall bothSides
	mov a, R1
	lcall bothSides	
	clr a
	movc a, @a+dptr
	lcall Writeright
	inc dptr
	inc R0
	cjne R0, #32, Voice_Word_right
	inc R1
	mov R0, #24
	cjne R1, #0xBA, Voice_Word_left

	ret


Print_Percentage:

	lcall Get_Percentage
	
	mov a, #00h	; Index of the percentage number
	add a, dpl
	mov dpl, a
	mov a, dph
	addc a, #00h
	mov dph, a	
	mov R1, #0xBA
	lcall bothSides	
	mov R0, #24
	
Percentage_Number:
		
	mov a, R0
	lcall bothSides
	clr a
	movc a, @a+dptr
	lcall Writeleft
	inc dptr
	inc R0
	cjne R0, #49, Percentage_Number

	ret


Get_Percentage:

	mov a, percentage
	
	ten_percent_:
	cjne a, #0x00, thirty_percent_
	mov dptr, #ten_percent
	ret
	
	thirty_percent_:
	cjne a, #0x01, fourty_percent_
	mov dptr, #thirty_percent
	ret
	
	fourty_percent_:
	cjne a, #0x02, seventy_percent_
	mov dptr, #fourty_percent
	ret
	
	seventy_percent_:
	cjne a, #0x03, eighty_percent_
	mov dptr, #seventy_percent
	ret
	
	eighty_percent_:
	cjne a, #0x04, ninenine_percent_
	mov dptr, #eighty_percent
	ret
	
	ninenine_percent_:
	cjne a, #0x05, None__
	mov dptr, #ninenine_percent
	ret
	
	None__:
	ret	
	

;--------------------------------------------;

			; FOREVER LOOP
			
;--------------------------------------------;
	
Forever:

	lcall fake_isr	

	mov a, alarm_state

	cjne a, #0x01, not_alarm_on

	mov dptr, #alarm_question
	lcall Print_Menu
	lcall fake_ISR
		
	not_alarm_on:

	mov a, state

	cjne a, #0x02, not_state2


	mov a, menudelay
	cjne a, #00, dont_update
	mov menudelay, #8

	lcall TempandHum
	lcall Print_Temperature_Home
	lcall UpdateTime
	lcall Print_DayofWeek_Home
	lcall UpdateTime
	lcall Print_Widgets_Home
	lcall UpdateTime
	lcall Print_Humidity_Home

dont_update:
	mov a, menudelay
	inc a
	mov menudelay, a

not_state2:

	cjne a, #0x03, not_state3

	lcall TempandHum
	lcall Kelvin
	lcall fake_isr
	lcall Celsius
	lcall Fahrenheit

not_state3:	

	mov a, state



buttoms:
	lcall fake_isr
	clr c

	jnb BUTTON1, HUB_state1
	jnb BUTTON2, HUB_state2
	jnb BUTTON3, HUB_state3
	jnb BUTTON4, HUB_state4
	jnb BUTTON5, HUB_state5

	mov a, state

ljmp Forever
	






HUB_state1: jb BUTTON1, cstate_1
			lcall fake_isr
			sjmp HUB_state1

HUB_state2: jb BUTTON2, cstate_2
			jnb BUTTON3, cstate_6
			lcall fake_isr
			sjmp HUB_state2

HUB_state3: jb BUTTON3, cstate_3
			lcall fake_isr
			sjmp HUB_state3

HUB_state4: jb BUTTON4, cstate_4
			lcall fake_isr
			sjmp HUB_state4

HUB_state5: jb BUTTON5, cstate_5
			lcall fake_isr
			sjmp HUB_state5

cstate_1: 
	lcall fake_ISR
	ljmp check_state_1
cstate_2: 
	lcall fake_ISR
	ljmp check_state_2
cstate_3: 
	lcall fake_ISR
	ljmp check_state_3
cstate_4: 
	lcall fake_ISR
	ljmp check_state_4
cstate_5: 
	lcall fake_ISR
	ljmp check_state_5
cstate_6: 
	mov state, #0x13
	ljmp check_state_3

check_state_1:

	mov dptr, #jmp_a
	mov a, state
	mov b, #0x03
	mul ab
	jmp @a+dptr
	

jmp_a:
	
	ljmp state_0a
	ljmp state_1a
	ljmp state_2a
	ljmp state_3a
	ljmp state_4a
	ljmp state_5a
	ljmp state_6a
	ljmp state_7a
	ljmp state_8a
	ljmp state_9a
	ljmp state_10a
	ljmp state_11a
	ljmp state_12a
	ljmp state_13a
	ljmp state_14a
	ljmp state_15a
	ljmp state_16a
	ljmp state_17a
	ljmp state_18a

state_0a:

	ljmp buttoms

state_1a:
	
	mov state, #0x02
	mov dptr, #home_menu
	lcall Print_Menu

	lcall tempandhum
	lcall fake_isr
	lcall Print_Temperature_Home
	lcall fake_isr
	lcall Print_DayofWeek_Home
	lcall fake_isr
	lcall Print_Widgets_Home
	lcall fake_isr
	lcall Print_Humidity_Home
	lcall fake_ISR
	ljmp buttoms

state_2a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_3a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_4a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_5a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_6a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_7a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_8a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_9a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_10a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_11a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_12a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_13a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_14a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_15a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_16a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_17a:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	
	ljmp buttoms

state_18a:

	ljmp buttoms
	

check_state_2:

	mov dptr, #jmp_b
	mov a, state
	mov b, #0x03
	mul ab
	jmp @a+dptr

jmp_b:

	ljmp state_0b
	ljmp state_1b
	ljmp state_2b
	ljmp state_3b
	ljmp state_4b
	ljmp state_5b
	ljmp state_6b
	ljmp state_7b
	ljmp state_8b
	ljmp state_9b
	ljmp state_10b
	ljmp state_11b
	ljmp state_12b
	ljmp state_13b
	ljmp state_14b
	ljmp state_15b
	ljmp state_16b
	ljmp state_17b
	ljmp state_18b

state_0b:

	ljmp buttoms

state_1b:

	mov state, #0x03
	mov dptr, #temperature_menu
	lcall Print_Menu
	lcall Kelvin
	lcall Celsius
	lcall Fahrenheit

	ljmp buttoms

state_2b:

	ljmp buttoms
	
state_3b:

	ljmp buttoms
	
state_4b:
	
	mov state, #0x05
	mov dptr, #utc_set0
	lcall Print_Menu
	
	ljmp buttoms

state_5b:

	ljmp buttoms

state_6b:

	ljmp buttoms

state_7b:

	ljmp buttoms

state_8b:

	ljmp buttoms

state_9b:

	ljmp buttoms

state_10b:

	ljmp buttoms

state_11b:

	ljmp buttoms

state_12b:

	mov state, #0x0D
	mov dptr, #alarm_menu_edit_set
	lcall Print_Menu
	lcall Get_Current_Alarm
	
	ljmp buttoms

state_13b:

	mov state, #0x0E
	
	ljmp buttoms

state_14b:
	
	mov state, #0x0F
	
	ljmp buttoms
	
state_15b:

	mov state, #0x10
	
	ljmp buttoms
	
state_16b:
	
	mov state, #0x0D
	
	ljmp buttoms
	
state_17b:


	ljmp buttoms

state_18b:

	ljmp buttoms
	
	
check_state_3:

	mov dptr, #jmp_c
	mov a, state
	mov b, #0x03
	mul ab
	jmp @a+dptr

jmp_c:

	ljmp state_0c
	ljmp state_1c
	ljmp state_2c
	ljmp state_3c
	ljmp state_4c
	ljmp state_5c
	ljmp state_6c
	ljmp state_7c
	ljmp state_8c
	ljmp state_9c
	ljmp state_10c
	ljmp state_11c
	ljmp state_12c
	ljmp state_13c
	ljmp state_14c
	ljmp state_15c
	ljmp state_16c
	ljmp state_17c
	ljmp state_18c
	ljmp state_19c

state_0c:

	ljmp buttoms

state_1c:
	
	
	mov state, #0x04
	lcall Get_Current_UTC
	
	ljmp buttoms

state_2c:

	ljmp buttoms

state_3c:

	ljmp buttoms

state_4c:

	ljmp buttoms

state_5c:

	ljmp buttoms

state_6c:

	mov timezone, #0x00
	lcall timezone_calculation
	mov dptr, #utc_menu_pst
	lcall Print_Menu	
	mov state, #0x04
	
	ljmp buttoms

state_7c:

	mov timezone, #0x01
	lcall timezone_calculation
	mov dptr, #utc_menu_mst
	lcall Print_Menu	
	mov state, #0x04
	
	ljmp buttoms

state_8c:

	mov timezone, #0x02
	lcall timezone_calculation
	mov dptr, #utc_menu_cst
	lcall Print_Menu	
	mov state, #0x04
	
	ljmp buttoms
	
state_9c:

	mov timezone, #0x03
	lcall timezone_calculation
	mov dptr, #utc_menu_est
	lcall Print_Menu	
	mov state, #0x04
	
	ljmp buttoms
	
state_10c:

	mov timezone, #0x04
	lcall timezone_calculation
	mov dptr, #utc_menu_ast
	lcall Print_Menu	
	mov state, #0x04
	
	ljmp buttoms
	
state_11c:
	
	mov timezone, #0x05
	lcall timezone_calculation
	mov dptr, #utc_menu_nst
	lcall Print_Menu	
	mov state, #0x04
	
	ljmp buttoms
	
state_12c:

	mov state, #0x0C
	lcall ChangeStatus
	
	ljmp buttoms
	
state_13c:

	lcall Save_Alarm
	mov state, #0x0C
	
	ljmp buttoms
	
state_14c:

	lcall Save_Alarm
	mov state, #0x0C
	
	ljmp buttoms
	
state_15c:

	lcall Save_Alarm
	mov state, #0x0C
	
	ljmp buttoms
	
state_16c:

	lcall Save_Alarm
	mov state, #0x0C
	
	ljmp buttoms

state_17c:


	ljmp buttoms
	
state_18c:

	ljmp buttoms
	
state_19c:

	mov dptr, #now_loading
	lcall Print_Menu
	
	lcall Update_data
	mov dptr, #main_Menu
	lcall Print_Menu
	
	mov state, #0x01
	ljmp buttoms
	
check_state_4:

	mov dptr, #jmp_d
	mov a, state
	mov b, #0x03
	mul ab
	jmp @a+dptr

jmp_d:

	ljmp state_0d
	ljmp state_1d
	ljmp state_2d
	ljmp state_3d
	ljmp state_4d
	ljmp state_5d
	ljmp state_6d
	ljmp state_7d
	ljmp state_8d
	ljmp state_9d
	ljmp state_10d
	ljmp state_11d
	ljmp state_12d
	ljmp state_13d
	ljmp state_14d
	ljmp state_15d
	ljmp state_16d	
	ljmp state_17d
	ljmp state_18d

state_0d:

	ljmp buttoms

state_1d:

	mov state, #0x11
	mov dptr, #access_denied
	lcall Print_Menu
;	lcall Check_Voice_Status
	
	ljmp buttoms

state_2d:

	ljmp buttoms

state_3d:

	ljmp buttoms
	
state_4d:
	
	ljmp buttoms
	
state_5d:

	mov state, #0x06
	mov dptr, #utc_set1
	lcall Print_Menu

	ljmp buttoms
	
state_6d:

	mov state, #0x07
	mov dptr, #utc_set2
	lcall Print_Menu

	ljmp buttoms
	
state_7d:

	mov state, #0x08
	mov dptr, #utc_set3
	lcall Print_Menu

	ljmp buttoms

state_8d:

	mov state, #0x09
	mov dptr, #utc_set4
	lcall Print_Menu

	ljmp buttoms

state_9d:

	mov state, #0x0A
	mov dptr, #utc_set5
	lcall Print_Menu

	ljmp buttoms

state_10d:

	mov state, #0x0B
	mov dptr, #utc_set6
	lcall Print_Menu

	ljmp buttoms

state_11d:

	mov state, #0x06
	mov dptr, #utc_set1
	lcall Print_Menu

	ljmp buttoms
	
state_12d:

	ljmp buttoms
	
state_13d:
	
	mov state, #0x0D
	lcall Inc_Number1
	
	ljmp buttoms
	
state_14d:

	mov state, #0x0E
	lcall Inc_Number2
	
	ljmp buttoms

state_15d:

	mov state, #0x0F
	lcall Inc_Number3
	
	ljmp buttoms

state_16d:

	mov state, #0x10
	lcall Inc_Number4
	
	ljmp buttoms

state_17d:

	ljmp buttoms

state_18d:

	mov state, #0x01
	mov dptr, #main_menu
	lcall Print_Menu
	mov alarm_state, #0x00
	cpl alarm_status
	ljmp buttoms	

check_state_5:

	mov dptr, #jmp_e
	mov a, state
	mov b, #0x03
	mul ab
	jmp @a+dptr

jmp_e:

	ljmp state_0e
	ljmp state_1e
	ljmp state_2e
	ljmp state_3e
	ljmp state_4e
	ljmp state_5e
	ljmp state_6e
	ljmp state_7e
	ljmp state_8e
	ljmp state_9e
	ljmp state_10e
	ljmp state_11e
	ljmp state_12e
	ljmp state_13e
	ljmp state_14e
	ljmp state_15e
	ljmp state_16e
	ljmp state_17e
	ljmp state_18e	

state_0e:

	ljmp buttoms

state_1e:

	mov state, #0x0C
	mov dptr, #alarm_menu
	lcall Print_Menu
	lcall Check_Status
	lcall Get_Current_Alarm
	
	ljmp buttoms

state_2e:

	ljmp buttoms
	
state_3e:

	ljmp buttoms

state_4e:

	ljmp buttoms
	
state_5e:

	mov state, #0x0B
	mov dptr, #utc_set6
	lcall Print_Menu

	ljmp buttoms

state_6e:

	mov state, #0x0B
	mov dptr, #utc_set6
	lcall Print_Menu

	ljmp buttoms

state_7e:

	mov state, #0x06
	mov dptr, #utc_set1
	lcall Print_Menu

	ljmp buttoms

state_8e:

	mov state, #0x07
	mov dptr, #utc_set2
	lcall Print_Menu

	ljmp buttoms

state_9e:

	mov state, #0x08
	mov dptr, #utc_set3
	lcall Print_Menu

	ljmp buttoms

state_10e:

	mov state, #0x09
	mov dptr, #utc_set4
	lcall Print_Menu

	ljmp buttoms

state_11e:

	mov state, #0x0A
	mov dptr, #utc_set5
	lcall Print_Menu

	ljmp buttoms

state_12e:

	ljmp buttoms
	
state_13e:

	mov state, #0x0D
	lcall Dec_Number1
	
	ljmp buttoms
	
state_14e:

	mov state, #0x0E
	lcall Dec_Number2
	
	ljmp buttoms
	
state_15e:

	mov state, #0x0F
	lcall Dec_Number3
	
	ljmp buttoms
	
state_16e:

	mov state, #0x10
	lcall Dec_Number4
	
	ljmp buttoms

state_17e:

	ljmp buttoms

state_18e:

	ljmp buttoms	


;-------------------------------------------------------;

			; HUMIDITY AND TEMPERATURE CODE
			

;-------------------------------------------------------;

	
InitTimer0:
	clr TR0 ; Stop timer 0
	mov a, #0F0H
	anl a,TMOD
	orl a, #00000001B ; Set timer 0 as 16-bit counter
	mov TMOD, a
	clr TF0
ret

INIT_ADC:
	anl P1, #01001111B
	orl P1, #01000000B
	clr SR_SCLK ; For mode (0,0) SCLK is zero
ret

DO_SPI_G:
	push acc
	mov R1, #0 ; Received byte stored in R1
	mov R2, #8 ; Loop counter (8-bits)
	
DO_SPI_G_LOOP:
	mov a, R0 ; Byte to write is in R0
	rlc a ; Carry flag has bit to write
	mov R0, a
	mov SR_MOSI, c
	setb SR_SCLK ; Transmit
	mov c, SR_MISO  ; Read received bit
	mov a, R1 ; Save received bit in R1
	rlc a
	mov R1, a
	clr SR_SCLK
	djnz R2, DO_SPI_G_LOOP
	pop acc
ret
	
	
; Gets the period counts
	
period:	
	lcall InitTimer0	
	
	mov A, P0
	orl A, #00010000B ; P0.4 is now input (humidity)
	mov P0, A
	
	mov TL0, #0 ; Reset the timer
	mov TH0, #0
	W1a: jb P0.4, W1a ; Wait for the signal to be zero
	W2a: jnb P0.4, W2a ; Wait for the signal to be one
	setb TR0 ; Start timing
	W3a: jb P0.4, W3a ; Wait for the signal to be zero
	clr TR0 ; Stop timer 0
ret

;--------------------------------------------------;

		;Equation for calculating humidity

;--------------------------------------------------;


Humidity_cal:

	lcall period
	
	mov x+0, TL0 					;TL0   
	mov x+1, TH0 					;TH0
	mov x+2, #0	
	mov x+3, #0	
	mov y+0, #low(1345) 	; 2*1080	
	mov y+1, #high(1345)	; X/1000000 -> ms
	mov y+2, #0
	mov y+3, #0
	lcall mul32
	
	mov y+0, #low(1000)	
	mov y+1, #high(1000)
	mov y+2, #0
	mov y+3, #0
	lcall div32
	
	
	mov y+0, #low(2188) 		
	mov y+1, #high(2188)
	mov y+2, #0
	mov y+3, #0
	lcall sub32
	
	mov y+0, #low(30) 		
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	lcall add32
	
	mov y+0, #low(10) 		
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	lcall mul32
		
	lcall hex2bcd
	
	mov R2, X+0
	mov R3, X+1
ret


;------------------------------------------------;

	;Equation for Temperature in Celcius

;------------------------------------------------;

Celsius_cal:

;;/*Above was repetition (of Kelvin_cal), can be replaced by following command*/
	lcall kelvin_cal

;Check for negative temp flag/bit
	jb negative_temp_C, Cels_Negative
	
	
Cels_Positive:	;Positive Calc X-Y
	mov y+0, #low(2730)
	mov y+1, #high(2730)
	mov y+2, #0
	mov y+3, #0
	lcall sub32
	sjmp Cels_End_Calc

Cels_Negative:	;Negative Calc (essentially) Y-X 
	mov y+0, x
	mov y+1, x+1
	mov y+2, x+2
	mov y+3, x+3
	mov x+0, #low(2730)
	mov x+1, #high(2730)
	mov x+2, #0
	mov x+3, #0
	lcall sub32
			
Cels_End_Calc:
	lcall hex2bcd	

ret

;--------------------------;

	;kelvin equation

;--------------------------;

kelvin_cal:

	mov x+0, R6
	mov x+1, R7
	mov x+2, #0
	mov x+3, #0
	mov y+0, #low(1000)			;To offset decimals
	mov y+1, #high(1000)
	mov y+2, #0
	mov y+3, #0
	lcall mul32
	
	mov y+0, #low(508)			;Voltage Reference (Of ADC)
	mov y+1, #high(508)
	mov y+2, #0
	mov y+3, #0
	lcall mul32
	
	mov y+0, #low(1024)			;ADC Resolution 2^10
	mov y+1, #high(1024)
	mov y+2, #0
	mov y+3, #0
	lcall div32
	
	mov y+0, #low(100)			;To reduce the decimal offset
	mov y+1, #high(100)
	mov y+2, #0
	mov y+3, #0
	lcall div32	
	lcall hex2bcd
ret

;------------------------------;
	
	;Fahrenheit equation

;------------------------------;

Fahrenheit_cal:
;	[°F] = [K] × 9/5 - 459.67

	lcall kelvin_cal
		
	mov y+0, #low(18)			;x9/5 *10 = 180
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	lcall mul32
	
	mov y+0, #low(10)			;Decimal adjustment
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	lcall div32


;Check for negative temp flag/bit
	jb negative_temp_F, Farh_Negative
		
Farh_Positive:	;Positive Calc [°F] = [K] × 9/5 - 459.67
	mov y+0, #low(4596)			;4596
	mov y+1, #high(4596)
	mov y+2, #0
	mov y+3, #0
	lcall sub32
	
	;mov y+0, #low(3200)
	;mov y+1, #high(3200)
	;mov y+2, #0
	;mov y+3, #0
	;lcall add32	
	sjmp Farh_end_calc
	
Farh_Negative:	;Negative Calc [°F] =  + 459.67-[K] × 9/5
	mov y+0, x
	mov y+1, x+1
	mov y+2, x+2
	mov y+3, x+3
	mov x+0, #low(4596)
	mov x+1, #high(4569)
	mov x+2, #0
	mov x+3, #0
	lcall sub32
	
Farh_end_calc:
	lcall hex2bcd
ret

Check_Humidity:

	clr c
	mov x+0, R2
	mov x+1, R3
	mov x+2, #0
	mov x+3, #0
	mov y+0, #10
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	lcall div32
	
	mov a, x+0
	subb a, #100
	jnc over100
	ret

over100:
	mov x+0, #low(1000)
	mov x+1, #high(1000)
	mov x+2, #0
	mov x+3, #0
	
	lcall hex2bcd
	ret

Check_Negative_Cel:

	clr negative_temp_C

	lcall kelvin_cal
	
	clr c
	
	mov A, X 		;273 Decimal *10	
	subb A, #low(2730)	; 
	mov A, X+1
	subb A, #high(2730)
	
	jnc end_check_C
	setb negative_temp_C
	
end_check_C:
ret


Check_Negative_Farh:
	clr negative_temp_F

	lcall kelvin_cal
	
	clr c
	
	mov A, X 		;255 Decimal *10	
	subb A, #low(2550)	; 
	mov A, X+1
	subb A, #high(2550)
	
	jnc end_check_F
	setb negative_temp_F
	
end_check_F:

ret

;--------------------------------;

		; MAIN FUNCTION
		
;--------------------------------;


TempandHum:  
	lcall fake_isr 
	
	push PSW
	push ACC
	
	anl PSW, #11100111b
	orl PSW, #00001000b


	
	lcall Humidity_cal 
	lcall Check_Humidity    ; check if it goes over 100% RH
	mov Humidity_temp, bcd
	mov Humidity_temp+1, bcd+1
	
;---------------------------------;

		; Temperature Calculation
		
;---------------------------------;
	lcall clear_7seg
	lcall INIT_ADC

	clr SR_CE

	mov R0, #00000001B ; Start bit:1, Single:1, D2: 0
	lcall DO_SPI_G

	mov R0, #10110000B ; Read channel 0; D1 (bit 7): 0, D0 (bit 6):0
	lcall DO_SPI_G
	
	mov a, R1 
	anl a, #03H		; R7 contains bits 9 to 8
	mov R7, a	   
	
	mov R0, #0FFH
	lcall DO_SPI_G

	mov a, R1
	mov R6, a
	setb SR_CE

	
	
	lcall clearXandY
	lcall Check_Negative_Cel

	lcall clearXandY
	lcall Check_Negative_Farh
		
; Kelvin
	lcall clearXandY
	lcall kelvin_cal
	mov a, bcd	
	mov kelvin_temp, a
	mov a, bcd+1
	mov kelvin_temp+1, a
	
; Celsius
	lcall clearXandY
	lcall celsius_cal
	mov a, bcd	
	mov Celsius_temp, a
	mov a, bcd+1
	mov celsius_temp+1, a


; Fahrenheit
	lcall clearXandY
	lcall Fahrenheit_cal
	mov a, bcd	
	mov Fahrenheit_temp, a
	mov a, bcd+1
	mov Fahrenheit_temp+1, a
	
	pop acc
	pop psw
	
ret

;-----------------------------------------------;

		; Timezone Calculation
		
;-----------------------------------------------;



;  take BCD from R2 convert back to binary and save back to R2
BCD_to_binary:

	clr c
	mov a, R2
	anl a, #0F0H
	swap a
	mov b,#10
	mul ab
	mov R3, a
	mov a, R2
	anl a, #0FH
	add a, R3
	mov R2,a

ret


;One fix the time for PST, MST, CST, EST, AST  --->NST special case with -3.5 timezone
timeadjust:  
	clr c
	mov a, temp_hours
	subb a, R0
	mov R1, a	
	jnc Q0		
	clr c
	mov a,temp_hours
	add a, #24
	subb a, R0
	mov Temp_hours, a
	clr c	
	mov a, Temp_day+0
	subb a, #1
	mov Temp_day+0, a
	mov a, Temp_day+1
	subb a, #0
	mov Temp_day+1, a
	
	sjmp K0
Q0:
	mov Temp_hours, R1
	
K0:	

ret

; Time Zones

pst1:
	mov R0, #8
	lcall timeadjust
	ljmp output
	
mst1:
	mov R0, #7
	lcall timeadjust
	ljmp output

cst1:
	mov R0, #6
	lcall timeadjust
	ljmp output

est1:
	mov R0, #5
	lcall timeadjust
	ljmp output

ast1:
	mov R0, #4
	lcall timeadjust
	ljmp output
	
nst1:
	clr c
	mov a, temp_minutes
	subb a, #30
	mov R4, a
	mov R5, temp_hours
	jnc L2
	
;--------------------------------------;

	; If minutes overflow fix it
	
;--------------------------------------;	
	clr c 
	mov a, temp_minutes
	add a, #30
	mov R4, a
	mov temp_minutes, R4
	
	mov a, temp_hours
	subb a,#1
	mov R5 ,a 
	jnc L2
	

	mov temp_hours,#23    ; when hours and minutes both overflow
	lcall hour

	
	sjmp L3

;-----------------------------

L2:	mov temp_minutes, R4	
	mov temp_hours, R5
	lcall hour
L3: 

ljmp output


hour:
	clr c
	mov a, Temp_hours
	mov R6, Temp_hours
	subb a, #3
	mov Temp_hours, a
	clr a
	jc hourbeforen
ret
	
hourbeforen:
	clr c
	mov a, R6
	add a, #24
	subb a, #3
	mov temp_hours, a
	
	clr c	
	mov a, Temp_day+0
	subb a, #1
	mov Temp_day+0, a
	mov a, Temp_day+1
	subb a, #0
	mov Temp_day+1, a

ret

; JUMP to timezones

K1: 
ljmp PST1
K2: 
ljmp MST1
K3: 
ljmp CST1
K4: 
ljmp EST1
K5: 
ljmp AST1
K6: 
ljmp NST1

; Setting

timezone_calculation:
	push psw
	push acc


	anl PSW, #11100111b
	orl PSW, #00001000b
 
;--------------------------------;

		; Main Code - Timezone
		
;-------------------------------;

	mov R2, hours
	lcall BCD_to_binary
	mov temp_hours, R2

	mov R2, Mins
	lcall BCD_to_binary
	mov temp_minutes, R2
	
	mov Temp_day+0, R_day+0
	mov Temp_day+1, R_day+1
	
	mov a, timezone
	subb a, #00000000b	 ;pst -8
	jz K1
	mov a, timezone
	subb a, #00000001b	 ;mst -7
	jz K2
	mov a, timezone
	subb a, #00000010b	 ;cst -6
	jz K3
	mov a, timezone      
	subb a, #00000011b   ;est -5 
	jz K4
	mov a, timezone
	subb a, #00000100b	 ;ast -4
	jz K5
	mov a, timezone
	subb a, #00000101b	 ;nst -3.5
	jz K6
	
	
output:
	mov x+0, #0h
	mov x+1, #0h
	mov x+2, #0h
	mov x+3, #0h

	mov x, Temp_hours
	lcall hex2bcd
	mov Temp_hours, bcd
	
	mov x+0, #0h
	mov x+1, #0h
	mov x+2, #0h
	mov x+3, #0h
	mov x, Temp_minutes
	lcall hex2bcd
	mov Temp_minutes, bcd
	
	
	lcall timezone_date
	lcall calculate_weekday
	pop acc
	pop psw
	
ret



RTC_init:
	; Settings for RTC
	lcall Reset_DS1302
	mov A, #8eh			; control reg
	lcall Write_DS1302
	mov A, #00h			; disable wp
	lcall Write_DS1302	
	lcall Reset_DS1302
	mov A, #90h			; trickle
	lcall Write_DS1302
	mov A, #0a5h		; 2d, 8kohm
	lcall Write_DS1302
	ret
	
	
Sample_RTC:
	; Set time 21:30:00 HRS and date 05/16/67
	; Sec
	lcall Reset_DS1302
	mov A, #80h			
	lcall Write_DS1302
	mov A, #000h		 
	lcall Write_DS1302
	; Min
	lcall Reset_DS1302
	mov A, #82h			
	lcall Write_DS1302
	mov A, #30h		 
	lcall Write_DS1302
	; Hrs
	lcall Reset_DS1302
	mov A, #84h			
	lcall Write_DS1302
	mov A, #21h		 
	lcall Write_DS1302
	; Date
	lcall Reset_DS1302
	mov A, #86h			
	lcall Write_DS1302
	mov A, #16h		 
	lcall Write_DS1302	
	; Month
	lcall Reset_DS1302
	mov A, #88h			
	lcall Write_DS1302
	mov A, #05h		 
	lcall Write_DS1302
	; Year
	lcall Reset_DS1302
	mov A, #8Ch			
	lcall Write_DS1302
	mov A, #12h		 
	lcall Write_DS1302
	ret


; Reads values from the RTC and writes to variables
Read_RTC:
	; Seconds
	lcall Reset_DS1302
	mov A, #81h
	lcall Write_DS1302
	lcall Read_DS1302
	mov Sec, A
	; Minutes
	lcall Reset_DS1302
	mov A, #83h
	lcall Write_DS1302
	lcall Read_DS1302
	mov Mins, A
	; Hours
	lcall Reset_DS1302
	mov A, #85h
	lcall Write_DS1302
	lcall Read_DS1302
	mov Hours, A
	; Date
	lcall Reset_DS1302
	mov A, #87h
	lcall Write_DS1302
	lcall Read_DS1302
	mov Date, A
	; Month
	lcall Reset_DS1302
	mov A, #89h
	lcall Write_DS1302
	lcall Read_DS1302
	mov Month, A
	; Year
	lcall Reset_DS1302
	mov A, #8Dh
	lcall Write_DS1302
	lcall Read_DS1302
	mov Year, A

		
	ret
	
	
	
Reset_DS1302:
	; Set P0.1 (SCLK), P1.3 (IO), P0.3 (CE) as outputs
	anl P1, #01100111B
	clr RTC_CLK ; 
	clr RTC_CE ; CE = 0
	nop
	setb RTC_CE ; CE = 1
	ret	

; Byte to send is in the accumulator
Write_DS1302:
	mov R2, #8
	anl P1, #11110111B	; Set IO pin as output
	 
	Write_DS1302_L1:
	rrc A
	mov RTC_IO, c
	clr RTC_CLK
	nop
	setb RTC_CLK
	djnz R2, Write_DS1302_L1
	ret

; Byte received is in the accumulator
Read_DS1302:
	mov R2, #8
	orl P1, #00001000B ; Set IO pin as input
	Read_DS1302_L1:
	setb RTC_CLK
	nop
	clr RTC_CLK
	nop
	mov c, RTC_IO
	rrc A
	djnz R2, Read_DS1302_L1
	ret

; Calulates R_Date and R_Months using the R_Day received from the radio.
; Uses the Date_LUT defined in declarations
Calculate_Date:
	clr A
	mov temp+1, A
	mov temp, A
	clr c
	mov A, R_Day
	anl A, #0FH
	mov temp, A
	mov A, R_Day
	swap A
	anl A, #0FH
	mov B, #10
	mul AB
	mov B, A
	mov A, temp
	addc A, B
	mov temp, A
	mov A, R_Day+1
	anl A, #03H
	mov B, #100
	mul AB
	addc A, temp
	mov temp, A
	mov A, B
	addc A, #0
	mov temp+1, A
	
	clr c
	mov A, temp
	rlc A
	mov temp, A
	mov A, temp+1
	rlc A
	mov temp+1, A
	
	
	clr c
	mov A, #LOW (LeapDate_LUT)
	addc A, temp
	mov DPL, A
	mov A, #HIGH (LeapDate_LUT)
	addc A, temp+1
	mov DPH, A
	
	
	clr A
	movc A, @A+DPTR
	mov R_Date, A
	mov A, #01H
	movc A, @A+DPTR
	mov R_Month, A
	ret

timezone_Date:
	clr A
	mov temp+1, A
	mov temp, A
	clr c
	mov A, temp_Day
	anl A, #0FH
	mov temp, A
	mov A, temp_Day
	swap A
	anl A, #0FH
	mov B, #10
	mul AB
	mov B, A
	mov A, temp
	addc A, B
	mov temp, A
	mov A, temp_Day+1
	anl A, #03H
	mov B, #100
	mul AB
	addc A, temp
	mov temp, A
	mov A, B
	addc A, #0
	mov temp+1, A
	
	clr c
	mov A, temp
	rlc A
	mov temp, A
	mov A, temp+1
	rlc A
	mov temp+1, A
	
	
	clr c
	mov A, #LOW (LeapDate_LUT)
	addc A, temp
	mov DPL, A
	mov A, #HIGH (LeapDate_LUT)
	addc A, temp+1
	mov DPH, A
	
	clr A
	movc A, @A+DPTR
	mov r_Date, A
	mov A, #01H
	movc A, @A+DPTR
	mov r_Month, A
	ret	


Calculate_weekday:
	clr a
	clr c
	mov A, Year
	anl A, #0FH
	mov R3, A
	mov A, year
	swap a
	anl A, #0FH
	mov B, #10
	mul ab
	addc A, R3
	mov R6, A	; number 1
	
	mov B, #4
	div ab
	mov R4, A	; number 2
	
	clr a
	clr c
	mov A, r_Month
	anl A, #0FH
	mov R3, A
	mov A, r_month
	swap a
	anl A, #0FH
	mov B, #10
	mul ab
	addc A, R3
	mov dptr, #weekday_month
	movc A, @a+dptr
	mov R5, A	; number 3
	
	clr a
	clr c
	mov A, r_date
	anl A, #0FH
	mov R3, A
	mov A, r_dATE
	swap a
	anl A, #0FH
	mov B, #10
	mul ab
	addc A, R3
	mov R7, A 	; number 4
	
	clr c
	mov A, #6
	addc A, R7
	addc A, R6
	addc A, R5
	addc A, R4
	
	mov B, #7
	div ab
	mov a, b
	mov day_of_week, A
	
	ret

	
; Checks type of signal from radio. checks 8 times in a second and stores checked value in R4
Take_Type:			
	mov R2, #8
	clr A
	Take_Type_L1:	
	lcall Wait
	mov c, R_SIG 
	cpl c
	rlc A
	djnz R2, Take_Type_L1
	mov R4, A
	ret 	

; Specific time for the interval that the radio signal has to be checked after
Wait:
	push PSW
	anl PSW, #11100111b
	orl PSW, #00010000b
	mov R6, #2
Wait_L3: mov R5, #250
Wait_L2: mov R4, #200
Wait_L1: djnz R4, Wait_L1 ; 2 machine cycles-> 2*542.5347ns*250=135.6us
	djnz R5, Wait_L2 ; 135.6us*250=0.034
	djnz R6, Wait_L3 ; 0.034s*3=0.102 (approximately)
	pop PSW
	ret

; Checks if the analyzed value from radio is one or not. Puts respective value in carry
Check_Type:
	clr c
	mov A, R4
	subb A, ONE
	jc itsazero
	setb c
	sjmp Check_Type_Return
	itsazero: clr c
	Check_Type_Return:
	ret


; Updates RTC from the radio signals.
Update_Data:
	orl P0, #00000001B

	L1: jb R_SIG, L1
	lcall Take_Type
	clr c
	mov A, R4
	subb A, MARKER
	jnz L1 ; if not marker continue checking
	L45:	jb R_SIG, L45
	lcall Take_Type
	clr c
	mov A, R4
	subb A, MARKER
	jnz L1 ; if not marker continue checking
	; if two markers encountered
	
	
	
	; Updating Minutes : Xmmm-mmmm (2 BCD Digits)
	mov R7, #0
	mov R6, #4
	Update_Data_L1: jb R_SIG, Update_Data_L1
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L1
	rrc A
	mov R7, A
	mov R6, #4
	Update_Data_L2: jb R_SIG, Update_Data_L2
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L2
	mov R_Mins, R7
	
	
	; Wait for 1 Marker + 2 Unused Bits
	mov R6, #3
	Update_Data_L3: jb R_SIG, Update_Data_L3
	lcall Take_Type
	djnz R6, Update_Data_L3
	
	; Updating Hours : XXhh-hhhh (2 BCD Digits)
	mov R7, #0
	mov R6, #3
	Update_Data_L4: jb R_SIG, Update_Data_L4
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L4
	rrc A
	mov R7, A
	mov R6, #4
	Update_Data_L5: jb R_SIG, Update_Data_L5

	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L5
	mov R_Hours, R7	
	
	; Wait for 1 Marker
	Update_Data_L6: jb R_SIG, Update_Data_L6
	lcall Take_Type
	
	; Updating Day of the Year: R_Day+1 (XXXX-XXdd) & R_Day (dddd-dddd)
	mov R7, #0
	mov R6, #4
	Update_Data_L7: jb R_SIG, Update_Data_L7
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L7
	mov A, R7	
	anl A, #00000011B
	mov R7, A
	mov R_Day+1, A
	; Marker
	Update_Data_L8: jb R_SIG, Update_Data_L8
	lcall Take_Type
	; Next byte
	mov R7, #0
	mov R6, #4
	Update_Data_L9: jb R_SIG, Update_Data_L9
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L9	
	Update_Data_L10: jb R_SIG, Update_Data_L10
	lcall Take_Type
	mov R6, #4
	Update_Data_L11: jb R_SIG, Update_Data_L11
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L11
	mov R_Day, R7
	
	
	; Wait for 11 Bits
	mov R6, #11
	Update_Data_L12: jb R_SIG, Update_Data_L12
	lcall Take_Type
	djnz R6, Update_Data_L12
	
	; Updating Year : yyyy-yyyy (2 BCD Digits)
	mov R7, #0
	mov R6, #4
	Update_Data_L13: jb R_SIG, Update_Data_L13
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L13

	; 1 Marker
	Update_Data_L14: jb R_SIG, Update_Data_L14
	lcall Take_Type
	
	mov R6, #4
	Update_Data_L15: jb R_SIG, Update_Data_L15
	lcall Take_Type
	lcall Check_Type	
	mov A, R7
	rlc A
	mov R7, A
	djnz R6, Update_Data_L15
	mov A, R7
	mov R_Year, A
	
	; 1 Marker
	Update_Data_L16: jb R_SIG, Update_Data_L16
	lcall Take_Type
	
	; Leap year Indicator
	Update_Data_L17: jb R_SIG, Update_Data_L17
	lcall Take_Type
	lcall Check_Type
	mov Leap_Bit, c
	
	; 1 value (leap second)
	Update_Data_L18: jb R_SIG, Update_Data_L18
	lcall Take_Type
	
	
	; 2 Daylight saving bits
	Update_Data_L19: jb R_SIG, Update_Data_L19
	lcall Take_Type
	lcall Check_Type
	mov dst_status, c
	Update_Data_L20: jb R_SIG, Update_Data_L20
	lcall Take_Type
	lcall Check_Type
	mov dst_status+1, c
	
	; 1 Marker
	Update_Data_L21: jb R_SIG, Update_Data_L21
	lcall Take_Type	
	
	; Wait for the transition
	Update_Data_L22: jb R_SIG, Update_Data_L22
	
	; Write seconds
	lcall Reset_DS1302
	mov A, #80h			
	lcall Write_DS1302
	mov A, #00H			
	lcall Write_DS1302
	
	
	clr c
	mov A, R_Mins
	addc A, #1
	da A
	mov B, A
	xrl A, #60H
	jz adjust_mins

	; Write minutes
	lcall Reset_DS1302
	mov A, #82h			
	lcall Write_DS1302
	mov A, B			
	lcall Write_DS1302
	; Write Hours
	lcall Reset_DS1302
	mov A, #84h			
	lcall Write_DS1302
	mov A, R_Hours			
	lcall Write_DS1302
	sjmp Happy_Valentines
	
	adjust_mins:
	
		; Write minutes
		lcall Reset_DS1302
		mov A, #82h			
		lcall Write_DS1302
		mov A, #00H			
		lcall Write_DS1302
	
		clr c
		mov A, R_Hours
		addc A, #1
		da A
		mov B, A
		xrl A, #24H
		jz adjust_hours
		; Write hours
		lcall Reset_DS1302
		mov A, #84h			
		lcall Write_DS1302
		mov A, B			
		lcall Write_DS1302
		sjmp Happy_Valentines
	
	adjust_hours:
		; Write hours
		lcall Reset_DS1302
		mov A, #84h			
		lcall Write_DS1302
		mov A, #00H			
		lcall Write_DS1302
		
		mov A, R_Day
		inc A
		da A
		mov R_Day, A		
	
	
	happy_valentines:
	lcall Calculate_Date
	
	; Write DATE
	lcall Reset_DS1302
	mov A, #86h			
	lcall Write_DS1302
	mov A, R_Date			
	lcall Write_DS1302
	; Write month
	lcall Reset_DS1302
	mov A, #88h			
	lcall Write_DS1302
	mov A, R_Month			
	lcall Write_DS1302
	; Write year
	lcall Reset_DS1302
	mov A, #8Ch			
	lcall Write_DS1302
	mov A, R_Year			
	lcall Write_DS1302
	
	ret
	
Delay4mS:
	push AR0
	push AR2
	mov R2, #1
	Wait3ms_L6:	mov R0, #100
	Wait3ms_L5: djnz R0, Wait3ms_L5 ;2*250*545ns=0.3ms
	djnz R2, Wait3ms_L6
	pop AR2
	pop AR0
	ret 	
	
	
SendSPI:
	mov SPDAT,SPI_Temp	;transmit SPI Data	
	WaitSPI:
	mov a,SPCFG
	jnb acc.7,WaitSPI		;wait for TX complete before reading

	mov A, SPDAT	;read SPI Data
	ret

serial:
	mov SPCTL,#01110011b	; Fosc /128, Master Mode, SPI Mode 3
	clr p1.4

  	mov R7, #00H	;25H	;7seg Value 2	
	mov SPI_Temp, r7		
	lcall	SendSPI			
	lcall	Delay4mS
	

	mov R7, #00H		
	mov SPI_Temp, r7		
	lcall	SendSPI			
	lcall	Delay4mS
	
	mov A, choice
	mov R7, A		
	mov SPI_Temp, r7		
	lcall	SendSPI			
	lcall	Delay4mS
		
	mov A, LEDs
	mov R7, A	
	mov SPI_Temp, r7		
	lcall	SendSPI			
	lcall	Delay4mS

	setb p1.4
	xrl SPCTL,#40h
	ret
	
updateTime:

	lcall checkclock
	lcall changestate;once integrated with other codes this will be one of the seconds we call
	lcall checkstate
	lcall checkseconds
	lcall Display_to_7Segs
	lcall Read_RTC
	lcall Alarm_Compare
	ret
		
checkclock:
	mov A, Sec
	anl A, #0FH
	mov R1, A
	mov A, sec
	anl A, #0F0H
	swap A
	mov b, #10
	mul ab
	add a, R1
	add a, #1
	mov Secondsbin, A

	ret

changeState:
	clr c
	mov A, Secondsbin
	cjne A, #08H, S1
	mov Secondsstate, #01H ;Less then 8 seconds
	sjmp return
S1: 
	cjne A, #10H, S2
	mov Secondsstate, #02H ;Less than 16
	sjmp return
S2: 
	cjne A, #18H, S3
	mov Secondsstate, #03H
	sjmp return
S3: cjne A, #20H, S4
	mov Secondsstate, #04H
	sjmp return
S4: cjne A, #28H, S5
	mov Secondsstate, #05H
	sjmp return
S5: cjne A, #30H, S6
	mov Secondsstate, #06H
	sjmp return
S6: cjne A, #38H, S7
	mov Secondsstate, #07H
	sjmp return
S7: cjne A, #01H, return
	mov Secondsstate, #00H
return:	ret

checkstate:

	 mov A, Secondsstate
	 cjne A, #00H, St1
	 mov select, #01H

	 ret
	 
	 
St1: cjne A, #01H, St2
	 mov choice, #02H
	 mov A, choice
	 mov select, A
ALL1:mov choice, #01H
	 mov LEDs, #00H
	 lcall serial

     ret
	 
	 	 
St2: cjne A, #02H, St3
	 mov choice, #04H
	 mov A, choice
	 mov select, A
ALL2:mov choice, #02H
	 mov LEDs, #00H
	 lcall serial
	 sjmp All1	 
	 
	 
St3: cjne A, #03H, St4
	 mov choice, #08H
	 mov A, choice
	 mov select, A
ALL3:mov choice, #04H
	 mov LEDs, #00H
	 lcall serial
	 sjmp All2	 
	 
	 
St4: cjne A, #04H, St5
	 mov choice, #10H
	 mov A, choice
	 mov select, A
ALL4:mov choice, #08H
	 mov LEDs, #00H
	 lcall serial
	 sjmp All3	 
	 
	 
St5: cjne A, #05H, St6
	 mov choice, #20H
	 mov A, choice
	 mov select, A
ALL5:mov choice, #10H
	 mov LEDs, #00H
	 lcall serial
	 sjmp All4	 
	 
	 
St6: cjne A, #06H, ALL7
	 mov choice, #40H
	 mov A, choice
	 mov select, A
ALL6:mov choice, #20H
	 mov LEDs, #00H
	 lcall serial
	 sjmp All5	 
ALL7:mov choice, #40H
	 mov select, #80H
	 mov LEDs, #00H
	 lcall serial
	 sjmp All6	
	 
	ret
	 
checkseconds:
	 clr c
	 mov A, select
	 mov choice, A
	 mov dptr, #secondLEDs
   	 mov A, Secondsstate
	 mov B, #8
	 mul AB
	 mov R0, A
	 mov A, Secondsbin
	 Subb A, R0
	 movc A, @A + dptr
	 mov LEDs, A
	 
	 lcall serial
	 ret
		
Clear_7Seg:
	mov SPCTL,#01110011B
	clr SR_CE
  	mov R7, #000H		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	mov R7, #00H		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	mov R7, #00H		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	mov R7, #00H		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	setb SR_CE
	xrl SPCTL,#40h
	ret
	
	
Display_to_7Segs:
	
	lcall timezone_calculation
	mov DPTR, #myLUT_R
	mov P1, #00001111B
	sjmp start
	
SerialDisplay:

	mov SPCTL,#01110011B
	clr SR_CE
	mov A, DisplayChoice1
  	mov R7, A		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	mov A, DisplayChoice2
	mov R7, A	
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	mov R7, #00H		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	mov A, DisplayChoice
	mov R7, A		
	mov SPI_Temp, R7		
	lcall	SendSPI			
	lcall	Delay4mS
	setb SR_CE
	
	
	xrl SPCTL,#40h	
	
start:
	mov A, DisplayState
	cjne A, #12H, hourss
	lcall clear_7seg
	mov DisplayState, #00H
	ret


hourss: cjne A, #00H, hour2

	mov A, temp_hours
    anl A, #0F0H
    swap A
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #01H
	mov DisplayChoice1, #00H
	mov DisplayChoice2, #08H
	ljmp SerialDisplay
	
hour2: cjne A, #01H, minutes

	mov A, temp_hours
    anl A, #0FH
	movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #02H
	mov DisplayChoice1, #00H
	mov DisplayChoice2, #04H
	ljmp SerialDisplay
   		  
minutes: 	  cjne A, #02H, minutes2

	mov A, temp_minutes
    anl A, #0F0H
    swap A
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #03H
	mov DisplayChoice1, #00H
	mov DisplayChoice2, #02H
	ljmp SerialDisplay

minutes2: 	cjne A, #03H, Day1

	mov A, temp_minutes
    anl A, #0FH
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #04H
	mov DisplayChoice1, #00H
	mov DisplayChoice2, #01H
	ljmp SerialDisplay


Day1:  	cjne A, #04H, day2

	mov A, r_date
    anl A, #0F0H
	swap A
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #05H
	mov DisplayChoice1, #80H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay
Day2:  	cjne A, #05H, Months

	mov A, r_date
    anl A, #0FH
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #06H
	mov DisplayChoice1, #40H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay
Months:  cjne A, #06H, month2

	mov A, r_month
    anl A, #0F0H
	swap A
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #07H
	mov DisplayChoice1, #20H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay	
Month2:  cjne A, #07H, Year1

	mov A, r_month
    anl A, #0FH
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #08H
	mov DisplayChoice1, #10H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay

Year1: cjne A, #08H, Year2

	mov A, year+1
    anl A, #0F0H
	swap A
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #09H
	mov DisplayChoice1, #08H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay
	

Year2: cjne A, #09H, Year3

	mov A, year+1
    anl A, #0FH
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #10H
	mov DisplayChoice1, #04H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay
	

Year3: cjne A, #10H, Year4

	mov A, year
    anl A, #0F0H
	swap A
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #11H
	mov DisplayChoice1, #02H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay
	
Year4: 

	mov A, year
    anl A, #0FH
    movc A, @A+dptr
	mov DisplayChoice, A
	mov DisplayState, #12H
	mov DisplayChoice1, #01H
	mov DisplayChoice2, #00H
	ljmp SerialDisplay
	



$include(math32.asm)
$include(lookup_tables.asm)
$include(lcd_commands.asm)
$include(AlarmClock_Subroutines.asm)


END

	