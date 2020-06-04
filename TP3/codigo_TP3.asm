.include "m328pdef.inc"

.cseg
.org	0x0000
		jmp		main

.org INT_VECTORS_SIZE

main:
	ldi		R20, 0xff									;declaro PORTB como salida						
	out		DDRB, R20

	ldi		R16, HIGH(RAMEND)							;Inicializo el stack pointer en la ultima dirección de memoria
	ldi		R16, LOW(RAMEND)
	out		SPL, R16

loop:													
	ldi		ZH, HIGH(secuencia1 <<1)				   ;Cargo la dirección de secuencia1 en el registro z. 
	ldi		ZL, LOW ((secuencia1 <<1)+1)			   ;El shift a la izquierda se debe a que los bits del 1 al 15 del registro guardan la dirección 
	lpm		R21, Z+									   ;el otro sólo se encarga de si lo que se va a leer es la parte alta o baja del registro
		
siguiente:	lpm		R20, Z+							
			out		PORTB, R20
			call	delay							   ;llamo al delay			
			dec		R21
			brne	siguiente

	jmp		loop

.org	0x0500										
secuencia1: .DB 0,10,1,2,4,8,16,32,16,8,4,2			   ;El vector con los datos. En el se encuentran los estados de la secuencia y la duración del ciclo. 
.org	0x0550
secuancia2: .DB 0,2,21,42
.org	RAMEND										   ;subrutina del delay
delay: 
		ldi r23, 32 
		loop3: ldi r24, 255 
		loop2: ldi r22, 255 
		loop1: dec r22 
		brne loop1 
		dec r24 
		brne loop2 
		dec r23 
		brne loop3	
	ret
