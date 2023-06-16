;
; SoftwareUartHalfDuplexInterrupt.asm
;
; Created: 15/08/2022 11:52:57
; Author : Aleksandar Bogdanovic
;


.include "m328pdef.inc"

//Definicija pinova
.equ Rx = 0 //PD0
.equ Tx = 1 //PD1

//Stop bitovi
.equ stopbit = 1	//Broj stop bitova (1, 2...)

//Globalni registri
.def bitcount = r16 //bit counter
.def temp = r17		//privremena memorija registar
.def TxByte = r18	//podaci koji ce biti poslati
.def RxByte = r19	//podaci koji ce biti primljeni

.cseg				//Start CODE segment 
.org 0x0000
		rjmp reset

postavichar:
		ldi bitcount, 9+stopbit	//1+8+stopbit = 10 bita 
		com	TxByte				//One’s Complement, invertuje sve
		sec						//Set Carry Flag, start bit

postavichar0:
		brcc postavichar1		//ako je carry setovan – Branch if Carry Cleared
		cbi	PORTD, Tx			//salje '0' - Clear Bit in I/O Register
		rjmp postavichar2

postavichar1:
		sbi	PORTD, Tx			//salje '1' - Set Bit in I/O Register
		nop

postavichar2:
		rcall delayUART			//jedan bit delay
		rcall delayUART			

		lsr	TxByte				//Logical Shift Right, prima sledeci bit
		dec bitcount			
		brne postavichar0		//posalji sledeci
		ret

primichar:
		ldi	bitcount, 9			//b data bitova + 1 stop bit

primichar1:
		sbic PIND, Rx			//sacekaj start bit
		rjmp primichar1		
		
		rcall delayUART			//0.5 bit delay

primichar2:
		rcall delayUART
		rcall delayUART			//1 bit delay (cekamo 1.5 bit puta = primichar1+primichar2)

		clc						//kliruje carry
		sbic PIND, Rx			//ako je Rx pin = 5V, Skip if Bit in I/O Register is Cleared
		sec						//setuje carry

		dec bitcount
		breq primichar3

		ror	RxByte				//Rotate Right through Carry, siftuje bit u RxByte
		rjmp	primichar2	

primichar3:
		ret

//Baud rate podesavanja
// 1sek/19200 = 0.000005208
//online timer calculator
// Total timer ticks 416
// 416/3 = 138

.equ br = 138				//19200 bps @ 8MHz kristal
delayUART:					//3*b + 7 ciklusa (zajedno sa rcall i ret)
		ldi temp, br		//temp(31) u r17

delayUART1:
		dec temp			//dekrament r17 (31 - 1...)
		brne delayUART1		//Branch if Not Equal
		ret

//Test programa

reset:
		sbi	PORTD, Tx		//inicijalizuje port pinove
		sbi DDRD, Tx	

		ldi	TxByte, 12
		rcall postavichar

loop:
		rcall primichar
		mov TxByte, RxByte	//kopiraj registar
		rcall postavichar
		rjmp loop