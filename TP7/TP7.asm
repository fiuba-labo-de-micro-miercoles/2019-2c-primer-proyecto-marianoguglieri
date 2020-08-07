.include "m328pdef.inc"

.cseg 
	;direcciones de codigo
.org 0x0000
	jmp		configuracion
.org INT0addr
	jmp		interrupcion_0
.org INT1addr
	jmp		interrupcion_1
configuracion:

	;inicializo el stack pointer
	ldi		R16, HIGH(RAMEND)							
	out		SPH, R16
	ldi		R16, LOW(RAMEND)
	out		SPL, R16

	;declaro el PINB1 como salida
	sbi		DDRB,1

	;declaro el PORTD como entrada
	ldi		R16, 0xff						
	out		DDRD, R16

	;configuro el timer1 para que trabaje sin prescaler, en modo fast PWM de 8bits y sobre el pin OC1A
	ldi		R16, ( 1<<CS10 | 1<<WGM12)
	sts		TCCR1B, R16
	ldi		R16, ( 1<<COM1A1 |1<<WGM10)
	sts		TCCR1A, R16

	;configuro la interrupcion 0 y 1 por flanco ascendente
	ldi		R16,(1 << ISC11 | 0 << ISC10 | 1 << ISC01 | 0 << ISC00  )
	sts		EICRA,R16				 
	ldi		R16,(1 << INT0 | 1 <<INT1) 
	out		EIMSK, R16

	sei

main:				
		clc		R16		;limpio el registro R16
fin:	rjmp	fin
		

	interrupcion_0:		
						cpi		R16, 0					;si el registro es igual a 0, llego a su limite y no se sigue decrementando
						breq	nomenos1
						subi	R16, 5
						sts		OCR1AL, R16				;el contenido del registro de comparación se disminuye en 5, disminuyendo el ciclo de trabajo del pulso de la onda
	nomenos1:
	reti

	interrupcion_1:										;si el registro es igual a 0xff, llego a su limite y no se sigue incrementando
						cpi		R16, 0xff
						breq	nomas1
						ldi		R17, 5
						add		R16, R17
						sts		OCR1AL, R16				;el contenido del registro de comparación se aumenta en 5, aumentando el ciclo de trabajo del pulso de la onda
	nomas1:
	reti

	