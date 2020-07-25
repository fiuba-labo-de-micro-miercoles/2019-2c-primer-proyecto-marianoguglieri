.include "m328pdef.inc"

.cseg 
	;direcciones de codigo
.org 0x0000
	jmp		configuracion
.org INT0addr
	jmp		interrupcion_0
.org INT_VECTORS_SIZE

configuracion:
	;inicializo el stack
	ldi		R16, HIGH(RAMEND)							
	out		SPH, R16
	ldi		R16, LOW(RAMEND)
	out		SPL, R16

	;declaro el PORTB como salida
	ldi		R16,0xff
	out		DDRB,R16

	;declaro el PORTD como entrada activando resistencia de pull-up
	ldi		R16, 0x00						
	out		DDRD, R16
	;si quiero activar la R de pull-up utilizo las siguientes dos lineas de cogido:						
	;ldi		R16, 0xff	
	;out		PORTD, R16

	;configuro la interrupcion 0 por flanco ascendente
	ldi		R16,( 1 << ISC01 | 0 << ISC00  )
	sts		EICRA, R16					  
	ldi		R16,(1 << INT0)
	out		EIMSK,R16

	sei

	;programa principal consta de dejar prendido un led
main:		
		sbi		PORTB,0
fin:	rjmp	fin

	;codigo de la interrupcion
interrupcion_0:

				cbi		PORTB,0

				ldi		R16, 5

	loop_int0:	sbi		PORTB,1
				rcall	delay
				cbi		PORTB,1
				rcall	delay

				dec		R16
				brne	loop_int0
				sbi		PORTB,0
reti
	;delay para que sea visible las pulsaciones del LED
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